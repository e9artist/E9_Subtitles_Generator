/*
 =====================================================================================================
 APPLICATION: Subtitles Video Generator
 VERSION:     1.0
 DATE:        2026-09-16
 AUTHOR:      Eli Page (E9)
 =====================================================================================================
 
 DESCRIPTION:
 Generate a subtitles animation overlay (transparent background) from a lyrics.txt file. The lyrics.txt
 file (case-sensitive) must be placed in a /data/ folder inside the sketch folder. For more fonts than
 the default, include a /fonts/ folder inside the /data/ folder and load your fonts. They are scanned 
 and ordered alphabetically at the beginning of each sketch session. A MIDI file of a take can be 
 exported, brought into a DAW, manipulated (MIDI note values, cc values, pc values), and used to 
 control/record takes. (Note: Every exported MIDI file contains MIDI notes 34 and 35 which automate the
 starting and stopping of recording a take. These do not save the timestamps or begin a render, just 
 start and stop recording of a take. Useful after making tweaks and wanting to automate a new take 
 recording. Be sure NOT to loop as MIDI note 34 will immediately delete the just-finished take and start
 recording a new one.) Be sure to set up virtual midi as described below (either macOS or 
 Linux) or the sketch won't respond to your DAW.
 
 The lyrics.txt file is scanned line-by-line at the start of the sketch session. All whitespace is 
 removed/discarded (see below for keyword to insert empty lines in stanzas). For the SimpleLine 
 style animation, each line is displayed normally. If a blank screen is desired, the [blank] keyword can 
 be inserted on a line by itself and pressing spacebar or MIDI note 38 will advance to that blank screen 
 as if it were a line. One can always blank the screen immediately by pressing B or MIDI note 36.
 
 The lyrics.txt file now supports multi-line paragraphs, referred to here as stanzas. To begin a stanza,
 place the keyword [stanza] on a line by itself. After that, write as many lines as you want and 
 mark the end with the keyword [endstanza] on a line by itself. Insert an empty line (within stanzas only) 
 with the keyword [emptyline] on a line by itself (note: the [blank] keyword does nothing inside of 
 stanzas). See the included lyrics.txt file for examples of these. Note that if in SimpleLine animation
 style, spacebar and MIDI note 38 advance to the next line/stanza. If in Highlight, Karaoke, or WordReveal
 styles, spacebar and MIDI note 38 advance through the words one by one in that stanza until the last word
 and then advances to the next line/stanza.
 
 There is now a new class of animation, the WordReveal animation, that can be accessed by hitting 4 on the 
 keyboard or MIDI note 51. The animation reveals one word at a time, similarly to the Karaoke style, but 
 with the later words hidden completely before being revealed. There is also a new modifier type, the Word
 Fade time. For Highlight, Karaoke, and WordReveal animations, this new modifier changes the rate at which
 their states change. Box, Outline, and Bold style Highlights now fade into view as do Karoake highlights
 and WordReveal words. Grow style Highlights now slowly grow into size instead of snapping. Press U on the 
 keyboard to cycle through some preset times (0.0 essentially turns this off so all states change instantly
 when spacebar or MIDI note 38 are triggered). Note that this Word Fade is different than the Transition Fade
 which fades in an entire line/stanza (and can be combined with Word Fade if desired).
 
 NOTES:
 This app needs FFmpeg installed and discoverable. On Linux, the render defaults to PNG-in-MOV. On macOS, 
 it defaults to ProRes 4444. These were chosen for their availability, speed of rendering, and alpha 
 channel support. Unique frames of PNGs are stored in the frames folder. playlist.txt contains a list of 
 audio files that have been used in sessions so as to save settings between them (this functionality has 
 seen limited testing on my end). All output files get saved to this sketch's folder. Remember when starting 
 a new song to change the lyrics.txt file and swap out any fonts you might want. It might be easiest to copy
 this entire sketch folder to a new Project folder (perhaps where your original video lives). See 
 Processing's console for debugging information.
 
 See MIDI_REFERENCE.txt for full list of keyboard shortcuts and MIDI shortcuts.
 
 =====================================================================================================
 MACOS MIDI SETUP
 =====================================================================================================
 
 macOS has a built-in virtual MIDI system called the IAC Driver.
 
 ONE-TIME SETUP
 --------------
 1. Open "Audio MIDI Setup" (Spotlight search it, or find it in
 Applications/Utilities).
 
 2. From the menu bar: Window > Show MIDI Studio.
 
 3. Double-click the "IAC Driver" icon.
 If you don't see it, switch the configuration dropdown at the
 top away from "Default" and back, or click the "+" button to
 create a new configuration. The IAC Driver should appear.
 
 4. Check "Device is online" at the top of the IAC Driver window.
 
 5. Under "Ports", make sure at least one bus exists. The default
 is usually named "IAC Driver Bus 1". Add one with the "+" button
 if the list is empty. Click Apply.
 
 EVERY SESSION
 -------------
 1. In the DAW (Reaper, Logic, etc.): set the track's MIDI output
 (or MIDI Hardware Output) to "IAC Driver Bus 1".
 
 2. Launch the Processing sketch. The auto-pick logic in
 setupMidi() already prefers ports whose name contains "IAC",
 so it should connect automatically.
 
 3. The console should print:
 MIDI input connected: IAC Driver Bus 1
 
 TROUBLESHOOTING
 ---------------
 - If the IAC Driver icon is missing entirely, quit Audio MIDI
 Setup and try the configuration dropdown trick above. As a last
 resort, run `sudo killall coreaudiod` in Terminal and reopen
 Audio MIDI Setup.
 
 - If the sketch connects but doesn't react to MIDI, confirm the
 DAW's output is actually routed to the same IAC bus name the
 sketch connected to.
 
 - Unlike Linux, no restart ordering is required. The IAC Driver
 is available to all apps at once.
 ====================================================================================================
 
 ====================================================================================================
 LINUX MIDI SETUP — run these commands after every reboot
 ====================================================================================================
 
 The reason this is needed: javax.sound.midi on Linux uses ALSA RawMIDI,
 but aconnect and Reaper use ALSA Sequencer. These are two different
 subsystems. snd-virmidi bridges them.
 
 1. Load the virtual RawMIDI module (creates a device Java can read from):
 
 sudo modprobe snd-virmidi midi_devs=1
 
 2. List ALSA ports to find the VirMIDI client number:
 
 aconnect -l
 
 Look for a line like:
 
 client 28: 'Virtual Raw MIDI 1-0' [type=kernel,card=1]
 0 'VirMIDI 1-0     '
 
 The client number (28 in this example) may change between reboots.
 
 3. Route Reaper's virtual MIDI output into VirMIDI:
 
 aconnect 129:0 <virmidi_client>:0
 
 Replace 129:0 with Reaper's actual client:port (also may change).
 Replace <virmidi_client> with the number from step 2.
 
 4. Verify the connection:
 
 aconnect -l
 
 Under the VirMIDI client you should see:
 
 Connected From: 129:0
 
 5. IMPORTANT — set up the routing BEFORE launching Processing.
 
 Java's javax.sound.midi opens a RawMIDI file descriptor when the sketch
 starts. If the ALSA route is created after Processing has already opened
 the device, Java will not see incoming MIDI, even though aconnect reports
 the route as active. The symptom is that the sketch prints
 
 MIDI input connected: VirMIDI [hw:X,0,0]
 
 on startup but never reacts to any notes.
 
 Correct order every time:
 
 a. Run the modprobe command (if not already loaded)
 b. Run aconnect to create the route
 c. Verify with aconnect -l
 d. THEN launch Processing
 
 If you forget and launch Processing first, just:
 
 a. Quit Processing
 b. Re-run aconnect (the route may have been dropped when Processing
 released the device)
 c. Relaunch Processing
 
 6. Launch the Processing sketch. The console should print:
 
 MIDI input connected: <device name containing "VirMIDI">
 
 If it prints that but the sketch does not respond to MIDI, see step 5.
 The order matters.
 
 NOTES:
 - Connections are not persistent. Repeat the modprobe and aconnect steps
 after any reboot, Reaper restart, or if the Processing sketch loses its
 MIDI input.
 - Order matters: ALWAYS create the aconnect route before launching
 Processing. Java opens the RawMIDI device at startup and will not see
 routes that are created afterward. If in doubt, quit Processing, re-run
 aconnect, then relaunch.
 - If the sketch stops responding mid-session, the route may have been
 dropped. Re-run aconnect and restart Processing.
 - On macOS, none of this is needed. macOS uses CoreMIDI, which is unified.
 Just enable the IAC Driver in Audio MIDI Setup and the sketch's auto-pick
 will find "IAC".
 
 ====================================================================================================
 */
import processing.sound.*;
import java.io.File;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.sound.midi.*;

// =========================================================
// CONFIG
// =========================================================
float TAIL_SECONDS = 3.0;
int OUTPUT_FPS = 30;

// =========================================================
// MODIFIER CONSTANTS
// =========================================================
final int TRANS_NONE  = 0;
final int TRANS_FADE  = 1;
final int TRANS_GROW  = 2;
final int TRANS_COUNT = 3;

final int HILITE_BOX     = 0;
final int HILITE_OUTLINE = 1;
final int HILITE_BOLD    = 2;
final int HILITE_GROW    = 3;
final int HILITE_COUNT   = 4;

final int PRESET_SIMPLE     = 0;
final int PRESET_HIGHLIGHT  = 1;
final int PRESET_KARAOKE    = 2;
final int PRESET_REVEAL     = 3;
final int NUM_PRESETS       = 4;

float[] TRANS_DURATIONS = { 0.3, 0.6, 1.0 };

String transitionName(int t) {
  if (t == TRANS_NONE) return "none";
  if (t == TRANS_FADE) return "fade";
  if (t == TRANS_GROW) return "grow";
  return "?";
}

String hiliteName(int h) {
  if (h == HILITE_BOX)     return "box";
  if (h == HILITE_OUTLINE) return "outline";
  if (h == HILITE_BOLD)    return "bold";
  if (h == HILITE_GROW)    return "grow";
  return "?";
}

// =========================================================
// MODE
// =========================================================
String mode = "record";

// =========================================================
// SHARED DATA
// =========================================================
String[] lyrics;
Stanza[] stanzas;
ArrayList<PlaylistEntry> playlist = new ArrayList<PlaylistEntry>();

class PlaylistEntry {
  String path;
  float bpm;
  int beats;
  PlaylistEntry(String p, float b, int c) {
    path = p;
    bpm = b;
    beats = c;
  }
}

String presetLabel(int idx) {
  if (idx == PRESET_SIMPLE)    return "SimpleLine";
  if (idx == PRESET_HIGHLIGHT) return "WordHighlight";
  if (idx == PRESET_KARAOKE)   return "KaraokeFill";
  if (idx == PRESET_REVEAL)    return "WordReveal";
  return "Unknown";
}

String[] parsePreset(String label) {
  if (label.startsWith("SimpleLine"))    return new String[] { "SimpleLine", "0" };
  if (label.startsWith("WordHighlight")) return new String[] { "WordHighlight", "0" };
  if (label.startsWith("KaraokeFill"))   return new String[] { "KaraokeFill", "0" };
  if (label.startsWith("WordReveal"))    return new String[] { "WordReveal", "0" };
  return new String[] { "SimpleLine", "0" };
}

class Event {
  int time;
  String preset;
  String action;
  String fontName = "Default";
  int line;
  int word;
  int transition = TRANS_NONE;
  float transDur = 1.0;
  float wordFade = 0.0;
  int hiliteStyle = HILITE_BOX;
  int colorCC = 0;       // 0-127
  int size = 24;       // 0-127
  int posX = 64;       // 0-127
  int posY = 64;       // 0-127

  Event(int t, String p, String a, int l, int w) {
    time = t;
    preset = p;
    action = a;
    line = l;
    word = w;
  }
}

class Stanza {
  int startLine;   // inclusive index into lyrics[]
  int endLine;     // inclusive index into lyrics[]
  Stanza(int s, int e) {
    startLine = s;
    endLine = e;
  }
}

class Bundle {
  String name;
  int preset;
  int transition;
  int transDurIdx;
  int hilite;
  int colorCC;
  int size;
  int fontIdx;
  int posX;
  int posY;
  float wordFade = 0.0;

  Bundle(String n, int p, int t, int td, int h, int c, int s, int f, int px, int py, float wf) {
    name = n;
    preset = p;
    transition = t;
    transDurIdx = td;
    hilite = h;
    colorCC = c;
    size = s;
    fontIdx = f;
    posX = px;
    posY = py;
    wordFade = wf;
  }
}

Bundle[] bundles;

/*void initBundles() {
 bundles = new Bundle[4];
 bundles[0] = new Bundle("Basic", 0, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 64);
 bundles[1] = new Bundle("WordDefault", 1, TRANS_NONE, 2, HILITE_BOX, 32, 24, 0, 64, 64);
 bundles[2] = new Bundle("KaraokeDefault", 2, TRANS_NONE, 2, HILITE_BOX, 64, 24, 0, 64, 64);
 bundles[3] = new Bundle("Dramatic", 1, TRANS_FADE, 2, HILITE_OUTLINE, 96, 64, 0, 64, 64);
 }*/
void initBundles() {
  // Bundle(name, preset, transition, transDurIdx, hilite, colorCC, size, fontIdx, posX, posY)
  //   name         : display label
  //   preset       : 0=SimpleLine, 1=WordHighlight, 2=KaraokeFill
  //   transition   : 0=none, 1=fade, 2=grow
  //   transDurIdx  : 0=0.3s, 1=0.6s, 2=1.0s
  //   hilite       : 0=box, 1=outline, 2=bold, 3=grow
  //   colorCC      : 0-127 (0=yellow, 32=red, 64=green, 96=blue)
  //   size         : 0-127 (maps to 12-200px)
  //   fontIdx      : index into fontNames[] (0 = Default)
  //   posX, posY   : 0-127 (0=edge, 64=center, 127=opposite edge)

  bundles = new Bundle[17];
  // --- Basic line presets ---
  bundles[0]  = new Bundle("Line Center", 0, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 64, 0.0);
  bundles[1]  = new Bundle("Subtitle Bottom", 0, TRANS_FADE, 1, HILITE_BOX, 0, 24, 0, 64, 90, 0.0);
  bundles[2]  = new Bundle("Title Top", 0, TRANS_FADE, 2, HILITE_BOX, 0, 35, 0, 64, 15, 0.0);
  // --- Word highlight presets ---
  bundles[3]  = new Bundle("Highlight Center Y", 1, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 64, 0.0);
  bundles[4]  = new Bundle("Highlight Bottom Y", 1, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 90, 0.0);
  bundles[5]  = new Bundle("Highlight Red", 1, TRANS_NONE, 2, HILITE_BOX, 32, 24, 0, 64, 64, 0.0);
  bundles[6]  = new Bundle("Highlight Green", 1, TRANS_NONE, 2, HILITE_BOX, 64, 24, 0, 64, 64, 0.0);
  bundles[7]  = new Bundle("Highlight Blue", 1, TRANS_NONE, 2, HILITE_BOX, 96, 24, 0, 64, 64, 0.0);
  bundles[8]  = new Bundle("Highlight Outline", 1, TRANS_FADE, 1, HILITE_OUTLINE, 0, 35, 0, 64, 64, 0.3);
  bundles[9]  = new Bundle("Highlight Bold", 1, TRANS_NONE, 2, HILITE_BOLD, 0, 24, 0, 64, 64, 0.0);
  bundles[10] = new Bundle("Highlight Grow", 1, TRANS_NONE, 2, HILITE_GROW, 0, 24, 0, 64, 64, 0.0);
  // --- Karaoke presets ---
  bundles[11] = new Bundle("Karaoke Center Y", 2, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 64, 0.3);
  bundles[12] = new Bundle("Karaoke Bottom Y", 2, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 90, 0.3);
  bundles[13] = new Bundle("Karaoke Red", 2, TRANS_NONE, 2, HILITE_BOX, 32, 24, 0, 64, 64, 0.3);
  bundles[14] = new Bundle("Karaoke Green", 2, TRANS_NONE, 2, HILITE_BOX, 64, 24, 0, 64, 64, 0.3);
  bundles[15] = new Bundle("Karaoke Blue", 2, TRANS_NONE, 2, HILITE_BOX, 96, 24, 0, 64, 64, 0.3);
  // --- Wordreveal presets ---
  bundles[16]  = new Bundle("WordReveal Center", 3, TRANS_NONE, 2, HILITE_BOX, 0, 24, 0, 64, 64, 0.3);
}

MidiDevice midiDevice = null;
Transmitter midiTransmitter = null;
MyMidiReceiver midiReceiver = null;
boolean transportPlaying = false;
int ignoreCCUntilMs = 0;
// =========================================================
// RECORD MODE STATE
// =========================================================
int currentLine = 0;
int currentWord = 0;
SoundFile song;
String audioPath = "";
int activePreset = 0;
int pendingPreset = 0;
ArrayList<Event> events = new ArrayList<Event>();
String recordState = "idle";
int countInBeats = 4;
float bpm = 120;
int countInStartMs = 0;
int audioStartMs = 0;
boolean showHelp = true;
boolean blanked = false;
boolean pendingFreshStart = false;
boolean showReference = false;

int currentEventStartMs = 0;
Event currentDisplayedEvent = null;

PFont[] fonts;
PFont uiFont;
String[] fontNames;
String[] fontPaths;
int FONT_COUNT = 0;
int homePreset      = 0;
int homeTransition  = TRANS_NONE;
int homeTransDurIdx = 2;
int homeHilite      = HILITE_BOX;
int homeColor       = 0;
int homeSize        = 24;
int homeFontIdx     = 0;
int homePosX        = 64;
int homePosY        = 64;
float homeWordFade = 0.0;
float LINE_HEIGHT_MODIFIER = 1.4;
// =========================================================
// MODIFIER STATE (all 0-127 for MIDI compatibility)
// =========================================================
// Discrete-cycle indices (still small ranges; keyboard cycles them)
int pendingTransition = TRANS_NONE;   // 0-2
int pendingTransDurIdx = 2;           // 0-2
int pendingHilite = HILITE_BOX;       // 0-3
int pendingFontIdx = 0;

// Continuous values (0-127; CC sets directly, keyboard cycles presets)
int pendingColor = 0;     // 0-127
int pendingSize = 24;     // 0-127
int pendingPosX = 64;     // 0-127, 64 = center
int pendingPosY = 64;     // 0-127, 64 = center
float pendingWordFade = 0.0;   // 0 = instant; positive = fade duration in seconds

// Keyboard cycle presets for continuous values
int[] COLOR_CYCLE = { 0, 32, 64, 96 };     // yellow, red, green, blue equivalents
int[] SIZE_CYCLE  = { 13, 24, 35 };
float[] WORD_FADE_CYCLE = { 0.0, 0.2, 0.5, 1.0 };
// =========================================================
// RENDER MODE STATE
// =========================================================
ArrayList<Event> renderEvents = new ArrayList<Event>();
int currentEventIdx = 0;
boolean rendering = false;
String framesDir;
String listPath;
String renderOutputPath;
ArrayList<Float> durations = new ArrayList<Float>();
String ffmpegPath = "ffmpeg";
boolean isMac = false;
String videoCodec = "png";
String pixelFormat = "rgba";
String[] extraCodecArgs = {};
int pngCounter = 0;

// =========================================================
// SETUP
// =========================================================
void setup() {
  size(1280, 720);
  textAlign(CENTER, CENTER);
  ffmpegPath = findFFmpeg();

  lyrics = loadStrings("lyrics.txt");
  if (lyrics == null) {
    println("ERROR: lyrics.txt missing");
    exit();
  }
  lyrics = stripEmptyLines(lyrics);
  println("Loaded " + lyrics.length + " lyric lines.");

  parseStanzas();

  println("Parsed " + stanzas.length + " stanzas:");
  for (int i = 0; i < stanzas.length; i++) {
    Stanza st = stanzas[i];
    String preview = lyrics[st.startLine];
    if (preview.length() > 40) preview = preview.substring(0, 40) + "...";
    println("  [" + i + "] lines " + st.startLine + "-" + st.endLine
      + " (" + (st.endLine - st.startLine + 1) + " lines) : " + preview);
  }

  // Build the font list: "Default" + every .ttf/.otf in data/fonts/
  ArrayList<String> names = new ArrayList<String>();
  ArrayList<String> paths = new ArrayList<String>();

  names.add("Default");
  paths.add("");

  File fontDir = new File(sketchPath("data/fonts"));
  if (fontDir.exists() && fontDir.isDirectory()) {
    File[] files = fontDir.listFiles();
    if (files != null) {
      // Collect and sort so ordering is stable
      ArrayList<File> fontFiles = new ArrayList<File>();
      for (File f : files) {
        String n = f.getName().toLowerCase();
        if (n.endsWith(".ttf") || n.endsWith(".otf")) {
          fontFiles.add(f);
        }
      }
      java.util.Collections.sort(fontFiles, new java.util.Comparator<File>() {
        public int compare(File a, File b) {
          return a.getName().compareToIgnoreCase(b.getName());
        }
      }
      );

      for (File f : fontFiles) {
        String displayName = f.getName();
        int dot = displayName.lastIndexOf('.');
        if (dot > 0) displayName = displayName.substring(0, dot);
        names.add(displayName);
        paths.add("fonts/" + f.getName());
      }
    }
  }

  FONT_COUNT = names.size();
  fontNames = names.toArray(new String[0]);

  // Index 0 is the built-in default, always available
  fonts = new PFont[FONT_COUNT];
  fonts[0] = createFont("SansSerif.plain", 48);
  uiFont = fonts[0];

  println("Found " + FONT_COUNT + " font entries:");
  for (int i = 0; i < FONT_COUNT; i++) {
    println("  [" + i + "] " + fontNames[i]);
  }

  // Save paths for lazy loading
  fontPaths = paths.toArray(new String[0]);
  currentLine = firstContentLine();
  currentWord = 0;
  activePreset = pendingPreset;
  // Initialize the preview with the first line so something is visible
  // in idle/stopped state before any recording begins.
  if (lyrics.length > 0) {
    Event init = new Event(0, presetLabel(pendingPreset), "initial", currentLine, 0);
    init.transition   = pendingTransition;
    init.transDur     = TRANS_DURATIONS[pendingTransDurIdx];
    init.hiliteStyle  = pendingHilite;
    init.colorCC        = pendingColor;
    init.size         = pendingSize;
    init.fontName     = fontNames[pendingFontIdx];
    init.posX         = pendingPosX;
    init.posY         = pendingPosY;
    init.wordFade     = pendingWordFade;
    currentDisplayedEvent = init;
    currentEventStartMs = millis();
  }

  loadPlaylist();
  initBundles();
  isMac = System.getProperty("os.name").toLowerCase().contains("mac");
  if (isMac) {
    videoCodec = "prores_ks";
    pixelFormat = "yuva444p10le";
    extraCodecArgs = new String[] { "-profile:v", "4" };
    println("Mac detected: using ProRes 4444.");
  } else {
    videoCodec = "png";
    pixelFormat = "rgba";
    extraCodecArgs = new String[] {};
    println("Non-Mac: using PNG-in-MOV.");
  }
  captureHomeState();
  setupMidi();
}

String findFFmpeg() {
  String[] candidates = { "/opt/homebrew/bin/ffmpeg", "/usr/local/bin/ffmpeg", "ffmpeg" };
  for (String c : candidates) {
    if (c.equals("ffmpeg")) return c;
    File f = new File(c);
    if (f.exists() && f.canExecute()) {
      println("Using FFmpeg at: " + c);
      return c;
    }
  }
  return "ffmpeg";
}

PFont getFont(int idx) {
  if (idx < 0 || idx >= FONT_COUNT) idx = 0;
  if (fonts[idx] != null) return fonts[idx];

  String path = fontPaths[idx];
  try {
    PFont f = createFont(path, 48);
    if (f == null) {
      println("Font failed to load: " + path + " — using Default.");
      return fonts[0];
    }
    fonts[idx] = f;
    return f;
  }
  catch (Exception e) {
    println("Font exception for " + path + ": " + e.getMessage());
    return fonts[0];
  }
}

int currentBundleIdx = 0;

void applyBundle(int idx) {
  if (idx < 0 || idx >= bundles.length) return;
  Bundle b = bundles[idx];
  pendingPreset      = b.preset;
  pendingTransition  = b.transition;
  pendingTransDurIdx = b.transDurIdx;
  pendingHilite      = b.hilite;
  pendingColor       = b.colorCC;
  pendingSize        = b.size;
  pendingFontIdx     = b.fontIdx;
  pendingPosX        = b.posX;
  pendingPosY        = b.posY;
  pendingWordFade    = b.wordFade;   // <-- new
  currentBundleIdx   = idx;
  println("Bundle: " + b.name);
}
// =========================================================
// DRAW
// =========================================================
void draw() {
  if (mode.equals("record")) drawRecord();
  else drawRender();
}

// =========================================================
// RECORD MODE
// =========================================================
void drawRecord() {
  background(0);
  updateRecordState();
  drawRecordStatusBar();
  drawModifierPanel();
  if (showHelp) drawRecordHelp();
  if (lyrics.length > 0) renderLyrics();
  if (recordState.equals("countin")) drawCountIn();
  if (showReference) drawReference();
}

void drawRecordStatusBar() {
  fill(40);
  noStroke();
  rect(0, 0, width, 50);

  fill(200);
  textFont(uiFont);
  textSize(14);
  textAlign(LEFT, CENTER);

  String audioLabel = (audioPath.length() > 0)
    ? new File(audioPath).getName()
    : "(freewheeling)";
  String bpmLabel = "BPM: " + nf(bpm, 0, 0) + "  Count-in: " + countInBeats;
  text(bpmLabel + "   |   " + audioLabel, 15, 15);

  String mods = "Preset: " + presetLabel(pendingPreset)
    + "  |  trans: " + transitionName(pendingTransition) + " " + TRANS_DURATIONS[pendingTransDurIdx] + "s"
    + "  |  hilite: " + hiliteName(pendingHilite)
    + "  |  color: " + pendingColor
    + "  |  size: " + sizeFromCC(pendingSize);
  fill(180);
  String lineInfo = "Line " + (currentLine + 1) + "/" + lyrics.length;
  fill(180);
  text(lineInfo, 15, 35);

  drawRecordBadge();
}

void drawRecordBadge() {
  String label;
  color c;
  if (recordState.equals("idle")) {
    label = "IDLE";
    c = color(120);
  } else if (recordState.equals("countin")) {
    label = "COUNT-IN";
    c = color(255, 180, 0);
  } else if (recordState.equals("playing")) {
    label = "● RECORDING";
    c = color(230, 40, 40);
  } else {
    label = "STOPPED";
    c = color(80, 140, 255);
  }

  textFont(uiFont);
  textSize(20);
  textAlign(RIGHT, CENTER);
  float tw = textWidth(label);
  float pad = 14;
  float badgeW = tw + pad * 2;
  float badgeH = 30;
  float badgeX = width - badgeW - 10;
  float badgeY = 10;

  noStroke();
  fill(c, 60);
  rect(badgeX, badgeY, badgeW, badgeH, 6);

  fill(c);
  text(label, width - 10 - pad, 25);
  textAlign(CENTER, CENTER);
}

void drawModifierPanel() {
  String[] values = {
    presetLabel(pendingPreset),
    transitionName(pendingTransition),
    nf(TRANS_DURATIONS[pendingTransDurIdx], 0, 1) + " s",
    hiliteName(pendingHilite),
    "" + pendingColor,
    "" + pendingSize,
    fontNames[pendingFontIdx],
    pendingPosX + ", " + pendingPosY,
    nf(pendingWordFade, 0, 2) + " s"
  };

  String[] labels = {
    "Preset", "Transition", "Duration", "Highlight",
    "Color", "Size", "Font", "Pos (X,Y)",
    "Word Fade"
  };

  int lineHeight = 20;
  int padding = 10;
  int panelW = 220;
  int panelH = labels.length * lineHeight + padding * 2;
  int panelX = 0;
  int panelY = 60;

  fill(0, 0, 0, 200);
  noStroke();
  rect(panelX, panelY, panelW, panelH, 8);

  textFont(uiFont);
  textSize(14);
  textAlign(LEFT, CENTER);

  int labelX = panelX + padding;
  int valueX = panelX + panelW - padding;
  int startY = panelY + padding + lineHeight / 2;

  for (int i = 0; i < labels.length; i++) {
    int rowY = startY + i * lineHeight;

    fill(150);
    textAlign(LEFT, CENTER);
    text(labels[i], labelX, rowY);
    if (i == 4) {
      color c = colorFromCC(pendingColor);
      fill(c);
      textAlign(RIGHT, CENTER);
      text(values[i], valueX, rowY);
    } else {
      fill(255, 220, 80);
      textAlign(RIGHT, CENTER);
      text(values[i], valueX, rowY);
    }
  }

  textAlign(CENTER, CENTER);
}

String colorName(int idx) {
  if (idx == 0) return "Yellow";
  if (idx == 1) return "Red";
  if (idx == 2) return "Green";
  if (idx == 3) return "Blue";
  return "?";
}

void drawCountIn() {
  float beatMs = 60000.0 / bpm;
  float elapsed = millis() - countInStartMs;
  int currentBeat = (int)(elapsed / beatMs) + 1;
  if (currentBeat <= countInBeats) {
    fill(255, 200, 0, 200);
    textFont(uiFont);
    textSize(200);
    text(currentBeat, width/2, height/2 - 100);
  }
}

// =========================================================
// LIVE PREVIEW — animated
// =========================================================
void renderLyrics() {
  if (blanked) return;
  if (currentDisplayedEvent == null) return;

  float elapsedSec = (millis() - currentEventStartMs) / 1000.0;
  float duration = currentDisplayedEvent.transDur;
  float t = 1.0;
  if (currentDisplayedEvent.transition != TRANS_NONE && duration > 0.001) {
    t = constrain(elapsedSec / duration, 0, 1);
  }

  float alpha = 255;
  float scale = 1.0;
  if (currentDisplayedEvent.transition == TRANS_FADE) alpha = 255 * t;
  if (currentDisplayedEvent.transition == TRANS_GROW) scale = t;

  pushMatrix();
  translate(width/2, height/2);
  scale(scale);
  translate(-width/2, -height/2);

  float wordFadeElapsed = elapsedSec;   // already computed above
  float wordFadeT = 1.0;
  if (currentDisplayedEvent.wordFade > 0.001) {
    wordFadeT = constrain(wordFadeElapsed / currentDisplayedEvent.wordFade, 0, 1);
  }

  drawEventContent(currentDisplayedEvent, alpha, wordFadeT, null);

  popMatrix();
}

int indexOfFont(String name) {
  for (int i = 0; i < FONT_COUNT; i++) {
    if (fontNames[i].equals(name)) return i;
  }
  return 0;  // fall back to Default if the font is missing
}
// =========================================================
// EVENT CONTENT RENDERING
// If g is null, draws to the main canvas. Otherwise to a PGraphics.
// =========================================================
void drawEventContent(Event ev, float alphaScale, float wordFadeT, PGraphics g) {
  int lineIdx = ev.line;
  int wordIdx = ev.word;
  if (lineIdx < 0 || lineIdx >= lyrics.length) return;

  boolean usingGraphics = (g != null);
  wordFadeT = constrain(wordFadeT, 0, 1);

  String[] presetParts = parsePreset(ev.preset);
  String presetType = presetParts[0];
  color accent = colorFromCC(ev.colorCC);
  int sz = sizeFromCC(ev.size);

  int fi = indexOfFont(ev.fontName);
  if (usingGraphics) {
    g.textFont(getFont(fi));
    g.textSize(sz);
    g.textAlign(CENTER, CENTER);
  } else {
    textFont(getFont(fi));
    textSize(sz);
    textAlign(CENTER, CENTER);
  }

  // Find the stanza that contains lineIdx
  Stanza st = stanzaForLine(lineIdx);
  if (st == null) return;

  // If the active line is a blank or a marker, just don't draw anything for it.
  if (lyrics[lineIdx].equals("[blank]") || isStructuralMarker(lyrics[lineIdx])) {
    return;
  }

  // Pre-compute per-line display states:
  //   0 = done (before active)
  //   1 = active
  //   2 = not started (after active)
  int lineCount = st.endLine - st.startLine + 1;

  // Find how many content lines are in the stanza (skip [blank] and markers)
  // for vertical positioning.
  float lineHeight = sz * LINE_HEIGHT_MODIFIER;
  float blockHeight = (lineCount - 1) * lineHeight;
  float baseY = map(ev.posY, 0, 127, 0, height) - blockHeight / 2.0;

  float centerX = map(ev.posX, 0, 127, 0, width);

  boolean isKaraoke   = presetType.equals("KaraokeFill");
  boolean isReveal    = presetType.equals("WordReveal");
  boolean isHighlight = presetType.equals("WordHighlight");

  // Draw each line in the stanza
  for (int li = st.startLine; li <= st.endLine; li++) {
    String raw = lyrics[li];
    int slot = li - st.startLine;
    float lineY = baseY + slot * lineHeight;

    // Blank lines render as empty vertical space
    if (isStructuralMarker(raw)) continue;
    if (raw.equals("[blank]")) continue;

    int state; // 0 = done, 1 = active, 2 = not started
    if (li < lineIdx) state = 0;
    else if (li == lineIdx) state = 1;
    else state = 2;

    drawOneLine(raw, state, wordIdx, wordFadeT, alphaScale,
      presetType, ev.hiliteStyle, isHighlight, isKaraoke, isReveal,
      accent, sz, centerX, lineY, usingGraphics, g);
  }
}

// Draw a single line of a stanza. state: 0=done, 1=active, 2=not-started.
void drawOneLine(String lineText, int state, int wordIdx, float wordFadeT,
  float alphaScale, String presetType, int hiliteStyle,
  boolean isHighlight, boolean isKaraoke, boolean isReveal,
  color accent, int sz, float centerX, float lineY,
  boolean usingGraphics, PGraphics g) {

  String[] words = split(lineText, ' ');

  // SimpleLine: no per-word treatment, just draw the whole line
  if (presetType.equals("SimpleLine")) {
    if (usingGraphics) {
      g.noStroke();
      g.fill(255, 255, 255, alphaScale);
      g.textAlign(CENTER, CENTER);
      g.text(lineText, centerX, lineY);
    } else {
      noStroke();
      fill(255, 255, 255, alphaScale);
      textAlign(CENTER, CENTER);
      text(lineText, centerX, lineY);
    }
    return;
  }

  // Compute layout width. Grow only applies to the active word on the active line.
  float totalWidth = 0;
  float spaceWidth = usingGraphics ? g.textWidth(' ') : textWidth(' ');
  for (int i = 0; i < words.length; i++) {
    float w;
    boolean growThisWord = (state == 1 && i == wordIdx && isHighlight && (hiliteStyle == HILITE_GROW));
    if (growThisWord) {
      if (usingGraphics) g.textSize(int(sz * 1.4));
      else textSize(int(sz * 1.4));
      w = usingGraphics ? g.textWidth(words[i]) : textWidth(words[i]);
      if (usingGraphics) g.textSize(sz);
      else textSize(sz);
    } else {
      w = usingGraphics ? g.textWidth(words[i]) : textWidth(words[i]);
    }
    totalWidth += w;
    if (i < words.length - 1) totalWidth += spaceWidth;
  }

  float x = centerX - totalWidth / 2.0;
  float y = lineY;

  for (int i = 0; i < words.length; i++) {
    float w = usingGraphics ? g.textWidth(words[i]) : textWidth(words[i]);

    // Which word is "current" on this line?
    //   - On the active line: wordIdx
    //   - On a done line: the last word (so karaoke/wordreveal show fully completed)
    //   - On a not-started line: -1 (nothing revealed)
    int currentWordOnThisLine = -1;
    if (state == 1) currentWordOnThisLine = wordIdx;
    else if (state == 0) currentWordOnThisLine = words.length - 1;
    else currentWordOnThisLine = -1;

    boolean isActiveWord = (state == 1 && i == wordIdx);

    if (isHighlight) {
      // Only the active word on the active line gets a highlight.
      if (isActiveWord) {
        float hlAlpha = alphaScale * wordFadeT;
        drawHighlight(hiliteStyle, x, y, w, sz, accent, hlAlpha, usingGraphics, g);
      }

      // Draw the word itself
      if (isActiveWord && hiliteStyle == HILITE_GROW) {
        int grownSize = int(lerp(sz, sz * 1.4, wordFadeT));
        if (usingGraphics) {
          g.textSize(grownSize);
          g.noStroke();
          g.fill(255, 255, 255, alphaScale * wordFadeT);
          g.textAlign(LEFT, CENTER);
          g.text(words[i], x, y);
          g.textSize(sz);
        } else {
          textSize(grownSize);
          noStroke();
          fill(255, 255, 255, alphaScale * wordFadeT);
          textAlign(LEFT, CENTER);
          text(words[i], x, y);
          textSize(sz);
        }
      } else if (isActiveWord && hiliteStyle == HILITE_BOLD) {
        if (usingGraphics) {
          g.noStroke();
          g.fill(255, 255, 255, alphaScale * wordFadeT);
          g.textAlign(LEFT, CENTER);
          for (int dx = -1; dx <= 1; dx++)
            for (int dy = -1; dy <= 1; dy++)
              g.text(words[i], x + dx * 0.7, y + dy * 0.7);
        } else {
          noStroke();
          fill(255, 255, 255, alphaScale * wordFadeT);
          textAlign(LEFT, CENTER);
          for (int dx = -1; dx <= 1; dx++)
            for (int dy = -1; dy <= 1; dy++)
              text(words[i], x + dx * 0.7, y + dy * 0.7);
        }
      } else if (isActiveWord && hiliteStyle == HILITE_OUTLINE) {
        strokeText(words[i], x, y, accent, color(255, 255, 255),
          alphaScale * wordFadeT, usingGraphics, g);
      } else {
        if (usingGraphics) {
          g.noStroke();
          g.fill(255, 255, 255, alphaScale);
          g.textAlign(LEFT, CENTER);
          g.text(words[i], x, y);
        } else {
          noStroke();
          fill(255, 255, 255, alphaScale);
          textAlign(LEFT, CENTER);
          text(words[i], x, y);
        }
      }
    } else if (isKaraoke) {
      // Dim base
      if (usingGraphics) {
        g.fill(80, 80, 80, alphaScale);
        g.textAlign(LEFT, CENTER);
        g.text(words[i], x, y);
      } else {
        fill(80, 80, 80, alphaScale);
        textAlign(LEFT, CENTER);
        text(words[i], x, y);
      }
      // Accent overlay for revealed words
      if (i < currentWordOnThisLine) {
        if (usingGraphics) {
          g.fill(red(accent), green(accent), blue(accent), alphaScale);
          g.text(words[i], x, y);
        } else {
          fill(red(accent), green(accent), blue(accent), alphaScale);
          text(words[i], x, y);
        }
      } else if (i == currentWordOnThisLine) {
        // Active word (or last word of done line) fades in
        float fade = (state == 1) ? wordFadeT : 1.0;
        if (usingGraphics) {
          g.fill(red(accent), green(accent), blue(accent), alphaScale * fade);
          g.text(words[i], x, y);
        } else {
          fill(red(accent), green(accent), blue(accent), alphaScale * fade);
          text(words[i], x, y);
        }
      }
      // Words past currentWordOnThisLine stay dim only
    } else if (isReveal) {
      // Only draw revealed words
      if (i < currentWordOnThisLine) {
        if (usingGraphics) {
          g.noStroke();
          g.fill(255, 255, 255, alphaScale);
          g.textAlign(LEFT, CENTER);
          g.text(words[i], x, y);
        } else {
          noStroke();
          fill(255, 255, 255, alphaScale);
          textAlign(LEFT, CENTER);
          text(words[i], x, y);
        }
      } else if (i == currentWordOnThisLine) {
        float fade = (state == 1) ? wordFadeT : 1.0;
        if (usingGraphics) {
          g.noStroke();
          g.fill(255, 255, 255, alphaScale * fade);
          g.textAlign(LEFT, CENTER);
          g.text(words[i], x, y);
        } else {
          noStroke();
          fill(255, 255, 255, alphaScale * fade);
          textAlign(LEFT, CENTER);
          text(words[i], x, y);
        }
      }
      // Words past the reveal threshold are hidden
    }

    // Advance x, accounting for grow on the active word
    float advanceW = w;
    if (isActiveWord && isHighlight && hiliteStyle == HILITE_GROW) {
      if (usingGraphics) g.textSize(int(sz * 1.4));
      else textSize(int(sz * 1.4));
      advanceW = usingGraphics ? g.textWidth(words[i]) : textWidth(words[i]);
      if (usingGraphics) g.textSize(sz);
      else textSize(sz);
    }
    x += advanceW + spaceWidth;
  }
}

void strokeText(String s, float x, float y, color strokeColor, color fillColor, float alphaScale, boolean usingGraphics, PGraphics g) {
  float[] dxs = { -1, 1, 0, 0, -2, 2, 0, 0 };
  float[] dys = {  0, 0, -1, 1, 0, 0, -2, 2 };

  if (usingGraphics) {
    g.textAlign(LEFT, CENTER);
    g.noStroke();

    // Outline layer
    g.fill(red(strokeColor), green(strokeColor), blue(strokeColor), alphaScale);
    for (int k = 0; k < dxs.length; k++) {
      g.text(s, x + dxs[k], y + dys[k]);
    }

    // Fill layer on top
    g.fill(red(fillColor), green(fillColor), blue(fillColor), alphaScale);
    g.text(s, x, y);
  } else {
    textAlign(LEFT, CENTER);
    noStroke();

    // Outline layer
    fill(red(strokeColor), green(strokeColor), blue(strokeColor), alphaScale);
    for (int k = 0; k < dxs.length; k++) {
      text(s, x + dxs[k], y + dys[k]);
    }

    // Fill layer on top
    fill(red(fillColor), green(fillColor), blue(fillColor), alphaScale);
    text(s, x, y);
  }
}

void drawHighlight(int style, float x, float y, float w, int sz, color accent, float alphaScale, boolean usingGraphics, PGraphics g) {
  if (style == HILITE_BOX) {
    float bx = x - 6;
    float by = y - sz * 0.62;
    float bw = w + 12;
    float bh = sz * 1.25;
    if (usingGraphics) {
      g.noStroke();
      g.fill(red(accent), green(accent), blue(accent), 100 * (alphaScale / 255.0));
      g.rect(bx, by, bw, bh, 6);
    } else {
      noStroke();
      fill(red(accent), green(accent), blue(accent), 100 * (alphaScale / 255.0));
      rect(bx, by, bw, bh, 6);
    }
  }
}

// =========================================================
// RECORD HELP
// =========================================================
void drawRecordHelp() {
  String[] lines = {
    "SPACE   advance (commits pending modifiers)",
    "B       blank screen and advance",
    "1-4     preset 1=SimpleLine 2=Highlight 3=Karaoke 4=Reveal",
    "F       transition: none / fade / grow",
    "G       cycle transition duration",
    "J       highlight: box / outline / bold / grow",
    "K       cycle color",
    "L       cycle size",
    "N       font: cycle through fonts folder",
    "O       open audio file",
    "ENTER   start / stop recording",
    "S       save timestamps",
    "X       export timestamps as MIDI file",
    "R       reset preview position",
    "P       set current state as home snapshot",
    "+ / -   BPM up / down",
    "] / [   count-in beats up / down",
    "M       switch to RENDER mode",
    "H       toggle this help",
    "Y       toggle full reference"
  };

  int perColumn = 10;
  int lineHeight = 16;
  int padding = 12;
  int columnWidth = 340;
  int rows = min(perColumn, lines.length);
  int panelHeight = rows * lineHeight + padding * 2;
  int panelWidth = columnWidth * 2;

  fill(0, 0, 0, 200);
  noStroke();
  rect(0, height - panelHeight, panelWidth, panelHeight);

  fill(200);
  textFont(uiFont);
  textSize(10);
  textAlign(LEFT, CENTER);

  for (int i = 0; i < lines.length; i++) {
    int col = i / perColumn;
    int row = i % perColumn;
    float x = 15 + col * columnWidth;
    float y = height - panelHeight + padding + lineHeight / 2 + row * lineHeight;
    text(lines[i], x, y);
  }

  textAlign(CENTER, CENTER);
}

void updateRecordState() {
  if (recordState.equals("countin")) {
    float beatMs = 60000.0 / bpm;
    float elapsed = millis() - countInStartMs;
    int beatsDone = (int)(elapsed / beatMs);
    if (beatsDone >= countInBeats) {
      recordState = "playing";
      audioStartMs = millis();
      if (song != null) {
        song.play();
        println("Audio started at t=0");
      } else {
        println("Freewheeling timeline started.");
      }
    }
  } else if (recordState.equals("playing")) {
    if (song != null && !song.isPlaying()) {
      recordState = "stopped";
      println("Playback finished. Press S to save.");
    }
  }
}

// =========================================================
// RENDER MODE
// =========================================================
void drawRender() {
  if (!rendering) {
    background(0);
    fill(255);
    textFont(uiFont);
    textSize(50);
    text("RENDER MODE", width/2, 100);
    textSize(20);
    fill(180);
    text("Press R to render the current timestamps file.", width/2, 140);
    text("Press M to return to Record mode.", width/2, 165);
    if (renderEvents.size() > 0) {
      fill(255, 220, 80);
      text("Timestamps loaded: " + renderEvents.size() + " events", width/2, 210);
    }
    return;
  }

  if (currentEventIdx < renderEvents.size()) {
    renderEventFrames(currentEventIdx);
    currentEventIdx++;
    background(0);
    fill(255);
    textFont(uiFont);
    textSize(40);
    text("Rendering event " + currentEventIdx + " / " + renderEvents.size(), width/2, height/2);
  } else {
    rendering = false;
    writeConcatList();
    runConcatFFmpeg();
    currentEventIdx = 0;
    durations.clear();
  }
}

void renderEventFrames(int idx) {
  Event e = renderEvents.get(idx);

  float gapSeconds;
  if (idx < renderEvents.size() - 1) {
    gapSeconds = (renderEvents.get(idx + 1).time - e.time) / 1000.0;
  } else {
    gapSeconds = TAIL_SECONDS;
  }
  if (gapSeconds <= 0) gapSeconds = 0.04;

  // Blank events: just one transparent hold frame
  if (e.action.equals("blank")) {
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
    savePNG(pg);
    durations.add(gapSeconds);
    return;
  }

  // --- Transition frames ---
  int transFrames = 0;
  if (e.transition != TRANS_NONE && e.transDur > 0.001) {
    transFrames = max(1, int(e.transDur * OUTPUT_FPS));
    int maxTransFrames = max(1, int(gapSeconds * OUTPUT_FPS) - 1);
    transFrames = min(transFrames, maxTransFrames);
  }

  for (int f = 0; f < transFrames; f++) {
    float t = (transFrames <= 1) ? 1.0 : (float)f / (transFrames - 1);
    float alpha = 255;
    float scale = 1.0;
    if (e.transition == TRANS_FADE) alpha = 255 * t;
    if (e.transition == TRANS_GROW) scale = t;

    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.clear();
    pg.textAlign(CENTER, CENTER);
    if (scale < 1.0) {
      pg.pushMatrix();
      pg.translate(width/2, height/2);
      pg.scale(scale);
      pg.translate(-width/2, -height/2);
    }
    // During the transition, the word fade is not yet active
    drawEventContent(e, alpha, 1.0, pg);
    if (scale < 1.0) pg.popMatrix();
    pg.endDraw();
    savePNG(pg);
    durations.add(1.0 / OUTPUT_FPS);
  }

  // --- Word fade frames ---
  // Only for word-based presets; SimpleLine doesn't need them.
  int wordFadeFrames = 0;
  boolean wordBased = !e.preset.startsWith("SimpleLine");
  if (wordBased && e.wordFade > 0.001) {
    wordFadeFrames = max(1, int(e.wordFade * OUTPUT_FPS));

    // Clamp so we don't overlap with what's left of the gap
    float remaining = gapSeconds - (transFrames * (1.0 / OUTPUT_FPS));
    int maxWordFrames = max(1, int(remaining * OUTPUT_FPS) - 1);
    wordFadeFrames = min(wordFadeFrames, maxWordFrames);
  }

  for (int f = 0; f < wordFadeFrames; f++) {
    float wordFadeT = (wordFadeFrames <= 1) ? 1.0 : (float)f / (wordFadeFrames - 1);
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.clear();
    pg.textAlign(CENTER, CENTER);
    drawEventContent(e, 255, wordFadeT, pg);
    pg.endDraw();
    savePNG(pg);
    durations.add(1.0 / OUTPUT_FPS);
  }

  // --- Hold frame at full state ---
  float consumed = (transFrames + wordFadeFrames) * (1.0 / OUTPUT_FPS);
  float holdSeconds = gapSeconds - consumed;
  if (holdSeconds < 0) holdSeconds = 0;

  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.clear();
  pg.textAlign(CENTER, CENTER);
  drawEventContent(e, 255, 1.0, pg);
  pg.endDraw();
  savePNG(pg);
  durations.add(max(holdSeconds, 0.04));
}

void savePNG(PGraphics pg) {
  String fname = String.format("frame_%06d.png", pngCounter);
  pg.save(framesDir + "/" + fname);
  pngCounter++;
}

void writeConcatList() {
  try {
    PrintWriter w = new PrintWriter(listPath, "UTF-8");
    for (int i = 0; i < durations.size(); i++) {
      w.print("file 'frames/frame_" + String.format("%06d", i) + ".png'\n");
      w.print("duration " + durations.get(i) + "\n");
    }
    w.print("file 'frames/frame_" + String.format("%06d", durations.size() - 1) + ".png'\n");
    w.close();
    println("Wrote " + listPath + " (" + durations.size() + " frames)");
  }
  catch (Exception ex) {
    println("Failed to write list.txt: " + ex.getMessage());
  }
}

void runConcatFFmpeg() {
  ArrayList<String> cmdList = new ArrayList<String>();
  cmdList.add(ffmpegPath);
  cmdList.add("-y");
  cmdList.add("-f");
  cmdList.add("concat");
  cmdList.add("-safe");
  cmdList.add("0");
  cmdList.add("-i");
  cmdList.add(listPath);
  cmdList.add("-r");
  cmdList.add(str(OUTPUT_FPS));
  cmdList.add("-c:v");
  cmdList.add(videoCodec);
  cmdList.add("-pix_fmt");
  cmdList.add(pixelFormat);
  for (String a : extraCodecArgs) cmdList.add(a);
  cmdList.add(renderOutputPath);

  String[] cmd = cmdList.toArray(new String[0]);
  println("FFmpeg command: " + join(cmd, " "));

  try {
    ProcessBuilder pb = new ProcessBuilder(cmd);
    pb.directory(new File(sketchPath("")));
    pb.redirectErrorStream(true);
    Process proc = pb.start();

    BufferedReader reader = new BufferedReader(new InputStreamReader(proc.getInputStream()));
    String line;
    while ((line = reader.readLine()) != null) println("[ffmpeg] " + line);
    int exitCode = proc.waitFor();
    println("FFmpeg exited with code: " + exitCode);
  }
  catch (Exception ex) {
    println("FFmpeg failed: " + ex.getMessage());
  }
}

// =========================================================
// INPUT
// =========================================================
void keyPressed() {
  if (mode.equals("record")) keyPressedRecord();
  else keyPressedRender();
}

void keyPressedRecord() {
  if (key == 'b' || key == 'B') {
    if (recordState.equals("playing") || recordState.equals("countin")) blankAndAdvance(true);
    else blankAndAdvance(false);
    return;
  }
  if (key == 'h' || key == 'H') {
    showHelp = !showHelp;
    return;
  }

  if (key == 'f' || key == 'F') {
    pendingTransition = (pendingTransition + 1) % TRANS_COUNT;
    println("Transition: " + transitionName(pendingTransition));
    return;
  }
  if (key == 'g' || key == 'G') {
    pendingTransDurIdx = (pendingTransDurIdx + 1) % TRANS_DURATIONS.length;
    println("Trans dur: " + TRANS_DURATIONS[pendingTransDurIdx]);
    return;
  }
  if (key == 'j' || key == 'J') {
    pendingHilite = (pendingHilite + 1) % HILITE_COUNT;
    println("Hilite: " + hiliteName(pendingHilite));
    return;
  }
  if (key == 'k' || key == 'K') {
    pendingColor = nextInCycle(pendingColor, COLOR_CYCLE);
    println("Color: " + pendingColor);
    return;
  }
  if (key == 'l' || key == 'L') {
    pendingSize = nextInCycle(pendingSize, SIZE_CYCLE);
    println("Size: " + pendingSize);
    return;
  }

  if (key >= '1' && key <= '4') {
    int chosen = key - '1';
    if (chosen < NUM_PRESETS) {
      pendingPreset = chosen;
      println("Preset: " + presetLabel(pendingPreset));
    }
    return;
  }

  if (key == 'm' || key == 'M') {
    if (recordState.equals("idle") || recordState.equals("stopped")) {
      if (events.size() > 0) {
        // Take in memory — save it, then render
        saveTimestamps();
        startRenderFromRecord();
        mode = "render";
        println("Switched to RENDER mode.");
      } else {
        // No take in memory — try to render the timestamps file from disk
        startRenderFromRecord();
        if (rendering) {
          mode = "render";
          println("Switched to RENDER mode (rendering from disk).");
        } else {
          println("Nothing to render — no take in memory and no timestamps file found.");
        }
      }
    }
    return;
  }

  if (key == 'n' || key == 'N') {
    pendingFontIdx = (pendingFontIdx + 1) % FONT_COUNT;
    println("Font: " + fontNames[pendingFontIdx]);
    return;
  }

  if (key == 'o' || key == 'O') {
    selectInput("Choose audio file:", "audioSelected");
    return;
  }

  if (key == 'p' || key == 'P') {
    captureHomeState();
    return;
  }

  if (key == 's' || key == 'S') {
    saveTimestamps();
    return;
  }

  if (key == 'r' || key == 'R') {
    if (recordState.equals("idle") || recordState.equals("stopped")) {
      resetToStart();
    }
    return;
  }

  if (key == 'u' || key == 'U') {
    pendingWordFade = nextFloatInCycle(pendingWordFade, WORD_FADE_CYCLE);
    println("Word fade: " + nf(pendingWordFade, 0, 2) + "s");
    return;
  }

  if (key == 'x' || key == 'X') {
    exportMidi();
    return;
  }

  if (key == 'y' || key == 'Y') {
    showReference = !showReference;
    return;
  }

  if (key == '+' || key == '=') {
    bpm = min(bpm + 1, 300);
    updatePlaylistEntry();
    return;
  }
  if (key == '-' || key == '_') {
    bpm = max(bpm - 1, 20);
    updatePlaylistEntry();
    return;
  }
  if (key == ']' || key == '}') {
    countInBeats = min(countInBeats + 1, 16);
    updatePlaylistEntry();
    return;
  }
  if (key == '[' || key == '{') {
    countInBeats = max(countInBeats - 1, 0);
    updatePlaylistEntry();
    return;
  }

  if (key == ENTER || key == RETURN) {
    if (recordState.equals("idle") || recordState.equals("stopped")) startCountIn();
    else stopRecording();
    return;
  }

  if (key == ' ') {
    if (recordState.equals("playing") || recordState.equals("countin")) tapAdvance(true);
    else tapAdvance(false);
    return;
  }
}

void keyPressedRender() {
  if (key == 'r' || key == 'R') {
    if (rendering) return;
    loadTimestampsForRender();
    if (renderEvents.size() == 0) {
      println("No timestamps.");
      return;
    }
    framesDir = sketchPath("frames");
    File d = new File(framesDir);
    if (!d.exists()) d.mkdirs();
    File[] old = d.listFiles();
    if (old != null) for (File f : old) f.delete();
    listPath = sketchPath("list.txt");
    renderOutputPath = sketchPath("lyrics.mov");
    currentEventIdx = 0;
    durations.clear();
    pngCounter = 0;
    rendering = true;
    return;
  }
  if (key == 'm' || key == 'M') {
    mode = "record";
    println("Switched to RECORD mode.");
    return;
  }
}

// =========================================================
// RECORD LOGIC
// =========================================================
void startCountIn() {
  // Manual path: run a count-in, then start recording
  captureHomeState();
  recordState = "countin";
  countInStartMs = millis();
  currentLine = firstContentLine();
  currentWord = 0;
  events.clear();
  activePreset = pendingPreset;

  Event init = new Event(0, presetLabel(activePreset), "initial", firstContentLine(), 0);
  init.transition   = pendingTransition;
  init.transDur     = TRANS_DURATIONS[pendingTransDurIdx];
  init.hiliteStyle  = pendingHilite;
  init.colorCC      = pendingColor;
  init.size         = pendingSize;
  init.fontName     = fontNames[pendingFontIdx];
  init.posX         = pendingPosX;
  init.posY         = pendingPosY;
  init.wordFade     = pendingWordFade;
  events.add(init);
  currentDisplayedEvent = init;
  currentEventStartMs = millis();

  println("Count-in: " + countInBeats + " beats at " + bpm + " BPM");
}

void startRecordingImmediate() {
  // MIDI-driven path: no count-in, recording starts at t=0 right now
  captureHomeState();
  currentLine = firstContentLine();
  currentWord = 0;
  events.clear();
  activePreset = pendingPreset;

  Event init = new Event(0, presetLabel(activePreset), "initial", firstContentLine(), 0);
  init.transition   = pendingTransition;
  init.transDur     = TRANS_DURATIONS[pendingTransDurIdx];
  init.hiliteStyle  = pendingHilite;
  init.colorCC      = pendingColor;
  init.size         = pendingSize;
  init.fontName     = fontNames[pendingFontIdx];
  init.posX         = pendingPosX;
  init.posY         = pendingPosY;
  init.wordFade     = pendingWordFade;
  events.add(init);
  currentDisplayedEvent = init;
  currentEventStartMs = millis();

  recordState = "playing";
  audioStartMs = millis();

  println("Recording started (MIDI-driven, no count-in) at t=0");
}

void stopRecording() {
  if (song != null && song.isPlaying()) song.stop();
  int elapsed = (recordState.equals("playing")) ? (millis() - audioStartMs) : 0;
  recordState = "stopped";
  println("Recording stopped at t=" + elapsed + "ms.");
}

void blankAndAdvance(boolean record) {
  int eventTime = record ? (millis() - audioStartMs) : 0;
  currentLine = nextContentLine(currentLine);
  currentWord = 0;
  blanked = true;
  pendingFreshStart = true;

  if (record) {
    Event e = new Event(eventTime, "SimpleLine", "blank", currentLine, 0);
    events.add(e);
    currentDisplayedEvent = e;
    currentEventStartMs = millis();
    println("Blank at t=" + eventTime + "ms");
  }
}

void tapAdvance(boolean record) {
  blanked = false;

  boolean wasSimpleLine = (activePreset == PRESET_SIMPLE);
  activePreset = pendingPreset;
  String preset = presetLabel(activePreset);
  String action;
  int eventTime = record ? (millis() - audioStartMs) : 0;

  boolean fromBlank = pendingFreshStart;
  boolean fromSimpleLine = (wasSimpleLine && activePreset != PRESET_SIMPLE);
  pendingFreshStart = false;

  if (fromBlank) {
    action = "advanceLine";
    currentWord = 0;
  } else if (wasSimpleLine && activePreset != PRESET_SIMPLE) {
    // Just switched from SimpleLine into a word-based preset.
    // Start fresh at word 0 on the current line.
    action = "advanceLine";
    currentLine = nextContentLine(currentLine);
    currentWord = 0;
  } else if (activePreset == PRESET_SIMPLE) {
    action = "advanceLine";
    currentLine = firstLineOfNextStanza(currentLine);
    currentWord = 0;
  } else {
    // Word-based: advance word, then line, then stanza
    String[] words = split(lyrics[currentLine], ' ');
    if (currentWord < words.length - 1) {
      action = "advanceWord";
      currentWord++;
    } else {
      action = "advanceLine";
      currentLine = nextContentLine(currentLine);
      currentWord = 0;
    }
  }

  Event e = new Event(eventTime, preset, action, currentLine, currentWord);
  e.transition   = pendingTransition;
  e.transDur     = TRANS_DURATIONS[pendingTransDurIdx];
  e.hiliteStyle  = pendingHilite;
  e.colorCC      = pendingColor;
  e.size         = pendingSize;
  e.fontName     = fontNames[pendingFontIdx];
  e.posX         = pendingPosX;
  e.posY         = pendingPosY;
  e.wordFade     = pendingWordFade;
  currentDisplayedEvent = e;
  currentEventStartMs = millis();

  if (record) {
    events.add(e);
    println("Event: t=" + eventTime + "ms " + preset + " " + action
      + " L" + currentLine + " W" + currentWord);
  }
}

// =========================================================
// RENDER LOGIC
// =========================================================
void loadTimestampsForRender() {
  renderEvents.clear();
  String tsFile = (audioPath != null && audioPath.length() > 0)
    ? timestampFileNameFor(audioPath)
    : "timestamps_freewheeling.txt";
  String[] raw = loadStrings(tsFile);
  if (raw == null) {
    println("Not found: " + tsFile);
    return;
  }
  for (String line : raw) {
    if (line == null || line.trim().length() == 0) continue;
    String[] p = split(line.trim(), '|');
    if (p.length < 5) continue;
    Event e = new Event(int(p[0]), p[1], p[2], int(p[3]), int(p[4]));
    if (p.length >= 6)  e.transition  = int(p[5]);
    if (p.length >= 7)  e.transDur    = float(p[6]);
    if (p.length >= 8)  e.hiliteStyle = int(p[7]);
    if (p.length >= 9)  e.colorCC     = int(p[8]);
    if (p.length >= 10) e.size        = int(p[9]);
    if (p.length >= 11) e.fontName    = p[10];
    if (p.length >= 12) e.posX        = int(p[11]);
    if (p.length >= 13) e.posY        = int(p[12]);
    if (p.length >= 14) e.wordFade    = float(p[13]);
    renderEvents.add(e);
  }
  println("Loaded " + renderEvents.size() + " events from " + tsFile);
}

class MyMidiReceiver implements Receiver {
  public void send(MidiMessage message, long timeStamp) {
    if (!(message instanceof ShortMessage)) return;
    ShortMessage sm = (ShortMessage) message;
    int command = sm.getCommand();
    if (command == ShortMessage.START) {
      resetToStart();
      transportPlaying = true;
      return;
    }
    if (command == ShortMessage.STOP) {
      // Restore the home snapshot so spurious CCs from the DAW's stop
      // sequence don't clobber the pending state.
      restoreHomeState();
      return;
    }
    if (command == ShortMessage.CONTINUE) {
      transportPlaying = true;
      return;
    }

    if (command == ShortMessage.PROGRAM_CHANGE) {
      int program = sm.getData1();
      if (program >= 0 && program < bundles.length) {
        applyBundle(program);
      }
      return;
    }

    if (command == ShortMessage.CONTROL_CHANGE) {
      if (millis() < ignoreCCUntilMs) return;
      int cc = sm.getData1();
      int val = sm.getData2();
      handleCC(cc, val);
      return;
    }

    if (command != ShortMessage.NOTE_ON || sm.getData2() == 0) return;
    int pitch = sm.getData1();
    int velocity = sm.getData2();
    boolean recording = recordState.equals("playing") || recordState.equals("countin");
    if (pitch == 37) {             // Reset lyrics to first line, exactly like R in Record mode
      resetToStart();
      return;
    } else if (pitch == 34) {      // Start recording — same as pressing ENTER when idle/stopped
      if (!recording) {
        startRecordingImmediate();
      }
      return;
    } else if (pitch == 35) {      // Stop recording — same as pressing ENTER when playing/countin
      if (recording) {
        stopRecording();
      }
      return;
    } else if (pitch == 36) {      // Blank screen, exactly like B
      blankAndAdvance(recording);
      return;
    } else if (pitch == 38) {      // Advance, exactly like SPACE
      tapAdvance(recording);
      return;
    } else if (pitch >= 48 && pitch <= 51) {
      pendingPreset = pitch - 48;
      println("MIDI preset: " + presetLabel(pendingPreset));
    }
  }
  public void close() {
  }
}

void setupMidi() {
  MidiDevice.Info[] infos = MidiSystem.getMidiDeviceInfo();

  println("=== Available MIDI devices ===");
  for (MidiDevice.Info info : infos) {
    println("  " + info.getName() + " | " + info.getDescription());
  }

  // Auto-pick: prefer IAC on Mac, Midi Through on Linux
  String[] preferred = { "IAC", "Midi Through", "VirMIDI", "Virtual Raw MIDI" };
  MidiDevice.Info chosen = null;

  for (String pref : preferred) {
    for (MidiDevice.Info info : infos) {
      if (info.getName().contains(pref)) {
        // Verify it has a Transmitter (input capability)
        try {
          MidiDevice dev = MidiSystem.getMidiDevice(info);
          if (dev.getMaxTransmitters() != 0) {
            chosen = info;
            break;
          }
        }
        catch (Exception e) { /* skip */
        }
      }
    }
    if (chosen != null) break;
  }

  if (chosen == null) {
    println("No virtual MIDI input port found. MIDI input disabled.");
    return;
  }

  try {
    midiDevice = MidiSystem.getMidiDevice(chosen);
    midiDevice.open();
    midiTransmitter = midiDevice.getTransmitter();
    midiReceiver = new MyMidiReceiver();
    midiTransmitter.setReceiver(midiReceiver);
    println("MIDI input connected: " + chosen.getName());
  }
  catch (Exception e) {
    println("Failed to open MIDI input: " + e.getMessage());
  }
}

void noteOn(int channel, int pitch, int velocity) {
  boolean recording = recordState.equals("playing") || recordState.equals("countin");

  if (pitch == 36) {
    blankAndAdvance(recording);   // same behavior as B key
    return;
  }
  if (pitch >= 48 && pitch <= 50) {
    pendingPreset = pitch - 48;   // same behavior as number keys
    println("MIDI preset: " + presetLabel(pendingPreset));
    return;
  }
}

void exportMidi() {
  if (events.size() == 0) {
    println("No events to export.");
    return;
  }

  int PPQ = 480;
  int NOTE_BASE = 48;
  int NOTE_BLANK = 36;
  int NOTE_ADVANCE = 38;
  int VELOCITY = 100;

  try {
    Sequence seq = new Sequence(Sequence.PPQ, PPQ);
    Track track = seq.createTrack();
    addNote(track, 37, 2L, VELOCITY);// Reset note at tick 0 so looping MIDI always realigns the lyric position
    addNote(track, 34, 1L, VELOCITY);// Start recording

    float ticksPerMs = (bpm / 60.0) * PPQ / 1000.0;

    // Track the last-sent value of each CC so we only emit on change
    int lastTrans = -1;
    int lastDur = -1;
    int lastHilite = -1;
    int lastColor = -1;
    int lastSize = -1;
    int lastFont = -1;
    int lastPosX = -1;
    int lastPosY = -1;
    int lastWordFadeCC = -1;

    for (int i = 0; i < events.size(); i++) {
      Event e = events.get(i);
      long tick = (long)(e.time * ticksPerMs) + 1;

      // Look up the font index from the stored font name
      int fontIdx = indexOfFont(e.fontName);

      // Duration index: reverse-map from the float value
      int durIdx = 0;
      for (int d = 0; d < TRANS_DURATIONS.length; d++) {
        if (abs(TRANS_DURATIONS[d] - e.transDur) < 0.01) {
          durIdx = d;
          break;
        }
      }

      // Emit CCs only when a value changed since the last event
      if (e.transition != lastTrans) {
        addCC(track, 20, e.transition, tick);
        lastTrans = e.transition;
      }
      if (durIdx != lastDur) {
        addCC(track, 21, durIdx, tick);
        lastDur = durIdx;
      }
      if (e.hiliteStyle != lastHilite) {
        addCC(track, 22, e.hiliteStyle, tick);
        lastHilite = e.hiliteStyle;
      }
      if (e.colorCC != lastColor) {
        addCC(track, 23, e.colorCC, tick);
        lastColor = e.colorCC;
      }
      if (e.size != lastSize) {
        addCC(track, 24, e.size, tick);
        lastSize = e.size;
      }
      if (fontIdx != lastFont) {
        addCC(track, 25, fontIdx, tick);
        lastFont = fontIdx;
      }
      if (e.posX != lastPosX) {
        addCC(track, 26, e.posX, tick);
        lastPosX = e.posX;
      }
      if (e.posY != lastPosY) {
        addCC(track, 27, e.posY, tick);
        lastPosY = e.posY;
      }
      int wordFadeCC = int(map(e.wordFade, 0.0, 2.0, 0, 127));// Map wordFade (0.0 - 2.0s) to CC value (0 - 127)
      if (wordFadeCC != lastWordFadeCC) {
        addCC(track, 28, wordFadeCC, tick);
        lastWordFadeCC = wordFadeCC;
      }

      // Emit the trigger note(s).
      // For the first event, emit the preset note but NOT the advance,
      // so line 0 shows without the advance skipping past it.
      boolean isFirst = (i == 0);
      if (e.action.equals("blank")) {
        if (!isFirst) {
          addNote(track, NOTE_BLANK, tick, VELOCITY);
        }
      } else {
        int presetNum = presetNumberFromLabel(e.preset);
        int presetPitch = NOTE_BASE + presetNum;
        long presetTick = (tick > 0) ? (tick - 1) : 0L;
        addNote(track, presetPitch, presetTick, VELOCITY);

        if (!isFirst) {
          addNote(track, NOTE_ADVANCE, tick, VELOCITY);
        }
      }
    }
    // Stop recording 3 seconds after the last event
    long lastEventTick = 1;
    for (Event e : events) {
      long t = (long)(e.time * ticksPerMs) + 1;
      if (t > lastEventTick) lastEventTick = t;
    }
    long stopTick = lastEventTick + (long)(3.0 * 1000 * ticksPerMs);
    addNote(track, 35, stopTick, VELOCITY);

    String outName = (audioPath == null || audioPath.length() == 0)
      ? "timestamps_freewheeling.mid"
      : "timestamps_" + new File(audioPath).getName().replaceAll("\\.[^.]+$", "") + ".mid";

    File outFile = new File(sketchPath(outName));
    int[] types = MidiSystem.getMidiFileTypes(seq);
    if (types.length == 0) {
      println("No supported MIDI types.");
      return;
    }
    MidiSystem.write(seq, types[0], outFile);
    println("MIDI exported: " + outFile.getAbsolutePath() + " (" + events.size() + " events)");
  }
  catch (Exception ex) {
    println("MIDI export failed: " + ex.getMessage());
    ex.printStackTrace();
  }
}

// Helper: emit a CC message at a tick
void addCC(Track track, int ccNum, int value, long tick) throws Exception {
  ShortMessage msg = new ShortMessage();
  msg.setMessage(ShortMessage.CONTROL_CHANGE, 0, ccNum, value);
  track.add(new MidiEvent(msg, tick));
}

// Helper: emit a note on/off pair at a tick
void addNote(Track track, int pitch, long tick, int velocity) throws Exception {
  ShortMessage on = new ShortMessage();
  on.setMessage(ShortMessage.NOTE_ON, 0, pitch, velocity);
  track.add(new MidiEvent(on, tick));

  ShortMessage off = new ShortMessage();
  off.setMessage(ShortMessage.NOTE_OFF, 0, pitch, 0);
  track.add(new MidiEvent(off, tick + 5));
}

int presetNumberFromLabel(String label) {
  if (label.startsWith("SimpleLine"))    return PRESET_SIMPLE;
  if (label.startsWith("WordHighlight")) return PRESET_HIGHLIGHT;
  if (label.startsWith("KaraokeFill"))   return PRESET_KARAOKE;
  if (label.startsWith("WordReveal"))    return PRESET_REVEAL;
  return PRESET_SIMPLE;
}

// =========================================================
// FILE HANDLING
// =========================================================
void audioSelected(File selection) {
  if (selection == null) return;
  audioPath = selection.getAbsolutePath();
  if (song != null) song.stop();
  song = new SoundFile(this, audioPath);
  PlaylistEntry found = findPlaylistEntry(audioPath);
  if (found != null) {
    bpm = found.bpm;
    countInBeats = found.beats;
  } else {
    playlist.add(new PlaylistEntry(audioPath, bpm, countInBeats));
    savePlaylist();
  }
}

PlaylistEntry findPlaylistEntry(String path) {
  for (PlaylistEntry e : playlist) if (e.path.equals(path)) return e;
  return null;
}

void loadPlaylist() {
  File f = new File(sketchPath("playlist.txt"));
  if (!f.exists()) return;
  String[] saved = loadStrings("playlist.txt");
  if (saved == null) return;
  for (String s : saved) {
    if (s == null || s.trim().length() == 0) continue;
    String[] parts = split(s.trim(), '|');
    if (parts.length >= 3) playlist.add(new PlaylistEntry(parts[0], float(parts[1]), int(parts[2])));
  }
}

void savePlaylist() {
  String[] out = new String[playlist.size()];
  for (int i = 0; i < playlist.size(); i++) {
    PlaylistEntry e = playlist.get(i);
    out[i] = e.path + "|" + e.bpm + "|" + e.beats;
  }
  saveStrings("playlist.txt", out);
}

void updatePlaylistEntry() {
  if (audioPath == null || audioPath.length() == 0) return;
  PlaylistEntry e = findPlaylistEntry(audioPath);
  if (e != null) {
    e.bpm = bpm;
    e.beats = countInBeats;
    savePlaylist();
  }
}

String timestampFileNameFor(String path) {
  String fname = new File(path).getName();
  int dot = fname.lastIndexOf('.');
  if (dot > 0) fname = fname.substring(0, dot);
  return "timestamps_" + fname + ".txt";
}

void saveTimestamps() {
  if (events.size() == 0) {
    println("No events.");
    return;
  }
  String[] lines = new String[events.size()];
  for (int i = 0; i < events.size(); i++) {
    Event e = events.get(i);
    lines[i] = e.time + "|" + e.preset + "|" + e.action + "|" + e.line + "|" + e.word
      + "|" + e.transition + "|" + e.transDur + "|" + e.hiliteStyle
      + "|" + e.colorCC + "|" + e.size + "|" + e.fontName
      + "|" + e.posX + "|" + e.posY + "|" + e.wordFade;
  }
  String outName = (audioPath == null || audioPath.length() == 0)
    ? "timestamps_freewheeling.txt"
    : timestampFileNameFor(audioPath);
  saveStrings(outName, lines);
  println("Saved " + events.size() + " events to " + outName);
}

String[] stripEmptyLines(String[] input) {
  ArrayList<String> out = new ArrayList<String>();
  for (String s : input) if (s != null && s.trim().length() > 0) out.add(s.trim());
  return out.toArray(new String[0]);
}

void handleCC(int cc, int val) {
  switch (cc) {
  case 20:
    pendingTransition = constrain(val, 0, TRANS_COUNT - 1);
    break;
  case 21:
    pendingTransDurIdx = constrain(val, 0, TRANS_DURATIONS.length - 1);
    break;
  case 22:
    pendingHilite = constrain(val, 0, HILITE_COUNT - 1);
    break;
  case 23:
    pendingColor = constrain(val, 0, 127);
    break;
  case 24:
    pendingSize = constrain(val, 0, 127);
    break;
  case 25:
    pendingFontIdx = constrain(val, 0, FONT_COUNT - 1);
    break;
  case 26:
    pendingPosX = constrain(val, 0, 127);
    break;
  case 27:
    pendingPosY = constrain(val, 0, 127);
    break;
  case 28:
    pendingWordFade = map(val, 0, 127, 0.0, 2.0);    // Map 0-127 to 0.0 - 2.0 seconds
    break;
  }
}

color colorFromCC(int cc) {
  float h = map(cc, 0, 127, 0, 360);
  float s = 1.0, v = 1.0;
  float c = v * s;
  float x = c * (1 - abs((h / 60.0) % 2 - 1));
  float m = v - c;
  float r=0, g=0, b=0;
  if (h <  60) {
    r=c;
    g=x;
    b=0;
  } else if (h < 120) {
    r=x;
    g=c;
    b=0;
  } else if (h < 180) {
    r=0;
    g=c;
    b=x;
  } else if (h < 240) {
    r=0;
    g=x;
    b=c;
  } else if (h < 300) {
    r=x;
    g=0;
    b=c;
  } else {
    r=c;
    g=0;
    b=x;
  }
  return color((r+m)*255, (g+m)*255, (b+m)*255);
}

int sizeFromCC(int cc) {
  // 0-127 maps to font sizes 12-200
  return int(map(cc, 0, 127, 12, 200));
}

int nextInCycle(int current, int[] cycle) {
  for (int i = 0; i < cycle.length; i++) {
    if (cycle[i] > current) return cycle[i];
  }
  return cycle[0];
}

void captureHomeState() {
  homePreset      = pendingPreset;
  homeTransition  = pendingTransition;
  homeTransDurIdx = pendingTransDurIdx;
  homeHilite      = pendingHilite;
  homeColor       = pendingColor;
  homeSize        = pendingSize;
  homeFontIdx     = pendingFontIdx;
  homePosX        = pendingPosX;
  homePosY        = pendingPosY;
  homeWordFade    = pendingWordFade;
  println("Home state captured.");
}

void restoreHomeState() {
  pendingPreset      = homePreset;
  pendingTransition  = homeTransition;
  pendingTransDurIdx = homeTransDurIdx;
  pendingHilite      = homeHilite;
  pendingColor       = homeColor;
  pendingSize        = homeSize;
  pendingFontIdx     = homeFontIdx;
  pendingPosX        = homePosX;
  pendingPosY        = homePosY;
  pendingWordFade    = homeWordFade;
}

void resetToStart() {
  currentLine = firstContentLine();
  currentWord = 0;
  blanked = false;
  pendingFreshStart = false;

  restoreHomeState();

  Event reset = new Event(0, presetLabel(pendingPreset), "initial", firstContentLine(), 0);
  reset.transition  = TRANS_NONE;
  reset.transDur    = TRANS_DURATIONS[pendingTransDurIdx];
  reset.hiliteStyle = pendingHilite;
  reset.colorCC     = pendingColor;
  reset.size        = pendingSize;
  reset.fontName    = fontNames[pendingFontIdx];
  reset.posX        = pendingPosX;
  reset.posY        = pendingPosY;
  reset.wordFade    = pendingWordFade;

  currentDisplayedEvent = reset;
  currentEventStartMs = millis();

  println("Reset to line 0. preset=" + reset.preset
    + " color=" + reset.colorCC + " size=" + reset.size
    + " pos=" + reset.posX + "," + reset.posY);
}
void drawReference() {
  // Full-screen dark overlay
  fill(0, 0, 0, 240);
  noStroke();
  rect(0, 0, width, height);

  textFont(uiFont);
  textAlign(LEFT, TOP);

  int marginX = 40;
  int topY = 40;
  int titleSize = 16;
  int bodySize = 12;
  int lineHeight = 18;
  int columnGap = 60;

  // Three columns: Left = key bindings, Middle = MIDI notes, Right = CCs + program change
  int col1X = marginX;
  int col2X = marginX + 400;
  int col3X = marginX + 700;

  // --- Column 1: Keyboard shortcuts ---
  fill(255, 220, 80);
  textSize(titleSize);
  text("KEYBOARD", col1X, topY);

  fill(220);
  textSize(bodySize);
  String[] keys = {
    "SPACE   advance (commit + advance)",
    "B       blank screen and advance",
    "1-3     preset: 1=SimpleLine, 2=WordHighlight, 3=KaraokeFill",
    "F       transition: none / fade / grow",
    "G       transition duration: 0.3 / 0.6 / 1.0 s",
    "J       highlight: box / outline / bold / grow",
    "K       color (cycles presets)",
    "L       size (cycles presets)",
    "N       font (cycles fonts folder)",
    "P       capture current state as home",
    "R       reset to line 0",
    "O       open audio file",
    "ENTER   start / stop recording",
    "S       save timestamps file",
    "X       export as MIDI file",
    "+ / -   BPM up / down",
    "] / [   count-in beats up / down",
    "M       SAVE+RENDER (in-memory take or disk timestamps if",
    "          empty) / return to RECORD after rendering",
    "H       toggle help panel",
    "Y       toggle this reference"
  };
  for (int i = 0; i < keys.length; i++) {
    text(keys[i], col1X, topY + 30 + i * lineHeight);
  }

  // --- Column 2: MIDI notes ---
  fill(255, 220, 80);
  textSize(titleSize);
  text("MIDI NOTES", col2X, topY);

  fill(220);
  textSize(bodySize);
  String[] notes = {
    "36    Blank screen (same as B key)",
    "37    Reset to line 0",
    "38    Advance (same as SPACE)",
    "48    SimpleLine",
    "49    WordHighlight",
    "50    KaraokeFill",
    "51    WordReveal"
  };
  for (int i = 0; i < notes.length; i++) {
    text(notes[i], col2X, topY + 30 + i * lineHeight);
  }

  // --- Column 2 continued: Program Change ---
  fill(255, 220, 80);
  textSize(titleSize);
  text("PROGRAM CHANGE (bundle selector)", col2X, topY + 190);

  fill(220);
  textSize(bodySize);
  for (int i = 0; i < bundles.length; i++) {
    Bundle b = bundles[i];
    text("PC " + i + "   " + b.name
      + "  [preset=" + presetLabel(b.preset)
      + " trans=" + transitionName(b.transition)
      + " hilite=" + hiliteName(b.hilite)
      + " color=" + b.colorCC
      + " size=" + b.size
      + " pos=" + b.posX + "," + b.posY + "]",
      col2X, topY + 220 + i * lineHeight);
  }

  // --- Column 3: CC numbers ---
  fill(255, 220, 80);
  textSize(titleSize);
  text("CC NUMBERS", col3X, topY);

  fill(220);
  textSize(bodySize);
  String[] ccs = {
    "20    Transition type (0-2)",
    "21    Transition duration (0-2)",
    "22    Highlight style (0-3)",
    "23    Color (0-127)",
    "24    Size (0-127)",
    "25    Font index",
    "26    Position X (0-127, 64 = center)",
    "27    Position Y (0-127, 64 = center)"
  };
  for (int i = 0; i < ccs.length; i++) {
    text(ccs[i], col3X, topY + 30 + i * lineHeight);
  }

  // --- Bottom note ---
  fill(180);
  textSize(bodySize);
  text("For a copy of this reference you can open while recording or rendering,", marginX, height - 60);
  text("see MIDI_REFERENCE.txt in the project folder.", marginX, height - 40);

  textAlign(CENTER, CENTER);
}
void startRenderFromRecord() {
  if (rendering) return;
  loadTimestampsForRender();
  if (renderEvents.size() == 0) {
    println("No timestamps to render.");
    return;
  }
  framesDir = sketchPath("frames");
  File d = new File(framesDir);
  if (!d.exists()) d.mkdirs();
  File[] old = d.listFiles();
  if (old != null) for (File f : old) f.delete();
  listPath = sketchPath("list.txt");
  renderOutputPath = sketchPath("lyrics.mov");
  currentEventIdx = 0;
  durations.clear();
  pngCounter = 0;
  rendering = true;
  println("Render started. " + renderEvents.size() + " events.");
}
float nextFloatInCycle(float current, float[] cycle) {
  for (int i = 0; i < cycle.length; i++) {
    if (cycle[i] > current + 0.001) return cycle[i];
  }
  return cycle[0];
}
boolean isStructuralMarker(String s) {
  return s.equals("[stanza]") || s.equals("[endstanza]") || s.equals("[emptyline]");
}

int nextContentLine(int from) {
  int i = from + 1;
  while (i < lyrics.length && isStructuralMarker(lyrics[i])) i++;
  if (i >= lyrics.length) return from;
  return i;
}

int firstContentLine() {
  int i = 0;
  while (i < lyrics.length && isStructuralMarker(lyrics[i])) i++;
  return i;
}
int prevContentLine(int from) {
  int i = from - 1;
  while (i >= 0 && isStructuralMarker(lyrics[i])) i--;
  return max(i, 0);
}

void parseStanzas() {
  ArrayList<Stanza> out = new ArrayList<Stanza>();
  boolean inStanza = false;
  int stanzaStart = -1;

  for (int i = 0; i < lyrics.length; i++) {
    String s = lyrics[i];

    if (s.equals("[stanza]")) {
      if (inStanza) {
        // Nested stanza — auto-close and warn
        println("WARNING: nested [stanza] at line " + i + "; auto-closing previous.");
        out.add(new Stanza(stanzaStart, i - 1));
      }
      inStanza = true;
      stanzaStart = i + 1;   // content starts after the marker
    } else if (s.equals("[endstanza]")) {
      if (!inStanza) {
        println("WARNING: [endstanza] without [stanza] at line " + i + "; ignoring.");
        continue;
      }
      // Close the stanza. Content runs from stanzaStart to i-1.
      if (i > stanzaStart) {
        out.add(new Stanza(stanzaStart, i - 1));
      } else {
        println("WARNING: empty stanza at lines " + stanzaStart + "-" + (i - 1) + "; skipping.");
      }
      inStanza = false;
      stanzaStart = -1;
    } else if (s.equals("[blank]")) {
      if (inStanza) {
        println("WARNING: [blank] inside a [stanza] at line " + i
          + "; [blank] is not allowed inside stanzas. Use [emptyline] instead. "
          + "Auto-closing the stanza here.");
        if (i > stanzaStart) {
          out.add(new Stanza(stanzaStart, i - 1));
        } else {
          println("WARNING: empty stanza at lines " + stanzaStart + "-" + (i - 1) + "; skipping.");
        }
        inStanza = false;
        stanzaStart = -1;
        // Treat this [blank] as its own single-line stanza
        out.add(new Stanza(i, i));
      }
    } else if (!inStanza) {
      if (s.equals("[emptyline]")) {
        println("WARNING: [emptyline] outside a [stanza] at line " + i + "; ignoring.");
        continue;
      }
      out.add(new Stanza(i, i));  // Single-line stanza
    }
    // Else: in-stanza content line — it's covered by the enclosing Stanza range
  }

  if (inStanza) {
    println("WARNING: unterminated [stanza] at end of file; auto-closing.");
    if (lyrics.length > stanzaStart) {
      out.add(new Stanza(stanzaStart, lyrics.length - 1));
    }
  }

  stanzas = out.toArray(new Stanza[0]);
}

Stanza stanzaForLine(int lineIdx) {
  for (Stanza s : stanzas) {
    if (lineIdx >= s.startLine && lineIdx <= s.endLine) return s;
  }
  return null;
}

int firstLineOfNextStanza(int currentLine) {
  Stanza st = stanzaForLine(currentLine);
  if (st == null) return nextContentLine(currentLine);
  int after = st.endLine + 1;
  while (after < lyrics.length && isStructuralMarker(lyrics[after])) after++;
  if (after >= lyrics.length) return currentLine;
  return after;
}
