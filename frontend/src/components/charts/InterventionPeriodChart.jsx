import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

function InterventionPeriodChart({ data }) {
  return (
    <div className="chart-card">
      <h2>Interventions par période</h2>

      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <CartesianGrid stroke="#dbe3ea" vertical={false} />
          <XAxis dataKey="date" tick={{ fontSize: 12, fill: "#8698a8" }} axisLine={{ stroke: "#dbe3ea" }} tickLine={false} />
          <YAxis allowDecimals={false} tick={{ fontSize: 12, fill: "#8698a8" }} axisLine={false} tickLine={false} />
          <Tooltip
            contentStyle={{ background: "#fff", border: "1px solid #dbe3ea", borderRadius: 8, fontSize: 13 }}
          />
          <Line
            type="monotone"
            dataKey="nombre"
            stroke="#0e7c86"
            strokeWidth={2.5}
            dot={{ fill: "#0e7c86", r: 4 }}
            activeDot={{ r: 6 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

export default InterventionPeriodChart;