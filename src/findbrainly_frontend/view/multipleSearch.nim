include pkg/karax/prelude
from pkg/util/forhtml import genclass

import findbrainly_frontend/view/base
from findbrainly_frontend/view/texts import multipleSearchPage, homePage

var started = false
proc renderMultipleSearch*: VNode =
  buildHtml section:
    tdiv(class = "container"):
      header:
        help(multipleSearchPage.help, size = "medium")
        a(href = homePage.url, class = "btn bg inverted"): text "Home"
      h1: text multipleSearchPage.title
      tdiv(class = "box"):
        tdiv(class = "row"):
          input(placeholder = multipleSearchPage.input)
          button(class="btn"): text multipleSearchPage.search
