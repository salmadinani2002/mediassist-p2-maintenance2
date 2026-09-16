import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

function IncidentEquipmentTypeChart({ data }) {
  return (
    <div className="chart-card">
      <h2>Incidents par type d'équipement</h2>

      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={data}>
          <CartesianGrid stroke="#dbe3ea" vertical={false} />
          <XAxis dataKey="type_equipement" tick={{ fontSize: 12, fill: "#8698a8" }} axisLine={{ stroke: "#dbe3ea" }} tickLine={false} />
          <YAxis allowDecimals={false} tick={{ fontSize: 12, fill: "#8698a8" }} axisLine={false} tickLine={false} />
          <Tooltip
            contentStyle={{ background: "#fff", border: "1px solid #dbe3ea", borderRadius: 8, fontSize: 13 }}
            cursor={{ fill: "rgba(14,124,134,0.06)" }}
          />
          <Bar dataKey="nombre" fill="#0e7c86" radius={[4, 4, 0, 0]} maxBarSize={48} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

export default IncidentEquipmentTypeChart;