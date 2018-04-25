#lang pollen

◊chapter[#:index "2"]{Memory and pointers}

◊section{Integers are indices}

Integers have lots of useful properties. They’re ◊keyword{closed} over addition, subtraction, multiplication, and exponentiation, which means the result of applying any of those operations to a pair of integers yields an integer. This means you can do most kinds of arithmetic on integers without ever worrying about losing precision (as long as the result doesn’t cross an overflow boundary).

◊aside{Javascript people! Yes, I know you use floats as array indices! Except they’re not really floats. Most Javascript engines store whole numbers as binary integers, if they are small enough to be representable by the integer type. Incidentally, that’s more or less the range of valid array indices in Javascript.}

More importantly, you can use integers as ◊keyword{indices}, which means if you have an integer ◊math{◊var{n}}, you can use it to refer to the ◊math{◊var{n}}th thing in a sequence. That’s because integers have an inherent ◊keyword{predecessor} and ◊keyword{successor}. It makes sense to ask what comes after 22, but it wouldn’t make much sense to ask what comes after 22.319891 or any other fraction.

This property is important because it lets us talk about ◊keyword{memory}. Memory is made up of ◊keyword{memory cells} which computers use to store bits of data. Memory cells are grouped into bytes (usually containing 8 bits each) called ◊keyword{memory locations}. Memory locations are sequentially numbered giving each one a unique ◊keyword{memory address}. The ◊keyword{address space}, or number of memory locations you can address, is limited by the range of your ◊keyword{pointers}, integer indices representing memory addresses. An 8 bit pointer can address up to 256 memory locations.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td{0} ◊td{1} ◊td{2} ◊td{3} ◊td-invisible{} ◊td{252} ◊td{253} ◊td{254} ◊td{255}
    }
    ◊memory-table-h-cells{
        ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{}
    }
}

◊section{Pointers are indices in memory}

Pointers are numbers. Those numbers are memory addresses, indices of bytes in memory. Since that tends to confuse people, even seasoned programmers from languages that have no concept of pointers, it helps to go slow.

◊aside{Here, we are binding all of the memory to the ◊swift{UInt8} data type so you have some way of telling what binary value each memory location holds. The only memory location that actually has to be an unsigned integer is the pointer itself. All the other locations could be any type.}

Here, we have a pointer in memory location 59. The 8 bit unsigned integer value of the pointer is 63. That number 63 is the index of the memory location that contains the pointer’s ◊keyword{pointee}, 17.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{◊strong{63}} ◊td{64} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{63}} ◊td{0} ◊td{0} ◊td{8} ◊td{17} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}

Don’t confuse the address of the pointee with the pointer’s own address. The address of the pointee is the ◊em{value} of the pointer, it has nothing to do with where in memory the pointer itself lives. In fact, you can have the pointer point to itself. Here, the value of memory location 59 is the number 59.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{◊strong{59}} ◊td{60} ◊td{61} ◊td{62} ◊td{63} ◊td{64} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{59}} ◊td{0} ◊td{0} ◊td{8} ◊td{17} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}

Similarly, don’t confuse the value of the pointee with the value of the pointer (the address of the pointee). You can swap out the contents of the memory location the pointer points to without ever changing the pointer.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{◊strong{63}} ◊td{64} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{63}} ◊td{0} ◊td{0} ◊td{8} ◊td{255} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{◊strong{63}} ◊td{64} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{63}} ◊td{0} ◊td{0} ◊td{8} ◊td{0} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{◊strong{63}} ◊td{64} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{63}} ◊td{0} ◊td{0} ◊td{8} ◊td{69} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}

Changing the value of a pointer changes which memory location it refers to. You can increment a pointer to iterate through a sequence of memory locations.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{◊strong{63}} ◊td{64} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{63}} ◊td{0} ◊td{0} ◊td{8} ◊td{17} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{63} ◊td{◊strong{64}} ◊td{65} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{64}} ◊td{0} ◊td{0} ◊td{8} ◊td{0} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{58} ◊td{59} ◊td{60} ◊td{61} ◊td{62} ◊td{63} ◊td{64} ◊td{◊strong{65}} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td{7} ◊td{◊strong{65}} ◊td{0} ◊td{0} ◊td{8} ◊td{69} ◊td{52} ◊td{0} ◊td-ellipsis{}
    }
}

◊section{Pointers have ordering and arithmetic operations}

◊warning{Not all languages define pointer comparisons and pointer arithmetic the same way Swift does, if at all.}

The value of a pointer is always interpreted as an unsigned integer. You can perform addition or subtraction — ◊keyword{pointer arithmetic} — on a pointer changing which memory location it points to. You can also compare pointer values. A pointer with a smaller unsigned integer value is said to reference an ◊keyword{earlier memory location} than a pointer with a larger unsigned integer value. This means an 8 bit pointer with the bit pattern ◊swift{1111,1111} compares greater than a pointer with the bit pattern ◊swift{0000,0001}. (Even though printing the first pointer as a ◊em{signed} integer would yield “−1”.)

Since they walk and talk like unsigned integers, we could use the data type ◊swift{UInt8} for all of our 8 bit pointers. However, since pointers are conceptually indices of memory locations, not numeric quantities, it makes sense for us to define a new data type just for pointers: ◊swift{UnsafeRawPointer}.

One of the reasons pointers are called “Unsafe” is that they can easily be set to reference a memory location that’s inaccessible, or nonexistent. For example, if you only have memory locations numbered 0 through 120, the pointer 121 points to a memory location that doesn’t exist.

The bigger reason is that they can create inconsistencies in the type system, and potentially undermine type safety if you’re not careful. To understand why, you need to first understand how Swift’s static typing system works.

◊section{Variables carry type information}

◊aside{Static typing is not the same as strong typing, although the two concepts are correlated. C/C++’s type system, for example, is both weak and mostly static.}

In ◊keyword{dynamically typed} languages, type information is carried by the data values themselves. This means, for example, that each ◊swift{Int8} value would have an extra piece of data attached to it labeling it as an ◊swift{Int8}. Normally this piece of data is a pointer to a table of data types. Moving the object around requires moving both pieces of data together as a unit. In contrast, in ◊keyword{statically typed} languages, type information is carried by ◊keyword{variables}. Swift’s type system is mostly static.

◊aside{Some scripting languages like Python instead implement variables using hash maps, a slower but more flexible approach.}

Variables are human-readable names we give to memory locations when coding in a high level language like Swift. In most languages, variables are implemented as hardcoded pointer offsets in the machine code the compiler generates. The offsets are relative to a hidden pointer called the ◊keyword{frame pointer} that lives in a register “outside” of memory, and is not directly accessible in Swift.

◊aside{From now on, you’ll start seeing raw binary values and memory addresses written in ◊keyword{hexadecimal} (base 16) notation instead of 0s and 1s. Each hexadecimal digit represents four bits. In this book, hexadecimal values will always be prefixed with the letter ◊swift{x}.}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{} ◊td{} ◊td{} ◊td{◊strong{x}} ◊td{◊strong{y}} ◊td{} ◊td{} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x3A} ◊td{x3B} ◊td{x3C} ◊td{x3D} ◊td{◊strong{x3E}} ◊td{x3F} ◊td{x40} ◊td{x41} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{}  ◊td[#:class "empty"]{} ◊td{x82} ◊td{xFB} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{}  ◊td-ellipsis{}
    }


}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-cells{
        ◊td-invisible{Frame pointer} ◊td[#:class "solo"]{x3E}
    }
}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Variable name} ◊td{Offset} ◊td{Raw value}
    }
    ◊tr{
        ◊td{x} ◊td{+0} ◊td{x82}
    }
    ◊tr{
        ◊td{y} ◊td{+1} ◊td{xFB}
    }
}

Variables carry type information that tells us how to interpret the data in the memory. It’s important to understand that in this system, the type is seen only by the author and the compiler; it’s not represented or stored anywhere in memory. Here, the variable ◊swift{x} is declared as a ◊swift{UInt8}, and the variable ◊swift{y} is declared as an ◊swift{Int8}. As notation, we write the variable name and variable type separated by a colon with the type to the right, like this: ◊swift{x:UInt8}, ◊swift{y:Int8}.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{} ◊td{} ◊td{} ◊td{◊strong{x}} ◊td{◊strong{y}} ◊td{} ◊td{} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x3A} ◊td{x3B} ◊td{x3C} ◊td{x3D} ◊td{◊strong{x3E}} ◊td{x3F} ◊td{x40} ◊td{x41} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{}  ◊td[#:class "empty"]{} ◊td{130} ◊td{−5} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{}  ◊td-ellipsis{}
    }
}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-cells{
        ◊td-invisible{Frame pointer} ◊td[#:class "solo"]{x3E}
    }
}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Variable} ◊td{Offset} ◊td{Raw value} ◊td{Typed value}
    }
    ◊tr{
        ◊td{x:UInt8} ◊td{+0} ◊td{x82} ◊td{130}
    }
    ◊tr{
        ◊td{y:Int8} ◊td{+1} ◊td{xFB} ◊td{−5}
    }
}

◊aside{The type of a variable does not need to be a concrete type. It’s possible for the data value to carry a concrete type that the variable doesn’t know about. Such a data value is called a ◊keyword{polymorphic object}. All of the data types in this chapter are concrete.}

Because Swift is a strongly typed language, once a variable binds a type to data, it is impossible to make the variable bind a different type later in the program.

◊section{Raw pointers point to arbitrary memory}

If you only ever access memory through variables, then Swift can enforce type safety perfectly since the compiler tracks type consistency through variables. However, pointers provide a way to reference and retrieve data values that live in memory locations not attached to a variable.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{} ◊td{} ◊td{} ◊td{◊strong{x}} ◊td{◊strong{y}} ◊td{◊strong{ptr}} ◊td{} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x3A} ◊td{◊strong{x3B}} ◊td{x3C} ◊td{x3D} ◊td{◊strong{x3E}} ◊td{x3F} ◊td{x40} ◊td{x41} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xDC} ◊td[#:class "empty"]{}  ◊td[#:class "empty"]{} ◊td{130} ◊td{−5} ◊td{x3B} ◊td[#:class "empty"]{} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-cells{
        ◊td-invisible{Frame pointer} ◊td[#:class "solo"]{x3E}
    }
}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Variable} ◊td{Offset} ◊td{Raw value} ◊td{Typed value}
    }
    ◊tr{
        ◊td{x:UInt8} ◊td{+0} ◊td{x82} ◊td{130}
    }
    ◊tr{
        ◊td{y:Int8} ◊td{+1} ◊td{xFB} ◊td{−5}
    }
    ◊tr{
        ◊td{ptr:UnsafeRawPointer} ◊td{+2} ◊td{x3B} ◊td{x3B}
    }
}

The type of the variable ◊swift{ptr} is ◊swift{UnsafeRawPointer}, which doesn’t tell you anything about the type of its pointee. The pointee, which lives in memory location ◊swift{x3B} and has the value ◊swift{xDC}, is not (necessarily) an ◊swift{UnsafeRawPointer}.

◊section{Typed pointers specify the pointee’s type}

Like almost all languages that support pointers, Swift provides ◊keyword{typed pointer types} (yes, you read that right) that specify the pointee’s type. This is as opposed to a pointer type that doesn’t specify the pointee’s type, which is called a ◊keyword{raw pointer}, hence the name ◊swift{UnsafeRawPointer}. In Swift, we use the ◊swift{UnsafePointer} type to represent a typed pointer, and put the pointee type in angle brackets like this: ◊swift{UnsafePointer<Int8>}.

◊aside{Remember, the pointee type only applies to the pointee — the −36 living in memory location ◊swift{x3B}. The pointer value ◊swift{x3B} living in location ◊swift{x40} is still a pointer.}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{} ◊td{} ◊td{} ◊td{◊strong{x}} ◊td{◊strong{y}} ◊td{◊strong{ptr}} ◊td{} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x3A} ◊td{◊strong{x3B}} ◊td{x3C} ◊td{x3D} ◊td{◊strong{x3E}} ◊td{x3F} ◊td{x40} ◊td{x41} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{−36} ◊td[#:class "empty"]{}  ◊td[#:class "empty"]{} ◊td{130} ◊td{−5} ◊td{x3B} ◊td[#:class "empty"]{} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-cells{
        ◊td-invisible{Frame pointer} ◊td[#:class "solo"]{x3E}
    }
}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Variable} ◊td{Offset} ◊td{Raw value} ◊td{Typed value}
    }
    ◊tr{
        ◊td{x:UInt8} ◊td{+0} ◊td{x82} ◊td{130}
    }
    ◊tr{
        ◊td{y:Int8} ◊td{+1} ◊td{xFB} ◊td{−5}
    }
    ◊tr{
        ◊td{ptr:UnsafePointer<Int8>} ◊td{+2} ◊td{x3B} ◊td{x3B}
    }
}

◊aside{Swift generics are something of a mixture between C# generics, and Rust generics and C++ templates.}

When the pointee type is combined with ◊swift{UnsafePointer} like that, it becomes a ◊keyword{type parameter} or a ◊keyword{generic parameter}. (The two terms mean the same thing.) A type that takes a generic parameter is called a ◊keyword{generic type}. If we just want to talk about the generic type in general without mentioning a specific type parameter, we usually write a letter like “T” or “U” where the type parameter goes, or use a placeholder word describing what “kind” of type belongs there, for example: ◊swift{UnsafePointer<Pointee>}.

Why not just define new data types like “◊swift{UnsafePointerToInt8}”, “◊swift{UnsafePointerToUInt8}”, “◊swift{UnsafePointerToUnsafeRawPointer}”, etc, instead of using a type parameter? Type parameters give you flexibility that providing a bunch of standard library pointer types can’t. For example, you can make ◊swift{UnsafePointer<Pointee>}s to custom types you define, and make ◊swift{UnsafePointer<Pointee>}s to other ◊swift{UnsafePointer<Pointee>}s.

◊section{Typed pointers can still create inconsistencies}

There’s a reason ◊swift{UnsafePointer<Pointee>} still has the “Unsafe” prefix. While typed pointers are safer than raw pointers, they are still unsafe. Because pointers point into arbitrary memory, there is no way of guaranteeing the values there are actually valid for that type. It can point to junk values, or to something that’s meant to be interpreted as a different type than the given pointee type. In the example below, ◊swift{ptr2:UnsafePointer<UInt8>} points to the same location as ◊swift{ptr1:UnsafePointer<Int8>}, except ◊swift{ptr2} is viewing the value as a ◊swift{UInt8}. So while ◊swift{ptr1} sees the ◊swift{xDC} value as a −36, ◊swift{ptr2} sees it as a 220.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{} ◊td{} ◊td{} ◊td{◊strong{x}} ◊td{◊strong{y}} ◊td{◊strong{ptr1}} ◊td{◊strong{ptr2}} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x3A} ◊td{◊strong{x3B}} ◊td{x3C} ◊td{x3D} ◊td{◊strong{x3E}} ◊td{x3F} ◊td{x40} ◊td{x41} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xDC} ◊td[#:class "empty"]{}  ◊td[#:class "empty"]{} ◊td{130} ◊td{−5} ◊td{x3B} ◊td{x3B} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-cells{
        ◊td-invisible{Frame pointer} ◊td[#:class "solo"]{x3E}
    }
}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Variable} ◊td{Offset} ◊td{Raw value} ◊td{Typed value}
    }
    ◊tr{
        ◊td{x:UInt8} ◊td{+0} ◊td{x82} ◊td{130}
    }
    ◊tr{
        ◊td{y:Int8} ◊td{+1} ◊td{xFB} ◊td{−5}
    }
    ◊tr{
        ◊td{ptr1:UnsafePointer<Int8>} ◊td{+2} ◊td{x3B} ◊td{x3B}
    }

    ◊tr{
        ◊td{ptr2:UnsafePointer<UInt8>} ◊td{+3} ◊td{x3B} ◊td{x3B}
    }
}

There’s lots of cases where you want to do something like this. However, Swift’s type safety won’t protect you from mismatch bugs here.

◊section{Multibyte values}

So far all of our data types have been exactly 8 bits long. You can’t count past 255 (unsigned), or 127 (signed) without overflow. The more pressing problem is that since our pointers are 8 bits long, we can only address 255 memory locations. That’s not a lot of memory. To address more memory, you need longer integer types, and to get longer integer types, you need more bits.

One way to get more bits is to make the bytes longer, say 16 bits instead of 8. The ◊link["https://en.wikipedia.org/wiki/LC-3"]{LC-3} does this. The downside of this is now, 16 bits is also your ◊em{minimum} integer length, since it’s fairly hard to extract just part of a byte.

◊aside{16 bit and 64 bit integers are equivalent to ◊swift{short} and ◊swift{long} in C-family languages.}

Instead, every “real” architecture strings multiple bytes together to get longer integers. Two bytes make a 16 bit integer, four make a 32 bit integer, and eight make a 64 bit integer. In Swift, these types are called ◊swift{Int16}, ◊swift{Int32}, and ◊swift{Int64}. Their unsigned varieties are called ◊swift{UInt16}, ◊swift{UInt32}, and ◊swift{UInt64}.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{◊strong{x}} ◊td{◊strong{y}} ◊td{} ◊td{◊strong{z}} ◊td{} ◊td{} ◊td-invisible{} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x66} ◊td{◊strong{x67}} ◊td{x68} ◊td{x69} ◊td{x6A} ◊td{x6B} ◊td{x6C} ◊td{x6D} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xA1} ◊td[#:colspan "2"]{xBADD} ◊td[#:colspan "4"]{xCAFEBABE} ◊td-ellipsis{}
    }
}
◊table[#:class "memory-table-h"]{
    ◊memory-table-h-cells{
        ◊td-invisible{Frame pointer} ◊td[#:class "solo"]{x67}
    }
}

◊table[#:class "data-table"]{
    ◊tr{
        ◊td{Variable} ◊td{Offset} ◊td{Raw value} ◊td{Typed value}
    }
    ◊tr{
        ◊td{x:Int8} ◊td{+0} ◊td{xA1} ◊td{−95}
    }
    ◊tr{
        ◊td{y:Int16} ◊td{+1} ◊td{xBADD} ◊td{−17,699}
    }
    ◊tr{
        ◊td{z:Int32} ◊td{+3} ◊td{xCAFEBABE} ◊td{−889,275,714}
    }
}

◊aside{The address of a multibyte value is the address of its first byte (the byte with the lowest address).}

The order that the bytes are sequenced within each multibyte value is called its ◊keyword{endianness} or ◊keyword{byte order}. A ◊keyword{big-endian} integer stores its most significant bits first.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{◊strong{x}} ◊td[#:colspan "2"]{◊strong{y} ◊br{}(big-end.)} ◊td[#:colspan "4"]{◊strong{z} ◊br{}(big-end.)} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x66} ◊td{◊strong{x67}} ◊td{x68} ◊td{x69} ◊td{x6A} ◊td{x6B} ◊td{x6C} ◊td{x6D} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xA1} ◊td{xBA} ◊td{xDD} ◊td{xCA} ◊td{xFE} ◊td{xBA} ◊td{xBE} ◊td-ellipsis{}
    }
}

A ◊keyword{little-endian} integer stores its ◊em{least} significant bits first. This means rebinding a little-endian integer to the ◊swift{UInt8} type will read its least significant 8 bits, not its most significant 8 bits.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{◊strong{x}} ◊td[#:colspan "2"]{◊strong{y} ◊br{}(little-end.)} ◊td[#:colspan "4"]{◊strong{z} ◊br{}(little-end.)} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x66} ◊td{◊strong{x67}} ◊td{x68} ◊td{x69} ◊td{x6A} ◊td{x6B} ◊td{x6C} ◊td{x6D} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xA1} ◊td{xDD} ◊td{xBA} ◊td{xBE} ◊td{xBA} ◊td{xFE} ◊td{xCA} ◊td-ellipsis{}
    }
}

Byte order does not affect the order of the bits inside each byte. The bits in the first byte of a little-endian integer are exactly the same as the bits in the last byte of a big-endian integer.

Little-endian is more common than big-endian. In general, you should think of multibyte values as ◊keyword{atomic}, i.e. as a single, opaque chunk. Never try to split or splice a multibyte integer without knowing the byte order of the platform.

◊section{Memory alignment}

Almost every modern processor can retrieve multiple bytes of memory at a time. Otherwise it would take forever to get all eight bytes out of an ◊swift{Int64}. However, they can’t just grab any two or four or eight bytes. They can only access slices of memory that are situated on multiples of two, four, eight etc.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td[#:colspan "10"]{1-byte access}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x28} ◊td{x29} ◊td{x2A} ◊td{x2B} ◊td{x2C} ◊td{x2D} ◊td{x2E} ◊td{x2F} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td[#:class "empty"]{} ◊td-ellipsis{}
    }
}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td[#:colspan "10"]{2-byte access}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x28} ◊td{x29} ◊td{x2A} ◊td{x2B} ◊td{x2C} ◊td{x2D} ◊td{x2E} ◊td{x2F} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty" #:colspan "2"]{} ◊td[#:class "empty" #:colspan "2"]{} ◊td[#:class "empty" #:colspan "2"]{} ◊td[#:class "empty" #:colspan "2"]{} ◊td-ellipsis{}
    }
}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td[#:colspan "10"]{4-byte access}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x28} ◊td{x29} ◊td{x2A} ◊td{x2B} ◊td{x2C} ◊td{x2D} ◊td{x2E} ◊td{x2F} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty" #:colspan "4"]{} ◊td[#:class "empty" #:colspan "4"]{} ◊td-ellipsis{}
    }
}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td[#:colspan "10"]{8-byte access}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x28} ◊td{x29} ◊td{x2A} ◊td{x2B} ◊td{x2C} ◊td{x2D} ◊td{x2E} ◊td{x2F} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty" #:colspan "8"]{} ◊td-ellipsis{}
    }
}

Failing to align a multibyte integer with a memory slice can have a negative impact on performance, since the integer will be split across two slices, and so the CPU will have to retrieve two slices instead of one, as well as perform the appropriate shifts and fuse the integer back together in a register.

Swift will automatically align all multibyte values to the correct memory alignment. However, it’s important to be aware of this because it can cause empty spaces called ◊keyword{padding bytes} to appear between different-sized values. For example, a padding byte appears between these three integers below.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x28} ◊td{x29} ◊td{x2A} ◊td{x2B} ◊td{x2C} ◊td{x2D} ◊td{x2E} ◊td{x2F} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:colspan "2"]{Int16} ◊td{Int8} ◊td[#:class "empty"]{}  ◊td[#:colspan "4"]{Int32} ◊td-ellipsis{}
    }
}

This becomes important when we discuss structures and arrays.

◊section{The pointer size is the default integer size}

Since Swift has four different sizes of signed integers, and four different sizes of unsigned integers, it can get confusing deciding which integer type to use when, and making them all play nice with one another. It would be fantastic to just settle on a single “default” integer type that you could use for everything, and leave the zoo of sized integers for specialized uses.

In C and C++, most people picked ◊swift{Int32} for this, mainly because the extra bit of range in an unsigned integer wasn’t worth the inability to represent negative numbers, and because all of the other sizes had longer names that required more typing. (◊swift{Int32} was just written as ◊swift{int} in C; to get the other sizes, you had to type ◊swift{short} or ◊swift{long} before it.)

◊aside{Don’t infer from this that Swift’s pointers are ◊em{signed}. Pointers have no concept of sign, and if you remember from the last chapter, signed representation is irrelevant to the mechanics of arithmetic itself; it’s merely a way to interpret the result.}

In Swift, the default integer size is signed, and is the same size as a pointer. This makes it easier to do pointer arithmetic, since you don’t have to convert types to make the two operands compatible. Making integers and pointers the same size (and therefore having the same alignment) also makes them pack better, wasting fewer padding bytes.

In the past, pointers were 32 bits long. Machines that operated with 32 bit pointers were “32 bit machines”. Since a ◊swift{UInt32} has a maximum value of 4,294,967,295, this meant you could only address about 4 gigabytes of RAM. That used to be plenty, but today, computers regularly feature upwards of 16 gigabytes of RAM, necessitating the transition to 64 bit pointers.

◊aside{This quantity is often referred to as the platform ◊keyword{word size}, though the term has several (conflicting) meanings which limit its usefulness.}

Because pointers today are either 64 bits long, or less commonly, 32 bits long, depending on the platform, Swift defines an integer type ◊swift{Int} which is the same size as a platform pointer, whatever that size is. This type also has an unsigned companion called ◊swift{UInt}. Most of the Swift standard library is built around ◊swift{Int}, and so you should prefer it over ◊swift{UInt} and the sized integer types whenever the integer’s binary format does not matter to you.
