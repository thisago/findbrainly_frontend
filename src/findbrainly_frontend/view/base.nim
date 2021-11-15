from std/json import JsonNode, items, `{}`, getStr, getInt, parseJson
from std/times import fromUnix, format

include pkg/karax/prelude
import pkg/karax/kajax

from findbrainly_frontend/view/texts import questionText
from findbrainly_frontend/config import apiUrl

func help*(
  text: string;
  position = "right";
  icon = "?";
  size = "small";
): VNode =
  if position notin ["up", "down", "left", "right", "up-left", "up-right", "down-left", "down-right"]:
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
  buildHtml tdiv(class="comments"):
    for comment in comments:
      let
        author = comment{"author"}.getStr
        avatar = comment{"avatar"}.getStr
        body = comment{"body"}.getStr
      tdiv(class="comment"):
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
  buildHtml tdiv(class = "question"):
    header:
      tdiv(class = "author"):
        img(src = avatar)
        span(class="name"): text author
      tdiv(class = "creation"):
        text creation.fromUnix.format "MM/dd/yyyy hh:mm:ss"
    main:
      a(class = "title", href = url, target = "_blank",
          rel = "noreferrer nofollow"):
        text title
      tdiv(class = "body"):
        for line in body.split "\n":
          p: text line
      drawComments question{"comments"}
      hr()
      h2: text questionText.answers
      for answer in question{"answers"}:
        let
          author = answer{"author"}.getStr
          avatar = answer{"avatar"}.getStr
          body = answer{"body"}.getStr
        tdiv(class = "answer"):
          header:
            tdiv(class = "author"):
              img(src = avatar)
              span(class="name"): text author
          main:
            tdiv(class = "body"):
              for line in body.split "\n":
                p: text line
            drawComments answer{"comments"}
