#lang pollen

◊chapter[#:index "4"]{Code and the stack}

Assembly instructions can be encoded in binary as ◊keyword{machine code}. Machine code is quite unintelligible to humans, so the translation from assembly mnemonics to binary machine instructions is done by tools called ◊keyword{assemblers}. Programs that have been assembled into machine code are called ◊keyword{binaries}.

The following is an example of an x86_64 instruction encoded in machine code.

◊table[#:class "segmented-box"]{
    ◊tr[#:class "header"]{
        ◊td-invisible{addq} ◊td-invisible{} ◊td-invisible{%rax,} ◊td-invisible{%rcx} 
    }
    ◊tr{
        ◊td{0100100000000001} ◊td{11} ◊td{000} ◊td{001} 
    }
}

The long part in the beginning is the ◊keyword{opcode}, which in this case corresponds to an ◊x86asm{addq} instruction. The two triplets of bits at the end correspond to register operands. In x86_64, ◊code{rax} through ◊code{rdi} are numbered ◊code{000} through ◊code{111}. (The ◊code{r8} through ◊code{r15} registers are encoded slightly differently.)

Machine instructions in x86_64 are ◊keyword{variable length}. They are usually 1 to 6 bytes long, though they can be up to 15 bytes long in some cases, mainly when the instruction contains a long immediate operand.

Don’t bother memorizing the details of machine code. It’s not important. What’s important is that binary machine code can be stored in memory for the processor to fetch and execute directly as machine instructions.

◊section{Memory areas}

Computers today generally execute binaries by setting aside a minimum of two areas in memory. The first area, called the ◊keyword{code segment}, stores the ◊keyword{program text}, the machine instructions in the binaries. The second area is the ◊keyword{stack area}, memory for the program to use in its calculations.

Instructions that touch memory almost always operate on the stack area or areas similar to the stack area we haven’t discussed yet. Programs, called ◊keyword{self-modifying programs}, that change memory in their own program text exist, but are extremely rare and are generally considered a form of art rather than a practical type of program. In fact, the operating system usually sets the code segment to read-only, which prevents the program from modifying its text.

◊section{Instruction cycles and the instruction pointer}

Processors contain an ◊keyword{instruction pointer} register which holds the address of an instruction in memory. On each ◊keyword{instruction cycle}, the processor loads the instruction referenced by the pointer from memory and executes it. The instruction pointer register is called ◊code{rip} in x86_64.

The ◊code{rip} register is a ◊keyword{special-purpose register}. Unlike general purpose registers, special-purpose registers can only be accessed by specific instructions, so you can’t use ◊x86asm{movq} to load or read ◊code{rip}. (Though you ◊em{can} use it as a base register in an addressing mode.)

For almost all instructions, the processor automatically increments the instruction pointer by the length of the instruction. This lets the processor load and execute instructions one after another in memory.

◊table[#:class "memory-table vertical"]{
    ◊tr{
        ◊td[#:class "invisible"]{rip 1 ->} 
        ◊td[#:class "addresses"]{x0} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{movq  %rcx, %rax}
    }
    ◊tr{
        ◊td[#:class "invisible" #:rowspan "2"]{} 
        ◊td[#:class "addresses"]{x1} 
        ◊td[#:class "merge-down"]{x89} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x2} 
        ◊td{xC8} 
    }
    
    ◊tr{
        ◊td[#:class "invisible"]{rip 2 ->} 
        ◊td[#:class "addresses"]{x3} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{sarq  $63 , %rcx}
    }
    ◊tr{
        ◊td[#:class "invisible" #:rowspan "3"]{} 
        ◊td[#:class "addresses"]{x4} 
        ◊td[#:class "merge-down"]{xC1} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x5} 
        ◊td[#:class "merge-down"]{xF9} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x6} 
        ◊td{x3F} 
    }

    ◊tr{
        ◊td[#:class "invisible"]{rip 3 ->} 
        ◊td[#:class "addresses"]{x7} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{xorq  %rcx, %rax}
    }
    ◊tr{
        ◊td[#:class "invisible" #:rowspan "2"]{}
        ◊td[#:class "addresses"]{x8} 
        ◊td[#:class "merge-down"]{x31} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x9} 
        ◊td{xC8} 
    }
    
    ◊tr{
        ◊td[#:class "invisible"]{rip 4 ->} 
        ◊td[#:class "addresses"]{xA} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{subq  %rcx, %rax}
    }
    ◊tr{
        ◊td[#:class "invisible" #:rowspan "2"]{}
        ◊td[#:class "addresses"]{xB} 
        ◊td[#:class "merge-down"]{x29} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{xC} 
        ◊td{xC8} 
    }
}

The exceptions are ◊keyword{control transfer instructions}, which set the instruction pointer explicitly. 

◊section{Jumps}

◊keyword{Jump instructions} are the simplest control transfer instructions — they simply load ◊code{rip} with whatever their operands evaluate to, causing the processor to move to an arbitrary location in the program text instead of advancing to the next instruction in memory. The mnemonic for a basic, unconditional jump instruction is ◊code{jmp}.

Jumps can be ◊keyword{direct} or ◊keyword{indirect}. Direct jumps add a constant offset into the instruction pointer and so always transfer program execution to a specific spot in the program text. Indirect jumps load the instruction pointer with a value stored either in a register or in memory and can be used to transfer program execution to a variable position in the program text. 

◊pre[#:class "x86-prototype"]{
◊keyword{jmp} address
}

Performs a direct jump to ◊code{address}.

◊em{Example:} ◊x86asm{jmp 89}

The x86_64 syntax for direct jump instructions is a little weird. Direct jump operands can be thought of as immediate values, though they are written without the ◊code{$} prefix. Direct jumps also don’t come in different sizes, so it’s ◊code{jmp 21}, not ◊code{jmpq 21}.

◊table[#:class "memory-table vertical"]{
    ◊tr{
        ◊td[#:class "addresses"]{x0} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{movq  %rcx, %rax}
    }
    ◊tr{
        ◊td[#:class "addresses"]{x1} 
        ◊td[#:class "merge-down"]{x89} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x2} 
        ◊td{xC8} 
    }
    
    ◊tr{
        ◊td[#:class "addresses"]{x3} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{sarq  $63 , %rcx}
    }
    ◊tr{
        ◊td[#:class "addresses"]{x4} 
        ◊td[#:class "merge-down"]{xC1} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x5} 
        ◊td[#:class "merge-down"]{xF9} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x6} 
        ◊td{x3F} 
    }

    ◊tr{
        ◊td[#:class "addresses"]{x7} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{xorq  %rcx, %rax}
    }
    ◊tr{
        ◊td[#:class "addresses"]{x8} 
        ◊td[#:class "merge-down"]{x31} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x9} 
        ◊td{xC8} 
    }
    
    ◊tr{
        ◊td[#:class "addresses"]{xA} 
        ◊td[#:class "merge-down"]{x48} ◊td[#:class "invisible pad-left"]{subq  %rcx, %rax}
    }
    ◊tr{
        ◊td[#:class "addresses"]{xB} 
        ◊td[#:class "merge-down"]{x29} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{xC} 
        ◊td{xC8} 
    }
    
    ◊tr{
        ◊td[#:class "addresses"]{xD} 
        ◊td[#:class "merge-down"]{xE9} ◊td[#:class "invisible pad-left"]{jmp   0x07}
    }
    ◊tr{
        ◊td[#:class "addresses"]{xE} 
        ◊td[#:class "merge-down"]{xF5} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{xF} 
        ◊td[#:class "merge-down"]{xFF} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x10} 
        ◊td[#:class "merge-down"]{xFF} 
    }
    ◊tr{
        ◊td[#:class "addresses"]{x11} 
        ◊td{xFF} 
    }
}

In this example, we’ve added a ◊x86asm{jmp 0x07} instruction to the end of the absolute value assembly from Chapter 3. This will make it so the next instruction the processor executes after the ◊code{jmp} instruction is the ◊x86asm{xorq %rcx, %rax} instruction at address ◊code{0x7} instead of whatever instruction starts at ◊code{0x12}. 

◊aside{Why did we say ◊code{0x12} is the end of the ◊code{jmp} instruction, and not ◊code{0x11}? Generally, in programming, we define the ending index of any interval to be the ◊em{starting index} of the ◊em{next} interval. It makes the math easier.}

See the ◊code{0xfffffff5} in the last four bytes of the ◊code{jmp} instruction? That’s −11 in little-endian signed integer representation, and it corresponds to the difference between the beginning of the ◊code{xorq} instruction, ◊code{0x7}, and the end of the ◊code{jmp} instruction, ◊code{0x12}. Although the ◊code{0x07} in the ◊code{jmp} instruction is an absolute address in assembly, x86_64 encodes it as a relative offset in machine code.

◊pre[#:class "x86-prototype"]{
◊keyword{jmpq} *source
}

Performs an indirect direct jump to the address in ◊code{source}.

◊em{Example:} ◊x86asm{jmpq *24(, %ecx, 8)}

Indirect jumps look more like most other x86_64 instructions, except their operands are always prefixed with an asterisk (◊code{*}). The operand is an absolute address to be loaded into ◊code{rip}, and it can be in either a register, or a memory location. So, all of the following are valid indirect jumps:

◊pre[#:class "x86asm"]{
jmpq   *%eax
jmpq   *(%eax)
jmpq   *18(%eax, %ecx, 8)
jmpq   *18
}

◊section{Flags and conditional jumps}

Jumps can be made conditional on the states of bits, called ◊keyword{processor flags}, in a special-purpose register called the ◊keyword{flags register}. The flags register is called ◊code{rflags} in x86_64.

Examples of processor flags include the overflow flag (OF), the carry flag (CF), the zero flag (ZF), and the sign flag (SF). Most instructions set at least some of the flags. Some instructions like ◊code{cmp} exist ◊em{solely} to set the flags.

◊pre[#:class "x86-prototype"]{
◊keyword{cmpq} left, right
}

Subtracts ◊code{left} from ◊code{right} and sets the processor flags, discarding the result.

◊em{Example:} ◊x86asm{cmpq $10, %eax}

The ◊code{cmp} instruction produces distinct flag patterns depending on whether its left operand is less than, equal to, or greater than its right operand, when compared as either unsigned or signed integers. We call these flag patterns ◊keyword{condition codes}.
 
The jump instruction comes in many conditional variants that perform jumps only if certain condition codes are present. They’re named assuming the flags were set by a comparison instruction. 

◊warning{The order of the operands is switched in the Intel assembly syntax.}

◊table[#:class "data-table"]{
    ◊tr[#:class "header"]{◊td{Flags set by} 
    }
    ◊tr{◊td{cmpq op1, op2}}
    ◊tr[#:class "header"]{
        ◊td{Instruction} ◊td{Condition} ◊td{Type}
    }
    ◊tr{
        ◊td{jb   target  } ◊td{op1 < op2} ◊td{unsigned}
    }
    ◊tr{
        ◊td{ja   target  } ◊td{op1 > op2} ◊td{unsigned}
    }
    ◊tr{
        ◊td{jbe  target  } ◊td{op1 ≤ op2} ◊td{unsigned}
    }
    ◊tr{
        ◊td{jae  target  } ◊td{op1 ≥ op2} ◊td{unsigned}
    }

    ◊tr{
        ◊td{je   target  } ◊td{op1 = op2} ◊td{both}
    }
    
    ◊tr{
        ◊td{jl   target  } ◊td{op1 < op2} ◊td{signed}
    }
    ◊tr{
        ◊td{jg   target  } ◊td{op1 > op2} ◊td{signed}
    }
    ◊tr{
        ◊td{jle  target  } ◊td{op1 ≤ op2} ◊td{signed}
    }
    ◊tr{
        ◊td{jge  target  } ◊td{op1 ≥ op2} ◊td{signed}
    }
}

The names of the conditional jumps follow a pretty consistent convention.

◊table[#:class "data-table pad-left"]{
    ◊tr[#:class "header"]{◊td{Mnemonic} ◊td{Meaning} 
    }
    ◊tr{
        ◊td{jb}  ◊td{jump if below} 
    }
    ◊tr{
        ◊td{ja}  ◊td{jump if above} 
    }
    ◊tr{
        ◊td{jbe} ◊td{jump if below or equal to} 
    }
    ◊tr{
        ◊td{jae} ◊td{jump if above or equal to} 
    }

    ◊tr{
        ◊td{je}  ◊td{jump if equal to} 
    }
    
    ◊tr{
        ◊td{jl}  ◊td{jump if less than} 
    }
    ◊tr{
        ◊td{jg}  ◊td{jump if greater than} 
    }
    ◊tr{
        ◊td{jle} ◊td{jump if less than or equal to} 
    }
    ◊tr{
        ◊td{jge} ◊td{jump if greater than or equal to} 
    }
}

Jumps can also be made conditional on specific flags. For example, ◊code{jc} jumps if the carry flag is set.

◊section{The stack}
