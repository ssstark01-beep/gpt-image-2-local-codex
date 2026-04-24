#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROMPT=""
OUT=""
declare -a REFS=()

usage() {
  cat <<'EOF'
Usage:
  bash scripts/gen.sh --prompt "..." --out /absolute/path/output.png [--ref /abs/ref.png ...]

Options:
  --prompt   Raw prompt text for the image
  --out      Output file path for the final image
  --ref      Optional reference image path (repeatable)
  -h, --help Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt)
      PROMPT="${2:-}"
      shift 2
      ;;
    --out)
      OUT="${2:-}"
      shift 2
      ;;
    --ref)
      REFS+=("${2:-}")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$PROMPT" ]]; then
  echo "Error: --prompt is required." >&2
  usage
  exit 1
fi
if [[ -z "$OUT" ]]; then
  echo "Error: --out is required." >&2
  usage
  exit 1
fi

command -v codex >/dev/null 2>&1 || {
  echo "Error: codex is not on PATH." >&2
  exit 1
}
command -v python3 >/dev/null 2>&1 || {
  echo "Error: python3 is not on PATH." >&2
  exit 1
}

export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$(dirname "$OUT")"

marker="$(mktemp)"
trap 'rm -f "$marker"' EXIT
: > "$marker"
export MARKER="$marker"

codex_args=(exec --full-auto --cd "$REPO_ROOT")
for ref in "${REFS[@]}"; do
  if [[ ! -f "$ref" ]]; then
    echo "Error: reference image not found: $ref" >&2
    exit 1
  fi
  codex_args+=( -i "$ref" )
done

agent_prompt=$(cat <<EOF
Use the built-in image generation tool to create a single image for this prompt.
Return no explanation. Just generate the image and save it through Codex's normal image output flow.

Prompt:
$PROMPT
EOF
)

codex "${codex_args[@]}" "$agent_prompt"

latest="$(python3 - <<'PY'
import os
from pathlib import Path

marker = Path(os.environ["MARKER"])
cutoff = marker.stat().st_mtime
codex_home = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex")))
root = codex_home / "generated_images"

if not root.exists():
    raise SystemExit(0)

suffixes = {".png", ".jpg", ".jpeg", ".webp"}
candidates = [
    p for p in root.rglob("*")
    if p.is_file() and p.suffix.lower() in suffixes and p.stat().st_mtime >= cutoff
]

if not candidates:
    candidates = [
        p for p in root.rglob("*")
        if p.is_file() and p.suffix.lower() in suffixes
    ]

if candidates:
    print(max(candidates, key=lambda p: p.stat().st_mtime))
PY
)"

if [[ -z "$latest" || ! -f "$latest" ]]; then
  echo "Error: no generated image file found under $CODEX_HOME/generated_images." >&2
  exit 1
fi

cp "$latest" "$OUT"
echo "$OUT"
