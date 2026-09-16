import { useEffect, useState } from "react";
import api from "../services/api";
import { useLocation, useNavigate } from "react-router-dom";

function Interventions() {
  const [interventions, setInterventions] = useState([]);
  const [tickets, setTickets] = useState([]);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);

  const [comments, setComments] = useState({});
  const [newComment, setNewComment] = useState({});
  const [showComments, setShowComments] = useState({});

  const [history, setHistory] = useState({});
  const [showHistory, setShowHistory] = useState({});
  const [statusFilter, setStatusFilter] = useState("Tous");


  const [formData, setFormData] = useState({
    ticket_id: "",
    date_intervention: "",
    type_intervention: "",
    description: "",
    actions: "",
    solution: "",
    resultat: "",
    technicien: "",
    statut: "En cours",
  });
  const location = useLocation();
const navigate = useNavigate();

useEffect(() => {
  if (location.state?.ticketId) {
    setFormData((previous) => ({
      ...previous,
      ticket_id: String(location.state.ticketId),
    }));
    setShowForm(true);

    // Nettoyer le state pour éviter de rouvrir le formulaire
    // si l'utilisateur revient sur cette page plus tard
    navigate(location.pathname, { replace: true, state: {} });
  }
}, [location.state]);

  const fetchComments = async (interventionId) => {
  try {
    const response = await api.get(
      `/interventions/${interventionId}/comments`
    );

    setComments((prev) => ({
      ...prev,
      [interventionId]: response.data,
    }));
    setShowComments((prev) => ({
      ...prev,
      [interventionId]: true,
    }));
  } catch (err) {
    console.error("Erreur lors du chargement des commentaires :", err);
  }
};

  const addComment = async (interventionId) => {
  const commentaire = newComment[interventionId]?.trim();

  if (!commentaire) {
    return;
  }

  try {
    await api.post(`/interventions/${interventionId}/comments`, {
      intervention_id: interventionId,
      commentaire: commentaire,
    });

    setNewComment((prev) => ({
      ...prev,
      [interventionId]: "",
    }));

    await fetchComments(interventionId);
  } catch (err) {
    console.error("Erreur lors de l'ajout du commentaire :", err);
  }
};

const fetchHistory = async (interventionId) => {
  try {
    const response = await api.get(
      `/interventions/${interventionId}/history`
    );

    setHistory((prev) => ({
      ...prev,
      [interventionId]: response.data,
    }));

    setShowHistory((prev) => ({
      ...prev,
      [interventionId]: true,
    }));
  } catch (err) {
    console.error(
      "Erreur lors du chargement de l'historique :",
      err
    );
  }
};


  // =========================
  // Récupérer les données
  // =========================

  const fetchData = async () => {
    try {
      setLoading(true);
      setError("");

      const [interventionsResponse, ticketsResponse] =
        await Promise.all([
          api.get("/interventions/"),
          api.get("/tickets/"),
        ]);

      setInterventions(interventionsResponse.data);
      setTickets(ticketsResponse.data);
    } catch (err) {
      console.error(err);
      setError("Impossible de récupérer les données.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  // =========================
  // Gestion formulaire
  // =========================

  const handleChange = (event) => {
    const { name, value } = event.target;

    setFormData((previous) => ({
      ...previous,
      [name]: value,
    }));
  };

  const resetForm = () => {
    setFormData({
      ticket_id: "",
      date_intervention: "",
      type_intervention: "",
      description: "",
      actions: "",
      solution: "",
      resultat: "",
      technicien: "",
      statut: "En cours",
    });

    setEditingId(null);
    setShowForm(false);
  };

  // =========================
  // Créer / modifier
  // =========================

  const handleSubmit = async (event) => {
    event.preventDefault();

    try {
      setError("");

      if (editingId === null) {
        // =========================
        // Création
        // =========================

        const dataToSend = {
          ticket_id: Number(formData.ticket_id),
          date_intervention: formData.date_intervention,
          type_intervention: formData.type_intervention,
          description: formData.description || null,
          actions: formData.actions || null,
          solution: formData.solution || null,
          resultat: formData.resultat || null,
          technicien: formData.technicien || null,
          statut: formData.statut,
        };

        await api.post("/interventions/", dataToSend);
      } else {
        // =========================
        // Modification
        // =========================

        const dataToSend = {
          date_intervention: formData.date_intervention,
          type_intervention: formData.type_intervention,
          description: formData.description || null,
          actions: formData.actions || null,
          solution: formData.solution || null,
          resultat: formData.resultat || null,
          technicien: formData.technicien || null,
          statut: formData.statut,
        };

        await api.put(
          `/interventions/${editingId}`,
          dataToSend
        );
      }

      resetForm();
      await fetchData();
    } catch (err) {
      console.error(err);

      setError(
        err.response?.data?.detail ||
          "Une erreur est survenue."
      );
    }
  };

  // =========================
  // Modifier
  // =========================

  const handleEdit = (intervention) => {
    setEditingId(intervention.id);

    setFormData({
      ticket_id: intervention.ticket_id || "",

      date_intervention: intervention.date_intervention
        ? intervention.date_intervention.slice(0, 16)
        : "",

      type_intervention:
        intervention.type_intervention || "",

      description:
        intervention.description || "",

      actions:
        intervention.actions || "",

      solution:
        intervention.solution || "",

      resultat:
        intervention.resultat || "",

      technicien:
        intervention.technicien || "",

      statut:
        intervention.statut || "En cours",
    });

    setShowForm(true);
  };

  // =========================
  // Supprimer
  // =========================

  const handleDelete = async (id) => {
    const confirmed = window.confirm(
      "Voulez-vous vraiment supprimer cette intervention ?"
    );

    if (!confirmed) {
      return;
    }

    try {
      setError("");

      await api.delete(`/interventions/${id}`);

      await fetchData();
    } catch (err) {
      console.error(err);

      setError(
        err.response?.data?.detail ||
          "Impossible de supprimer l'intervention."
      );
    }
  };

  // =========================
  // Clôturer une intervention
  // =========================

  const handleClose = async (id) => {
    const confirmed = window.confirm(
      "Voulez-vous vraiment clôturer cette intervention ?"
    );

    if (!confirmed) {
      return;
    }

    try {
      setError("");

      await api.put(`/interventions/${id}/close`);

      await fetchData();
    } catch (err) {
      console.error(err);

      setError(
        err.response?.data?.detail ||
          "Impossible de clôturer l'intervention."
      );
    }
  };

  // =========================
  // Affichage chargement
  // =========================

  if (loading) {
    return (
      <div className="interventions-page">
        <h1>Interventions</h1>
        <p>Chargement des interventions...</p>
      </div>
    );
  }

  // =========================
  // Affichage principal
  // =========================
const filteredInterventions =
  statusFilter === "Tous"
    ? interventions
    : interventions.filter((intervention) => intervention.statut === statusFilter);

    return (
    <div className="interventions-page">

      <h1>Interventions</h1>

      <p>Gestion des interventions</p>

      {error && (
        <p className="error-message">
          {error}
        </p>
      )}

      {/* =========================
          BOUTON AJOUT
      ========================= */}

      {!showForm && (
        <button
          type="button"
          onClick={() => setShowForm(true)}
        >
          + Nouvelle intervention
        </button>
      )}

      {/* =========================
          FORMULAIRE
      ========================= */}

      {showForm && (
        <div className="intervention-form">

          <h2>
            {editingId === null
              ? "Nouvelle intervention"
              : "Modifier l'intervention"}
          </h2>

          <form onSubmit={handleSubmit}>

            {/* =========================
                Ticket
            ========================= */}

            {editingId === null && (
              <div>
                <label htmlFor="ticket_id">
                  Ticket :
                </label>

                <select
                  id="ticket_id"
                  name="ticket_id"
                  value={formData.ticket_id}
                  onChange={handleChange}
                  required
                >
                  <option value="">
                    Sélectionner un ticket
                  </option>

                  {tickets.map((ticket) => (
                    <option
                      key={ticket.id}
                      value={ticket.id}
                    >
                      Ticket #{ticket.id}
                      {" - "}
                      {ticket.description}
                    </option>
                  ))}
                </select>
              </div>
            )}

            {/* =========================
                Date
            ========================= */}

            <div>
              <label htmlFor="date_intervention">
                Date d'intervention :
              </label>

              <input
                id="date_intervention"
                type="datetime-local"
                name="date_intervention"
                value={formData.date_intervention}
                onChange={handleChange}
                required
              />
            </div>

            {/* =========================
                Type
            ========================= */}

            <div>
              <label htmlFor="type_intervention">
                Type d'intervention :
              </label>

              <input
                id="type_intervention"
                type="text"
                name="type_intervention"
                value={formData.type_intervention}
                onChange={handleChange}
                required
              />
            </div>

            {/* =========================
                Description
            ========================= */}

            <div>
              <label htmlFor="description">
                Description :
              </label>

              <textarea
                id="description"
                name="description"
                value={formData.description}
                onChange={handleChange}
              />
            </div>

            {/* =========================
                Actions
            ========================= */}

            <div>
              <label htmlFor="actions">
                Actions réalisées :
              </label>

              <textarea
                id="actions"
                name="actions"
                value={formData.actions}
                onChange={handleChange}
                placeholder="Décrire les actions réalisées..."
              />
            </div>

            {/* =========================
                Solution
            ========================= */}

            <div>
              <label htmlFor="solution">
                Solution :
              </label>

              <textarea
                id="solution"
                name="solution"
                value={formData.solution}
                onChange={handleChange}
              />
            </div>

            {/* =========================
                Résultat
            ========================= */}

            <div>
              <label htmlFor="resultat">
                Résultat :
              </label>

              <textarea
                id="resultat"
                name="resultat"
                value={formData.resultat}
                onChange={handleChange}
                placeholder="Décrire le résultat de l'intervention..."
              />
            </div>

            {/* =========================
                Technicien
            ========================= */}

            <div>
              <label htmlFor="technicien">
                Technicien :
              </label>

              <input
                id="technicien"
                type="text"
                name="technicien"
                value={formData.technicien}
                onChange={handleChange}
              />
            </div>

            {/* =========================
                Statut
            ========================= */}

            <div>
              <label htmlFor="statut">
                Statut :
              </label>

              <select
                id="statut"
                name="statut"
                value={formData.statut}
                onChange={handleChange}
                required
              >
                <option value="En cours">
                  En cours
                </option>

                <option value="Terminée">
                  Terminée
                </option>

                <option value="Annulée">
                  Annulée
                </option>
              </select>
            </div>

            {/* =========================
                Boutons
            ========================= */}

            <div>
              <button type="submit">
                {editingId === null
                  ? "Créer"
                  : "Enregistrer"}
              </button>

              <button
                type="button"
                onClick={resetForm}
              >
                Annuler
              </button>
            </div>

          </form>
        </div>
      )}

      {/* =========================
          FILTRE
      ========================= */}

      <div className="filter-section">
        <label htmlFor="status-filter">Filtrer par statut</label>
        <select
          id="status-filter"
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
        >
          <option value="Tous">Tous</option>
          <option value="En cours">En cours</option>
          <option value="Clôturée">Clôturée</option>
        </select>
      </div>

      {/* =========================
          LISTE
      ========================= */}

      {filteredInterventions.length === 0 ? (
        <p>
          Aucune intervention ne correspond à ce filtre.
        </p>
      ) : (
        <table>

          <thead>
            <tr>
              <th>ID</th>
              <th>Ticket</th>
              <th>Date</th>
              <th>Date de fin</th>
              <th>Type</th>
              <th>Description</th>
              <th>Actions réalisées</th>
              <th>Solution</th>
              <th>Résultat</th>
              <th>Technicien</th>
              <th>Statut</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            {filteredInterventions.map((intervention) => (
              <tr key={intervention.id}>

                <td>
                  {intervention.id}
                </td>

                <td>
                  #{intervention.ticket_id}
                </td>

                <td>
                  {intervention.date_intervention
                    ? new Date(
                        intervention.date_intervention
                      ).toLocaleString("fr-FR")
                    : "-"}
                </td>

                <td>
                  {intervention.date_fin
                    ? new Date(
                        intervention.date_fin
                      ).toLocaleString("fr-FR")
                    : "-"}
                </td>

                <td>
                  {intervention.type_intervention}
                </td>

                <td>
                  {intervention.description || "-"}
                </td>

                <td>
                  {intervention.actions || "-"}
                </td>

                <td>
                  {intervention.solution || "-"}
                </td>

                <td>
                  {intervention.resultat || "-"}
                </td>

                <td>
                  {intervention.technicien || "-"}
                </td>

                <td>
                  {intervention.statut}
                </td>

                <td>

                  <button
                    type="button"
                    onClick={() =>
                      handleEdit(intervention)
                    }
                  >
                    Modifier
                  </button>

                  {intervention.statut !== "Clôturée" && (
                    <button
                      type="button"
                      onClick={() =>
                        handleClose(intervention.id)
                      }
                    >
                      Clôturer
                    </button>
                  )}

                  <button
                    type="button"
                    onClick={() =>
                      handleDelete(intervention.id)
                    }
                  >
                    Supprimer
                  </button>

                </td>
                <td>
                    <div>
                        <strong>Commentaires</strong>

                        <button
                          type="button"
                          onClick={() => fetchComments(intervention.id)}
                        >
                          Voir les commentaires
                        </button>
                        {showComments[intervention.id] && (
      <div>
        {comments[intervention.id]?.length > 0 ? (
          comments[intervention.id].map((comment) => (
            <div key={comment.id}>
              <small>
                {new Date(comment.date_commentaire).toLocaleString("fr-FR")}
              </small>
              <p>{comment.commentaire}</p>
            </div>
          ))
        ) : (
          <p>Aucun commentaire.</p>
        )}

        <textarea
          value={newComment[intervention.id] || ""}
          onChange={(e) =>
            setNewComment((prev) => ({
              ...prev,
              [intervention.id]: e.target.value,
            }))
          }
          placeholder="Ajouter un commentaire..."
        />

        <button
          type="button"
          onClick={() => addComment(intervention.id)}
        >
          Ajouter
        </button>
      </div>

    )}
  </div>
</td>
<td>
<div>
  <strong>Historique</strong>

  <button
    type="button"
    onClick={() => fetchHistory(intervention.id)}
  >
    📜 Voir l'historique
  </button>

  {showHistory[intervention.id] && (
    <div>
      {history[intervention.id]?.length > 0 ? (
        history[intervention.id].map((item) => (
          <div key={item.id}>
            <hr />

            <small>
              {new Date(item.date_action).toLocaleString("fr-FR")}
            </small>

            <p>
              <strong>Action :</strong> {item.action}
            </p>
            {item.ancienne_description !== null ? (
  <p>
    <strong>Description :</strong>{" "}
    {item.ancienne_description || "-"}
    {" → "}
    {item.nouvelle_description || "-"}
  </p>
) : null}

{item.anciennes_actions !== null ? (
  <p>
    <strong>Actions :</strong>{" "}
    {item.anciennes_actions || "-"}
    {" → "}
    {item.nouvelles_actions || "-"}
  </p>
) : null}

{item.ancienne_solution !== null ? (
  <p>
    <strong>Solution :</strong>{" "}
    {item.ancienne_solution || "-"}
    {" → "}
    {item.nouvelle_solution || "-"}
  </p>
) : null}
            {item.ancien_statut || item.nouveau_statut ? (
              <p>
                <strong>Statut :</strong>{" "}
                {item.ancien_statut || "-"}
                {" → "}
                {item.nouveau_statut || "-"}
              </p>
            ) : null}

            {item.ancien_technicien || item.nouveau_technicien ? (
              <p>
                <strong>Technicien :</strong>{" "}
                {item.ancien_technicien || "-"}
                {" → "}
                {item.nouveau_technicien || "-"}
              </p>
            ) : null}
          </div>
        ))
      ) : (
        <p>Aucun historique.</p>
      )}
    </div>
  )}
</div>
</td>

              </tr>
            ))}

          </tbody>

        </table>
      )}

    </div>
  );
}

export default Interventions;