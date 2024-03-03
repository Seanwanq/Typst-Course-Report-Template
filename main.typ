#import "@preview/tablex:0.0.8": *
#import "template.typ": *

#import "sourcerer.typ": *


#show: MSTemplate.with(
  reportName: "Template homework",
  authorName: "Andre F. V. Matias",
  courseName: "Modeling and Simulations",
  professor: "Prof. dr. it. Marjolein Dijksta and Dr. Laura Filion",
  date: "April 25th, 1974",
  IsComplexEquationNumberingOn: true,
  ShowProfessorName: false,
)

= The basics
The easiest way to edit a Typst file is using #link("https://typst.app")[typst.app] online
editor, a browser based editor that already has all the required packages
installed. Try importing this project to typst online editor and edit there.

After opening this project in typst online editor, the first thing to edit is
the information about you and the course. You can change that above. For
example, the title can be changed in `#Title(reportName: "Template homework")`.

== Images <section>
The inclusion of figures needs to be inside the environment _figure_. You can
see an example below.


#FigureBlock(
  captionAlign: "l",
)[
#figure(
  placement: none,
  image("figures/swallow.jpg", width: 60%),
  caption: [
  Figure caption edited here. The position of the image can be controlled by
  changing the `h` above. Use `t` for top of the page, `b` to bottom of the page,
  `h` to fix the position of the image, and `auto` to let typst decide. The
  alignment of caption can also be adjusted, by changing the `captionAlign` above,
  `l` indicates left, `r` indicates right, and `c` indicates
  center@FigureFunctionTypst.
  ],
) <figure>
]


=== Sub figures
Multi figures can also be combined using the `subfigure` environment.

#FigureBlock(
  captionAlign: "c",
)[
  #figure(
    placement: auto,
    caption: [Pictures of animals.],
  )[
    #grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 10pt,
    )[
      #subfigure(image("figures/gull.jpg"), caption: [A gull], lbl: <fig:gull>)
    ][
      #subfigure(image("figures/tiger.jpg"), caption: [A tiger], lbl: <fig:tiger>)
    ][
      #set align(bottom)
      #subfigure(image("figures/mouse.jpg"), caption: [A mouse], lbl: <fig:mouse>)
    ]
  ]<fig:parent>
]

For more information see #link(
  "https://typst.app/docs/reference/model/figure/",
)[Typst>Reference>Model>Figure].

*Remark:* It is hard to place the iages and tables exactly where we want.
Sometimes it is better to let Typst win.

== Math mode
Euqations can be embedded in the text with `$...$`. For example, $a^2 = b^2 +c^2$.
And can be highlighted with
$
  alpha^2 = beta^2 + gamma^2
$
$
  sum_x^2
$<eq-1>
Code like `<eq-1>` added labels to equations, figures, tables, etc. For
equation, only those with labels will show reference numbering on the right.
This method enables the referencing of equations using @eq-1. The same is true
for figures (@figure, @fig:gull), tables (@table1), sections (@section),
etc@ReferenceFunctionTypst...

For more information see #link("https://typst.app/docs")[Typst documents] and #link(
  "https://sitandr.github.io/typst-examples-book/book/about.html",
)[Typst example book].

= Code snippets
To include code snippets we use a 3#super[rd] party library called `codly`.
Import the library at the beginning of the document@CodlyREADMEMd:

#code(lang: "Typst", ```typ
#import "codly.typ": *
```)


And then you can write code like the example.

#figure(
  code(lang: "C", ```c
        // Simple C program to display "hello world"
        
        // Header file for input output functions
        #include <stdio.h>
        
        // main functions
        // where the excution of program begins
        int main()
        {
          // prints hello world
          printf("hello world");
          return 0;
        }
        ```),
  kind: "code",
  supplement: [Listing],
  caption: [A code listing.],
  placement: auto,
)<code1>

For more information see #link(
  "https://github.com/typst/packages/tree/main/packages/preview/codelst/2.0.0",
). To refer it, use `@code1` to get @code1.

= Lists
The inclusion of list, such as enumerate or bullet points are very easy to make.

== Enumerate
+ Point 1;
   
  + Subpoint 1;
   
  + Subpoint 2;
     
    + Subsubpoint 1;

+ Point 2;

+ Point 3.

Without an empty line between, it will be:
+ Point 1;
+ Point 2;
+ Point 3.

== Bullet points
- Bullet 1;
   
  - Subbullet 1;
    
    - Subsubbullet 1;

- Bullet 2;

- Bullet 3.

Without an empty line between, it will be:
- Bullet 1;
- Bullet 2;
- Bullet 3.

= Tables
Tables are generated with a 3#super[rd] party library called `tablex`. Import it
at the top of the document using:

//     ```typ
// #import "@preview/tablex:0.0.8": *
//     ```
Below is an example of a table.
#show figure.where(kind: table): set figure.caption(position: top)

#figure(tablex(
  auto-lines: false,
  columns: 3,
  (),
  vlinex(),
  vlinex(),
  (),
  [A1],
  [B1],
  [C1],
  hlinex(),
  [A2],
  [B2],
  [C2],
), kind: table, supplement: "Table", caption: [Table caption]) <table1>
For more complex configurations, please refer to #link("https://github.com/PgBiel/typst-tablex").

#bibliography("Typst.bib", title: "References", style: "gb-7714-2005-numeric")

