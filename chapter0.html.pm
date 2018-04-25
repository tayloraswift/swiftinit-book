#lang pollen

◊chapter[#:index "0"]{Introduction}

Hello Swift!


◊section{Data types give meaning to groups of bits}

Data types are specific ways to interpret an otherwise meaningless group of bits. When a binary value has an associated data type, we say that it is ◊keyword{bound} to that specific data type. That data type tells you how you should read the binary value, for example as a number, or a letter, or a true-false value, or as a day of the week, etc. You’ll see examples of specific Swift data types in the coming sections and chapters.

◊aside{When we get into ◊keyword{dynamic programming}, it’s possible for binary data to “tell” you what specific data type it is. But of course, you still have to know to ask it, and that requires knowing enough beforehand to assume that it’s some sort of dynamic data type in the first place.}

Bits have no inherent data type. You cannot look at a binary value and say, ◊inline-quote{well, this looks like a letter to me}. Data types are all in the compiler, and the programmer’s head. CPUs don’t know anything about data types, they operate on data ◊em{assuming} it’s bound to a certain data type, even if that binding doesn’t make any sense.

◊section{Swift is a strongly typed programming language}

Swift is what’s known in the taxonomy of programming languages as a ◊keyword{strongly typed} language. This means that Swift forces you to be specific as to which binary values are bound to which types, and it forces you to be consistent when passing around and operating on those values in your program. This is in contrast to ◊keyword{weakly typed} languages, where “anything goes” and you’re allowed to (accidentally) change the data type of a binary value, changing its meaning.

◊aside{There is a Pythonista reading this who swears that Python is a strongly typed language. This is true — at run-time. Swift is strongly typed at ◊em{compile-time}. This means that in Swift, type bugs get caught while the program is being compiled, whereas in Python, they don’t get caught until they crash the program. Of course, this is still better than them never getting caught at all.}

Using a strongly typed language like Swift might seem like a lot of work. Programmers coming from weakly typed languages like Python, C, and C++ often complain about having to make data types match exactly in Swift. However strong typing can help prevent lots and lots of bugs, since you almost never want to implicitly change the interpretation of a data value. When you do, Swift forces you to be explicit about it. These consistency guarantees are collectively known as ◊keyword{type safety} and it’s one of the most fundamental features of Swift’s design.
