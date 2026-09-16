from collections import Counter

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func
from database import get_db
from models import Incident, Equipment, Ticket, Alert
import statistics

PRIORITY_WEIGHT = {
    "Critique": 4,
    "Haute": 3,
    "Moyenne": 2,
    "Basse": 1,
}

router = APIRouter(
    prefix="/analysis",
    tags=["Analysis"]
)


def _group_by_month(dates):
    """Regroupe une liste de dates par mois (YYYY-MM), en Python —
    fonctionne avec n'importe quelle base (Postgres, SQLite, ...)."""
    compteur = Counter(d.strftime("%Y-%m") for d in dates)
    return sorted(compteur.items())


@router.get("/frequent-problems")
def frequent_problems(db: Session = Depends(get_db)):
    results = (
        db.query(
            Incident.description,
            func.count(Incident.id).label("nombre")
        )
        .group_by(Incident.description)
        .order_by(func.count(Incident.id).desc())
        .all()
    )

    return [
        {"probleme": description, "nombre": nombre}
        for description, nombre in results
    ]


@router.get("/problematic-equipment")
def problematic_equipment(db: Session = Depends(get_db)):
    results = (
        db.query(
            Incident.equipment_id,
            Equipment.name,
            Equipment.inventory_code,
            func.count(Incident.id).label("nombre_incidents")
        )
        .join(Equipment, Equipment.id == Incident.equipment_id)
        .group_by(Incident.equipment_id, Equipment.name, Equipment.inventory_code)
        .order_by(func.count(Incident.id).desc())
        .all()
    )

    return [
        {
            "equipment_id": equipment_id,
            "name": name,
            "inventory_code": inventory_code,
            "nombre_incidents": nombre_incidents
        }
        for equipment_id, name, inventory_code, nombre_incidents in results
    ]


@router.get("/trends")
def trends(db: Session = Depends(get_db)):
    dates = [i.date_signalement for i in db.query(Incident.date_signalement).all()]
    resultats = _group_by_month(dates)

    return [{"mois": mois, "nombre": nombre} for mois, nombre in resultats]


@router.get("/anomalies")
def anomalies(db: Session = Depends(get_db)):
    dates = [i.date_signalement for i in db.query(Incident.date_signalement).all()]
    resultats = _group_by_month(dates)

    valeurs = [nombre for mois, nombre in resultats]

    if len(valeurs) < 3:
        return {
            "message": "Historique insuffisant pour détecter des anomalies "
                       "(minimum 3 mois de données nécessaires).",
            "anomalies": []
        }

    moyenne = statistics.mean(valeurs)
    ecart_type = statistics.pstdev(valeurs)
    seuil = moyenne + 2 * ecart_type

    anomalies_detectees = [
        {"mois": mois, "nombre": nombre, "seuil": round(seuil, 2)}
        for mois, nombre in resultats
        if nombre > seuil
    ]

    return {
        "moyenne_mensuelle": round(moyenne, 2),
        "ecart_type": round(ecart_type, 2),
        "seuil_anomalie": round(seuil, 2),
        "anomalies": anomalies_detectees
    }


@router.get("/indicators")
def indicators(db: Session = Depends(get_db)):
    tickets = db.query(Ticket).all()

    resolus = [t for t in tickets if t.date_resolution is not None]

    if resolus:
        durees = [
            (t.date_resolution - t.date_signalement).total_seconds() / 3600
            for t in resolus
        ]
        temps_moyen_heures = round(statistics.mean(durees), 1)
    else:
        temps_moyen_heures = None

    total = len(tickets)
    taux_resolution = round(len(resolus) / total * 100, 1) if total else 0

    return {
        "total_tickets": total,
        "tickets_resolus": len(resolus),
        "taux_resolution_pourcent": taux_resolution,
        "temps_moyen_resolution_heures": temps_moyen_heures
    }


@router.get("/priority-ranking")
def priority_ranking(db: Session = Depends(get_db)):
    equipments = db.query(Equipment).all()

    classement = []
    for equipment in equipments:
        tickets_non_resolus = [
            t for t in equipment.tickets
            if t.statut not in ("Résolu", "Clôturé")
        ]

        if not tickets_non_resolus:
            continue

        score = sum(
            PRIORITY_WEIGHT.get(t.priorite, 1) for t in tickets_non_resolus
        )

        classement.append({
            "equipment_id": equipment.id,
            "name": equipment.name,
            "inventory_code": equipment.inventory_code,
            "score_priorite": score,
            "tickets_non_resolus": len(tickets_non_resolus),
        })

    classement.sort(key=lambda item: item["score_priorite"], reverse=True)

    return {"classement": classement}


@router.post("/generate-alerts")
def generate_alerts(db: Session = Depends(get_db)):
    created = []

    def alert_exists(type_, equipment_id=None):
        query = db.query(Alert).filter(
            Alert.type == type_,
            Alert.statut == "Active",
        )
        if equipment_id is not None:
            query = query.filter(Alert.equipment_id == equipment_id)
        return db.query(query.exists()).scalar()

    equipments = db.query(Equipment).all()
    for equipment in equipments:
    
        nb_incidents = (
            db.query(Incident)
            .filter(Incident.equipment_id == equipment.id)
            .count()
        )

        if nb_incidents < 2:
            continue

        if alert_exists("equipement_problematique", equipment.id):
            continue

        alert = Alert(
            type="equipement_problematique",
            titre=f"Équipement problématique : {equipment.name}",
            message=f"{nb_incidents} incidents enregistrés pour cet équipement.",
            severite="Haute",
            equipment_id=equipment.id,
        )
        db.add(alert)
        created.append(alert)

    dates = [t.date_signalement for t in db.query(Ticket.date_signalement).all()]
    resultats_mensuels = _group_by_month(dates)
    valeurs = [nombre for mois, nombre in resultats_mensuels]

    if len(valeurs) >= 3:
        moyenne = statistics.mean(valeurs)
        ecart_type = statistics.pstdev(valeurs)
        seuil = moyenne + 2 * ecart_type

        for mois, nombre in resultats_mensuels:
            if nombre > seuil and not alert_exists("anomalie"):
                alert = Alert(
                    type="anomalie",
                    titre=f"Pic anormal de tickets en {mois}",
                    message=f"{nombre} tickets signalés en {mois}, au-dessus du seuil ({round(seuil, 2)}).",
                    severite="Critique",
                )
                db.add(alert)
                created.append(alert)

    db.commit()
    for alert in created:
        db.refresh(alert)

    return {
        "alertes_creees": len(created),
        "alertes": [
            {"id": a.id, "type": a.type, "titre": a.titre, "severite": a.severite}
            for a in created
        ]
    }


@router.get("/alerts")
def get_alerts(statut: str = None, db: Session = Depends(get_db)):
    query = db.query(Alert)

    if statut is not None:
        query = query.filter(Alert.statut == statut)

    results = query.order_by(Alert.date_creation.desc()).all()

    return [
        {
            "id": a.id,
            "type": a.type,
            "titre": a.titre,
            "message": a.message,
            "severite": a.severite,
            "statut": a.statut,
            "equipment_id": a.equipment_id,
            "ticket_id": a.ticket_id,
            "date_creation": a.date_creation,
        }
        for a in results
    ]


@router.put("/alerts/{alert_id}/resolve")
def resolve_alert(alert_id: int, db: Session = Depends(get_db)):
    alert = db.query(Alert).filter(Alert.id == alert_id).first()

    if not alert:
        return {"error": "Alerte introuvable"}, 404

    alert.statut = "Résolue"
    db.commit()
    db.refresh(alert)

    return {"id": alert.id, "titre": alert.titre, "statut": alert.statut}