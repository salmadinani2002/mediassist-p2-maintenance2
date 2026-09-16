import { NavLink } from "react-router-dom";

function Sidebar() {
  return (
    <aside className="sidebar">
      <div className="sidebar-brand">
        <div className="sidebar-brand-mark">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M2 12h5l2-7 3 14 2-7h8" />
          </svg>
        </div>
        <h2>MediAssist AI</h2>
      </div>

      <nav className="sidebar-nav">
        <NavLink to="/" end>Dashboard</NavLink>
        <NavLink to="/incidents">Incidents</NavLink>
        <NavLink to="/tickets">Tickets</NavLink>
        <NavLink to="/interventions">Interventions</NavLink>
        <NavLink to="/statistics">Statistiques</NavLink>
        <NavLink to="/analyse">Analyse</NavLink>
        <NavLink to="/reports">Rapports</NavLink>
      </nav>

      <div className="sidebar-foot">
        <svg className="pulse-line" viewBox="0 0 220 24" preserveAspectRatio="none">
          <path d="M0 12 H70 L80 4 L90 20 L100 8 L108 12 H220" />
        </svg>
      </div>
    </aside>
  );
}

export default Sidebar;