import { useMemo, useState } from 'react';
import './Home.css';
import NavBar from './NavBar';

export default function Home() {
  const [authState, setAuthState] = useState<
    'idle' | 'loading' | 'success' | 'error'
  >(() => {
    const status = new URLSearchParams(window.location.search).get('status');
    if (status === 'success') return 'success';
    if (status === 'error') return 'error';
    return 'idle';
  });

  const isLoading = authState === 'loading';

  const banner = useMemo(() => {
    if (authState === 'success') return { tone: 'success' as const, text: 'Sesión iniciada.' };
    if (authState === 'error')
      return { tone: 'error' as const, text: 'No se pudo iniciar sesión. Intenta nuevamente.' };
    return null;
  }, [authState]);

  const handleLogin = () => {
    setAuthState('loading');
    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3001';
    window.location.href = `${apiUrl}/deezer/oauth/start`;
  };

  const scrollToConnect = () => {
    const el = document.getElementById('connect');
    if (!el) return;
    el.scrollIntoView({ behavior: 'smooth', block: 'start' });
  };

  return (
    <div className="home-container">
      <NavBar onLoginClick={scrollToConnect} onRegisterClick={scrollToConnect} />

      <main className="home-main">
        <section className="home-hero" aria-labelledby="home-title">
          <div className="home-kicker" aria-hidden="true">
            MOODSTREAM
          </div>
          <h1 className="home-title" id="home-title">
            La música que necesitas,<br />
            <em className="home-emphasis">en el momento exacto</em>
          </h1>
          <p className="subtitle">
            Cuéntanos cómo te sientes. Nosotros encontramos la playlist perfecta en Deezer.
          </p>
          <div className="home-ctaRow">
            <button className="btn btn--primary" type="button" onClick={scrollToConnect}>
              Generar mi playlist
            </button>
            <button className="btn btn--ghost" type="button" onClick={scrollToConnect}>
              Ya tengo cuenta
            </button>
          </div>
          <p className="home-micro">Gratis · Requiere cuenta Deezer</p>
        </section>

        {banner ? (
          <div
            role="status"
            aria-live="polite"
            className={`card statusBanner statusBanner--${banner.tone}`}
          >
            <div className="statusBanner__text">{banner.text}</div>
          </div>
        ) : null}

        <section className="features">
          <div className="features-grid" role="list" aria-label="Features">
            <div className="card card--sm featureItem" role="listitem">
              <div className="featureItem__icon" aria-hidden="true">
                🎭
              </div>
              <div className="featureItem__title">Entiende tu mood</div>
              <p className="featureItem__body">Describe cómo te sientes en tus palabras.</p>
            </div>
            <div className="card card--sm featureItem" role="listitem">
              <div className="featureItem__icon" aria-hidden="true">
                ✨
              </div>
              <div className="featureItem__title">IA emocional</div>
              <p className="featureItem__body">
                Ajustamos la energía para expresar o para superar.
              </p>
            </div>
            <div className="card card--sm featureItem" role="listitem">
              <div className="featureItem__icon" aria-hidden="true">
                🎵
              </div>
              <div className="featureItem__title">En Deezer</div>
              <p className="featureItem__body">
                Guardada directo en tu cuenta, lista para escuchar.
              </p>
            </div>
          </div>
        </section>

        <section className="login-section" id="connect" aria-label="Conectar con Deezer">
          <button className="btn btn--deezer" onClick={handleLogin} disabled={isLoading}>
            {isLoading ? 'Conectando...' : 'Conectar con Deezer'}
          </button>
          <p className="note">
            Necesitas una cuenta de Deezer para poder generar y guardar tus playlists.
          </p>
        </section>
      </main>
    </div>
  );
}
