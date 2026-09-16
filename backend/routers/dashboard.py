from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func, cast, Date
from database import SessionLocal
from models import Equipment, Ticket, Intervention, Incident
from database import get_db


router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"]
)


@router.get("/")
def get_dashboard(
    db: Session = Depends(get_db)
):
    total_equipment = db.query(Equipment).count()
    equipements_operationnels = db.query(Equipment).filter(
        Equipment.status == "En service"
    ).count()

    equipements_en_panne = db.query(Equipment).filter(
        Equipment.status == "En panne"
    ).count()

    total_tickets = db.query(Ticket).count()

    tickets_ouverts = db.query(Ticket).filter(
        Ticket.statut == "Ouvert"
    ).count()

    tickets_en_cours = db.query(Ticket).filter(
        Ticket.statut == "En cours"
    ).count()

    tickets_resolus = db.query(Ticket).filter(
        Ticket.statut == "Clôturé"
    ).count()

    total_interventions = db.query(Intervention).count()

    interventions_en_cours = db.query(Intervention).filter(
        Intervention.statut == "En cours"
    ).count()

    interventions_terminees = db.query(Intervention).filter(
        Intervention.statut == "Terminée"
    ).count()

    total_incidents = db.query(Incident).count()

    
    incidents_par_service = (
        db.query(
            Equipment.service,
            func.count(Incident.id)
        )
        .join(Incident, Incident.equipment_id == Equipment.id)
        .group_by(Equipment.service)
        .all()
    )

    incidents_par_type_equipement = (
    db.query(
        Equipment.category,
        func.count(Incident.id)
    )
    .join(Incident, Incident.equipment_id == Equipment.id)
    .group_by(Equipment.category)
    .all()
    )

    tickets_par_statut = (
    db.query(
        Ticket.statut,
        func.count(Ticket.id)
    )
    .group_by(Ticket.statut)
    .all()
)
    equipements_par_statut = (
    db.query(
        Equipment.status,
        func.count(Equipment.id)
    )
    .group_by(Equipment.status)
    .all()
)
    interventions_par_periode = (
    db.query(
        cast(Intervention.date_intervention, Date),
        func.count(Intervention.id)
    )
    .group_by(cast(Intervention.date_intervention, Date))
    .order_by(cast(Intervention.date_intervention, Date))
    .all()
)
    problemes_frequents = (
    db.query(
        Incident.description,
        func.count(Incident.id)
    )
    .group_by(Incident.description)
    .order_by(func.count(Incident.id).desc())
    .limit(10)
    .all()
)
    incidents_par_periode = (
    db.query(
        cast(Incident.date_signalement, Date),
        func.count(Incident.id)
    )
    .group_by(cast(Incident.date_signalement, Date))
    .order_by(cast(Incident.date_signalement, Date))
    .all()
)
    return {
        "total_equipment": total_equipment,
        "total_tickets": total_tickets,
        "tickets_ouverts": tickets_ouverts,
        "tickets_en_cours": tickets_en_cours,
        "tickets_resolus": tickets_resolus,
        "total_interventions": total_interventions,
        "equipements_operationnels": equipements_operationnels,
        "equipements_en_panne": equipements_en_panne,
        "interventions_en_cours": interventions_en_cours,
        "interventions_terminees": interventions_terminees,
        "total_incidents": total_incidents,
        "incidents_par_service": [
    {
        "service": service,
        "nombre": nombre
    }
    for service, nombre in incidents_par_service
],
        "incidents_par_type_equipement": [
    {
        "type_equipement": type_equipement,
        "nombre": nombre
    }
    for type_equipement, nombre in incidents_par_type_equipement
],
        "tickets_par_statut": [
    {
        "statut": statut,
        "nombre": nombre
    }
    for statut, nombre in tickets_par_statut
],
        "equipements_par_statut": [
    {
        "statut": statut,
        "nombre": nombre
    }
    for statut, nombre in equipements_par_statut
],
        "interventions_par_periode": [
    {
        "date": str(date),
        "nombre": nombre
    }
    for date, nombre in interventions_par_periode
],
        "problemes_frequents": [
    {
        "probleme": description,
        "nombre": nombre
    }
    for description, nombre in problemes_frequents
],

    "incidents_par_periode": [
    {
        "date": str(date),
        "nombre": nombre
    }
    for date, nombre in incidents_par_periode
],
    }