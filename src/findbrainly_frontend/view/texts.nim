import findbrainly_frontend/pages

const
  homePage* = (
    url: toStr pgHome,
    help: "Select one option below",
    title: "Findbrainly",
  )
  singleSearchPage* = (
    url: toStr pgSingle,
    help: "Searches in Duckduckgo and shows the brainly question with most interaction",
    title: "Single",
    input: "Question",
    search: "Search"
  )
  multipleSearchPage* = (
    url: toStr pgMulti,
    help: "Searches in Duckduckgo and shows all brainly questions with at least one answer",
    title: "Multiple",
    input: "Question",
    search: "Search",
  )

const
  questionText* = (
    answers: "Answers",
    noTitle: "No title",
  )
