// DocuBus — permet d'ouvrir l'appli même sans réseau.
// Toujours la version en ligne d'abord ; la copie en cache sert seulement hors connexion.
// Les documents vierges déjà ouverts une fois restent consultables hors connexion.
// Rien de ce qui est saisi dans le formulaire de délivrance ne passe par ici.
const CACHE = 'docubus-v1';
const FILES = [
  './',
  './index.html',
  './css/commun.css',
  './manifest.webmanifest',
  './config/documents.json',
  './config/listes.json',
  './config/structure.json',
  './lib/jspdf.umd.min.js',
  './img/logo.svg',
  './img/logo-app.png',
  './img/logo-association.png',
  './img/logo-association.jpg',
  './img/icon-192.png',
  './img/icon-512.png',
  './img/apple-touch-icon.png',
  './img/favicon.png',
  './fonts/permanent-marker.woff2',
  './fonts/atkinson-400.woff2',
  './fonts/atkinson-700.woff2',
  './fonts/atkinson-mono-400.woff2',
  './fonts/atkinson-mono-700.woff2'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;     // GitHub (page admin) : jamais mis en cache
  if (url.pathname.endsWith('/config/cle.json')) return; // la clé chiffrée n'est jamais mise en cache

  e.respondWith(
    fetch(req, { cache: 'no-cache' })
      .then(res => {
        if (res && res.ok) {
          const copy = res.clone();
          caches.open(CACHE).then(c => c.put(req, copy));
        }
        return res;
      })
      .catch(() => caches.match(req, { ignoreSearch: true })
        .then(r => r || (req.mode === 'navigate' ? caches.match('./index.html') : undefined)))
  );
});
