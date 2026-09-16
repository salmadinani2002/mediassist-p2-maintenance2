from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from database import Base
from datetime import datetime, timezone


class Role(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False, unique=True)
    description = Column(Text, nullable=True)

    users = relationship("User", back_populates="role")


class Department(Base):
    __tablename__ = "departments"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, unique=True)
    location = Column(String(150), nullable=True)
    description = Column(Text, nullable=True)

    users = relationship("User", back_populates="department")


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    employee_code = Column(String(30), nullable=False, unique=True)
    first_name = Column(String(50), nullable=False)
    last_name = Column(String(50), nullable=False)
    email = Column(String(150), nullable=False, unique=True)
    phone = Column(String(30), nullable=True)
    password_hash = Column(String(255), nullable=False)

    role_id = Column(Integer, ForeignKey("roles.id"), nullable=False)
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=True)

    is_active = Column(Boolean, nullable=False, default=True)

    role = relationship("Role", back_populates="users")
    department = relationship("Department", back_populates="users")

class EquipmentCategory(Base):
    __tablename__ = "equipment_categories"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, unique=True)
    description = Column(Text, nullable=True)

    equipments = relationship("Equipment", back_populates="category_relation")

class Equipment(Base):
    __tablename__ = "equipment"

    id = Column(Integer, primary_key=True, index=True)
    inventory_code = Column(String(50), unique=True, nullable=False)
    name = Column(String(100), nullable=False)
    category = Column(String(50), nullable=False)
    service = Column(String(100), nullable=False)
    brand = Column(String(50))
    model = Column(String(100))
    status = Column(String(50), nullable=False)
    category_id = Column(Integer, ForeignKey("equipment_categories.id"), nullable=True)
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=True)

    # Relation : un équipement peut avoir plusieurs tickets
    tickets = relationship("Ticket", back_populates="equipment")
    # Incidents
    incidents = relationship(
        "Incident",
        back_populates="equipment"
    )
    category_relation = relationship(
    "EquipmentCategory",
    back_populates="equipments"
    )

    department = relationship("Department")
    


class Ticket(Base):
    __tablename__ = "ticket"

    id = Column(Integer, primary_key=True, index=True)

    # Clé étrangère vers equipment
    equipment_id = Column(
        Integer,
        ForeignKey("equipment.id"),
        nullable=False
    )
    department_id = Column(
    Integer,
    ForeignKey("departments.id"),
    nullable=True
    )
    user_id = Column(
    Integer,
    ForeignKey("users.id"),
    nullable=True
    )
    user = relationship("User")

    date_signalement = Column(DateTime, nullable=False)
    description = Column(Text, nullable=False)
    priorite = Column(String(20), nullable=False)
    statut = Column(String(20), nullable=False)
    solution = Column(Text, nullable=True)
    date_resolution = Column(DateTime, nullable=True)
    technicien = Column(String(100), nullable=True)

    # Relation avec Equipment
    equipment = relationship("Equipment", back_populates="tickets")
    historique = relationship(
    "TicketHistory",
    back_populates="ticket",
    cascade="all, delete-orphan"
)
    department = relationship("Department")
    user = relationship("User")
    interventions = relationship(
    "Intervention",
    back_populates="ticket"
)

class TicketHistory(Base):
    __tablename__ = "ticket_history"

    id = Column(Integer, primary_key=True, index=True)

    ticket_id = Column(
        Integer,
        ForeignKey("ticket.id"),
        nullable=False
    )

    action = Column(String(100), nullable=False)

    ancien_statut = Column(String(50), nullable=True)

    nouveau_statut = Column(String(50), nullable=True)
    ancienne_priorite = Column(
        String(20),
        nullable=True
    )

    nouvelle_priorite = Column(
        String(20),
        nullable=True
    )

    date_action = Column(
        DateTime,
        default=datetime.now,
        nullable=False
    )

    ticket = relationship(
        "Ticket",
        back_populates="historique"
    )
class Intervention(Base):
    __tablename__ = "intervention"

    id = Column(Integer, primary_key=True, index=True)

    # Ticket concerné par l'intervention
    ticket_id = Column(
        Integer,
        ForeignKey("ticket.id"),
        nullable=False
    )
    user_id = Column(
    Integer,
    ForeignKey("users.id"),
    nullable=True
    )

    department_id = Column(
    Integer,
    ForeignKey("departments.id"),
    nullable=True
    )

    date_intervention = Column(DateTime, nullable=False)
    date_fin = Column(DateTime, nullable=True)
    type_intervention = Column(String(100), nullable=False)
    description = Column(Text, nullable=True)
    actions = Column(Text, nullable=True)
    solution = Column(Text, nullable=True)
    resultat = Column(Text, nullable=True)
    technicien = Column(String(100), nullable=True)
    statut = Column(String(50), nullable=False)

    # Relation avec Ticket
    ticket = relationship(
        "Ticket",
        back_populates="interventions"
    )
    historique = relationship(
        "InterventionHistory",
        back_populates="intervention",
        cascade="all, delete-orphan"
    )
    commentaires = relationship(
        "InterventionComment",
        back_populates="intervention",
        cascade="all, delete-orphan"
    )
    user = relationship("User")
    department = relationship("Department")

class InterventionHistory(Base):
    __tablename__ = "intervention_history"

    id = Column(Integer, primary_key=True, index=True)
    intervention_id = Column(Integer, ForeignKey("intervention.id"), nullable=False)
    action = Column(String(100), nullable=False)

    ancien_statut = Column(String(50), nullable=True)
    nouveau_statut = Column(String(50), nullable=True)

    ancien_technicien = Column(String(100), nullable=True)
    nouveau_technicien = Column(String(100), nullable=True)

    ancienne_description = Column(Text, nullable=True)
    nouvelle_description = Column(Text, nullable=True)

    anciennes_actions = Column(Text, nullable=True)
    nouvelles_actions = Column(Text, nullable=True)

    ancienne_solution = Column(Text, nullable=True)
    nouvelle_solution = Column(Text, nullable=True)

    ancien_resultat = Column(Text, nullable=True)
    nouveau_resultat = Column(Text, nullable=True)

    date_action = Column(
        DateTime,
        nullable=False,
        default=datetime.now
    )

    intervention = relationship(
        "Intervention",
        back_populates="historique"
    )

class InterventionComment(Base):
    __tablename__ = "intervention_comment"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    intervention_id = Column(
        Integer,
        ForeignKey("intervention.id"),
        nullable=False
    )

    commentaire = Column(
        Text,
        nullable=False
    )

    date_commentaire = Column(
        DateTime,
        nullable=False,
        default=datetime.now
    )

    intervention = relationship(
        "Intervention",
        back_populates="commentaires"
    )

class Incident(Base):
    __tablename__ = "incident"

    id = Column(Integer, primary_key=True, index=True)

    titre = Column(String(150), nullable=False)
    description = Column(Text, nullable=False)
    priorite = Column(String(20), nullable=False)
    statut = Column(String(50), nullable=False)
    date_signalement = Column(DateTime, nullable=False)
    solution = Column(Text, nullable=True)
    equipment_id = Column(
        Integer,
        ForeignKey("equipment.id"),
        nullable=False
    )
    ticket_id = Column(
        Integer,
        ForeignKey("ticket.id"),
        nullable=True
    )

    technicien = Column(String(100), nullable=True)

    # Relation avec Equipment
    equipment = relationship(
        "Equipment",
        back_populates="incidents"
    )
    ticket = relationship("Ticket")

class Alert(Base):
    """
    Table Alert (section I du cahier des charges P2).
    Générée automatiquement par le module d'analyse (analysis.py),
    ou manuellement.
    """
    __tablename__ = "alert"

    id = Column(Integer, primary_key=True, index=True)

    type = Column(String(50), nullable=False)
    # "equipement_problematique", "anomalie", "manuelle"...

    titre = Column(String(150), nullable=False)
    message = Column(Text, nullable=False)
    severite = Column(String(20), nullable=False, default="Moyenne")
    statut = Column(String(20), nullable=False, default="Active")
    # Active / Résolue

    equipment_id = Column(Integer, ForeignKey("equipment.id"), nullable=True)
    ticket_id = Column(Integer, ForeignKey("ticket.id"), nullable=True)

    date_creation = Column(DateTime, nullable=False, default=datetime.utcnow)

    equipment = relationship("Equipment")
    ticket = relationship("Ticket")

class Report(Base):
    """
    Table Report (section I du cahier des charges P2).
    Un rapport capture un instantané des indicateurs clés sur une
    période donnée, pour garder une trace consultable plus tard
    (au lieu de recalculer à chaque fois via /analysis/indicators).
    """
    __tablename__ = "report"

    id = Column(Integer, primary_key=True, index=True)

    titre = Column(String(200), nullable=False)
    periode_debut = Column(DateTime, nullable=False)
    periode_fin = Column(DateTime, nullable=False)

    total_tickets = Column(Integer, nullable=False, default=0)
    tickets_resolus = Column(Integer, nullable=False, default=0)
    taux_resolution_pourcent = Column(Integer, nullable=False, default=0)

    total_incidents = Column(Integer, nullable=False, default=0)
    total_interventions = Column(Integer, nullable=False, default=0)
    interventions_terminees = Column(Integer, nullable=False, default=0)

    resume = Column(Text, nullable=True)

    date_generation = Column(
        DateTime,
        nullable=False,
        default=lambda: datetime.now(timezone.utc).replace(tzinfo=None)
    )