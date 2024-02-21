#let subfigure(body, pos: bottom+center, dx: 0%, dy: 0%, caption: "", numbering: "(a)", separator: "", lbl: none, supplement: none) = {
  let fig = figure(body, caption: none, kind: "subfigure", supplement: none, numbering: numbering, outlined: false)
  
  let number = locate(loc => {
    let fc = query(selector(figure).before(loc), loc).last().counter.display(numbering)
    return fc
  })
  if caption != "" and separator == none { separator = ":" }
  caption = [#set text(12pt); #supplement #number#separator #caption]

  return [ #fig #lbl \ #place(pos, dx: dx, dy: dy, caption)]
}

#let CodeFrame(lang: none, body) = {
  body
  place(
    right+top,
    dx: -0.3em,
    dy: 0.3em
  )[
    #block(
      stroke: rgb("#B8B8B8")+0.5pt,
      fill: rgb("#DEDADA8E"),
      radius: 3.3pt,
      inset: 0.1em
    )[
      #raw(lang)
    ]
  ]
}

#let FigureBlock(
  captionAlign: "l",
  body
  ) = {
    show figure.caption: it => [
      #if captionAlign == "l" [
        #align(left)[
          #v(0.5em)
          Figure #it.counter.display(it.numbering): #it.body
          #v(10pt)
        ]
      ] else if captionAlign == "c" [
        #align(center)[
          #v(0.5em)
          Figure #it.counter.display(it.numbering): #it.body
          #v(10pt)
        ]
      ] else if captionAlign == "r" [
        #align(right)[
          #v(0.5em)
          Figure #it.counter.display(it.numbering): #it.body
          #v(10pt)
        ]
      ]
    ]

    body
}


#let MSTemplate(
  reportName: "",
  authorName: "",
  professor: "",
  date: "",
  courseName: "",
  IsComplexEquationNumberingOn: true,
  ShowProfessorName: true,
  body) = [
  #set page(
    paper: "a4",
    header: locate(loc => {
      if counter(page).at(loc).first() > 1 [
        _#courseName _ - 
        #reportName
        #h(1fr)
        #counter(page).at(loc).first() \
        #v(-5pt)
        #set line(
          stroke: 0.35pt
        )
        #line(length: 100%)
      ]
    }),
    footer: locate(loc => {
      if counter(page).at(loc).first() == 1 [
        #align(center)[1]
      ] else [
        #set line(
          stroke: 0.35pt
        )
        #line(length: 100%)
        #v(-5pt)
        #h(1fr)
        _#authorName _
      ]
    })
  )

  #set text(
    size: 12pt,
    font: "New Computer Modern"
  )
  #set par(
    justify: true,
    linebreaks: "optimized",
    first-line-indent: 1.5em,
  )

  #set enum(
    indent: 1.5em,
  )

  #show enum.where(tight: false): it => {
    it.children
      .enumerate()
      .map(((n,item)) => block(below: 1.6em, above: 1.6em)[#h(1.5em)#numbering("1.", n + 1) #item.body])
      .join()
  }

  #set list(
    indent: 1.5em,
  )

  #show list.where(tight: false): it => {
    it.children
      .enumerate()
      .map(((n,item)) => block(below: 1.6em, above: 1.6em)[#h(1.5em)• #h(.25em) #item.body])
      .join()
  }
  
  #set heading(numbering: "1.1.1.")

  #set figure(numbering: "1.a")

  #set ref(supplement: it => {
    if it.func() == heading {
      "Sec."
    } else if it.func() == math.equation {
      "Eq."
    } else if it.func() == figure {
      "Fig."
    }
  })
  
  #show heading.where(
    level: 1
  ): it => block(
    width: 100%,
    breakable: false,
    )[
      #if IsComplexEquationNumberingOn == true [
        #counter(math.equation).update(0)
      ]

      #set align(center)
      #set text(size: 12pt)
      #v(-5pt)
      \ #counter(heading).display("1"). #it.body \
      #v(0.5em)
    ]

  #show math.equation:it => {
    if it.has("label"){
      if IsComplexEquationNumberingOn == true {
        math.equation(block: true, numbering: it => {
          locate(loc => {
          let count = counter(heading.where(level:1)).at(loc).last()
          numbering("(1.1)", count, it)
          })}, it)
      } else {
        math.equation(block:true, numbering: "(1.1)", it)
      }

    } else {
      it
    }
  }

  #show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation [
      #link(
        el.location(), 
      )[
        #text(font: "New Computer Modern", size: 12pt)[
          Eq.
          #if IsComplexEquationNumberingOn == true [
            #numbering(
              "(1.1)",
              counter(heading.where(level:1)).at(el.location()).last(),
              counter(math.equation).at(el.location()).at(0) + 1
            )
          ] else [
            #numbering(
              "(1.1)",
              counter(math.equation).at(el.location()).at(0) + 1
            )
          ]
        ]
      ]
    ] else if el != none and el.func() == figure and el.kind == "subfigure" {
      locate(loc => {
            let q = query(figure.where(outlined: true).before(it.target), loc).last()
            ref(q.label)
            set ref(supplement: none)
            it
          })
    } else if el != none and el.func() == figure and el.kind == "code" {
      set ref(supplement: "Listing")
      it
    } else if el != none and el.func() == figure and el.kind == table {
      set ref(supplement: "Table")
      it
    } else {
      it
    }
  }

  #show figure: it => {
    if it.kind != "subfigure" and it.kind != "code" {
      locate(loc => {
        let q = query(figure.where(kind: "subfigure").after(loc), loc)
        if q.len() != 0 {
          q.first().counter.update(0)
        }
      })
      it
    } else if it.kind == "code" [
      #it
      #par()[#text(size: 0.5em)[#h(0.0em)]]
     ] else {
      it
    }
  }

  #show figure.where(
  kind: table
): set figure.caption(position: top)

  #show heading: it => {
    if it.level == 2 {
      text(size: 12pt)[
        #par()[#text(size: 0.5em)[#h(0.0em)]]
        #v(0em)
        #h(-1.5em + 5pt) #counter(heading).display("1.1.") #it.body.    
      ]
    } else if it.level > 2 {
      text(size: 12pt)[
        #par()[#text(size: 0.5em)[#h(0.0em)]]
        #v(0em)
        #h(-1.5em + 5pt) #emph[#counter(heading).display("1.1.1.") #it.body.]
      ]
    } else {
      it
    }
  }

  #show par: it => [
    #set block(above: 0.8em, below: 0.8em)
    #it
  ]

  #show link: set text(font: "Cascadia Code", size: 10pt)
  #show link: it => {
    if type(it.dest) == str {
      underline(it)
    } else {
      it
    }
  }

  #align(center)[
    #block(
      breakable: true,
    )[
      #set line(
        stroke: 0.35pt
      )
      #smallcaps(text()[University of Utrecht]) \
      #v(1pt)
      #line(length: 100%)
      #v(-2pt)
      #text(
        size: 21.5pt, 
        weight: "semibold"
        )[#reportName] \
      #v(2pt)
      #text()[
        Student name: _#authorName _
      ]
      #v(-2pt)
      #line(length: 100%) 
      #v(-3pt)
      #if ShowProfessorName == true [
      Course: _#courseName _ - Professor: _#professor _ \
      ] else [
        Course: _#courseName _ \
      ]
      Due date: _#date _
    ]
  ]

  #body
]