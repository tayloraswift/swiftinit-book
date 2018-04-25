#lang pollen

◊chapter[#:index "2"]{Memory and addressing}

◊keyword{Memory} is one of the means by which computers store bytes. Memory is also referred to as ◊keyword{primary storage}. Memory can be thought of as an array of sequentially indexed cells, called ◊keyword{memory locations}, each of which can hold a single byte. This is, in fact, the formal definition of a byte — the size of a single memory location — which corresponds to 8 bits on almost all extant computer architectures.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td{0} ◊td{1} ◊td{2} ◊td{3} ◊td{4} ◊td{5} ◊td{6} ◊td{7}  ◊td-invisible{} 
    }
    ◊memory-table-h-cells{
        ◊td{???} ◊td{???} ◊td{???} ◊td{???} ◊td{???} ◊td{???} ◊td{???} ◊td{???} ◊td-ellipsis{} 
    }
}

The indices of the storage units are called ◊keyword{memory addresses}. Operations on data in memory are defined by supplying both the operation to perform, and the address of the memory location to perform it on.

In concept, all memory locations can be accessed equally quickly. Though this is emphatically ◊em{not} true in practice, any memory location can nevertheless be accessed without traversing all the memory locations between it and the previously accessed location. Memory is sometimes called ◊keyword{random access memory}, or ◊keyword{RAM}, to emphasize this property.

◊section{Addresses are integers}

◊aside{Javascript people! Yes, I know you use floats as array indices! Except they’re not really floats. Most Javascript engines store whole numbers as binary integers, if they’re small enough to be representable by the integer type. Incidentally, that’s more or less the range of valid array indices in Javascript.}

Integers are ◊strong{countable}, which means if you have an integer ◊math{◊var{n}}, you can use it to refer to the ◊math{◊var{n}}th thing in a sequence. That’s because integers have an inherent ◊keyword{predecessor} and ◊keyword{successor}. It makes sense to ask what comes after 22, but it wouldn’t make much sense to ask what comes after 22.319891 or any other fraction.

This property is important because it means we can use integers to represent memory addresses. These integers are called ◊strong{pointers}. The range of addresses that pointers can represent is known as the ◊keyword{address space}. 8-bit pointers have a 256-byte address space.

◊section{Multibyte values}

So far all of our integer types have been exactly 8 bits long. This means we can only address 256 unique memory locations. That’s not a lot of memory. To address more memory, we need longer integer types, and to get longer integer types, we need more bits.

One way to get more bits is to make the bytes bigger, say 16 bits instead of 8. The ◊link["https://en.wikipedia.org/wiki/LC-3"]{LC-3} does this. The downside of this is, now, 16 bits is also your ◊em{minimum} integer length, since it’s relatively hard to extract just part of a byte.

Instead, most architectures string multiple 8-bit bytes together to make longer integers. Two bytes make a 16-bit integer, four make a 32-bit integer, and eight make a 64-bit integer. 

◊aside{From now on, you’ll start seeing raw binary values and memory addresses written in ◊keyword{hexadecimal} (base 16) notation instead of 0s and 1s. Each hexadecimal digit represents four bits. In this book, hexadecimal values will always be prefixed with the letter ◊swift{x}.}

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{◊strong{x}} ◊td[#:colspan "2"]{◊strong{y}} ◊td[#:colspan "4"]{◊strong{z}} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x66} ◊td{x67} ◊td{x68} ◊td{x69} ◊td{x6A} ◊td{x6B} ◊td{x6C} ◊td{x6D} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xA1} ◊td[#:colspan "2"]{xBADD} ◊td[#:colspan "4"]{xCAFEBABE} ◊td-ellipsis{}
    }
}

The way the bits of a multibyte integer are distributed among its constituent bytes is called its ◊keyword{endianness} or ◊keyword{byte order}. A ◊keyword{big-endian} integer stores its most significant bits first.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{◊strong{x}} ◊td[#:colspan "2"]{◊strong{y} ◊br{}(big-end.)} ◊td[#:colspan "4"]{◊strong{z} ◊br{}(big-end.)} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x66} ◊td{x67} ◊td{x68} ◊td{x69} ◊td{x6A} ◊td{x6B} ◊td{x6C} ◊td{x6D} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xA1} ◊td{xBA} ◊td{xDD} ◊td{xCA} ◊td{xFE} ◊td{xBA} ◊td{xBE} ◊td-ellipsis{}
    }
}

In contrast, a ◊keyword{little-endian} integer stores its ◊em{least} significant bits first. 

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{} ◊td{◊strong{x}} ◊td[#:colspan "2"]{◊strong{y} ◊br{}(little-end.)} ◊td[#:colspan "4"]{◊strong{z} ◊br{}(little-end.)} ◊td-invisible{}
    }
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x66} ◊td{x67} ◊td{x68} ◊td{x69} ◊td{x6A} ◊td{x6B} ◊td{x6C} ◊td{x6D} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:class "empty"]{} ◊td{xA1} ◊td{xDD} ◊td{xBA} ◊td{xBE} ◊td{xBA} ◊td{xFE} ◊td{xCA} ◊td-ellipsis{}
    }
}

◊aside{The address of a multibyte value is the address of its first byte (the byte with the lowest address).}

Whether a value is big- or little-endian does not affect the order of the bits inside each byte. The bits in the first byte of a little-endian integer are exactly the same as the bits in the last byte of a big-endian integer. That said, you should think of multibyte values as ◊keyword{atomic}, in other words, as single, opaque chunks. Never try to split or splice a multibyte integer without knowing the byte order of the platform.

Most computer architectures are natively little-endian. Little-endian has useful properties which advantage it over big-endian. A small integer stored in a large integer format has all its meaningful bits in its leading bytes. This means the same number can be read off as different-sized integers from the same address. (A number stored as an 8-byte big-endian integer would have to be read at offset +7 to read it as an 8-bit integer, +6 to view it as a 16-bit integer, and +4 to view it as a 32-bit integer.)

Big-endian is relatively rare. It’s most common in data formats intended for transmission over a network. Since the first byte of a big-endian integer contains its most significant bits, users recieving its bytes in sequence get an initial approximation of the number, with subsequent bytes providing increasing precision.

◊section{Memory alignment}

Almost all modern processors can retrieve multiple bytes of memory at a time. Otherwise it would take a long time to get all eight bytes of a 64-bit integer. However, they can’t just grab any two or four or eight bytes. They can only access slices of memory situated on multiples of specific powers of two.

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

Failing to align a multibyte integer with a memory slice can have a negative impact on performance, since the integer will be split across two slices, and so the CPU will have to retrieve two slices instead of one, as well as perform the appropriate bit shifts and fuse the integer back together. An some architectures, misalignment can even cause a processor error.

Correct alignment can cause empty spaces called ◊keyword{padding bytes} to appear between different-sized values. For example, a padding byte appears between these three integers below.

◊table[#:class "memory-table-h"]{
    ◊memory-table-h-addresses{
        ◊td-invisible{} ◊td{x28} ◊td{x29} ◊td{x2A} ◊td{x2B} ◊td{x2C} ◊td{x2D} ◊td{x2E} ◊td{x2F} ◊td-invisible{}
    }
    ◊memory-table-h-cells{
        ◊td-ellipsis{} ◊td[#:colspan "2"]{16-bit} ◊td{8-bit} ◊td[#:class "empty"]{}  ◊td[#:colspan "4"]{32-bit} ◊td-ellipsis{}
    }
}

Padding will become important when we talk about structures and arrays.
