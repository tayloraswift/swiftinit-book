#lang pollen

◊chapter[#:index "1"]{Binary data types}

◊keyword{Bits} form the basis of all contemporary computing. Computers run on bits because bits are the smallest possible unit of information — a yes or a no, or a 0 or a 1. (Someday, we’ll have quantum computers that run on “qubits” but we’re only going to talk about ordinary bits here.)

We can use bits as ◊keyword{digits} to form a number system. This number system is a ◊keyword{binary} number system, since each binary digit can only take two possible values. (The word ◊em{bit} is actually short for ◊em{◊strong{b}inary ◊strong{d}igit}.) In contrast, our human number system is a ◊keyword{decimal} number system, made out of decimal digits that can take ten possible values, 0 through 9.

◊section{Bits can represent whole numbers}

Just as we can string together multiple decimal digits to represent numbers bigger than 9, we can string together multiple bits to represent numbers bigger than 1. You might remember from elementary school that digits have ◊keyword{place values} depending on their positions in the sequence. In decimal, the place values are ones, tens, hundreds, thousands, and so on. In binary, the place values are ones, twos, fours, eights, sixteens, and so on.

The digit with the smallest place value is called the ◊keyword{least significant digit}, and the digit with the largest place value is called the ◊keyword{most significant digit}. In English, we usually write the least significant digit on the right and the most significant digit on the left.

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

The largest number you can count up to with ◊math{◊var{n}} unsigned decimal digits is ◊math{10◊exponent{◊var{n}} − 1}. If you have three decimal digits, you can count up to ◊math{10◊exponent{3} − 1}, or 999. Similarly, if you have ◊math{◊var{n}} binary digits, you can count all the way up to ◊math{2◊exponent{◊var{n}} − 1}. So if you have three bits, you can count all the way up to ◊math{2◊exponent{3} − 1}, or 7.

Almost all computers today store bits in groups of eight, called ◊keyword{bytes}. The exceptions are too few to be within the scope of this book. A byte can take ◊math{2◊exponent{8}} possible values. This means if you start from 0 (◊code{0000,0000}), you can count all the way up to ◊math{2◊exponent{8} − 1}, or 255 (◊code{1111,1111}). We define this as the ◊keyword{unsigned integer interpretation} of a byte value.

◊section{Binary addition}

Binary addition works a lot like decimal addition. You add up the bits in each place value from least to most significant, carrying the 1 when appropriate.

◊centered-ascii-figure{  1 1
  0 1 1 0 = 6
+ 0 0 1 1 = 3
—————————
  1 0 0 1 = 9
}

If a 1 gets carried off of the last bit, the result will have one more bit than either of the inputs. Computers, however, work on a fixed number of bits. If you carry a 1 off of the last bit in an 8-bit addition, that carried 1 is lost, effectively subtracting 256 from the result. 

◊centered-ascii-figure{  1 1 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 = 255
+   0 0 0 0 0 0 0 1 =   1
———————————————————
  _ 0 0 0 0 0 0 0 0 =   0???
}

◊aside{A few languages like Java, Ruby, and Python automatically extend their integer types at run-time when they detect overflow, a lot like how you would use extra space on the the paper to write down the carry-out digit when doing addition by hand. These integer types are called ◊keyword{bignums} or ◊keyword{big integers}. These languages sacrifice speed so that you don’t have to worry about integer overflow. Swift makes the opposite tradeoff, making Swift programs fast, but susceptible to integer overflow.}

This means if you keep incrementing an unsigned byte value, it will eventually wrap around and start counting back up from zero. A good physical anology is an analog car odometer — once it hits 999,999, the next number it shows is 000,000. This phenomenon is called ◊keyword{integer overflow}.

◊section{Integer overflow gives us subtraction}

We could try and do binary subtraction just like we did binary addition.

◊centered-ascii-figure{             −1 10
  0 0 0 1 0 0 1 0 = 18
− 0 0 0 0 0 0 0 1 =  1
—————————————————
  0 0 0 1 0 0 0 1 = 17
}

Subtraction is a lot harder than addition, mostly because you have to borrow, though in principle, you ◊em{could} build a CPU circuit that performs subtraction just like the one that performs addition. But it turns out there’s an easier way.

Imagine that you have space for three decimal digits — you can count from 0 all the way to 999. One way to subtract 1 from an arbitrary three-digit decimal number, ◊em{without actually doing subtraction}, is to ◊em{add} 999 to it. For example, if you had the number 25, adding 999 to it would give you 1024. But since you don’t have a thousands place, you just end up with 24.

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

In other words, to subtract a number ◊math{◊var{n}}, you add ◊math{◊var{n}} less than the ◊em{smallest number not representable} by the digits you have. Remember, this number is equal to ◊math{◊var{base} ◊exponent{◊var{digits}}}. So for an 8-bit value, you subtract 1 by adding 255. You subtract 2 by adding 254, and so forth. You can use addition to get subtraction for free.

◊section{Subtraction gives us negative numbers}

◊aside{This should come naturally to any of you who know ◊keyword{modular arithmetic}. If you haven’t figured it out already, the ◊keyword{modulus} of a binary number with ◊math{◊var{n}} bits is always ◊math{2◊exponent{◊var{n}}}.}

Mind you that subtracting ◊math{◊var{n}} is the same thing as adding ◊math{−◊var{n}}. And since we just established that subtracting ◊math{◊var{n}} is also the same thing as adding ◊math{◊var{base} ◊exponent{◊var{digits}} − ◊var{n}}, that implies that ◊math{−◊var{n} = ◊var{base} ◊exponent{◊var{digits}} − ◊var{n}}. Now we have ◊em{two} ways of interpreting any binary number. We can interpret the 8 bit number ◊code{0101,1001} as the positive number ◊math{89}, or we can interpret it as the negative number ◊math{89 − 256 = −167}.

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

Up until now, every 8 bit number has had two interpretations — a positive one, and a negative one. This is pretty silly, so we’ll define numbers with 1 as their most significant bit as negative, and numbers with 0 as their most significant bit as positive. For our purposes, zero rolls with the positives. We call this the ◊keyword{signed integer interpretation} of a binary value. The smallest byte value when viewed as a signed integer is ◊code{1000,0000}, or −128. The largest is ◊code{0111,1111}, or +127. Contrast with the unsigned integer interpretation which starts with ◊code{0000,0000}, or 0, and ends with ◊code{1111,1111}, or 255.

◊aside{Flipping the most significant bit of a signed byte adds 128 to its numeric value, mapping the range ◊math{[−128, 128) to [0, 256)}. Do you understand why?}

Defining negatives and positives this way makes comparisons easy because you can compare any two signed integers by flipping their most significant bit, and then comparing them as if they were unsigned integers.

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
