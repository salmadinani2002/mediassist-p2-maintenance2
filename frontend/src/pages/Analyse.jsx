import { useEffect, useState } from "react";
import api from "../services/api";

function Analyse() {
  const [indicators, setIndicators] = useState(null);
  const [problematicEquipment, setProblematicEquipment] = useState([]);
  const [frequentProblems, setFrequentProblems] = useState([]);
  const [priorityRanking, setPriorityRanking] = useState([]);
  const [trends, setTrends] = useState([]);
  const [anomalies, setAnomalies] = useState(null);
  const [alerts, setAlerts] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const loadData = async () => {
      try {
        setLoading(true);
        setError("");

        const [
          indicatorsRes,
          equipmentRes,
          problemsRes,
          rankingRes,
          trendsRes,
          anomaliesRes,
          alertsRes,
        ] = await Promise.all([
          api.get("/analysis/indicators"),
          api.get("/analysis/problematic-equipment"),
          api.get("/analysis/frequent-problems"),
          api.get("/analysis/priority-ranking"),
          api.get("/analysis/trends"),
          api.get("/analysis/anomalies"),
          api.get("/analysis/alerts?statut=Active"),
        ]);

        setIndicators(indicatorsRes.data);
        setProblematicEquipment(equipmentRes.data);
        setFrequentProblems(problemsRes.data);
        setPriorityRanking(rankingRes.data.classement);
        setTrends(trendsRes.data);
        setAnomalies(anomaliesRes.data);
        setAlerts(alertsRes.data);
      } catch (error) {
        console.error(error);
        setError("Impossible de récupérer les données d'analyse.");
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  const handleGenerateAlerts = async () => {
    try {
      await api.post("/analysis/generate-alerts");
      const response = await api.get("/analysis/alerts?statut=Active");
      setAlerts(response.data);
    } catch (error) {
      console.error(error);
      alert("Impossible de générer les alertes.");
    }
  };

  const handleResolveAlert = async (alertId) => {
    try {
      await api.put(`/analysis/alerts/${alertId}/resolve`);
      setAlerts((previous) => previous.filter((a) => a.id !== alertId));
    } catch (error) {
      console.error(error);
      alert("Impossible de résoudre l'alerte.");
    }
  };

  if (loading) {
    return (
      <div className="analyse-page">
        <h1>Analyse intelligente</h1>
        <p>Chargement des analyses...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="analyse-page">
        <h1>Analyse intelligente</h1>
        <p className="error-message">{error}</p>
      </div>
    );
  }

  return (
    <div className="analyse-page">
      <h1>Analyse intelligente</h1>
      <p>Détection de tendances, problèmes récurrents et équipements à risque</p>

      {/* =========================
          INDICATEURS
      ========================= */}
      {indicators && (
        <div className="indicators-section">
          <h2>Indicateurs</h2>
          <p><strong>Total tickets :</strong> {indicators.total_tickets}</p>
          <p><strong>Tickets résolus :</strong> {indicators.tickets_resolus}</p>
          <p><strong>Taux de résolution :</strong> {indicators.taux_resolution_pourcent}%</p>
          <p>
            <strong>Temps moyen de résolution :</strong>{" "}
            {indicators.temps_moyen_resolution_heures !== null
              ? `${indicators.temps_moyen_resolution_heures} h`
              : "Non disponible"}
          </p>
        </div>
      )}

      {/* =========================
          ALERTES ACTIVES
      ========================= */}
      <div className="alerts-section">
        <h2>Alertes actives</h2>

        <button type="button" onClick={handleGenerateAlerts}>
          Générer les alertes
        </button>

        {alerts.length === 0 ? (
          <p>Aucune alerte active.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Titre</th>
                <th>Message</th>
                <th>Sévérité</th>
                <th>Date</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              {alerts.map((alertItem) => (
                <tr key={alertItem.id}>
                  <td>{alertItem.titre}</td>
                  <td>{alertItem.message}</td>
                  <td>{alertItem.severite}</td>
                  <td>{new Date(alertItem.date_creation).toLocaleString("fr-FR")}</td>
                  <td>
                    <button type="button" onClick={() => handleResolveAlert(alertItem.id)}>
                      Résoudre
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* =========================
          ÉQUIPEMENTS PROBLÉMATIQUES
      ========================= */}
      <div className="problematic-equipment-section">
        <h2>Équipements problématiques</h2>

        {problematicEquipment.length === 0 ? (
          <p>Aucun équipement problématique détecté.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Équipement</th>
                <th>Code</th>
                <th>Nombre d'incidents</th>
              </tr>
            </thead>
            <tbody>
              {problematicEquipment.map((item) => (
                <tr key={item.equipment_id}>
                  <td>{item.name}</td>
                  <td>{item.inventory_code}</td>
                  <td>{item.nombre_incidents}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* =========================
          PROBLÈMES FRÉQUENTS
      ========================= */}
      <div className="frequent-problems-section">
        <h2>Problèmes fréquents</h2>

        {frequentProblems.length === 0 ? (
          <p>Aucun problème récurrent détecté.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Problème</th>
                <th>Occurrences</th>
              </tr>
            </thead>
            <tbody>
              {frequentProblems.map((item, index) => (
                <tr key={index}>
                  <td>{item.probleme}</td>
                  <td>{item.nombre}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* =========================
          CLASSEMENT / PRIORISATION
      ========================= */}
      <div className="priority-ranking-section">
        <h2>Équipements à prioriser</h2>

        {priorityRanking.length === 0 ? (
          <p>Aucun équipement à prioriser actuellement.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Équipement</th>
                <th>Code</th>
                <th>Score de priorité</th>
                <th>Tickets non résolus</th>
              </tr>
            </thead>
            <tbody>
              {priorityRanking.map((item) => (
                <tr key={item.equipment_id}>
                  <td>{item.name}</td>
                  <td>{item.inventory_code}</td>
                  <td>{item.score_priorite}</td>
                  <td>{item.tickets_non_resolus}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* =========================
          TENDANCES
      ========================= */}
      <div className="trends-section">
        <h2>Évolution mensuelle des incidents</h2>

        {trends.length === 0 ? (
          <p>Pas encore assez de données.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>Mois</th>
                <th>Nombre</th>
              </tr>
            </thead>
            <tbody>
              {trends.map((item) => (
                <tr key={item.mois}>
                  <td>{item.mois}</td>
                  <td>{item.nombre}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* =========================
          ANOMALIES
      ========================= */}
      {anomalies && (
        <div className="anomalies-section">
          <h2>Anomalies détectées</h2>
          {anomalies.message ? (
            <p>{anomalies.message}</p>
          ) : anomalies.anomalies.length === 0 ? (
            <p>Aucune anomalie détectée (moyenne : {anomalies.moyenne_mensuelle}).</p>
          ) : (
            <table>
              <thead>
                <tr>
                  <th>Mois</th>
                  <th>Nombre</th>
                  <th>Seuil</th>
                </tr>
              </thead>
              <tbody>
                {anomalies.anomalies.map((item) => (
                  <tr key={item.mois}>
                    <td>{item.mois}</td>
                    <td>{item.nombre}</td>
                    <td>{item.seuil}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      )}
    </div>
  );
}

export default Analyse;