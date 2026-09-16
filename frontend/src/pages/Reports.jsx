import { useEffect, useState } from "react";
import api from "../services/api";

function Reports() {
  const [reports, setReports] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [generating, setGenerating] = useState(false);

  const [formData, setFormData] = useState({
    titre: "",
    periode_debut: "",
    periode_fin: "",
  });

  const fetchReports = async () => {
    try {
      setLoading(true);
      const response = await api.get("/reports/");
      setReports(response.data);
    } catch (err) {
      console.error(err);
      setError("Impossible de récupérer les rapports.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchReports();
  }, []);

  const handleChange = (event) => {
    const { name, value } = event.target;
    setFormData((previous) => ({ ...previous, [name]: value }));
  };

  const handleGenerate = async (event) => {
    event.preventDefault();
    setGenerating(true);
    setError("");

    try {
      await api.post("/reports/generate", {
        titre: formData.titre,
        periode_debut: formData.periode_debut,
        periode_fin: formData.periode_fin,
      });

      setFormData({ titre: "", periode_debut: "", periode_fin: "" });
      await fetchReports();
    } catch (err) {
      console.error(err);
      setError(
        err.response?.data?.detail || "Impossible de générer le rapport."
      );
    } finally {
      setGenerating(false);
    }
  };

  const handleDelete = async (id) => {
    const confirmed = window.confirm("Supprimer ce rapport ?");
    if (!confirmed) return;

    try {
      await api.delete(`/reports/${id}`);
      await fetchReports();
    } catch (err) {
      console.error(err);
      alert("Impossible de supprimer le rapport.");
    }
  };

  if (loading) {
    return (
      <div className="reports-page">
        <h1>Rapports</h1>
        <p>Chargement des rapports...</p>
      </div>
    );
  }

  return (
    <div className="reports-page">
      <h1>Rapports</h1>
      <p>Génération et consultation de rapports périodiques</p>

      {error && <div className="error-message">{error}</div>}

      <div className="intervention-form">
        <h2>Générer un nouveau rapport</h2>

        <form onSubmit={handleGenerate}>
          <div className="form-group">
            <label htmlFor="titre">Titre</label>
            <input
              id="titre"
              name="titre"
              type="text"
              value={formData.titre}
              onChange={handleChange}
              placeholder="Ex : Rapport septembre 2026"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="periode_debut">Début de la période</label>
            <input
              id="periode_debut"
              name="periode_debut"
              type="datetime-local"
              value={formData.periode_debut}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="periode_fin">Fin de la période</label>
            <input
              id="periode_fin"
              name="periode_fin"
              type="datetime-local"
              value={formData.periode_fin}
              onChange={handleChange}
              required
            />
          </div>

          <button type="submit" disabled={generating}>
            {generating ? "Génération..." : "Générer le rapport"}
          </button>
        </form>
      </div>

      <h2>Rapports générés</h2>

      {reports.length === 0 ? (
        <p>Aucun rapport généré pour l'instant.</p>
      ) : (
        <div className="tickets-list">
          {reports.map((report) => (
            <div className="ticket-card" key={report.id}>
              <h3>{report.titre}</h3>

              <p>
                <strong>Période :</strong>{" "}
                {new Date(report.periode_debut).toLocaleDateString("fr-FR")}
                {" → "}
                {new Date(report.periode_fin).toLocaleDateString("fr-FR")}
              </p>

              <p>{report.resume}</p>

              <p>
                <strong>Généré le :</strong>{" "}
                {new Date(report.date_generation).toLocaleString("fr-FR")}
              </p>

              <button type="button" onClick={() => handleDelete(report.id)}>
                Supprimer
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default Reports;