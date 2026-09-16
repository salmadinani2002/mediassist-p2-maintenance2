from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from database import get_db
from models import Incident, Equipment, Ticket
from schemas import IncidentCreate, IncidentResponse, IncidentUpdate


router = APIRouter(
    prefix="/incidents",
    tags=["Incidents"]
)


# =========================
# GET - Liste des incidents
# =========================

@router.get("/", response_model=list[IncidentResponse])
def get_incidents(
    db: Session = Depends(get_db)
):
    return db.query(Incident).all()


# =========================
# POST - Créer un incident
# =========================

@router.post("/", response_model=IncidentResponse)
def create_incident(
    incident: IncidentCreate,
    db: Session = Depends(get_db)
):
    # Vérifier que l'équipement existe
    equipment = db.query(Equipment).filter(
        Equipment.id == incident.equipment_id
    ).first()

    if not equipment:
        raise HTTPException(
            status_code=404,
            detail="Équipement non trouvé"
        )

    new_incident = Incident(
        titre=incident.titre,
        description=incident.description,
        priorite=incident.priorite,
        statut=incident.statut,
        equipment_id=incident.equipment_id,
        date_signalement=datetime.now(),
        solution=incident.solution,
    )

    db.add(new_incident)
    db.commit()
    db.refresh(new_incident)

    return new_incident


# =========================
# GET - Un incident
# =========================

@router.get(
    "/{incident_id}",
    response_model=IncidentResponse
)
def get_incident(
    incident_id: int,
    db: Session = Depends(get_db)
):
    incident = db.query(Incident).filter(
        Incident.id == incident_id
    ).first()

    if not incident:
        raise HTTPException(
            status_code=404,
            detail="Incident non trouvé"
        )

    return incident


# =========================
# PUT - Modifier un incident (statut, priorité, technicien)
# =========================

@router.put("/{incident_id}", response_model=IncidentResponse)
def update_incident(
    incident_id: int,
    incident_data: IncidentUpdate,
    db: Session = Depends(get_db)
):
    incident = db.query(Incident).filter(
        Incident.id == incident_id
    ).first()

    if not incident:
        raise HTTPException(
            status_code=404,
            detail="Incident non trouvé"
        )

    if incident_data.priorite is not None:
        incident.priorite = incident_data.priorite

    if incident_data.statut is not None:
        incident.statut = incident_data.statut

    if incident_data.technicien is not None:
        incident.technicien = incident_data.technicien

    db.commit()
    db.refresh(incident)

    return incident


# =========================
# POST - Créer un ticket à partir d'un incident
# =========================

@router.post("/{incident_id}/create-ticket")
def create_ticket_from_incident(
    incident_id: int,
    db: Session = Depends(get_db)
):
    incident = db.query(Incident).filter(
        Incident.id == incident_id
    ).first()

    if not incident:
        raise HTTPException(
            status_code=404,
            detail="Incident non trouvé"
        )

    if incident.ticket_id is not None:
        raise HTTPException(
            status_code=400,
            detail="Un ticket existe déjà pour cet incident"
        )

    ticket = Ticket(
        equipment_id=incident.equipment_id,
        date_signalement=incident.date_signalement,
        description=incident.description,
        priorite=incident.priorite,
        statut="Ouvert",
    )

    db.add(ticket)
    db.commit()
    db.refresh(ticket)

    incident.ticket_id = ticket.id
    incident.statut = "Ouvert"

    db.commit()
    db.refresh(incident)

    return {
        "message": "Ticket créé et lié à l'incident",
        "incident_id": incident.id,
        "ticket_id": ticket.id,
    }