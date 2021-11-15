include pkg/karax/prelude
from pkg/util/forhtml import genclass

import findbrainly_frontend/view/base
from findbrainly_frontend/view/texts import singleSearchPage, homePage

proc renderSingleSearch*: VNode =
  buildHtml section:
    tdiv(class = "container"):
      header:
        help(singleSearchPage.help, size = "medium")
        a(href = homePage.url, class = "btn bg inverted"): text "Home"
      h1: text singleSearchPage.title
      tdiv(class = "box"):
        tdiv(class = "row"):
          input(placeholder = singleSearchPage.input)
          button(class="btn"): text singleSearchPage.search
