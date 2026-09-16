import pytest


@pytest.fixture()
def ticket(client, equipment):
    return client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Ne s'allume plus",
        "priorite": "Critique",
        "statut": "Ouvert",
    }).json()


def test_create_intervention(client, ticket):
    response = client.post("/interventions/", json={
        "ticket_id": ticket["id"],
        "date_intervention": "2026-01-11T09:00:00",
        "type_intervention": "Réparation",
        "technicien": "Karim",
        "statut": "En cours",
    })

    assert response.status_code == 200
    data = response.json()
    assert data["technicien"] == "Karim"


def test_create_intervention_unknown_ticket(client):
    response = client.post("/interventions/", json={
        "ticket_id": 9999,
        "date_intervention": "2026-01-11T09:00:00",
        "type_intervention": "Réparation",
        "statut": "En cours",
    })

    assert response.status_code == 404


def test_close_intervention_sets_date_fin(client, ticket):
    intervention = client.post("/interventions/", json={
        "ticket_id": ticket["id"],
        "date_intervention": "2026-01-11T09:00:00",
        "type_intervention": "Réparation",
        "statut": "En cours",
    }).json()

    response = client.put(f"/interventions/{intervention['id']}/close")

    assert response.status_code == 200
    data = response.json()
    assert data["statut"] == "Clôturée"
    assert data["date_fin"] is not None


def test_delete_intervention(client, ticket):
    intervention = client.post("/interventions/", json={
        "ticket_id": ticket["id"],
        "date_intervention": "2026-01-11T09:00:00",
        "type_intervention": "Réparation",
        "statut": "En cours",
    }).json()

    response = client.delete(f"/interventions/{intervention['id']}")
    assert response.status_code == 200

    response = client.get(f"/interventions/{intervention['id']}")
    assert response.status_code == 404