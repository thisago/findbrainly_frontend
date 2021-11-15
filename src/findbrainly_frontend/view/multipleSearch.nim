from std/json import items
from std/strutils import split

include pkg/karax/prelude
from pkg/util/forhtml import genclass

import findbrainly_frontend/view/base
from findbrainly_frontend/view/texts import multipleSearchPage, homePage

var
  state: State
  search = cstring ""

proc renderMultipleSearch*: VNode =
  buildHtml section:
    tdiv(class = "container"):
      header:
        help(multipleSearchPage.help, size = "medium")
        a(href = homePage.url, class = "btn bg inverted"): text "Home"
      h1: text multipleSearchPage.title
      tdiv(class = "box"):
        tdiv(class = "row"):
          input(placeholder = multipleSearchPage.input):
            proc onInput(ev: Event; n: VNode) =
              search = n.value
          button(class="btn"):
            text multipleSearchPage.search
            proc onClick(ev: Event; n: VNode) =
              state.get "multi?q=" & $search
        if not isNil state.response:
          hr()
          tdiv(class = "questions"):
            for question in state.response:
              drawQuestion question
