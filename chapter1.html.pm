#lang pollen

◊chapter[#:index "1"]{Binary data types}

If you already know binary, perhaps if you’re coming from another low-level language like C, it’s not the end of the world if you skip this chapter. But I encourage you to review it anyway. Swift arguably cares more about binary representation than even C does.

◊section{Binary means base two}

◊keyword{Binary} is just another name for ◊keyword{base two}. That’s why binary has two digits — 0 and 1. Our “normal” counting is done in ◊keyword{decimal}, or ◊keyword{base ten}. It has ten digits — 0 through 9.

We usually call ◊strong{b}inary dig◊strong{its} ◊em{◊keyword{bits}} for short. Bits are special because they only exist in two forms, 0 and 1. This makes them easy to represent with electronics — “on” means 1, “off” means 0.

◊section{Data types give meaning to groups of bits}

Data types are specific ways to interpret an otherwise meaningless group of bits. When a binary value has an associated data type, we say that it is ◊keyword{bound} to that specific data type. That data type tells you how you should read the binary value, for example as a number, or a letter, or a true-false value, or as a day of the week, etc. You’ll see examples of specific Swift data types in the coming sections and chapters.

◊aside{When we get into ◊keyword{dynamic programming}, it’s possible for binary data to “tell” you what specific data type it is. But of course, you still have to know to ask it, and that requires knowing enough beforehand to assume that it’s some sort of dynamic data type in the first place.}

Bits have no inherent data type. You cannot look at a binary value and say, ◊inline-quote{well, this looks like a letter to me}. Data types are all in the compiler, and the programmer’s head. CPUs don’t know anything about data types, they operate on data ◊em{assuming} it’s bound to a certain data type, even if that binding doesn’t make any sense.

◊section{Swift is a strongly typed programming language}

Swift is what’s known in the taxonomy of programming languages as a ◊keyword{strongly typed} language. This means that Swift forces you to be specific as to which binary values are bound to which types, and it forces you to be consistent when passing around and operating on those values in your program. This is in contrast to ◊keyword{weakly typed} languages, where “anything goes” and you’re allowed to (accidentally) change the data type of a binary value, changing its meaning.

◊aside{There is a Pythonista reading this who swears that Python is a strongly typed language. This is true — at run-time. Swift is strongly typed at ◊em{compile-time}. This means that in Swift, type bugs get caught while the program is being compiled, whereas in Python, they don’t get caught until they crash the program. Of course, this is still better than them never getting caught at all.}

Using a strongly typed language like Swift might seem like a lot of work. Programmers coming from weakly typed languages like Python, C, and C++ often complain about having to make data types match exactly in Swift. However strong typing can help prevent lots and lots of bugs, since you almost never want to implicitly change the interpretation of a data value. When you do, Swift forces you to be explicit about it. These consistency guarantees are collectively known as ◊keyword{type safety} and it’s one of the most fundamental features of Swift’s design.

◊section{Bits can represent whole numbers}

Just like we can string together multiple decimal digits to represent numbers bigger than 9, we can string together multiple bits to represent numbers bigger than 1. Every base has ◊keyword{place values}. In decimal, the place values are ones, tens, hundreds, thousands, and so on. In binary, the place values are ones, twos, fours, eights, sixteens, and so on.

◊table[#:class "place-table"]{
    ◊tr{
        ◊td{Thousands} ◊td{Hundreds} ◊td{Tens} ◊td{Ones} ◊td{Total}
    }
    ◊tr{
        ◊td{1} ◊td{9} ◊td{8} ◊td{9} ◊td{= 1000 + 900 + 80 + 9}
    }
    ◊tr{
        ◊td[#:colspan "4"]{} ◊td{= 1989}
    }
}

◊table[#:class "place-table"]{
    ◊tr{
        ◊td{Eights} ◊td{Fours} ◊td{Twos} ◊td{Ones} ◊td{Total}
    }
    ◊tr{
        ◊td{1} ◊td{1} ◊td{0} ◊td{1} ◊td{= 8 + 4 + 1}
    }
    ◊tr{
        ◊td[#:colspan "4"]{} ◊td{= 13}
    }
}

Notice that the largest number you can count up to with ◊math{◊var{n}} unsigned decimal digits is ◊math{10◊exponent{◊var{n}} − 1}. If you have three decimal digits, you can count up to ◊math{10◊exponent{3} − 1}, or 999. Similarly, if you have ◊math{◊var{n}} unsigned ◊em{binary} digits, you can count all the way up to ◊math{2◊exponent{◊var{n}} − 1}. So if you have eight bits, you can count all the way up to ◊math{2◊exponent{8} − 1}, or 255.

◊aside{To be perfectly specific, 8 bits is an ◊keyword{octet}, which is ◊em{almost} always the same thing as a byte. The exceptions are too few to be within the scope of this book.}

8 bit sets are special because 8 bits is what we usually call a ◊keyword{byte}. Interpreting a byte as a number between ◊swift{0} and ◊swift{255} (inclusive) is an example of a data type. In Swift, we call it a ◊swift{UInt8}, which is short for unsigned 8-bit integer. “◊keyword{Unsigned}” means it’s always a positive number. “◊keyword{Integer}” means it’s a whole number, and “8-bit” means, well, it’s 8 bits long.

◊section{Integer addition can overflow}

Binary addition works a lot like decimal addition. You add up the bits in each place value from right to left, carrying the 1 when necessary.

◊centered-ascii-figure{  1 1
  0 1 1 0 = 6
+ 0 0 1 1 = 3
—————————
  1 0 0 1 = 9
}

Since this is all implemented in hardware as a nanoscopic circuit inside the CPU, and circuits don’t really have a “right” or “left”, we’ll start calling the bit on the right the ◊keyword{least significant bit}, or ◊keyword{LSB}, and the bit on the left the ◊keyword{most significant bit}, or ◊keyword{MSB}. Significance increases from right to left because the place value gets bigger and bigger.

◊centered-ascii-figure{
0 1 0 1 1 0 0 1
more significant ←→ less significant
}

Remember though, that we have a fixed number of bits. A ◊swift{UInt8} is ◊em{always} 8 bits long, no more, no less. And sometimes, when adding two ◊swift{UInt8}s, you have to carry a 1 off of the most significant bit.

◊centered-ascii-figure{  1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 = 255
+   0 0 0 0 0 0 0 1 =   1
———————————————————
  _ 0 0 0 0 0 0 0 0 =   0???
}

◊aside{A few languages like Java, Ruby, and Python can automatically extend their integer types at run-time when they detect arithmetic overflow, a lot like how you would use extra space on the the paper to write down the carry-out digit when doing addition by hand. These integer types are called ◊keyword{bignums} or ◊keyword{big-integers}. These languages sacrifice performance so that you don’t have to worry about integer overflow. Swift makes the opposite tradeoff, the implication being that Swift programs are fast, but you have to be aware of integer overflow.}

That last 1 gets lost, effectively subtracting 256 from the result. That means that if you keep incrementing a ◊swift{UInt8} value, eventually it will wrap around and start counting back up from zero. Think of an analog car odometer — once it hits 999,999, the next number it shows is 000,000. This phenomenon is called ◊keyword{integer overflow}.

◊section{Integer overflow gives us subtraction}

You ◊em{could} try and do binary subtraction just like we did with binary addition.

◊centered-ascii-figure{             −1 10
  0 0 0 1 0 0 1 0 = 18
− 0 0 0 0 0 0 0 1 =  1
—————————————————
  0 0 0 1 0 0 0 1 = 17
}

Subtraction is a lot harder than addition, mostly because you have to borrow, though in principle, you ◊em{could} build a CPU circuit that performs subtraction just like the one that performs addition. But it turns out there’s an easier way.

The easiest way to understand it is to imagine that you have space for three decimal digits — you can count from 0 all the way to 999. One way to subtract 1 from an arbitrary three-digit decimal number without ◊em{actually doing subtraction} is to ◊em{add} 999 to it. For example, if you had the number 25, adding 999 to it would give you 1024. But 1024 overflows the space for three digits, so you get rid of the 1 in the thousands place, leaving you with 24.

This works because adding 999 is the same as adding 1000 and subtracting 1. Integer overflow then subtracts 1000 from the total, so in the end you are effectively subtracting 1. Similarly, you can subtract 2 by adding 998, 3 by adding 997, and so forth.

◊centered-ascii-figure{   NNN + 999
=  NNN + 1000 − 1
= 1NNN − 1
→  NNN - 1 }

◊centered-ascii-figure{   NNN + 998
=  NNN + 1000 − 2
= 1NNN − 2
→  NNN - 2 }

◊centered-ascii-figure{   NNN + 997
=  NNN + 1000 − 3
= 1NNN − 3
→  NNN - 3 }

In other words, to subtract a number ◊math{◊var{n}}, you add ◊math{◊var{n}} less than the ◊em{smallest number not representable} by the digits you have. Remember, this number is equal to ◊math{◊var{base} ◊exponent{◊var{digits}}}. So for a ◊swift{UInt8}, you subtract 1 by adding 255. You subtract 2 by adding 254, and so forth. You can use addition to get subtraction “for free”.

◊section{Subtraction gives us negative numbers}

◊aside{This should come naturally to any of you who know ◊keyword{modular arithmetic}. If you haven’t figured it out already, the ◊keyword{modulus} of a binary number with ◊math{◊var{n}} bits is always ◊math{2◊exponent{◊var{n}}}.}

Mind you that subtracting ◊math{◊var{n}} is the same thing as adding ◊math{−◊var{n}}. And since we just established that subtracting ◊math{◊var{n}} is also the same thing as adding ◊math{◊var{base} ◊exponent{◊var{digits}} − ◊var{n}}, that implies that ◊math{−◊var{n} = ◊var{base} ◊exponent{◊var{digits}} − ◊var{n}}. Now we have ◊em{two} ways of interpreting any binary number. We can interpret the 8 bit number ◊swift{0101,1001} as the positive number ◊math{89}, or we can interpret it as the negative number ◊math{89 − 256 = −167}.

◊section{Negate numbers using the two’s complement}

◊aside{Don’t confuse the negative of a number with the ◊em{negative interpretation} of a number. The latter always has the exact same bit pattern as the number because it’s just another way of reading it. The negative of a number has a completely different bit pattern.}

Subtraction-by-addition isn’t very useful if you don’t have an easy way of negating a number. Let’s go back to the three-digit decimal example. To get the negative of a three-digit decimal number ◊math{◊var{n}}, you have to compute ◊math{1000 − ◊var{n}}. This quantity is called the ◊keyword{ten’s complement} of the number. But doing ◊math{1000 − ◊var{n}} directly is hard because you have to borrow all the way out to the hundreds place. So instead, we do ◊math{999 − ◊var{n}}, and then add 1 later.

◊centered-ascii-figure{  9 9 9
− 7 8 9
———————
  2 1 0 = nines complement
+     1
———————
  2 1 1 = ten’s complement
}

◊aside{Don’t confuse the nines complement with the ◊em{nine’s} complement. (There’s an apostrophe.) The nines complement (without the apostrophe) is a digit-wise operation ◊math{999 − ◊var{n}}. The nine’s complement (with the apostrophe) is equal to ◊math{9◊exponent{3} − ◊var{n} = 729 − ◊var{n}}, and is utterly irrelevant here.}

Notice that no matter what you subtract from 999, you ◊em{never} have to borrow. This means you can do the subtraction on each pair of digits without having to worry about any of the surrounding digits. We call the result of ◊math{999 − ◊var{n}} the ◊keyword{nines complement} of ◊math{◊var{n}}. Then we add 1 to get ◊math{1000 − ◊var{n}}, but we already know how to add 1 to a number.

Doing it in binary is even easier because computing the ◊keyword{ones complement} is just a matter of flipping the bits. Adding 1 gives you the ◊keyword{two’s complement}, the negative of the number.

◊centered-ascii-figure{  1 1 1 1 1 1 1 1
− 0 1 0 1 1 0 0 1
—————————————————
  1 0 1 0 0 1 1 0 = ones complement
+               1
—————————————————
  1 0 1 0 0 1 1 1 = two’s complement
}

◊section{The most significant bit separates negative numbers from positive numbers}

◊aside{What about zero, you ask? Zero is signless because its complement in any base is always itself. Don’t believe me? Try it!}

Up until now, every 8 bit number has had two interpretations — a positive one, and a negative one. This is pretty silly, so we’ll define numbers with 1 as their most significant bit as negative, and numbers with 0 as their most significant bit as positive. For our purposes, zero rolls with the positives. We’ll make this a new data type — a ◊em{signed} 8 bit integer, or an ◊swift{Int8}. (Because ◊swift{SInt8} sounds stupid.) The smallest ◊swift{Int8} is ◊swift{1000,0000}, or −128. The largest ◊swift{Int8} is ◊swift{0111,1111}, or +127.

◊aside{Flipping the most significant bit of an ◊swift{Int8} adds 128 to its numeric value, mapping the range ◊math{[−128, 128) to [0, 256)}. Do you understand why?}

Defining negatives and positives this way makes comparisons easy because you can compare any two ◊swift{Int8}s by flipping their most significant bit, and then comparing them as if they were ◊swift{UInt8}s.

Just like unsigned integers, signed integers can overflow. However, in terms of bit patterns, their overflow boundary occurs ◊link["https://xkcd.com/571/"]{half a period out of phase} with that of unsigned integers.

◊warning{Unlike Swift, in some languages such as C and C++, signed integer overflow is undefined behavior.}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Bit pattern} ◊td{Signed value} ◊td{Unsigned value} ◊td-invisible{}
    }
    ◊tr{
        ◊td{0000,0000} ◊td{0} ◊td{0}
    }
    ◊tr{
        ◊td{0000,0001} ◊td{1} ◊td{1}
    }
    ◊tr{
        ◊td{0000,0010} ◊td{2} ◊td{2}
    }
    ◊tr{
        ◊td{0000,0011} ◊td{3} ◊td{3}
    }
    ◊tr{
        ◊td-ellipsis{} ◊td-ellipsis{} ◊td-ellipsis{}
    }
    ◊tr{
        ◊td{0111,1110} ◊td{126} ◊td{126}
    }
    ◊tr{
        ◊td{0111,1111} ◊td{127} ◊td{127}
    }
    ◊tr{
        ◊td{1000,0000} ◊td-highlight[#:background-color "rgba(255, 0, 50, 0.2)"]{−128} ◊td{128} ◊td-annotation{← Signed overflow}
    }
    ◊tr{
        ◊td{1000,0001} ◊td{−127} ◊td{129}
    }
    ◊tr{
        ◊td{1000,0010} ◊td{−126} ◊td{130}
    }
    ◊tr{
        ◊td-ellipsis{} ◊td-ellipsis{} ◊td-ellipsis{}
    }
    ◊tr{
        ◊td{1111,1101} ◊td{−3} ◊td{253}
    }
    ◊tr{
        ◊td{1111,1110} ◊td{−2} ◊td{254}
    }
    ◊tr{
        ◊td{1111,1111} ◊td{−1} ◊td{255}
    }
    ◊tr{
        ◊td{0000,0000} ◊td{0} ◊td-highlight[#:background-color "rgba(255, 0, 50, 0.2)"]{0} ◊td-annotation{← Unsigned overflow}
    }
}
