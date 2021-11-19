from std/json import JsonNode, items, `{}`, getStr, getInt, parseJson, len,
                     newJObject, `$`
from std/times import fromUnix, format

include pkg/karax/prelude
import pkg/karax/kajax

import pkg/animatecss

from findbrainly_frontend/view/texts import questionText
from findbrainly_frontend/config import apiUrl

func help*(
  text: string;
  position = "right";
  icon = "?";
  size = "small";
): VNode =
  if position notin ["up", "down", "left", "right", "up-left", "up-right",
      "down-left", "down-right"]:
    doAssert false, "Invalid help tooltip position"
  if size notin ["small", "medium", "large", "fit"]:
    doAssert false, "Invalid help tooltip size"
  buildHtml(tdiv(
    class = "help",
    aria-label = text,
    data-balloon-pos = position,
    data-balloon-length = size,
  )):
    text icon

type
  State* = object
    response*: JsonNode

proc get*(state: var State; route: string) =
  proc cb(status: int; resp: cstring) =
    if status == 200:
      state.response = parseJson $resp
  ajaxGet(apiUrl & route, @[], cb)

func drawComments*(comments: JsonNode): VNode =
  buildHtml tdiv(class = "comments"):
    for comment in comments:
      let
        author = comment{"author"}.getStr
        avatar = comment{"avatar"}.getStr
        body = comment{"body"}.getStr
      tdiv(class = "comment " & animatecss slideInLeft):
        header(aria-label = author, data-balloon-pos = "left"):
          img(src = avatar)
        main:
          p: text body

proc drawQuestion*(question: JsonNode): VNode =
  let
    url = question{"url"}.getStr
    title = question{"title"}.getStr
    body = question{"body"}.getStr
    author = question{"author"}.getStr
    avatar = question{"avatar"}.getStr
    creation = question{"creation"}.getInt
    subject = question{"subject"}.getStr
    grade = question{"grade"}.getStr
  if url.len == 0:
    return buildHtml tdiv(class = "question"):
      h1: text questionText.noResults
  buildHtml tdiv(class = "question"):
    header:
      tdiv(class = "author " & animatecss fadeIn):
        img(src = avatar)
        span(class = "name"): text author
      tdiv:
        tdiv(class = "grade " & animatecss fadeIn):
          bold: text questionText.grade
          text grade
        tdiv(class = "subject " & animatecss fadeIn):
          bold: text questionText.subject
          text subject
        tdiv(class = "creation " & animatecss fadeIn):
          bold: text questionText.creation
          text creation.fromUnix.format "MM/dd/yyyy hh:mm:ss"

    main:
      a(class = "title", href = url, target = "_blank",
          rel = "noreferrer nofollow"):
        if title.len > 0: text title
        else: text questionText.noTitle
      tdiv(class = "body"):
        for line in body.split "\n":
          p: text line
        if question{"attachments"}.len > 0:
          h3: text questionText.attachments
          tdiv(class = "attachements"):
            for node in question{"attachments"}:
              let url = kstring getStr node
              a(href = url):
                text url
      drawComments question{"comments"}
      hr()
      h2: text questionText.answers
      for answer in question{"answers"}:
        let
          author = answer{"author"}.getStr
          avatar = answer{"avatar"}.getStr
          body = answer{"body"}.getStr
        tdiv(class = "answer " & animatecss fadeIn):
          header:
            tdiv(class = "author"):
              img(src = avatar)
              span(class = "name"): text author
          main:
            tdiv(class = "body"):
              for line in body.split "\n":
                p: text line
              if answer{"attachments"}.len > 0:
                h4: text questionText.attachments
                tdiv(class = "attachements"):
                  for node in answer{"attachments"}:
                    let url = kstring getStr node
                    a(href = url):
                      text url
            drawComments answer{"comments"}
