from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from models import Ticket, TicketHistory
from database import SessionLocal
from schemas import TicketCreate, TicketUpdate, TicketHistoryResponse
from database import get_db


router = APIRouter(
    prefix="/tickets",
    tags=["Tickets"]
)


# =========================
# POST - Créer un ticket
# =========================
@router.post("/")
def create_ticket(
    ticket_data: TicketCreate,
    db: Session = Depends(get_db)
):
    ticket = Ticket(
        equipment_id=ticket_data.equipment_id,
        date_signalement=ticket_data.date_signalement,
        description=ticket_data.description,
        priorite=ticket_data.priorite,
        statut=ticket_data.statut,
        solution=ticket_data.solution,
        date_resolution=ticket_data.date_resolution
    )

    db.add(ticket)
    db.commit()
    db.refresh(ticket)

    return ticket


# =========================
# GET - Liste des tickets
# =========================
@router.get("/")
def get_tickets(
    db: Session = Depends(get_db)
):
    tickets = db.query(Ticket).all()
    return tickets


# =========================
# GET - Un ticket
# =========================
@router.get("/{ticket_id}")
def get_ticket(
    ticket_id: int,
    db: Session = Depends(get_db)
):
    ticket = db.query(Ticket).filter(
        Ticket.id == ticket_id
    ).first()

    if not ticket:
        raise HTTPException(
            status_code=404,
            detail="Ticket introuvable"
        )

    return ticket


# =========================
# PUT - Modifier un ticket
# =========================
@router.put("/{ticket_id}")
def update_ticket(
    ticket_id: int,
    ticket_data: TicketUpdate,
    db: Session = Depends(get_db)
):
    ticket = db.query(Ticket).filter(
        Ticket.id == ticket_id
    ).first()

    if not ticket:
        raise HTTPException(
            status_code=404,
            detail="Ticket introuvable"
        )
    ancien_statut = ticket.statut
    if ticket_data.priorite is not None:
        ticket.priorite = ticket_data.priorite

    if ticket_data.statut is not None:
        ticket.statut = ticket_data.statut

    if ticket_data.solution is not None:
        ticket.solution = ticket_data.solution

    if ticket_data.date_resolution is not None:
        ticket.date_resolution = ticket_data.date_resolution
    if ticket_data.technicien is not None:
        ticket.technicien = ticket_data.technicien

        # Enregistrer l'historique si le statut a changé
    if ticket_data.statut is not None and ticket_data.statut != ancien_statut:
        history = TicketHistory(
            ticket_id=ticket.id,
            action="Modification du statut",
            ancien_statut=ancien_statut,
            nouveau_statut=ticket_data.statut,
            date_action=datetime.now()
        )

        db.add(history)
    
    db.commit()
    db.refresh(ticket)

    return ticket


# =========================
# PUT - Clôturer un ticket
# =========================
@router.put("/{ticket_id}/close")
def close_ticket(
    ticket_id: int,
    db: Session = Depends(get_db)
):
    ticket = db.query(Ticket).filter(
        Ticket.id == ticket_id
    ).first()

    if not ticket:
        raise HTTPException(
            status_code=404,
            detail="Ticket introuvable"
        )

    if ticket.statut == "Clôturé":
        raise HTTPException(
            status_code=400,
            detail="Ce ticket est déjà clôturé"
        )

    # Ancien statut
    ancien_statut = ticket.statut

    # Modifier le ticket
    ticket.statut = "Clôturé"
    ticket.date_resolution = datetime.now()

    # Enregistrer la clôture dans l'historique
    history = TicketHistory(
        ticket_id=ticket.id,
        action="Clôture du ticket",
        ancien_statut=ancien_statut,
        nouveau_statut="Clôturé",
        date_action=datetime.now()
    )

    db.add(history)

    db.commit()
    db.refresh(ticket)

    return ticket

# =========================
# GET - Historique d'un ticket
# =========================
@router.get(
    "/{ticket_id}/history",
    response_model=list[TicketHistoryResponse]
)
def get_ticket_history(
    ticket_id: int,
    db: Session = Depends(get_db)
):
    # Vérifier que le ticket existe
    ticket = db.query(Ticket).filter(
        Ticket.id == ticket_id
    ).first()

    if not ticket:
        raise HTTPException(
            status_code=404,
            detail="Ticket introuvable"
        )

    # Récupérer l'historique
    history = db.query(TicketHistory).filter(
        TicketHistory.ticket_id == ticket_id
    ).order_by(
        TicketHistory.date_action.desc()
    ).all()

    return history
# =========================
# DELETE - Supprimer un ticket
# =========================
@router.delete("/{ticket_id}")
def delete_ticket(
    ticket_id: int,
    db: Session = Depends(get_db)
):
    ticket = db.query(Ticket).filter(
        Ticket.id == ticket_id
    ).first()

    if not ticket:
        raise HTTPException(
            status_code=404,
            detail="Ticket introuvable"
        )

    db.delete(ticket)
    db.commit()

    return {
        "message": "Ticket supprimé avec succès",
        "ticket_id": ticket_id
    }