# from std/strformat import fmt
from std/dom import window, document, getElementById, setTimeout,
                    addEventListener, scrollLeft
from std/math import round
from std/jsffi import newJsObject, `[]=`, JsObject

include pkg/karax/prelude

import findbrainly_frontend/view/[
  home,
  singleSearch,
  multipleSearch
]
import findbrainly_frontend/pages

proc scroll*(el: dom.Element; x: JsObject) {.importcpp.}

proc updateScroll(node: VNode) =
  let
    floatPage = node.dom.scrollLeft / window.innerWidth
    roundedPage = round floatPage
  if roundedPage == floatPage:
    window.location.hash = toStr Page(int roundedPage)
    lastPage = pg404

proc createDom(data: RouterData): VNode =
  var
    path = "#/"
    hash = "#"
  if data.hashPart.len > 1:
    path = $data.hashPart
    let hashInd = path[1..^1].find '#'
    if hashInd > -1:
      hash = path[hashInd + 1..^1]
      path = path[0..hashInd]
  page = getPage path
  result = buildHtml(tdiv(class = "sections")):
    renderHome()
    renderSingleSearch()
    renderMultipleSearch()
    proc onScroll(ev: Event; n: VNode) =
      updateScroll(n)
      return
  if page != lastPage and page != pg404:
    lastPage = page
    var config = newJsObject()
    config["left"] = window.innerWidth * ord page
    config["behavior"] = cstring "smooth"
    document.getElementById("ROOT").scroll config

setRenderer createDom
