#!/usr/bin/env bash
set -euo pipefail

COMPOSE="docker compose"
SERVICE="api"                        # nome servizio nel docker-compose.yml
PORT="${API_PORT:-8080}"             # puoi override con: API_PORT=8081 ./controlService start
HEALTH_URL="http://localhost:${PORT}/actuator/health"

need() { command -v "$1" >/dev/null 2>&1 || { echo "Errore: manca '$1' nel PATH"; exit 127; }; }
ensure_prereq() {
  need docker
  $COMPOSE version >/dev/null 2>&1 || { echo "Errore: Docker Compose v2 non trovato"; exit 127; }
  [[ -f "docker-compose.yml" ]] || { echo "Errore: docker-compose.yml non trovato nella root"; exit 1; }
}

cmd_build()   { ensure_prereq; $COMPOSE build "$SERVICE"; }
cmd_start()   { ensure_prereq; $COMPOSE up -d --build "$SERVICE"; wait_health; }
cmd_stop()    { ensure_prereq; $COMPOSE down; }
cmd_restart() { cmd_stop || true; cmd_start; }
cmd_logs()    { ensure_prereq; $COMPOSE logs -f "$SERVICE"; }
cmd_status()  { ensure_prereq; $COMPOSE ps; }

wait_health() {
  echo "→ Attendo health su ${HEALTH_URL} ..."
  for i in {1..30}; do
    if curl -fsS "$HEALTH_URL" | grep -q '"status":"UP"'; then
      echo "✓ Service UP"; return 0
    fi
    sleep 1
  done
  echo "⚠️  Non ancora UP (timeout). Vedi log con: ./controlService logs"
  return 1
}

usage() {
  cat <<EOF
Uso: $(basename "$0") <comando>

Comandi:
  start     Avvia il servizio (build se necessario) e attende /actuator/health
  stop      Ferma e rimuove i container/risorse di compose
  restart   Stop + Start
  status    Stato dei servizi (docker compose ps)
  logs      Log in streaming del servizio '${SERVICE}'
  build     Solo build delle immagini

Variabili:
  API_PORT  Porta esposta (default 8080)

Esempi:
  ./controlService start
  API_PORT=8081 ./controlService start
  ./controlService logs
  ./controlService stop
EOF
}

case "${1:-}" in
  start)   cmd_start ;;
  stop)    cmd_stop ;;
  restart) cmd_restart ;;
  status)  cmd_status ;;
  logs)    cmd_logs ;;
  build)   cmd_build ;;
  *)       usage; exit 1 ;;
esac
