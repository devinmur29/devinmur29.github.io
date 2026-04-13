// Devin Murphy — Curriculum Vitae
// Compile: typst compile --root . cv/cv.typ assets/profile/DevinCVLatest.pdf
// Data sources: _data/cv.yaml, _data/publications.yaml

#set document(title: "Devin Murphy — Curriculum Vitae")
#set page(
  paper: "us-letter",
  margin: (x: 0.9in, y: 0.75in),
  footer: context [
    #set text(size: 8pt, fill: luma(160))
    Devin Murphy — CV
    #h(1fr)
    #counter(page).display() of #counter(page).final().first()
  ],
)
#set text(font: "Libertinus Serif", size: 10.5pt, lang: "en")
#set par(leading: 0.6em, spacing: 0.6em)
#show link: it => it

// ── Data ─────────────────────────────────────────────────────────────────
#let cv = yaml("/_data/cv.yaml")
#let pubs_all = yaml("/_data/publications.yaml")

// ── Helpers ───────────────────────────────────────────────────────────────
#let fmt-authors(authors) = {
  let parts = authors.map(a => {
    let n = if a.at("me", default: false) { strong(a.name) } else { a.name }
    if a.at("equal", default: false) { n + super[\*] } else { n }
  })
  parts.join(", ")
}

#let section(title, body) = {
  v(0.9em)
  text(size: 12pt, weight: "bold")[#upper(title)]
  v(0.15em)
  line(length: 100%, stroke: 0.4pt + luma(160))
  v(0.4em)
  body
}

#let subsection(title) = {
  v(0.5em)
  text(weight: "bold")[#title]
  v(0.2em)
}

// ── Header ────────────────────────────────────────────────────────────────
#grid(
  columns: (1fr, auto),
  gutter: 1em,
  [
    #text(size: 20pt, weight: "bold")[#cv.name]
    #v(0.2em)
    #cv.title, #cv.institution
  ],
  [
    #set align(right)
    #set text(size: 9.5pt)
    #link("mailto:" + cv.email)[#cv.email] \
    #link(cv.urls.scholar)[Google Scholar] \
    #link(cv.urls.website)[devinmurphy.net]
  ],
)
#v(0.4em)
#line(length: 100%, stroke: 0.5pt)

// ── Research Interests ────────────────────────────────────────────────────
#section("Research Interests")[
  #cv.research_interests
]

// ── Education ─────────────────────────────────────────────────────────────
#section("Education")[
  #for (i, edu) in cv.education.enumerate() {
    if i > 0 { v(0.65em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        strong[#edu.institution],
        text(size: 9.5pt)[#edu.dates],
      )
      #v(0.1em)
      #edu.degree#if edu.at("advisors", default: none) != none [
        \ #text(size: 9.5pt)[_Advisors:_ #edu.advisors.map(a => a.name).join(", ")]
      ]
    ]
  }
]

// ── Peer-Reviewed Publications ────────────────────────────────────────────
#section("Peer-Reviewed Publications")[
  #text(size: 9pt, style: "italic")[\* indicates equal contribution]
  #v(0.4em)

  #let pubs = pubs_all
  #let total = pubs.len()

  #for (i, pub) in pubs.enumerate() {
    let num = total - i
    if i > 0 { v(0.6em) }
    [\[#num\] ]
    fmt-authors(pub.authors)
    [. ]
    pub.title
    [. In ]
    emph(pub.venue)
    if pub.at("doi", default: none) != none {
      [ ]
      text(size: 9pt)[#link("https://doi.org/" + pub.doi, "doi:" + pub.doi)]
    }
    if pub.at("note", default: none) != none {
      [ ]
      text(size: 9pt)[★ #pub.note]
    }
  }
]

// ── Awards, Grants, and Fellowships ──────────────────────────────────────
#section("Awards, Grants, and Fellowships")[
  #for (i, award) in cv.awards.enumerate() {
    if i > 0 { v(0.45em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        strong[#award.name],
        text(size: 9.5pt)[#award.year],
      )
      #v(0.1em)
      #award.description
    ]
  }
]

// ── Selected Talks ────────────────────────────────────────────────────────
#section("Selected Talks")[
  #for (i, talk) in cv.talks.enumerate() {
    if i > 0 { v(0.45em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        strong[#talk.name],
        text(size: 9.5pt)[#talk.date],
      )
      #v(0.1em)
      #talk.description
    ]
  }
]

// ── Service ───────────────────────────────────────────────────────────────
#section("Service")[
  #let has-outstanding = cv.service.peer_review.any(v => v.years.any(y => y.at("outstanding", default: false)))
  #v(0.5em)
  #grid(
    columns: (1fr, auto),
    text(weight: "bold")[Peer Review],
    if has-outstanding { text(size: 9pt, style: "italic")[★ Outstanding Review Recognition] } else { [] },
  )
  #v(0.2em)
  #for item in cv.service.peer_review {
    let year-strs = item.years.map(y => {
      if y.at("outstanding", default: false) { str(y.year) + "★" } else { str(y.year) }
    })
    grid(
      columns: (1fr, auto),
      item.venue,
      text(size: 9.5pt)[#year-strs.join(", ")],
    )
  }

  #subsection("Organizing Committee")
  #for (i, item) in cv.service.organizing.enumerate() {
    if i > 0 { v(0.35em) }
    grid(
      columns: (1fr, auto),
      if item.at("url", default: none) != none { link(item.url, item.description) } else { item.description },
      text(size: 9.5pt)[#item.date],
    )
  }
]

// ── Teaching Experience ───────────────────────────────────────────────────
#section("Teaching Experience")[
  #for (i, t) in cv.teaching.enumerate() {
    if i > 0 { v(0.65em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        gutter: 1em,
        [
          #strong[#t.course] \
          #t.role
        ],
        [
          #set align(right)
          #t.institution \
          #text(size: 9.5pt)[#t.dates]
        ],
      )
    ]
  }
]

// ── Professional Experience ───────────────────────────────────────────────
#section("Professional Experience")[
  #for (i, exp) in cv.experience.enumerate() {
    if i > 0 { v(0.65em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        strong[#exp.organization],
        text(size: 9.5pt)[#exp.dates],
      )
      #v(0.1em)
      #exp.role#if exp.at("course", default: none) != none [ | #exp.course]
      #if exp.at("location", default: none) != none [
        \ #text(size: 9.5pt, fill: luma(100))[#exp.location]
      ]
    ]
  }
]

// ── Mentorship Experience ─────────────────────────────────────────────────
#section("Mentorship Experience")[
  #for (i, m) in cv.mentorship.enumerate() {
    if i > 0 { v(0.45em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        [
          #strong[#m.name]#if m.at("description", default: none) != none [, #m.description]
        ],
        text(size: 9.5pt)[#m.dates],
      )
    ]
  }
]

// ── Selected Press ────────────────────────────────────────────────────────
#section("Selected Press")[
  #for (i, item) in cv.press.enumerate() {
    if i > 0 { v(0.45em) }
    block(breakable: false)[
      #grid(
        columns: (1fr, auto),
        [
          #if item.at("url", default: none) != none { strong(link(item.url, item.outlet)) } else { strong(item.outlet) }, #item.title
        ],
        text(size: 9.5pt)[#item.date],
      )
    ]
  }
]
