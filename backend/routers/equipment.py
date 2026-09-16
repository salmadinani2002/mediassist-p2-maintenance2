from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from database import SessionLocal
from models import Equipment
from schemas import EquipmentCreate


router = APIRouter(
    prefix="/equipment",
    tags=["Equipment"]
)



# =========================
# GET - Liste des équipements
# =========================

@router.get("/")
def get_equipments(
    db: Session = Depends(get_db)
):
    equipments = db.query(Equipment).all()
    return equipments


# =========================
# GET - Un équipement
# =========================

@router.get("/{equipment_id}")
def get_equipment(
    equipment_id: int,
    db: Session = Depends(get_db)
):
    equipment = db.query(Equipment).filter(
        Equipment.id == equipment_id
    ).first()

    if not equipment:
        raise HTTPException(
            status_code=404,
            detail="Équipement introuvable"
        )

    return equipment


# =========================
# POST - Créer un équipement
# =========================

@router.post("/")
def create_equipment(
    equipment_data: EquipmentCreate,
    db: Session = Depends(get_db)
):
    # Vérifier si le code inventaire existe déjà
    existing_equipment = db.query(Equipment).filter(
        Equipment.inventory_code == equipment_data.inventory_code
    ).first()

    if existing_equipment:
        raise HTTPException(
            status_code=400,
            detail="Ce code inventaire existe déjà"
        )

    equipment = Equipment(
        inventory_code=equipment_data.inventory_code,
        name=equipment_data.name,
        category=equipment_data.category,
        service=equipment_data.service,
        brand=equipment_data.brand,
        model=equipment_data.model,
        status=equipment_data.status
    )

    db.add(equipment)
    db.commit()
    db.refresh(equipment)

    return equipment