from fastapi import FastAPI
from sqlalchemy import text
from database import engine, Base
from models import Equipment, Ticket, Intervention
from routers.tickets import router as tickets_router
from routers.equipment import router as equipment_router
from routers.interventions import router as interventions_router
from routers.dashboard import router as dashboard_router
from routers.statistics import router as statistics_router
from fastapi.middleware.cors import CORSMiddleware
from routers import incidents
from routers import analysis
from routers.reports import router as reports_router

app = FastAPI(title="MediAssist AI - P2")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
Base.metadata.create_all(bind=engine)

app.include_router(tickets_router)
app.include_router(equipment_router)
app.include_router(interventions_router)
app.include_router(dashboard_router)
app.include_router(statistics_router)
app.include_router(incidents.router)
app.include_router(analysis.router)
app.include_router(reports_router)


@app.get("/")
def root():
    return {
        "message": "MediAssist AI - Backend P2 fonctionne"
    }


@app.get("/test-db")
def test_database():
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))

        return {
            "message": "Connexion PostgreSQL réussie !"
        }

    except Exception as e:
        return {
            "message": "Erreur de connexion à PostgreSQL",
            "error": str(e)
        }