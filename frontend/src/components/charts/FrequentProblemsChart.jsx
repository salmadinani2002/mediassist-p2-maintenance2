import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

function FrequentProblemsChart({ data }) {
  return (
    <div className="chart-card">
      <h2>Problèmes les plus fréquents</h2>

      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={data} layout="vertical">
          <CartesianGrid stroke="#dbe3ea" horizontal={false} />
          <XAxis type="number" allowDecimals={false} tick={{ fontSize: 12, fill: "#8698a8" }} axisLine={false} tickLine={false} />
          <YAxis
            type="category"
            dataKey="probleme"
            width={150}
            tick={{ fontSize: 12, fill: "#8698a8" }}
            axisLine={false}
            tickLine={false}
          />
          <Tooltip
            contentStyle={{ background: "#fff", border: "1px solid #dbe3ea", borderRadius: 8, fontSize: 13 }}
            cursor={{ fill: "rgba(14,124,134,0.06)" }}
          />
          <Bar dataKey="nombre" fill="#0e7c86" radius={[0, 4, 4, 0]} maxBarSize={28} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

export default FrequentProblemsChart;