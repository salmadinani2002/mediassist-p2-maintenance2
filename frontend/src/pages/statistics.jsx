import { useEffect, useState } from "react";
import api from "../services/api";

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from "recharts";

function Statistics() {
  const [statistics, setStatistics] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [ticketStatusFilter, setTicketStatusFilter] = useState("Tous");
  const [ticketPriorityFilter, setTicketPriorityFilter] = useState("Tous");

  const [tickets, setTickets] = useState([]);
  const [interventions, setInterventions] = useState([]);

  useEffect(() => {
    Promise.all([
      api.get("/statistics/"),
      api.get("/tickets/"),
      api.get("/interventions/"),
    ])
      .then(
        ([
          statisticsResponse,
          ticketsResponse,
          interventionsResponse,
        ]) => {
          setStatistics(statisticsResponse.data);
          setTickets(ticketsResponse.data);
          setInterventions(interventionsResponse.data);
          setLoading(false);
        }
      )
      .catch((error) => {
        console.error(error);
        setError("Impossible de récupérer les statistiques.");
        setLoading(false);
      });
  }, []);

  if (loading) {
    return <p>Chargement des statistiques...</p>;
  }

  if (error) {
    return <p>{error}</p>;
  }

  const totalEquipments =
    statistics?.equipment_by_category?.reduce(
      (total, item) => total + item.count,
      0
    ) || 0;

  const totalTickets =
    statistics?.tickets_by_status?.reduce(
      (total, item) => total + item.count,
      0
    ) || 0;

  const totalInterventions =
    statistics?.interventions_by_status?.reduce(
      (total, item) => total + item.count,
      0
    ) || 0;

  const ticketsOuverts =
    statistics?.tickets_by_status?.find(
      (item) => item.status === "Ouvert"
    )?.count || 0;

  const filteredTicketsByStatus =
    ticketStatusFilter === "Tous"
      ? statistics?.tickets_by_status || []
      : (statistics?.tickets_by_status || []).filter(
          (item) => item.status === ticketStatusFilter
        );

  const filteredTicketsByPriority =
    ticketPriorityFilter === "Tous"
      ? statistics?.tickets_by_priority || []
      : (statistics?.tickets_by_priority || []).filter(
          (item) => item.priority === ticketPriorityFilter
        );

  // Tickets haute ou critique encore ouverts/en cours
  const alertTickets = tickets.filter(
    (ticket) =>
      (ticket.priorite === "Haute" ||
        ticket.priorite === "Critique") &&
      (ticket.statut === "Ouvert" ||
        ticket.statut === "En cours")
  );

  // Interventions qui ne sont pas terminées
  const alertInterventions = interventions.filter(
    (intervention) =>
      intervention.statut !== "Terminée"
  );

  return (
    <div className="statistics-page">

      <h1>Statistiques</h1>

      <p>Analyse et statistiques</p>

      {/* ALERTES */}
      <div className="statistics-alerts">

        <h2>Alertes</h2>

        {alertTickets.length === 0 &&
        alertInterventions.length === 0 ? (
          <p>Aucune alerte critique.</p>
        ) : (
          <>
            {/* Alertes tickets */}
            {alertTickets.map((ticket) => (
              <div
                className="alert-card"
                key={`ticket-${ticket.id}`}
              >
                <strong>
                  ⚠️ Ticket #{ticket.id}
                </strong>

                <p>
                  Priorité : {ticket.priorite}
                </p>

                <p>
                  Statut : {ticket.statut}
                </p>

                <p>
                  {ticket.description}
                </p>
              </div>
            ))}

            {/* Alertes interventions */}
            {alertInterventions.map((intervention) => (
              <div
                className="alert-card"
                key={`intervention-${intervention.id}`}
              >
                <strong>
                  ⚠️ Intervention #{intervention.id}
                </strong>

                <p>
                  Statut : {intervention.statut}
                </p>

                <p>
                  Technicien :{" "}
                  {intervention.technicien ||
                    "Non renseigné"}
                </p>

                <p>
                  {intervention.description}
                </p>
              </div>
            ))}
          </>
        )}

      </div>

      {/* INDICATEURS */}
      <div className="statistics-cards">

        <div className="stat-card">
          <h3>Équipements</h3>
          <strong>{totalEquipments}</strong>
        </div>

        <div className="stat-card">
          <h3>Tickets</h3>
          <strong>{totalTickets}</strong>
        </div>

        <div className="stat-card">
          <h3>Interventions</h3>
          <strong>{totalInterventions}</strong>
        </div>

        <div className="stat-card">
          <h3>Tickets ouverts</h3>
          <strong>{ticketsOuverts}</strong>
        </div>

      </div>

      {/* FILTRE PAR STATUT */}
      <div className="statistics-filters">

        <label htmlFor="ticket-status-filter">
          Filtrer les tickets par statut :
        </label>

        <select
          id="ticket-status-filter"
          value={ticketStatusFilter}
          onChange={(event) =>
            setTicketStatusFilter(
              event.target.value
            )
          }
        >
          <option value="Tous">Tous</option>
          <option value="Ouvert">Ouvert</option>
          <option value="En cours">En cours</option>
          <option value="Résolu">Résolu</option>
        </select>

      </div>

      {/* FILTRE PAR PRIORITÉ */}
      <div className="statistics-filters">

        <label htmlFor="ticket-priority-filter">
          Filtrer les tickets par priorité :
        </label>

        <select
          id="ticket-priority-filter"
          value={ticketPriorityFilter}
          onChange={(event) =>
            setTicketPriorityFilter(
              event.target.value
            )
          }
        >
          <option value="Tous">Tous</option>
          <option value="Basse">Basse</option>
          <option value="Moyenne">Moyenne</option>
          <option value="Haute">Haute</option>
          <option value="Critique">Critique</option>
        </select>

      </div>

      {/* GRAPHIQUES */}
      <div className="statistics-charts">

        {/* 1. Tickets par statut */}
        <div className="chart-card">

          <h2>Tickets par statut</h2>

          <ResponsiveContainer
            width="100%"
            height={300}
          >
            <BarChart
              data={filteredTicketsByStatus}
            >
              <CartesianGrid
                strokeDasharray="3 3"
              />

              <XAxis dataKey="status" />

              <YAxis />

              <Tooltip />

              <Legend />

              <Bar
                dataKey="count"
                name="Tickets"
              />
            </BarChart>
          </ResponsiveContainer>

        </div>

        {/* 2. Tickets par priorité */}
        <div className="chart-card">

          <h2>Tickets par priorité</h2>

          <ResponsiveContainer
            width="100%"
            height={300}
          >
            <BarChart
              data={filteredTicketsByPriority}
            >
              <CartesianGrid
                strokeDasharray="3 3"
              />

              <XAxis dataKey="priority" />

              <YAxis />

              <Tooltip />

              <Legend />

              <Bar
                dataKey="count"
                name="Tickets"
              />
            </BarChart>
          </ResponsiveContainer>

        </div>

        {/* 3. Équipements par catégorie */}
        <div className="chart-card">

          <h2>Équipements par catégorie</h2>

          <ResponsiveContainer
            width="100%"
            height={300}
          >
            <BarChart
              data={
                statistics.equipment_by_category
              }
            >
              <CartesianGrid
                strokeDasharray="3 3"
              />

              <XAxis dataKey="category" />

              <YAxis />

              <Tooltip />

              <Legend />

              <Bar
                dataKey="count"
                name="Équipements"
              />
            </BarChart>
          </ResponsiveContainer>

        </div>

        {/* 4. Équipements par statut */}
        <div className="chart-card">

          <h2>Équipements par statut</h2>

          <ResponsiveContainer
            width="100%"
            height={300}
          >
            <BarChart
              data={
                statistics.equipment_by_status
              }
            >
              <CartesianGrid
                strokeDasharray="3 3"
              />

              <XAxis dataKey="status" />

              <YAxis />

              <Tooltip />

              <Legend />

              <Bar
                dataKey="count"
                name="Équipements"
              />
            </BarChart>
          </ResponsiveContainer>

        </div>

        {/* 5. Interventions par statut */}
        <div className="chart-card">

          <h2>Interventions par statut</h2>

          <ResponsiveContainer
            width="100%"
            height={300}
          >
            <BarChart
              data={
                statistics.interventions_by_status
              }
            >
              <CartesianGrid
                strokeDasharray="3 3"
              />

              <XAxis dataKey="status" />

              <YAxis />

              <Tooltip />

              <Legend />

              <Bar
                dataKey="count"
                name="Interventions"
              />
            </BarChart>
          </ResponsiveContainer>

        </div>

      </div>

    </div>
  );
}

export default Statistics;