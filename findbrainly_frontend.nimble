# Package

version       = "1.3.0"
author        = "lurlo"
description   = "Frontend to findbrainly API"
license       = "GPL-3"
srcDir        = "src"

bin = @["findbrainly_frontend"]
binDir = "public/script"
backend = "js"

# Dependencies

requires "nim >= 1.5.1"
requires "karax"
requires "animatecss"
requires "util"

task build_release, "Builds the release version":
  exec "nimble -d:release build"
task build_danger, "Builds the danger version":
  exec "nimble -d:danger build"
