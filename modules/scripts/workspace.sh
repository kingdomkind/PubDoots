#!/usr/bin/env bash
set -euo pipefail
set -x

usage() {
  cat >&2 <<'EOF'
Usage:
  workspace.sh <base_workspace> [focus|move]
Examples:
  workspace.sh 3            # focus workspace on current monitor: 3/13/23...
  workspace.sh 3 focus
  workspace.sh 3 move       # move active window to 3/13/23... silently
EOF
  exit 2
}

(( $# >= 1 && $# <= 2 )) || usage
base="$1"
mode="${2:-focus}"

if ! [[ "$base" =~ ^-?[0-9]+$ ]]; then
  echo "Error: base_workspace must be an integer, got: $base" >&2
  usage
fi

case "$mode" in
  focus) dispatch="focusworkspaceoncurrentmonitor" ;;
  move)  dispatch="movetoworkspacesilent" ;;
  *) echo "Error: mode must be 'focus' or 'move' (got: $mode)" >&2; usage ;;
esac

mon_out="$(hyprctl monitors 2>/dev/null)" || {
  echo "Error: hyprctl monitors failed (is Hyprland running?)." >&2
  exit 1
}

mapfile -t monitors < <(awk '$1=="Monitor"{print $2}' <<<"$mon_out")

focused="$(
  awk '
    $1=="Monitor" {name=$2}
    $1=="focused:" && $2=="yes" {print name; exit}
  ' <<<"$mon_out"
)"

if (( ${#monitors[@]} == 0 )); then
  echo "Error: no monitors found." >&2
  exit 1
fi
if [[ -z "${focused:-}" ]]; then
  echo "Error: could not determine focused monitor." >&2
  exit 1
fi

idx=-1
for i in "${!monitors[@]}"; do
  if [[ "${monitors[$i]}" == "$focused" ]]; then
    idx="$i"
    break
  fi
done
if (( idx < 0 )); then
  echo "Error: focused monitor '$focused' not found in monitor list: ${monitors[*]}" >&2
  exit 1
fi

target=$(( base + idx * 10 ))
exec hyprctl dispatch "$dispatch" "$target"
