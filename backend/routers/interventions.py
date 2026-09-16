from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from database import get_db
from database import SessionLocal
from models import Intervention, InterventionHistory, Ticket
from models import Intervention, Ticket, InterventionComment
from schemas import (
    InterventionCreate,
    InterventionUpdate,
    InterventionHistoryResponse,
    InterventionCommentCreate,
    InterventionCommentResponse
)

router = APIRouter(
    prefix="/interventions",
    tags=["Interventions"]
)



@router.post("/")
def create_intervention(
    intervention_data: InterventionCreate,
    db: Session = Depends(get_db)
):
    # Vérifier que le ticket existe
    ticket = db.query(Ticket).filter(
        Ticket.id == intervention_data.ticket_id
    ).first()

    if not ticket:
        raise HTTPException(
            status_code=404,
            detail="Ticket introuvable"
        )

    intervention = Intervention(
        ticket_id=intervention_data.ticket_id,
        date_intervention=intervention_data.date_intervention,
        date_fin=intervention_data.date_fin,
        type_intervention=intervention_data.type_intervention,
        description=intervention_data.description,
        actions=intervention_data.actions,
        solution=intervention_data.solution,
        resultat=intervention_data.resultat,
        technicien=intervention_data.technicien,
        statut=intervention_data.statut
    )

    db.add(intervention)
    db.commit()
    db.refresh(intervention)
    history = InterventionHistory(
        intervention_id=intervention.id,
        action="Création de l'intervention",
        ancien_statut=None,
        nouveau_statut=intervention.statut,
        ancien_technicien=None,
        nouveau_technicien=intervention.technicien,
        date_action=datetime.now(),
    )

    db.add(history)
    db.commit()

    db.refresh(intervention)



    return intervention

@router.get("/")
def get_interventions(
    db: Session = Depends(get_db)
):
    interventions = db.query(Intervention).all()

    return interventions

@router.get("/{intervention_id}")
def get_intervention(
    intervention_id: int,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    return intervention

@router.put("/{intervention_id}")
def update_intervention(
    intervention_id: int,
    intervention_data: InterventionUpdate,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )
    ancien_statut = intervention.statut
    ancien_technicien = intervention.technicien
    ancienne_description = intervention.description
    anciennes_actions = intervention.actions
    ancienne_solution = intervention.solution
    ancien_resultat = intervention.resultat

    if intervention_data.description is not None and intervention_data.description != ancienne_description:
        history = InterventionHistory(
            intervention_id=intervention.id,
            action="Modification de la description",
            ancienne_description=ancienne_description,
            nouvelle_description=intervention_data.description,
            date_action=datetime.now(),
    )
        db.add(history)

    if intervention_data.actions is not None and intervention_data.actions != anciennes_actions:
        history = InterventionHistory(
            intervention_id=intervention.id,
            action="Modification des actions",
            anciennes_actions=anciennes_actions,
            nouvelles_actions=intervention_data.actions,
            date_action=datetime.now(),
    )
        db.add(history)

    if intervention_data.solution is not None and intervention_data.solution != ancienne_solution:
        history = InterventionHistory(
            intervention_id=intervention.id,
            action="Modification de la solution",
            ancienne_solution=ancienne_solution,
            nouvelle_solution=intervention_data.solution,
            date_action=datetime.now(),
    )
        db.add(history)

    if intervention_data.resultat is not None and intervention_data.resultat != ancien_resultat:
        history = InterventionHistory(
            intervention_id=intervention.id,
            action="Modification du résultat",
            ancien_resultat=ancien_resultat,
            nouveau_resultat=intervention_data.resultat,
            date_action=datetime.now(),
    )
        db.add(history)


    if intervention_data.date_intervention is not None:
        intervention.date_intervention = intervention_data.date_intervention

    if intervention_data.date_fin is not None:
        intervention.date_fin = intervention_data.date_fin

    if intervention_data.type_intervention is not None:
        intervention.type_intervention = intervention_data.type_intervention

    if intervention_data.description is not None:
        intervention.description = intervention_data.description

    if intervention_data.actions is not None:
        intervention.actions = intervention_data.actions

    if intervention_data.solution is not None:
        intervention.solution = intervention_data.solution

    if intervention_data.resultat is not None:
        intervention.resultat = intervention_data.resultat

    if intervention_data.technicien is not None:
        intervention.technicien = intervention_data.technicien

    if intervention_data.statut is not None:
        intervention.statut = intervention_data.statut

    if (
        intervention_data.statut is not None
        and intervention_data.statut != ancien_statut
    ):
        history = InterventionHistory(
            intervention_id=intervention.id,
            action="Modification du statut",
            ancien_statut=ancien_statut,
            nouveau_statut=intervention_data.statut,
            date_action=datetime.now(),
        )

        db.add(history)

    if (
        intervention_data.technicien is not None
        and intervention_data.technicien != ancien_technicien
    ):
        history = InterventionHistory(
            intervention_id=intervention.id,
            action="Modification du technicien",
            ancien_technicien=ancien_technicien,
            nouveau_technicien=intervention_data.technicien,
            date_action=datetime.now(),
        )

        db.add(history)

    db.commit()
    db.refresh(intervention)

    return intervention

# =========================================================
# PUT - Affecter un technicien
# =========================================================

@router.put("/{intervention_id}/assign")
def assign_technician(
    intervention_id: int,
    technicien: str,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    ancien_technicien = intervention.technicien

    intervention.technicien = technicien

    history = InterventionHistory(
        intervention_id=intervention.id,
        action="Affectation du technicien",
        ancien_technicien=ancien_technicien,
        nouveau_technicien=technicien,
        date_action=datetime.now(),
    )

    db.add(history)

    db.commit()
    db.refresh(intervention)

    return intervention


# =========================================================
# PUT - Clôturer une intervention
# =========================================================

@router.put("/{intervention_id}/close")
def close_intervention(
    intervention_id: int,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    if intervention.statut == "Clôturée":
        raise HTTPException(
            status_code=400,
            detail="Cette intervention est déjà clôturée"
        )

    ancien_statut = intervention.statut

    intervention.statut = "Clôturée"

    # Enregistrer la date de fin automatiquement
    intervention.date_fin = datetime.now()

    history = InterventionHistory(
        intervention_id=intervention.id,
        action="Clôture de l'intervention",
        ancien_statut=ancien_statut,
        nouveau_statut="Clôturée",
        date_action=datetime.now(),
    )

    db.add(history)

    db.commit()
    db.refresh(intervention)

    return intervention


# =========================================================
# GET - Historique d'une intervention
# =========================================================

@router.get(
    "/{intervention_id}/history",
    response_model=list[InterventionHistoryResponse]
)
def get_intervention_history(
    intervention_id: int,
    db: Session = Depends(get_db)
):
    # Vérifier que l'intervention existe
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    # Récupérer l'historique
    history = db.query(InterventionHistory).filter(
        InterventionHistory.intervention_id == intervention_id
    ).order_by(
        InterventionHistory.date_action.desc()
    ).all()

    return history



@router.delete("/{intervention_id}")
def delete_intervention(
    intervention_id: int,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    db.delete(intervention)
    db.commit()

    return {
        "message": "Intervention supprimée avec succès",
        "intervention_id": intervention_id
    }

# =========================================================
# POST - Ajouter un commentaire à une intervention
# =========================================================
@router.post("/{intervention_id}/comments", response_model=InterventionCommentResponse)
def add_comment(
    intervention_id: int,
    comment_data: InterventionCommentCreate,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    comment = InterventionComment(
        intervention_id=intervention_id,
        commentaire=comment_data.commentaire
    )

    db.add(comment)
    db.commit()
    db.refresh(comment)

    return comment

# =========================================================
# GET - Récupérer les commentaires d'une intervention
# =========================================================
@router.get(
    "/{intervention_id}/comments",
    response_model=list[InterventionCommentResponse]
)
def get_comments(
    intervention_id: int,
    db: Session = Depends(get_db)
):
    intervention = db.query(Intervention).filter(
        Intervention.id == intervention_id
    ).first()

    if not intervention:
        raise HTTPException(
            status_code=404,
            detail="Intervention introuvable"
        )

    comments = db.query(InterventionComment).filter(
        InterventionComment.intervention_id == intervention_id
    ).order_by(
        InterventionComment.date_commentaire.desc()
    ).all()

    return comments
