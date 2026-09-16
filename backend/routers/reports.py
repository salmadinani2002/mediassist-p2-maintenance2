from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db
from models import Report, Ticket, Incident, Intervention
from schemas import ReportCreate, ReportResponse


router = APIRouter(
    prefix="/reports",
    tags=["Reports"]
)


@router.post("/generate", response_model=ReportResponse)
def generate_report(
    report_data: ReportCreate,
    db: Session = Depends(get_db)
):
    """
    Génère un rapport en calculant les indicateurs sur la période
    demandée, et le sauvegarde pour consultation future.
    """
    debut = report_data.periode_debut
    fin = report_data.periode_fin

    tickets = db.query(Ticket).filter(
        Ticket.date_signalement >= debut,
        Ticket.date_signalement <= fin
    ).all()

    incidents = db.query(Incident).filter(
        Incident.date_signalement >= debut,
        Incident.date_signalement <= fin
    ).all()

    interventions = db.query(Intervention).filter(
        Intervention.date_intervention >= debut,
        Intervention.date_intervention <= fin
    ).all()

    tickets_resolus = [t for t in tickets if t.statut in ("Résolu", "Clôturé")]
    interventions_terminees = [i for i in interventions if i.statut == "Clôturée"]

    total_tickets = len(tickets)
    taux_resolution = (
        round(len(tickets_resolus) / total_tickets * 100)
        if total_tickets else 0
    )

    resume = (
        f"Sur la période du {debut.strftime('%d/%m/%Y')} au {fin.strftime('%d/%m/%Y')}, "
        f"{total_tickets} ticket(s) signalé(s), dont {len(tickets_resolus)} résolu(s) "
        f"({taux_resolution}%). {len(incidents)} incident(s) déclaré(s) et "
        f"{len(interventions)} intervention(s) réalisée(s), dont "
        f"{len(interventions_terminees)} clôturée(s)."
    )

    report = Report(
        titre=report_data.titre,
        periode_debut=debut,
        periode_fin=fin,
        total_tickets=total_tickets,
        tickets_resolus=len(tickets_resolus),
        taux_resolution_pourcent=taux_resolution,
        total_incidents=len(incidents),
        total_interventions=len(interventions),
        interventions_terminees=len(interventions_terminees),
        resume=resume,
    )

    db.add(report)
    db.commit()
    db.refresh(report)

    return report


@router.get("/", response_model=list[ReportResponse])
def get_reports(db: Session = Depends(get_db)):
    return db.query(Report).order_by(Report.date_generation.desc()).all()


@router.get("/{report_id}", response_model=ReportResponse)
def get_report(report_id: int, db: Session = Depends(get_db)):
    report = db.query(Report).filter(Report.id == report_id).first()

    if not report:
        raise HTTPException(status_code=404, detail="Rapport introuvable")

    return report


@router.delete("/{report_id}")
def delete_report(report_id: int, db: Session = Depends(get_db)):
    report = db.query(Report).filter(Report.id == report_id).first()

    if not report:
        raise HTTPException(status_code=404, detail="Rapport introuvable")

    db.delete(report)
    db.commit()

    return {"message": "Rapport supprimé avec succès", "report_id": report_id}