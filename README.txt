================================================================
  SUBTITLES VIDEO GENERATOR — README
================================================================

A tool for making lyric and subtitle videos with precise timing.

You perform the lyrics live — tapping a key or sending a MIDI note
for each word or line — and the program records the timing. It
then renders a transparent video of the lyrics that you can
composite over a music video in any editor.


================================================================
  WHAT IT DOES
================================================================

- Play your song and tap along to time each lyric line or word.
- Style the lyrics with four different animation classes, a
  dozen parameters, and per-event overrides.
- Export the timing as a MIDI file, edit it in your DAW, and
  play it back to drive the visuals.
- Render a transparent video file (PNG-in-MOV or ProRes 4444)
  ready to composite in Final Cut Pro, DaVinci Resolve, Reaper,
  or any editor that supports alpha channels.


================================================================
  WHAT YOU NEED
================================================================

- Processing 4 (with the Sound library installed)
- FFmpeg
- An audio file (if you want to record with a song)
- A lyrics.txt file (see below)

Full install instructions are in SETUP.txt.


================================================================
  GETTING STARTED
================================================================

1. Install Processing and FFmpeg. See SETUP.txt.

2. Open the sketch in Processing (File > Open).

3. Put your lyrics in data/lyrics.txt. One line per lyric.
   See the LYRICS FORMAT section below.

4. (Optional) Put audio files in the sketch folder. Press O in
   the sketch to load one.

5. Press the Run button.

6. Press ENTER to start a count-in and recording. Tap SPACE for
   each word or line. Press ENTER again to stop.

7. Press M to save the timestamps and render the video. Wait
   for the console to say the render finished.

8. The output file is "lyrics.mov" in the sketch folder. Import
   it into your editor and layer it over your music video.


================================================================
  LYRICS FORMAT
================================================================

Basic:

   Just a single lyric line
   Another lyric line
   A third lyric line

Each line is shown separately. SimpleLine advances one line per
tap. Word-based classes (highlight, karaoke, reveal) advance one
word per tap.

Stanzas (multi-line blocks):

   [stanza]
   First line of the verse
   Second line of the verse
   Third line of the verse
   [endstanza]

All three lines appear together. In SimpleLine mode, one tap
shows the whole stanza. In word-based modes, one tap reveals one
word, walking through the lines in order.

Empty lines inside a stanza:

   [stanza]
   Line one

   [emptyline]

   Line three
   [endstanza]

[emptyline] leaves vertical space. The recorder skips it — no tap
needed.

Screen-clearing pause:

   Some lyric line
   [blank]
   The next lyric line

[blank] clears the screen. It's its own one-line stanza and the
recorder lands on it (one tap to pass).

Rules:
- [stanza] and [endstanza] must come in pairs.
- [blank] cannot appear inside a [stanza] block. Use [emptyline].
- Markers must be on their own line, exactly as written.

See MIDI_REFERENCE.txt for the full stanza reference.


================================================================
  KEYBOARD QUICK REFERENCE
================================================================

   SPACE    advance (commit preset, advance word/line/stanza)
   B        blank screen
   ENTER    start or stop recording
   M        save + render (or return to record mode from render)
   R        reset to first line
   S        save timestamps without rendering
   X        export as MIDI file

   1-4      select preset class
   F        cycle transition
   G        cycle transition duration
   J        cycle highlight style
   K        cycle color
   L        cycle size
   U        cycle word fade duration
   N        cycle font
   P        capture "home" state (what R resets to)

   H        toggle help panel
   Y        toggle on-screen reference

The full reference is in MIDI_REFERENCE.txt, or press Y inside
the sketch.


================================================================
  WORKFLOW OVERVIEW
================================================================

There are two ways to record timing:

  1. Live performance — press ENTER, play your song, tap along
     with SPACE or a MIDI note, press ENTER to stop. The timings
     are captured as you go.

  2. MIDI-driven — route your DAW's output into the sketch (see
     the header comment inside the sketch for setup). Send note
     34 to start, 38 to advance, 35 to stop. The DAW becomes
     the timing source, which is more accurate and easier to
     edit.

Once the timing is captured, press M to render. The sketch
generates one PNG per visual change, then FFmpeg stitches them
into a video in a few seconds.

To edit the timing later, press X to export a MIDI file. Load
it into your DAW, adjust the notes and automation, then play it
back into the sketch to re-render.


================================================================
  FILES IN THIS FOLDER
================================================================

   README.txt              This file
   SETUP.txt               How to install Processing and FFmpeg
   MIDI_REFERENCE.txt      Full keyboard, MIDI, and CC reference

   data/lyrics.txt         Your lyrics. One per line, or use
                           [stanza] blocks for multi-line verses.

   data/fonts/			   Store custom fonts. See below.

   playlist.txt            Auto-generated. Remembers audio file
                           paths and per-song BPM / count-in.

   timestamps_*.txt        Auto-generated. One per recording.
                           Contains every event and its modifiers.

   timestamps_*.mid        Auto-generated on X. The MIDI export
                           of a take.

   frames/                 Temporary. Individual PNG frames
                           during a render. Cleared each time.

   list.txt                Temporary. FFmpeg concat list.
                           Cleared each time.

   lyrics.mov              The rendered output. Overwritten on
                           every render.

   FONTS
   -----
   The sketch loads any .ttf or .otf font placed in data/fonts/.
   Fonts are scanned alphabetically at startup, so the order is
   stable across sessions.

   To add a font:
     1. Drop the .ttf or .otf file into data/fonts/
     2. Restart the sketch (or press N to cycle if it's already
        loaded and the file was added after launch — restart is
        the reliable path)

   The font list appears in the console at startup, and the current
   font is shown in the modifier panel. Press N to cycle.

   Notes:
     - Font file names become the display names. "leadcoat.ttf"
       shows as "leadcoat". Use spaces or hyphens if you want a
       readable label: "Lead Coat.ttf" or "lead-coat.ttf".
     - The first entry is always "Default" (the built-in
       SansSerif font). It cannot be removed.
     - Fonts are referenced by name in timestamps files, not by
       index. If you remove a font that a timestamps file uses,
       the renderer falls back to Default and prints a warning.
     - Licensing: make sure any font you redistribute is licensed
       for it. Google Fonts (fonts.google.com) are almost all
       SIL Open Font License, which permits bundling and
       redistribution.


================================================================
  TROUBLESHOOTING
================================================================

  "lyrics.txt missing"
  -> Create data/lyrics.txt in the sketch folder. See the
     LYRICS FORMAT section above.

  "Nothing to render"
  -> You pressed M without a take in memory and no timestamps
     file exists. Press ENTER to record first, then M.

  Rendering produces a blank or black file
  -> Your editor may not be decoding the alpha channel. Try
     importing into a different app (QuickTime, VLC, Resolve)
     to confirm the file itself is correct.

  MIDI doesn't reach the sketch
  -> On Linux, the aconnect route must exist BEFORE Processing
     launches. See the header comment inside the sketch.

  Visuals look different from what I recorded
  -> Bundles, home state, and CC defaults can be overwritten by
     a DAW on stop. Press P to re-capture the home state.


================================================================
  ABOUT
================================================================

Author: Eli Page (E9)
License: MIT (see LICENSE.txt)

Built in Processing. Uses FFmpeg for encoding.