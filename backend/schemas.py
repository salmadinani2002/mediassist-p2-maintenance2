from datetime import datetime
from typing import Optional
from pydantic import BaseModel


class EquipmentCreate(BaseModel):
    inventory_code: str
    name: str
    category: str
    service: str
    brand: Optional[str] = None
    model: Optional[str] = None
    status: str


class TicketCreate(BaseModel):
    equipment_id: int
    date_signalement: datetime
    description: str
    priorite: str
    statut: str
    solution: Optional[str] = None
    date_resolution: Optional[datetime] = None
    technicien: Optional[str] = None

class TicketUpdate(BaseModel):
    priorite: Optional[str] = None
    statut: Optional[str] = None
    solution: Optional[str] = None
    date_resolution: Optional[datetime] = None
    technicien: Optional[str] = None

class InterventionCreate(BaseModel):
    ticket_id: int
    date_intervention: datetime
    date_fin: Optional[datetime] = None
    type_intervention: str
    description: Optional[str] = None
    actions: Optional[str] = None
    solution: Optional[str] = None
    resultat: Optional[str] = None
    technicien: Optional[str] = None
    statut: str

class InterventionUpdate(BaseModel):
    date_intervention: Optional[datetime] = None
    date_fin: Optional[datetime] = None
    type_intervention: Optional[str] = None
    description: Optional[str] = None
    actions: Optional[str] = None
    solution: Optional[str] = None
    resultat: Optional[str] = None
    technicien: Optional[str] = None
    statut: Optional[str] = None

class IncidentBase(BaseModel):
    titre: str
    description: str
    priorite: str
    statut: str
    date_signalement: datetime
    solution: str | None = None

class InterventionHistoryResponse(BaseModel):
    id: int
    intervention_id: int

    action: str

    ancien_statut: Optional[str] = None
    nouveau_statut: Optional[str] = None

    ancien_technicien: Optional[str] = None
    nouveau_technicien: Optional[str] = None

    ancienne_description: Optional[str] = None
    nouvelle_description: Optional[str] = None

    anciennes_actions: Optional[str] = None
    nouvelles_actions: Optional[str] = None

    ancienne_solution: Optional[str] = None
    nouvelle_solution: Optional[str] = None

    ancien_resultat: Optional[str] = None
    nouveau_resultat: Optional[str] = None

    date_action: datetime

    class Config:
        from_attributes = True


class IncidentCreate(BaseModel):
    titre: str
    description: str
    priorite: str
    statut: str = "Ouvert"
    equipment_id: int
    solution: str | None = None
    technicien: str | None = None

class IncidentResponse(IncidentBase):
    id: int
    equipment_id: int
    ticket_id: Optional[int] = None
    technicien: Optional[str] = None

    class Config:
        from_attributes = True

class IncidentUpdate(BaseModel):
    priorite: Optional[str] = None
    statut: Optional[str] = None
    technicien: Optional[str] = None

class TicketHistoryResponse(BaseModel):
    id: int
    ticket_id: int
    action: str
    ancien_statut: str | None = None
    nouveau_statut: str | None = None
    date_action: datetime
    ancienne_priorite: Optional[str] = None
    nouvelle_priorite: Optional[str] = None

    class Config:
        from_attributes = True

class InterventionCommentCreate(BaseModel):
    intervention_id: int
    commentaire: str


class InterventionCommentResponse(BaseModel):
    id: int
    intervention_id: int
    commentaire: str
    date_commentaire: datetime

    class Config:
        from_attributes = True

class AlertCreate(BaseModel):
    type: str
    titre: str
    message: str
    severite: str = "Moyenne"
    equipment_id: Optional[int] = None
    ticket_id: Optional[int] = None


class AlertResponse(BaseModel):
    id: int
    type: str
    titre: str
    message: str
    severite: str
    statut: str
    equipment_id: Optional[int] = None
    ticket_id: Optional[int] = None
    date_creation: datetime

    class Config:
        from_attributes = True



class ReportCreate(BaseModel):
    titre: str
    periode_debut: datetime
    periode_fin: datetime


class ReportResponse(BaseModel):
    id: int
    titre: str
    periode_debut: datetime
    periode_fin: datetime
    total_tickets: int
    tickets_resolus: int
    taux_resolution_pourcent: int
    total_incidents: int
    total_interventions: int
    interventions_terminees: int
    resume: Optional[str] = None
    date_generation: datetime

    class Config:
        from_attributes = True