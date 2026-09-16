import { useEffect, useState } from "react";
import api from "../services/api";
import StatCard from "../components/StatCard";
import Alert from "../components/Alert";
import TicketStatusChart from "../components/charts/TicketStatusChart";
import EquipmentCategoryChart from "../components/charts/EquipmentCategoryChart";
import EquipmentStatusChart from "../components/charts/EquipmentStatusChart";
import TicketPriorityChart from "../components/charts/TicketPriorityChart";
import InterventionStatusChart from "../components/charts/InterventionStatusChart";
import IncidentServiceChart from "../components/charts/IncidentServiceChart";
import IncidentEquipmentTypeChart from "../components/charts/IncidentEquipmentTypeChart";
import InterventionPeriodChart from "../components/charts/InterventionPeriodChart";
import FrequentProblemsChart from "../components/charts/FrequentProblemsChart";
import IncidentEvolutionChart from "../components/charts/IncidentEvolutionChart";

function Dashboard() {
  const [data, setData] = useState(null);
  const [statistics, setStatistics] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    Promise.all([
      api.get("/dashboard/"),
      api.get("/statistics/"),
    ])
      .then(([dashboardResponse, statisticsResponse]) => {
        setData(dashboardResponse.data);
        setStatistics(statisticsResponse.data);
      })
      .catch((error) => {
        console.error(error);
        setError("Impossible de récupérer les données.");
      });
  }, []);

  if (error) {
    return <p>{error}</p>;
  }

  if (!data || !statistics) {
    return <p>Chargement du dashboard...</p>;
  }

  return (
    <div className="dashboard">

      <h1>Dashboard</h1>

      {/* INDICATEURS */}
      <div className="stats-grid">

        <StatCard
          title="Total équipements"
          value={data.total_equipment}
        />
        <StatCard
  title="Équipements opérationnels"
  value={data.equipements_operationnels}
/>

<StatCard
  title="Équipements en panne"
  value={data.equipements_en_panne}
/>

<StatCard
  title="Incidents"
  value={data.total_incidents}
/>

        <StatCard
          title="Total tickets"
          value={data.total_tickets}
        />

        <StatCard
          title="Tickets ouverts"
          value={data.tickets_ouverts}
        />

        <StatCard
          title="Tickets en cours"
          value={data.tickets_en_cours}
        />

        <StatCard
          title="Tickets résolus"
          value={data.tickets_resolus}
        />

        <StatCard
          title="Total interventions"
          value={data.total_interventions}
        />
        <StatCard
  title="Interventions en cours"
  value={data.interventions_en_cours}
/>

<StatCard
  title="Interventions terminées"
  value={data.interventions_terminees}
/>

      </div>


      {/* ALERTES */}
      <div className="alerts-section">

        <h2>Alertes</h2>

        {data.tickets_ouverts > 0 && (
          <Alert
            message={`${data.tickets_ouverts} ticket(s) ouvert(s) nécessitent une attention.`}
            type="warning"
          />
        )}

        {data.tickets_en_cours > 0 && (
          <Alert
            message={`${data.tickets_en_cours} ticket(s) sont actuellement en cours de traitement.`}
            type="info"
          />
        )}

        {data.tickets_ouverts === 0 &&
          data.tickets_en_cours === 0 && (
            <Alert
              message="Aucun ticket en attente. Tout est sous contrôle."
              type="success"
            />
          )}

      </div>


      {/* GRAPHIQUE */}
      <div className="charts-section">

        <TicketStatusChart
          data={statistics.tickets_by_status}
        />
        <EquipmentCategoryChart
          data={statistics.equipment_by_category}
        />
        <EquipmentStatusChart
          data={statistics.equipment_by_status}
        />
        <TicketPriorityChart
          data={statistics.tickets_by_priority}
        />
        <InterventionStatusChart
          data={statistics.interventions_by_status}
        />
        <IncidentServiceChart
          data={data.incidents_par_service}
        />
        <IncidentEquipmentTypeChart
          data={data.incidents_par_type_equipement}
        />
        <InterventionPeriodChart
          data={data.interventions_par_periode}
        />
        <FrequentProblemsChart
          data={data.problemes_frequents}
        />
        <IncidentEvolutionChart
          data={data.incidents_par_periode}
        />

      </div>

    </div>
  );
}

export default Dashboard;