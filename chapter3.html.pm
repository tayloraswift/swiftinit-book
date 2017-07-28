#lang pollen

◊chapter[#:index "3"]{Symbols}

Until now, this book has contained very little actual Swift syntax. This was intentional. I always hated books that introduced syntax before explaining what any of it actually meant. The first two chapters were meant to establish the building blocks of Swift’s functionality — data types, integers, pointers, and memory. Throwing too much syntax into the mix would have been confusing. Now, we’ll establish the building blocks of Swift’s syntax and explore how Swift code is written in text before it’s fed to the compiler.

◊section{Swift has symbols, punctuation, and literals}

In English, text is divided into words and punctuation. The words are the stuff of the text, and the punctuation is the glue that puts it together and gives it meaning. Similarly, Swift has ◊keyword{symbols} and punctuation. Symbols are names that identify the stuff in a program, like variables, ◊keyword{functions}, and ◊keyword{types}.

Punctuation in programming languages isn’t the same as in English. In Swift, ◊swift{+} is a symbol — the addition operator — even though in English it’s considered “punctuation”. Conversely, ◊keyword{keywords} like ◊swift{while}, ◊swift{guard}, and ◊swift{return} are words in English, but punctuation in Swift.

Most of the “special characters” on your keyboard are operators — ◊swift{=}, ◊swift{+}, ◊swift{-}, ◊swift{*}, ◊swift{/}, ◊swift{!}, ◊swift{?}, ◊swift{%}, ◊swift{^}, ◊swift{&}, ◊swift{|}, and ◊swift{~} are all operators. 
