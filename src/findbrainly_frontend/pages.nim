from std/strutils import toLowerAscii

type
  Page* = enum
    pgHome, pgSingle, pgMulti, pg404

func getPage*(r: string): Page =
  let curr = r[2..^1].toLowerAscii
  for page in Page:
    if page.`$`[2..^1].toLowerAscii == curr:
      return page
  return pg404

func toStr*(page: Page): string =
  result = "#/"
  result &= page.`$`[2..^1]
  result[2] = char result[2].toLowerAscii

var
  page*: Page
  lastPage*: Page
