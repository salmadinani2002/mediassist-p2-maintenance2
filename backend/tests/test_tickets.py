def test_create_ticket(client, equipment):
    response = client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Ne s'allume plus",
        "priorite": "Critique",
        "statut": "Ouvert",
    })

    assert response.status_code == 200
    data = response.json()
    assert data["statut"] == "Ouvert"


def test_close_ticket_sets_statut_and_date(client, equipment):
    ticket = client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Ne s'allume plus",
        "priorite": "Critique",
        "statut": "En cours",
    }).json()

    response = client.put(f"/tickets/{ticket['id']}/close")

    assert response.status_code == 200
    data = response.json()
    assert data["statut"] == "Clôturé"


def test_update_ticket_technicien(client, equipment):
    ticket = client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Lenteur",
        "priorite": "Basse",
        "statut": "Ouvert",
    }).json()

    response = client.put(f"/tickets/{ticket['id']}", json={
        "priorite": "Moyenne",
        "statut": "En cours",
        "technicien": "Karim",
    })

    assert response.status_code == 200
    data = response.json()
    assert data["priorite"] == "Moyenne"
    assert data["technicien"] == "Karim"


def test_ticket_not_found(client):
    response = client.get("/tickets/9999")
    assert response.status_code == 404


def test_delete_ticket(client, equipment):
    ticket = client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Lenteur",
        "priorite": "Basse",
        "statut": "Ouvert",
    }).json()

    response = client.delete(f"/tickets/{ticket['id']}")
    assert response.status_code == 200

    response = client.get(f"/tickets/{ticket['id']}")
    assert response.status_code == 404