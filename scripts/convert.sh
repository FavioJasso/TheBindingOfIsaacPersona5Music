#!/usr/bin/env bash
# Convert a source audio file to a Soundtrack Menu friendly OGG:
# OGG Vorbis, managed constant 192 kbps, 44.1 kHz stereo, ASCII filename.
#
# Usage:
#   scripts/convert.sh <input> <output.ogg> [start] [end]
# Example (loop section from 0:07.250 to 1:52.000):
#   scripts/convert.sh "~/Music/Beneath the Mask.flac" resources/music/P5R/main_menu.ogg 00:00:07.250 00:01:52.000
#
# Needs ffmpeg (decode/trim) and oggenc from vorbis-tools (encode):
#   brew install ffmpeg vorbis-tools
# The Homebrew ffmpeg build has no libvorbis encoder, which is why oggenc does the encoding.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  sed -n '2,12p' "$0"
  exit 1
fi

in="$1"
out="$2"
start="${3:-}"
end="${4:-}"

command -v ffmpeg >/dev/null || { echo "ffmpeg not found: brew install ffmpeg" >&2; exit 1; }
command -v oggenc >/dev/null || { echo "oggenc not found: brew install vorbis-tools" >&2; exit 1; }

base="$(basename "$out")"
if [[ "$base" =~ [^A-Za-z0-9._-] ]]; then
  echo "Output filename must be ASCII letters, digits, '.', '_' or '-' only: $base" >&2
  exit 1
fi

args=()
[[ -n "$start" ]] && args+=(-ss "$start")
[[ -n "$end" ]] && args+=(-to "$end")

tmp="$(mktemp -t p5r).wav"
trap 'rm -f "$tmp"' EXIT
ffmpeg -hide_banner -loglevel error -y -i "$in" "${args[@]}" -vn -c:a pcm_s16le -ar 44100 -ac 2 "$tmp"
oggenc -Q --managed -b 192 -m 192 -M 192 -o "$out" "$tmp"
echo "Wrote $out"
ffprobe -hide_banner -v error -show_entries format=duration,bit_rate -of default=nw=1 "$out"
