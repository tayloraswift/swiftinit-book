#lang pollen

◊chapter[#:index "3"]{Computing}

Memory allows a computer to store data but to make it actually ◊em{do anything}, you have to feed it ◊keyword{instructions} to execute. 

Instructions consist of an operation, and multiple operands. Operands specify the input data for the operation. An operand can be an ◊keyword{immediate} (a constant, hardcoded) value, or the address of a memory location containing the value. ◊keyword{Registers}, special high-speed data storage units, are also valid operands. Although the theoretical ◊keyword{random access machine} model does not involve registers, only memory, real computers have a set of registers, collectively called the ◊keyword{register file}, which serve as scratch space for computations. 

◊section{Registers store high-traffic data}

Accessing registers is about 3-12 times faster than accessing the fastest parts of memory making them ideal for storing frequently used data. Registers are typically several times the size of a single byte allowing them to store multi-byte values. The size of the register file is usually in the high single- to low double-digits for a typical CPU, though some specialized chips, like GPUs, can contain hundreds.

◊aside{We can assume the first four names were chosen so that they would spell out the first four letters of the alphabet when abbreviated.}

Unlike memory locations, registers do not have addresses. Instructions refer to them by name. In the ◊keyword{x86_64 architecture}, the first eight general-purpose registers are named ◊x86asm{rax}, ◊x86asm{rbx}, ◊x86asm{rcx}, ◊x86asm{rdx}, ◊x86asm{rsi}, ◊x86asm{rdi}, ◊x86asm{rbp}, and ◊x86asm{rsp}, which stand for “◊em{accumulator}”, “◊em{base}”, “◊em{counter}”, “◊em{data}”, “◊em{source}”, “◊em{destination}”, “◊em{base pointer}”, and “◊em{stack pointer}”, named after what the designers of x86_64 assumed each register would be primarily used for.

◊section{Architectures define instruction sets}

Architectures define ◊keyword{instruction sets}, which are the sets of operations processors can do. The x86_64 architecture and its parent, x86, are some of the most common in the world. They are by no means the only ones. ARM, an alternative class of architectures, is common in mobile devices. Your phone’s processor is probably ARM. Your desktop’s is probably x86_64. This book will use x86_64 for its examples, though the specific architecture used is unimportant.

Instructions are encoded in binary ◊keyword{machine code} which the processor can execute directly. Since binary machine code is unintelligible to us humans, instructions are usually given ◊keyword{mnemonics}, short nicknames that stand in for binary codewords. Examples of x86_64 mnemonics include ◊x86asm{mov} (the “move” instruction) and ◊x86asm{add} (the “add” instruction). Instructions written in mnemonics are called ◊keyword{assembly}, and are translated into machine code by an ◊keyword{assembler}.

◊section{x86 assembly basics}

◊aside{Here we use the ◊keyword{GNU assembly}, or ◊keyword{GAS} x86 syntax. Another x86 syntax called ◊keyword{Intel syntax} also exists, which we won’t use.}

Instructions in x86 assembly take the form of 

◊pre{
    operation operand1, operand2.
}

Some instructions only take one operand and so are just written 

◊pre{
    operation operand.
}

Modern x86_64 has well over 900 instructions, though only a dozen or so are used commonly. Each instruction comes in one or more flavors which indicate the size of the data they operate on. The size is written as a suffix, ◊code{b} (“byte”, 1 byte), ◊code{w} (“word”, 2 bytes), ◊code{l} (“long””, 4 bytes), or ◊code{q} (“quadword”, 8 bytes), at the end of the mnemonic. For example, ◊x86asm{movq} is the move instruction for 8-byte values.

The table below lists some of the most commonly used x86_64 instructions. Only the quadword flavor of each instruction is shown.
