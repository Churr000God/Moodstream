import './NavBar.css';

type NavBarProps = {
  onLoginClick?: () => void;
  onRegisterClick?: () => void;
};

export default function NavBar({ onLoginClick, onRegisterClick }: NavBarProps) {
  return (
    <header className="navbar" role="banner">
      <nav className="navbar__inner" aria-label="Principal">
        <a className="navbar__brand" href="/" aria-label="Moodstream - Inicio">
          <span className="navbar__brandIcon" aria-hidden="true">
            <svg viewBox="0 0 24 24" width="18" height="18" focusable="false">
              <path
                fill="currentColor"
                d="M17 3h-3a1 1 0 0 0-1 1v9.2a3.5 3.5 0 1 0 2 3.2V9h2a1 1 0 0 0 0-2h-2V5h2a1 1 0 0 0 0-2Z"
              />
            </svg>
          </span>
          <span className="navbar__brandText">Moodstream</span>
        </a>

        <div className="navbar__actions">
          <button
            className="btn btn--ghost btn--sm"
            type="button"
            onClick={onLoginClick}
          >
            Iniciar sesión
          </button>
          <button
            className="btn btn--primary btn--sm"
            type="button"
            onClick={onRegisterClick}
          >
            Registrarse
          </button>
        </div>
      </nav>
    </header>
  );
}
