from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func
from database import get_db
from database import SessionLocal
from models import Equipment, Ticket, Intervention


router = APIRouter(
    prefix="/statistics",
    tags=["Statistics"]
)



@router.get("/")
def get_statistics(
    db: Session = Depends(get_db)
):
    equipment_by_category = db.query(
        Equipment.category,
        func.count(Equipment.id)
    ).group_by(
        Equipment.category
    ).all()

    equipment_by_status = db.query(
        Equipment.status,
        func.count(Equipment.id)
    ).group_by(
        Equipment.status
    ).all()

    tickets_by_priority = db.query(
        Ticket.priorite,
        func.count(Ticket.id)
    ).group_by(
        Ticket.priorite
    ).all()

    tickets_by_status = db.query(
        Ticket.statut,
        func.count(Ticket.id)
    ).group_by(
        Ticket.statut
    ).all()

    interventions_by_status = db.query(
        Intervention.statut,
        func.count(Intervention.id)
    ).group_by(
        Intervention.statut
    ).all()

    return {
        "equipment_by_category": [
            {
                "category": category,
                "count": count
            }
            for category, count in equipment_by_category
        ],

        "equipment_by_status": [
            {
                "status": status,
                "count": count
            }
            for status, count in equipment_by_status
        ],

        "tickets_by_priority": [
            {
                "priority": priority,
                "count": count
            }
            for priority, count in tickets_by_priority
        ],

        "tickets_by_status": [
            {
                "status": status,
                "count": count
            }
            for status, count in tickets_by_status
        ],

        "interventions_by_status": [
            {
                "status": status,
                "count": count
            }
            for status, count in interventions_by_status
        ]
    }