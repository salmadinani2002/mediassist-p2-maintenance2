def _create_equipment(client, code):
    response = client.post("/equipment/", json={
        "inventory_code": code,
        "name": "Scanner",
        "category": "Scanner",
        "service": "Radiologie",
        "status": "Opérationnel",
    })
    return response.json()


def test_frequent_problems(client):
    equipment = _create_equipment(client, "EQ-A1")

    for _ in range(3):
        client.post("/incidents/", json={
            "titre": "Bourrage",
            "description": "Bourrage papier",
            "priorite": "Basse",
            "statut": "Nouveau",
            "date_signalement": "2026-01-10T09:00:00",
            "equipment_id": equipment["id"],
        })

    response = client.get("/analysis/frequent-problems")

    assert response.status_code == 200
    data = response.json()
    top = next(item for item in data if item["probleme"] == "Bourrage papier")
    assert top["nombre"] == 3


def test_problematic_equipment(client):
    equipment = _create_equipment(client, "EQ-A2")

    for _ in range(2):
        client.post("/incidents/", json={
            "titre": "Panne",
            "description": "Panne",
            "priorite": "Haute",
            "statut": "Nouveau",
            "date_signalement": "2026-01-10T09:00:00",
            "equipment_id": equipment["id"],
        })

    response = client.get("/analysis/problematic-equipment")

    assert response.status_code == 200
    data = response.json()
    match = next(item for item in data if item["equipment_id"] == equipment["id"])
    assert match["nombre_incidents"] == 2
    assert match["inventory_code"] == "EQ-A2"


def test_priority_ranking(client):
    equipment = _create_equipment(client, "EQ-A3")

    client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Panne",
        "priorite": "Critique",
        "statut": "Ouvert",
    })

    response = client.get("/analysis/priority-ranking")

    assert response.status_code == 200
    data = response.json()["classement"]
    match = next(item for item in data if item["equipment_id"] == equipment["id"])
    assert match["score_priorite"] == 4


def test_indicators(client, equipment):
    client.post("/tickets/", json={
        "equipment_id": equipment["id"],
        "date_signalement": "2026-01-10T09:00:00",
        "description": "Panne",
        "priorite": "Basse",
        "statut": "Résolu",
        "date_resolution": "2026-01-11T09:00:00",
    })

    response = client.get("/analysis/indicators")

    assert response.status_code == 200
    data = response.json()
    assert data["taux_resolution_pourcent"] == 100.0
    assert data["temps_moyen_resolution_heures"] == 24.0


def test_anomalies_insufficient_history(client):
    response = client.get("/analysis/anomalies")

    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert data["anomalies"] == []


def test_generate_and_list_alerts(client):
    equipment = _create_equipment(client, "EQ-A4")

    for _ in range(2):
        client.post("/incidents/", json={
            "titre": "Panne",
            "description": "Panne",
            "priorite": "Critique",
            "statut": "Nouveau",
            "date_signalement": "2026-01-10T09:00:00",
            "equipment_id": equipment["id"],
        })

    response = client.post("/analysis/generate-alerts")
    assert response.status_code == 200
    assert response.json()["alertes_creees"] >= 1

    alerts = client.get("/analysis/alerts?statut=Active").json()
    assert len(alerts) >= 1

    alert_id = alerts[0]["id"]
    resolve_response = client.put(f"/analysis/alerts/{alert_id}/resolve")
    assert resolve_response.json()["statut"] == "Résolue"

        # Un deuxième appel recrée une alerte tant que le problème persiste
    # (l'équipement a toujours ses 2 incidents, l'ancienne alerte est résolue)
    second = client.post("/analysis/generate-alerts")
    active_after = client.get("/analysis/alerts?statut=Active").json()
    assert len(active_after) == 1
    assert active_after[0]["id"] != alert_id