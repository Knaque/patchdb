import strutils, osproc, strformat

func fileType*(filename: string): string =
  # doesnt account for files w/o extensions, ok for now
  filename.split(".")[^1].toLower()

proc pushPatches*(n: int) =
  echo execProcess("git add ./Patches").strip()
  echo execProcess(&"git commit -m \"added {n} presets\"").strip()
  echo execProcess("git push").strip()

func extDir*(filename: string): string =
  case filename.fileType()
  of "bwpreset": result = "Bitwig Presets"
  of "bwclip": result = "Bitwig Clips"
  of "wt", "vitaltable": result = "Wavetables"
  of "mid", "midi": result = "MIDI"
  of "vital": result = "Vital Presets"
  of "adg", "adv", "amxd": result = "Ableton Presets"
  of "wav", "aiff", "mp3", "ogg", "m4a", "aud": result = "Audio Files"
  of "helm": result = "Helm Presets"
  of "nmsv": result = "Massive Presets"
  of "fxp": result = "Serum Presets"
  of "pgtx": result = "Pigments Presets"
  else: result = "Miscellaneous"
  result.add("/")