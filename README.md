# P5R Menu Music (Soundtrack Menu pack)

A Steam Workshop mod for The Binding of Isaac: Repentance+ that plays Persona 5 Royal music on the main menu. It is a soundtrack pack for Nato Potato's **Soundtrack Menu** mod (Workshop id 1933285222), which needs **Repentogon** to switch menu music. Only the main menu track is defined; everything in a run keeps the default audio.

## Layout

| Path | Purpose |
| --- | --- |
| `metadata.xml` | Workshop metadata. No `<id>`; the uploader assigns one. |
| `main.lua` | Registers the "P5R" soundtrack with Soundtrack Menu on run start. |
| `content/music.xml` | Declares the P5R tracks (main menu, tainted menu layer, run-start jingles). |
| `resources/music/P5R/` | The .ogg files. Folder name must stay `P5R`. |
| `scripts/convert.sh` | ffmpeg + oggenc wrapper that produces a compliant .ogg. |

The three strings that must agree: `AddSoundtrackToMenu("P5R")` in `main.lua`, the `P5R ` prefix on every track name in `music.xml`, and the `music/P5R/` root folder.

## Tracks

| File | Source | Cut |
| --- | --- | --- |
| `main_menu_intro.ogg` | Beneath the Mask (instrumental) | 0:00 to 0:15.474, plays once |
| `main_menu.ogg` | Beneath the Mask (instrumental) | 0:15.474 to 1:33.313, loops, 0.5 s crossfade at the seam |
| `tainted_menu_intro.ogg` | Life Will Change | 0:00 to 1:54.688, plays once |
| `tainted_menu.ogg` | Life Will Change | 1:54.688 to 3:51.053, loops, 0.5 s crossfade at the seam |
| `run_start.ogg` | Last Surprise | first two bars, 5.71 s, fades out |
| `tainted_run_start.ogg` | Life Will Change | first four bars, 7.67 s, fades out |

All files are OGG Vorbis, managed constant 192 kbps, 44.1 kHz stereo. Loop points were chosen by cross-correlating each song with itself to find where a section restates, then refining to the sample.

## Replacing or adding audio

1. Pick the source track and find the loop point (Audacity, or trial and error with the start/end args below).
2. Convert it. Filenames must be ASCII with no `!` or accented letters.
   ```sh
   brew install ffmpeg vorbis-tools   # once, on macOS
   scripts/convert.sh "path/to/source.flac" resources/music/P5R/main_menu.ogg [start] [end]
   ```
3. If the song has a non-looping intro, cut it into a separate `_intro.ogg` with the same script and reference it with `intro=` in `content/music.xml`. Intro and loop must share a bitrate or the music stops after the intro.

## Testing (Windows)

1. Copy this folder to `%USERPROFILE%\Documents\My Games\Binding of Isaac Repentance+\mods\p5r menu music\`. The folder name must match `<directory>` in `metadata.xml`.
2. Subscribe to Soundtrack Menu and Repentogon. Launch the game, enable the mod in Mods.
3. Start a run so `main.lua` runs and registers the soundtrack.
4. Open Mod Config Menu (default key `L`) > Soundtrack > Main Menu section > choose `P5R`.
5. Quit to the menu. The track should play. If not, open the console (`~`) and look for `SM ERROR` or `Failed to open stream`. Usual causes: name mismatch, wrong folder name, non-ASCII filename, VBR ogg.

## Publishing

Run `<game install>\tools\ModUploader\ModUploader.exe`, choose this folder's `metadata.xml`, add a 512x512 PNG thumbnail, keep the Music tag, upload. Do not list Soundtrack Menu or Repentogon as required items; the description already names them.

## Credits

Music by Shoji Meguro / Atlus. Template by Absolute-Lambda (Custom-Soundtrack-Menu-Mod-Template).
