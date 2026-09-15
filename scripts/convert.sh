#!/usr/bin/env bash
# Convert a source audio file to a Soundtrack Menu friendly OGG:
# OGG Vorbis, constant 192 kbps, 44.1 kHz, ASCII filename.
#
# Usage:
#   scripts/convert.sh <input> <output.ogg> [start] [end]
# Example (loop section from 0:07.250 to 1:52.000):
#   scripts/convert.sh "~/Music/Beneath the Mask.flac" resources/music/P5R/main_menu.ogg 00:00:07.250 00:01:52.000
#
# For a track with a non-looping intro, run it twice: once with the intro range
# to main_menu_intro.ogg and once with the loop range to main_menu.ogg.
# Both files come out at the same bitrate, which the game requires.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  sed -n '2,12p' "$0"
  exit 1
fi

in="$1"
out="$2"
start="${3:-}"
end="${4:-}"

command -v ffmpeg >/dev/null || { echo "ffmpeg not found. macOS: brew install ffmpeg. Windows: winget install ffmpeg" >&2; exit 1; }

base="$(basename "$out")"
if [[ "$base" =~ [^A-Za-z0-9._-] ]]; then
  echo "Output filename must be ASCII letters, digits, '.', '_' or '-' only: $base" >&2
  exit 1
fi

args=()
[[ -n "$start" ]] && args+=(-ss "$start")
[[ -n "$end" ]] && args+=(-to "$end")

ffmpeg -hide_banner -y "${args[@]}" -i "$in" -vn -c:a libvorbis -b:a 192k -minrate 192k -maxrate 192k -ar 44100 -ac 2 "$out"
echo "Wrote $out"
ffprobe -hide_banner -v error -show_entries format=duration,bit_rate -of default=nw=1 "$out"
