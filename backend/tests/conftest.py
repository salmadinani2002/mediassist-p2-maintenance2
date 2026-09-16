import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from fastapi.testclient import TestClient

from database import Base, get_db
import main

TEST_DATABASE_URL = "sqlite:///./test_mediassist.db"

engine = create_engine(
    TEST_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(
    autocommit=False, autoflush=False, bind=engine
)


def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


main.app.dependency_overrides[get_db] = override_get_db


@pytest.fixture()
def client():
    Base.metadata.create_all(bind=engine)
    with TestClient(main.app) as test_client:
        yield test_client
    Base.metadata.drop_all(bind=engine)


@pytest.fixture()
def equipment(client):
    response = client.post("/equipment/", json={
        "inventory_code": "PC-TEST-001",
        "name": "PC de test",
        "category": "Ordinateur",
        "service": "Radiologie",
        "status": "Opérationnel",
    })
    assert response.status_code == 200
    return response.json()