import dimscord, asyncdispatch, httpclient, os, strutils
import patchdb/[utils]

let token = readFile("token.txt").strip()
const root = "./Patches/"
const channels = ["812058809508954153", "817566738622185493"]

var bot = newDiscordClient(token)

bot.events.on_ready = proc (s: Shard, r: Ready) {.async.} =
  echo "Ready to rumble!"

bot.events.message_create = proc (s: Shard, m: Message) {.async.} =
  if m.channel_id in channels and m.attachments.len > 0:
    var client = newAsyncHttpClient()
    for f in m.attachments:
      echo "Trying to download and save file " & f.filename
      let dir = root & extDir(f.filename) & m.author.username & "/"
      createDir(dir)
      await client.downloadFile(f.url, dir & f.filename)
      echo f.filename & " success"
    pushPatches(m.attachments.len)

waitFor bot.startSession()