#!/usr/bin/env bash
#
# test-tenable-api.sh
#
# Verifies Tenable API connectivity and credentials for the
# compliance-prioritizer skill BEFORE you run a full analysis.
#
# Supports both Tenable.io (cloud) and Tenable.sc (SecurityCenter, on-prem).
# Credentials are read from the environment or prompted for interactively.
# They are NEVER written to disk or logged.
#
# Usage:
#   ./test-tenable-api.sh                 # interactive, defaults to Tenable.io
#   TENABLE_PLATFORM=sc ./test-tenable-api.sh
#
# Environment variables (all optional; prompted if missing):
#   TENABLE_PLATFORM     io | sc            (default: io)
#   TENABLE_ACCESS_KEY   API access key
#   TENABLE_SECRET_KEY   API secret key
#   TENABLE_URL          base URL          (sc only; e.g. https://tenable.corp)
#   TENABLE_INSECURE     1 to skip TLS verification (sc self-signed; discouraged)
#
set -euo pipefail

platform="${TENABLE_PLATFORM:-io}"

# --- gather credentials without echoing secrets or persisting them ----------
access_key="${TENABLE_ACCESS_KEY:-}"
secret_key="${TENABLE_SECRET_KEY:-}"

if [[ -z "$access_key" ]]; then
  read -rp "Tenable API Access Key: " access_key
fi
if [[ -z "$secret_key" ]]; then
  read -rsp "Tenable API Secret Key: " secret_key
  echo
fi

if [[ -z "$access_key" || -z "$secret_key" ]]; then
  echo "ERROR: both an access key and a secret key are required." >&2
  exit 1
fi

auth_header="X-ApiKeys: accessKey=${access_key}; secretKey=${secret_key}"

# --- resolve endpoint per platform ------------------------------------------
curl_opts=(--silent --show-error --max-time 30)

case "$platform" in
  io)
    base_url="https://cloud.tenable.com"
    test_path="/scans"
    ;;
  sc)
    base_url="${TENABLE_URL:-}"
    if [[ -z "$base_url" ]]; then
      read -rp "Tenable.sc base URL (e.g. https://tenable.corp): " base_url
    fi
    base_url="${base_url%/}"          # strip trailing slash
    base_url="${base_url%/rest}"      # strip trailing /rest if user included it
    base_url="${base_url}/rest"
    test_path="/currentUser"
    if [[ "${TENABLE_INSECURE:-0}" == "1" ]]; then
      echo "WARNING: TLS certificate verification disabled (TENABLE_INSECURE=1)." >&2
      curl_opts+=(--insecure)
    fi
    ;;
  *)
    echo "ERROR: unknown TENABLE_PLATFORM='$platform' (expected 'io' or 'sc')." >&2
    exit 1
    ;;
esac

url="${base_url}${test_path}"
echo "Testing ${platform} connectivity: ${url}"

# --- make the request, capturing body and HTTP status separately ------------
http_code="$(curl "${curl_opts[@]}" \
  -o /tmp/tenable_api_test_body.$$ \
  -w '%{http_code}' \
  -H "$auth_header" \
  -H 'Accept: application/json' \
  "$url" || echo "000")"

body="$(cat /tmp/tenable_api_test_body.$$ 2>/dev/null || true)"
rm -f /tmp/tenable_api_test_body.$$

# --- interpret result -------------------------------------------------------
case "$http_code" in
  200)
    echo "SUCCESS: authenticated to Tenable ${platform} (HTTP 200)."
    exit 0
    ;;
  401)
    echo "FAILED: 401 Unauthorized — check that your access/secret keys are correct." >&2
    ;;
  403)
    echo "FAILED: 403 Forbidden — keys are valid but lack permission for ${test_path}." >&2
    ;;
  404)
    echo "FAILED: 404 Not Found — verify the base URL is correct for this platform." >&2
    ;;
  429)
    echo "FAILED: 429 Too Many Requests — rate limited. Wait and retry." >&2
    ;;
  000)
    echo "FAILED: could not reach ${base_url} — check the URL, network, or TLS trust." >&2
    ;;
  *)
    echo "FAILED: unexpected HTTP ${http_code}." >&2
    [[ -n "$body" ]] && echo "Response: ${body:0:300}" >&2
    ;;
esac
exit 1
