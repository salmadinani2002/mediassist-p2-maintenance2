def test_create_incident(client, equipment):
    response = client.post("/incidents/", json={
        "titre": "Écran noir",
        "description": "Ecran noir au démarrage",
        "priorite": "Haute",
        "statut": "Nouveau",
        "date_signalement": "2026-01-10T09:00:00",
        "equipment_id": equipment["id"],
    })

    assert response.status_code == 200
    data = response.json()
    assert data["titre"] == "Écran noir"
    assert data["equipment_id"] == equipment["id"]


def test_create_incident_unknown_equipment(client):
    response = client.post("/incidents/", json={
        "titre": "Écran noir",
        "description": "Ecran noir au démarrage",
        "priorite": "Haute",
        "statut": "Nouveau",
        "date_signalement": "2026-01-10T09:00:00",
        "equipment_id": 999,
    })

    assert response.status_code == 404