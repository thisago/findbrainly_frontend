include pkg/karax/prelude
from pkg/util/forhtml import genclass

import findbrainly_frontend/view/base
import findbrainly_frontend/view/texts

var started = false
proc renderHome*: VNode =
  buildHtml section:
    tdiv(class = "container"):
      help(homePage.help)
      h1: text homePage.title
      tdiv(class = "box menu"):
        tdiv(class="item"):
          a(href = singleSearchPage.url, class="btn"): text singleSearchPage.title
          help(singleSearchPage.help)
        tdiv(class="item"):
          a(href = multipleSearchPage.url, class="btn"): text multipleSearchPage.title
          help(multipleSearchPage.help)
