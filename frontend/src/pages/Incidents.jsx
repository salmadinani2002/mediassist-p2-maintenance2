import { useEffect, useState } from "react";
import api from "../services/api";

function Incidents() {
  const [incidents, setIncidents] = useState([]);
  const [equipments, setEquipments] = useState([]);

  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  const [formData, setFormData] = useState({
    titre: "",
    description: "",
    priorite: "Moyenne",
    statut: "Ouvert",
    equipment_id: "",
  });

  const [statusFilter, setStatusFilter] = useState("Tous");

  // =========================
  // Modification (technicien / statut)
  // =========================
  const [editingIncident, setEditingIncident] = useState(null);
  const [editData, setEditData] = useState({ technicien: "", statut: "" });
  const [updating, setUpdating] = useState(false);

  const openEditForm = (incident) => {
    setEditingIncident(incident);
    setEditData({
      technicien: incident.technicien || "",
      statut: incident.statut || "",
    });
  };

  const handleUpdateIncident = async (event) => {
    event.preventDefault();
    setUpdating(true);

    try {
      const response = await api.put(`/incidents/${editingIncident.id}`, {
        technicien: editData.technicien || null,
        statut: editData.statut,
      });

      setIncidents((previousIncidents) =>
        previousIncidents.map((incident) =>
          incident.id === editingIncident.id ? response.data : incident
        )
      );

      setEditingIncident(null);
    } catch (error) {
      console.error(error);
      alert(
        error.response?.data?.detail ||
          "Impossible de modifier l'incident."
      );
    } finally {
      setUpdating(false);
    }
  };

  // =========================
  // Charger incidents + équipements
  // =========================
  useEffect(() => {
    const loadData = async () => {
      try {
        setLoading(true);
        setError("");

        const [incidentsResponse, equipmentsResponse] =
          await Promise.all([
            api.get("/incidents/"),
            api.get("/equipment/"),
          ]);

        setIncidents(incidentsResponse.data);
        setEquipments(equipmentsResponse.data);
      } catch (error) {
        console.error(error);

        setError(
          error.response?.data?.detail ||
            "Impossible de récupérer les données."
        );
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  // =========================
  // Gestion du formulaire
  // =========================
  const handleChange = (event) => {
    const { name, value } = event.target;

    setFormData((previousData) => ({
      ...previousData,
      [name]: value,
    }));
  };

  // =========================
  // Création d'un incident
  // =========================
  const handleSubmit = async (event) => {
    event.preventDefault();

    setError("");
    setSuccess("");

    if (!formData.titre.trim()) {
      setError("Veuillez saisir un titre.");
      return;
    }

    if (!formData.description.trim()) {
      setError("Veuillez décrire le problème.");
      return;
    }

    if (!formData.equipment_id) {
      setError("Veuillez sélectionner un équipement.");
      return;
    }

    try {
      setSubmitting(true);

      const response = await api.post("/incidents/", {
        titre: formData.titre.trim(),
        description: formData.description.trim(),
        priorite: formData.priorite,
        statut: formData.statut,
        equipment_id: Number(formData.equipment_id),
      });

      // Ajouter le nouvel incident à la liste
      setIncidents((previousIncidents) => [
        ...previousIncidents,
        response.data,
      ]);

      // Réinitialiser le formulaire
      setFormData({
        titre: "",
        description: "",
        priorite: "Moyenne",
        statut: "Ouvert",
        equipment_id: "",
      });

      setSuccess("Incident créé avec succès.");
    } catch (error) {
      console.error(error);

      setError(
        error.response?.data?.detail ||
          "Impossible de créer l'incident."
      );
    } finally {
      setSubmitting(false);
    }
  };

  // =========================
  // Récupérer le nom de l'équipement
  // =========================
  const getEquipmentLabel = (equipmentId) => {
    const equipment = equipments.find(
      (item) => item.id === equipmentId
    );

    if (!equipment) {
      return `Équipement #${equipmentId}`;
    }

    return `${equipment.inventory_code} - ${equipment.name}`;
  };

  // =========================
  // Créer un ticket depuis un incident
  // =========================
  const handleCreateTicket = async (incidentId) => {
    try {
      const response = await api.post(
        `/incidents/${incidentId}/create-ticket`
      );

      setIncidents((previousIncidents) =>
        previousIncidents.map((incident) =>
          incident.id === incidentId
            ? {
                ...incident,
                ticket_id: response.data.ticket_id,
                statut: "Ouvert",
              }
            : incident
        )
      );
    } catch (error) {
      console.error(error);
      alert(
        error.response?.data?.detail ||
          "Impossible de créer le ticket."
      );
    }
  };
  const filteredIncidents =
  statusFilter === "Tous"
    ? incidents
    : incidents.filter((incident) => incident.statut === statusFilter);

  // =========================
  // Chargement
  // =========================
  if (loading) {
    return (
      <div className="incidents-page">
        <h1>Incidents</h1>
        <p>Chargement des incidents...</p>
      </div>
    );
  }

  // =========================
  // Affichage
  // =========================
  return (
    <div className="incidents-page">
      <h1>Incidents</h1>

      <p>Déclaration et suivi des incidents</p>

      {/* =========================
          Messages
      ========================= */}
      {error && (
        <div className="error-message">
          {error}
        </div>
      )}

      {success && (
        <div className="success-message">
          {success}
        </div>
      )}

      {/* =========================
          FORMULAIRE
      ========================= */}
      <div className="incident-form">
        <h2>Déclarer un incident</h2>

        <form onSubmit={handleSubmit}>
          {/* Titre */}
          <div className="form-group">
            <label htmlFor="titre">
              Titre
            </label>

            <input
              id="titre"
              name="titre"
              type="text"
              value={formData.titre}
              onChange={handleChange}
              placeholder="Ex : Problème de connexion"
              required
            />
          </div>

          {/* Équipement */}
          <div className="form-group">
            <label htmlFor="equipment_id">
              Équipement concerné
            </label>

            <select
              id="equipment_id"
              name="equipment_id"
              value={formData.equipment_id}
              onChange={handleChange}
              required
            >
              <option value="">
                Sélectionner un équipement
              </option>

              {equipments.map((equipment) => (
                <option
                  key={equipment.id}
                  value={equipment.id}
                >
                  {equipment.inventory_code} -{" "}
                  {equipment.name}
                </option>
              ))}
            </select>
          </div>

          {/* Description */}
          <div className="form-group">
            <label htmlFor="description">
              Description du problème
            </label>

            <textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleChange}
              placeholder="Décrire le problème rencontré..."
              rows="4"
              required
            />
          </div>

          {/* Priorité */}
          <div className="form-group">
            <label htmlFor="priorite">
              Priorité
            </label>

            <select
              id="priorite"
              name="priorite"
              value={formData.priorite}
              onChange={handleChange}
            >
              <option value="Basse">
                Basse
              </option>

              <option value="Moyenne">
                Moyenne
              </option>

              <option value="Haute">
                Haute
              </option>

              <option value="Critique">
                Critique
              </option>
            </select>
          </div>

          {/* Statut */}
          <div className="form-group">
            <label htmlFor="statut">
              Statut
            </label>

            <select
              id="statut"
              name="statut"
              value={formData.statut}
              onChange={handleChange}
            >
              <option value="Ouvert">
                Ouvert
              </option>

              <option value="En cours">
                En cours
              </option>

              <option value="Résolu">
                Résolu
              </option>

              <option value="Clôturé">
                Clôturé
              </option>
            </select>
          </div>

          {/* Bouton */}
          <button
            type="submit"
            disabled={submitting}
          >
            {submitting
              ? "Création..."
              : "Déclarer l'incident"}
          </button>
        </form>
      </div>
      <div className="filter-section">
  <label htmlFor="status-filter">Filtrer par statut</label>
  <select
    id="status-filter"
    value={statusFilter}
    onChange={(e) => setStatusFilter(e.target.value)}
  >
    <option value="Tous">Tous</option>
    <option value="Nouveau">Nouveau</option>
    <option value="Ouvert">Ouvert</option>
    <option value="En cours">En cours</option>
    <option value="Résolu">Résolu</option>
    <option value="Clôturé">Clôturé</option>
  </select>
</div>

      {/* =========================
          LISTE DES INCIDENTS
      ========================= */}
      <div className="incidents-list">
        <h2>Liste des incidents</h2>

        {filteredIncidents.length === 0 ? (
          <p>Aucun incident ne correspond à ce filtre.</p>
        ) : (
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Titre</th>
                <th>Équipement</th>
                <th>Description</th>
                <th>Priorité</th>
                <th>Statut</th>
                <th>Technicien</th>
                <th>Ticket</th>
                <th>Date de signalement</th>
                <th>Actions</th>
              </tr>
            </thead>

            <tbody>
              {filteredIncidents.map((incident) => (
                <tr key={incident.id}>
                  <td>
                    {incident.id}
                  </td>

                  <td>
                    {incident.titre}
                  </td>

                  <td>
                    {getEquipmentLabel(
                      incident.equipment_id
                    )}
                  </td>

                  <td>
                    {incident.description}
                  </td>

                  <td>
                    {incident.priorite}
                  </td>

                  <td>
                    {incident.statut}
                  </td>

                  <td>
                    {incident.technicien || "-"}
                  </td>

                  <td>
                    {incident.ticket_id ? (
                      `Ticket #${incident.ticket_id}`
                    ) : (
                      <button
                        type="button"
                        onClick={() => handleCreateTicket(incident.id)}
                      >
                        Créer un ticket
                      </button>
                    )}
                  </td>

                  <td>
                    {incident.date_signalement
                      ? new Date(
                          incident.date_signalement
                        ).toLocaleString("fr-FR")
                      : "-"}
                  </td>

                  <td>
                    <button
                      type="button"
                      onClick={() => openEditForm(incident)}
                    >
                      Modifier
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* =========================
          MODIFIER UN INCIDENT
      ========================= */}
      {editingIncident && (
        <div className="modal">
          <div className="modal-content">
            <h2>Modifier l'incident #{editingIncident.id}</h2>

            <form onSubmit={handleUpdateIncident}>
              <div className="form-group">
                <label htmlFor="edit-technicien">Technicien</label>
                <input
                  id="edit-technicien"
                  type="text"
                  value={editData.technicien}
                  onChange={(e) =>
                    setEditData({ ...editData, technicien: e.target.value })
                  }
                  placeholder="Nom du technicien"
                />
              </div>

              <div className="form-group">
                <label htmlFor="edit-statut">Statut</label>
                <select
                  id="edit-statut"
                  value={editData.statut}
                  onChange={(e) =>
                    setEditData({ ...editData, statut: e.target.value })
                  }
                >
                  <option value="Nouveau">Nouveau</option>
                  <option value="Ouvert">Ouvert</option>
                  <option value="En cours">En cours</option>
                  <option value="Résolu">Résolu</option>
                  <option value="Clôturé">Clôturé</option>
                </select>
              </div>

              <div className="modal-actions">
                <button type="submit" disabled={updating}>
                  {updating ? "Modification..." : "Enregistrer"}
                </button>
                <button
                  type="button"
                  onClick={() => setEditingIncident(null)}
                >
                  Annuler
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default Incidents;