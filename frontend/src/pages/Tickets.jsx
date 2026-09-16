import { useEffect, useState } from "react";
import api from "../services/api";
import { useNavigate } from "react-router-dom";

function Tickets() {
  const [tickets, setTickets] = useState([]);

  const [statusFilter, setStatusFilter] = useState("Tous");

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const navigate = useNavigate();

  // =========================
  // FORMULAIRE CRÉATION
  // =========================

  const [showCreateForm, setShowCreateForm] = useState(false);

  const [formData, setFormData] = useState({
    equipment_id: "",
    date_signalement: "",
    description: "",
    priorite: "Moyenne",
    statut: "Ouvert",
    solution: "",
    date_resolution: "",
  });

  const [creating, setCreating] = useState(false);
  const [createError, setCreateError] = useState("");
  const [createSuccess, setCreateSuccess] = useState("");

  // =========================
  // MODIFICATION
  // =========================

  const [editingTicket, setEditingTicket] = useState(null);

  const [editData, setEditData] = useState({
    priorite: "",
    statut: "",
    solution: "",
    date_resolution: "",
    technicien: "",
  });

  const [updating, setUpdating] = useState(false);
  const [updateError, setUpdateError] = useState("");

  // =========================
  // HISTORIQUE
  // =========================

  const [historyTicket, setHistoryTicket] = useState(null);
  const [history, setHistory] = useState([]);
  const [historyLoading, setHistoryLoading] = useState(false);
  const [historyError, setHistoryError] = useState("");

  // =========================
  // CHARGER LES TICKETS
  // =========================

  const fetchTickets = async () => {
    try {
      setLoading(true);

      const response = await api.get("/tickets/");

      setTickets(response.data);
      setError("");
    } catch (error) {
      console.error(error);
      setError("Impossible de récupérer les tickets.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTickets();
  }, []);

  // =========================
  // CRÉATION
  // =========================

  const handleCreateChange = (event) => {
    const { name, value } = event.target;

    setFormData((previous) => ({
      ...previous,
      [name]: value,
    }));
  };

  const handleCreateTicket = async (event) => {
    event.preventDefault();

    setCreating(true);
    setCreateError("");
    setCreateSuccess("");

    try {
      const data = {
        equipment_id: Number(formData.equipment_id),
        date_signalement: formData.date_signalement,
        description: formData.description,
        priorite: formData.priorite,
        statut: formData.statut,
        solution: formData.solution || null,
        date_resolution: formData.date_resolution || null,
      };

      await api.post("/tickets/", data);

      setCreateSuccess("Ticket créé avec succès.");

      setFormData({
        equipment_id: "",
        date_signalement: "",
        description: "",
        priorite: "Moyenne",
        statut: "Ouvert",
        solution: "",
        date_resolution: "",
      });

      await fetchTickets();
    } catch (error) {
      console.error(error);

      setCreateError(
        error.response?.data?.detail ||
          "Impossible de créer le ticket."
      );
    } finally {
      setCreating(false);
    }
  };

  // =========================
  // MODIFICATION
  // =========================

  const openEditForm = (ticket) => {
    setEditingTicket(ticket);

    setEditData({
      priorite: ticket.priorite || "",
      statut: ticket.statut || "",
      solution: ticket.solution || "",
      date_resolution: ticket.date_resolution
        ? ticket.date_resolution.slice(0, 16)
        : "",
    });

    setUpdateError("");
  };

  const handleEditChange = (event) => {
    const { name, value } = event.target;

    setEditData((previous) => ({
      ...previous,
      [name]: value,
    }));
  };

  const handleUpdateTicket = async (event) => {
  event.preventDefault();

  if (!editingTicket) {
    return;
  }

  setUpdating(true);
  setUpdateError("");

  try {
    const data = {
      priorite: editData.priorite,
      statut: editData.statut,
      solution: editData.solution || null,
      date_resolution: editData.date_resolution || null,
      technicien: editData.technicien || null,
    };

    await api.put(
      `/tickets/${editingTicket.id}`,
      data
    );

    setEditingTicket(null);

    await fetchTickets();
  } catch (error) {
    console.error(error);

    setUpdateError(
      error.response?.data?.detail ||
        "Impossible de modifier le ticket."
    );
  } finally {
    setUpdating(false);
  }
};

  // =========================
  // CLÔTURER UN TICKET
  // =========================

  const handleCloseTicket = async (ticketId) => {
    const confirmation = window.confirm(
      "Voulez-vous vraiment clôturer ce ticket ?"
    );

    if (!confirmation) {
      return;
    }

    try {
      await api.put(`/tickets/${ticketId}/close`);

      await fetchTickets();
    } catch (error) {
      console.error(error);

      alert(
        error.response?.data?.detail ||
          "Impossible de clôturer le ticket."
      );
    }
  };

  // =========================
  // HISTORIQUE
  // =========================

  const handleShowHistory = async (ticket) => {
    setHistoryTicket(ticket);
    setHistory([]);
    setHistoryError("");
    setHistoryLoading(true);

    try {
      const response = await api.get(
        `/tickets/${ticket.id}/history`
      );

      setHistory(response.data);
    } catch (error) {
      console.error(error);

      setHistoryError(
        error.response?.data?.detail ||
          "Impossible de récupérer l'historique."
      );
    } finally {
      setHistoryLoading(false);
    }
  };

  const closeHistory = () => {
    setHistoryTicket(null);
    setHistory([]);
    setHistoryError("");
  };

  // =========================
  // FILTRE
  // =========================

  const filteredTickets =
    statusFilter === "Tous"
      ? tickets
      : tickets.filter(
          (ticket) => ticket.statut === statusFilter
        );

  // =========================
  // CHARGEMENT
  // =========================

  if (loading) {
    return <p>Chargement des tickets...</p>;
  }

  // =========================
  // ERREUR
  // =========================

  if (error) {
    return <p>{error}</p>;
  }

  // =========================
  // INTERFACE
  // =========================

  return (
    <div className="tickets-page">

      {/* =================================================
          CRÉER UN TICKET
      ================================================= */}

      <section className="ticket-create-section">

        <button
          type="button"
          onClick={() =>
            setShowCreateForm(!showCreateForm)
          }
        >
          {showCreateForm
            ? "Fermer"
            : "+ Créer un ticket"}
        </button>

        {showCreateForm && (
          <div className="ticket-form">

            <h2>Créer un ticket</h2>

            {createSuccess && (
              <p className="success-message">
                {createSuccess}
              </p>
            )}

            {createError && (
              <p className="error-message">
                {createError}
              </p>
            )}

            <form onSubmit={handleCreateTicket}>

              <div className="form-group">
                <label htmlFor="equipment_id">
                  Équipement
                </label>

                <input
                  type="number"
                  id="equipment_id"
                  name="equipment_id"
                  value={formData.equipment_id}
                  onChange={handleCreateChange}
                  min="1"
                  required
                  placeholder="ID de l'équipement"
                />
              </div>

              <div className="form-group">
                <label htmlFor="date_signalement">
                  Date de signalement
                </label>

                <input
                  type="datetime-local"
                  id="date_signalement"
                  name="date_signalement"
                  value={formData.date_signalement}
                  onChange={handleCreateChange}
                  required
                />
              </div>

              <div className="form-group">
                <label htmlFor="description">
                  Description
                </label>

                <textarea
                  id="description"
                  name="description"
                  value={formData.description}
                  onChange={handleCreateChange}
                  required
                  rows="4"
                  placeholder="Décrivez le problème..."
                />
              </div>

              <div className="form-group">
                <label htmlFor="priorite">
                  Priorité
                </label>

                <select
                  id="priorite"
                  name="priorite"
                  value={formData.priorite}
                  onChange={handleCreateChange}
                >
                  <option value="Basse">Basse</option>
                  <option value="Moyenne">Moyenne</option>
                  <option value="Haute">Haute</option>
                  <option value="Critique">
                    Critique
                  </option>
                </select>
              </div>

              <div className="form-group">
                <label htmlFor="statut">
                  Statut
                </label>

                <select
                  id="statut"
                  name="statut"
                  value={formData.statut}
                  onChange={handleCreateChange}
                >
                  <option value="Ouvert">Ouvert</option>
                  <option value="En cours">
                    En cours
                  </option>
                  <option value="Résolu">Résolu</option>
                </select>
              </div>

              <div className="form-group">
                <label htmlFor="solution">
                  Solution
                </label>

                <textarea
                  id="solution"
                  name="solution"
                  value={formData.solution}
                  onChange={handleCreateChange}
                  rows="3"
                  placeholder="Solution éventuelle..."
                />
              </div>

              <div className="form-group">
                <label htmlFor="date_resolution">
                  Date de résolution
                </label>

                <input
                  type="datetime-local"
                  id="date_resolution"
                  name="date_resolution"
                  value={formData.date_resolution}
                  onChange={handleCreateChange}
                />
              </div>

              <button
                type="submit"
                disabled={creating}
              >
                {creating
                  ? "Création..."
                  : "Créer le ticket"}
              </button>

            </form>

          </div>
        )}

      </section>

      {/* =================================================
          LISTE DES TICKETS
      ================================================= */}

      <section className="tickets-section">

        <h1>Tickets</h1>

        {/* FILTRE */}

        <div className="filter-section">

          <label htmlFor="status-filter">
            Filtrer par statut :
          </label>

          <select
            id="status-filter"
            value={statusFilter}
            onChange={(event) =>
              setStatusFilter(event.target.value)
            }
          >
            <option value="Tous">Tous</option>
            <option value="Ouvert">Ouvert</option>
            <option value="En cours">En cours</option>
            <option value="Résolu">Résolu</option>
            <option value="Clôturé">Clôturé</option>
          </select>

        </div>

        {/* TICKETS */}

        <div className="tickets-list">

          {filteredTickets.length === 0 ? (
            <p>Aucun ticket trouvé.</p>
          ) : (
            filteredTickets.map((ticket) => (

              <div
                className="ticket-card"
                key={ticket.id}
              >

                <h3>
                  Ticket #{ticket.id}
                </h3>

                <p>
                  <strong>Équipement :</strong>{" "}
                  {ticket.equipment_id}
                </p>

                <p>
                  <strong>Date :</strong>{" "}
                  {ticket.date_signalement
                    ? new Date(
                        ticket.date_signalement
                      ).toLocaleString()
                    : "-"}
                </p>

                <p>
                  <strong>Priorité :</strong>{" "}
                  {ticket.priorite}
                </p>

                <p>
                  <strong>Statut :</strong>{" "}
                  {ticket.statut}
                </p>
                <p>
  <strong>Technicien :</strong> {ticket.technicien || "Non affecté"}
</p>

                <p>
                  <strong>Description :</strong>{" "}
                  {ticket.description}
                </p>

                {ticket.solution && (
                  <p>
                    <strong>Solution :</strong>{" "}
                    {ticket.solution}
                  </p>
                )}

                {/* ACTIONS */}

                <div className="ticket-actions">

                  <button
                    type="button"
                    onClick={() =>
                      openEditForm(ticket)
                    }
                  >
                    Modifier
                  </button>

                  {ticket.statut !== "Clôturé" && (
                    <button
                      type="button"
                      onClick={() =>
                        handleCloseTicket(ticket.id)
                      }
                    >
                      Clôturer
                    </button>
                  )}

                  <button
                    type="button"
                    onClick={() =>
                      handleShowHistory(ticket)
                    }
                  >
                    Historique
                  </button>
                  <button
  type="button"
  onClick={() =>
    navigate("/interventions", { state: { ticketId: ticket.id } })
  }
>
  Créer une intervention
</button>

                </div>

              </div>

            ))
          )}

        </div>

      </section>

      {/* =================================================
          MODIFIER UN TICKET
      ================================================= */}

      {editingTicket && (
        <div className="modal">

          <div className="modal-content">

            <h2>
              Modifier le ticket #
              {editingTicket.id}
            </h2>

            {updateError && (
              <p className="error-message">
                {updateError}
              </p>
            )}

            <form onSubmit={handleUpdateTicket}>

              <div className="form-group">
                <label htmlFor="edit-priorite">
                  Priorité
                </label>

                <select
                  id="edit-priorite"
                  name="priorite"
                  value={editData.priorite}
                  onChange={handleEditChange}
                >
                  <option value="Basse">Basse</option>
                  <option value="Moyenne">Moyenne</option>
                  <option value="Haute">Haute</option>
                  <option value="Critique">
                    Critique
                  </option>
                </select>
              </div>

              <div className="form-group">
                <label htmlFor="edit-statut">
                  Statut
                </label>

                <select
                  id="edit-statut"
                  name="statut"
                  value={editData.statut}
                  onChange={handleEditChange}
                >
                  <option value="Ouvert">Ouvert</option>
                  <option value="En cours">
                    En cours
                  </option>
                  <option value="Résolu">Résolu</option>
                  <option value="Clôturé">
                    Clôturé
                  </option>
                </select>
              </div>
              <div className="form-group">
  <label htmlFor="edit-technicien">Technicien</label>
  <input
    id="edit-technicien"
    name="technicien"
    type="text"
    value={editData.technicien}
    onChange={handleEditChange}
    placeholder="Nom du technicien"
  />
</div>

              <div className="form-group">
                <label htmlFor="edit-solution">
                  Solution
                </label>

                <textarea
                  id="edit-solution"
                  name="solution"
                  value={editData.solution}
                  onChange={handleEditChange}
                  rows="4"
                />
              </div>

              <div className="form-group">
                <label htmlFor="edit-date-resolution">
                  Date de résolution
                </label>

                <input
                  type="datetime-local"
                  id="edit-date-resolution"
                  name="date_resolution"
                  value={editData.date_resolution}
                  onChange={handleEditChange}
                />
              </div>

              <div className="modal-actions">

                <button
                  type="submit"
                  disabled={updating}
                >
                  {updating
                    ? "Modification..."
                    : "Enregistrer"}
                </button>

                <button
                  type="button"
                  onClick={() =>
                    setEditingTicket(null)
                  }
                >
                  Annuler
                </button>

              </div>

            </form>

          </div>

        </div>
      )}

      {/* =================================================
          HISTORIQUE
      ================================================= */}

      {historyTicket && (
        <div className="modal">

          <div className="modal-content">

            <h2>
              Historique du ticket #
              {historyTicket.id}
            </h2>

            {historyLoading && (
              <p>
                Chargement de l'historique...
              </p>
            )}

            {historyError && (
              <p className="error-message">
                {historyError}
              </p>
            )}

            {!historyLoading &&
              !historyError &&
              history.length === 0 && (
                <p>
                  Aucun historique pour ce ticket.
                </p>
              )}

            {!historyLoading &&
              history.length > 0 && (
                <div className="history-list">

                  {history.map((item) => (

                    <div
                      className="history-item"
                      key={item.id}
                    >

                      <p>
                        <strong>
                          Action :
                        </strong>{" "}
                        {item.action}
                      </p>

                      {item.ancien_statut && (
                        <p>
                          <strong>
                            Ancien statut :
                          </strong>{" "}
                          {item.ancien_statut}
                        </p>
                      )}

                      {item.nouveau_statut && (
                        <p>
                          <strong>
                            Nouveau statut :
                          </strong>{" "}
                          {item.nouveau_statut}
                        </p>
                      )}

                      {item.ancienne_priorite && (
                        <p>
                          <strong>
                            Ancienne priorité :
                          </strong>{" "}
                          {item.ancienne_priorite}
                        </p>
                      )}

                      {item.nouvelle_priorite && (
                        <p>
                          <strong>
                            Nouvelle priorité :
                          </strong>{" "}
                          {item.nouvelle_priorite}
                        </p>
                      )}

                      <p>
                        <strong>
                          Date :
                        </strong>{" "}
                        {item.date_action
                          ? new Date(
                              item.date_action
                            ).toLocaleString()
                          : "-"}
                      </p>

                    </div>

                  ))}

                </div>
              )}

            <button
              type="button"
              onClick={closeHistory}
            >
              Fermer
            </button>

          </div>

        </div>
      )}

    </div>
  );
}

export default Tickets;