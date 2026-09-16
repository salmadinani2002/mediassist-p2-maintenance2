import { BrowserRouter, Routes, Route } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import Dashboard from "./pages/Dashboard";
import Incidents from "./pages/Incidents";
import Interventions from "./pages/Interventions";
import Tickets from "./pages/Tickets";
import Statistics from "./pages/statistics";
import Analyse from "./pages/Analyse";
import Reports from "./pages/Reports";

function App() {
  return (
    <BrowserRouter>
      <div className="app-shell">
        <Sidebar />

        <main className="app-main">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/incidents" element={<Incidents />} />
            <Route path="/tickets" element={<Tickets />} />
            <Route path="/interventions" element={<Interventions />} />
            <Route path="/statistics" element={<Statistics />} />
            <Route path="/analyse" element={<Analyse />} />
            <Route path="/reports" element={<Reports />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  );
}

export default App;