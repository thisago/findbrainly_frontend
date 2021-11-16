include pkg/karax/prelude
from pkg/util/forhtml import genclass

import findbrainly_frontend/view/base
from findbrainly_frontend/view/texts import singleSearchPage, homePage

var
  state: State
  search = cstring ""

proc renderSingleSearch*: VNode =
  buildHtml section:
    tdiv(class = "container"):
      header:
        help(singleSearchPage.help, size = "medium")
        a(href = homePage.url, class = "btn bg inverted"): text "Home"
      h1: text singleSearchPage.title
      tdiv(class = "box"):
        tdiv(class = "row"):
          input(placeholder = singleSearchPage.input):
            proc onInput(ev: Event; n: VNode) =
              search = n.value
          button(class="btn"):
            text singleSearchPage.search
            proc onClick(ev: Event; n: VNode) =
              state.response = nil
              state.get "single?q=" & $search
        if not isNil state.response:
          hr()
          tdiv(class="questions"):
            drawQuestion state.response
