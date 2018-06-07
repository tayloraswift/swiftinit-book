#lang pollen

◊chapter[#:index "5"]{Language abstractions}

Assembly is extremely literal. Each instruction corresponds to a machine operation, which makes assembly straightforward to translate into machine code. For this reason, assembly languages (though not x86_64 specifically) were the first programming languages ever created. However, the same traits that make assembly natural for computers to process also make assembly highly ◊em{unnatural} for human programmers to use. People soon started creating ◊keyword{high-level languages}, languages that express logical intent and abstract away hardware details like registers and instructions.

To help you get a better feel for the difference, high-level languages tend to look like this:

◊pre[#:class "swift"]{
    let c:Int = a + b/2 - 76
}

Rather than this:

◊pre[#:class "x86asm"]{
    movq    %rax, %rcx
    sarq    $1  , %rbx
    addq    %rbx, %rcx
    subq    $76 , %rcx
}

Swift is a high-level language, and so this chapter, in a way, marks the turning point where we begin to talk less about general computing fundamentals and more about the Swift language in particular.

◊section{Compilers}

“High-level” is a relative term, and so high-level languages can be further subdivided into ◊keyword{compiled languages} and ◊keyword{interpreted languages}. Programs written in compiled languages are meant to be transformed into assembly and eventually a native machine code binary by a tool called a ◊keyword{compiler}. The binary can then be executed directly by the processor. Programs written in interpreted languages are not meant to be turned into binaries. Instead, a program called an ◊keyword{interpreter} parses and dynamically executes statements inside an interpeted program.

◊section{Advantages of compiled languages}

While compiled and interpreted languages both have strengths and weaknesses relative to one another, compiled languages are superior to assembly in almost every way. Almost nobody writes assembly these days. 

The largest advantage of a high-level language is ◊keyword{machine independence}. Recall that instruction sets are specific to particular processor architectures. Thus, you have to rewrite an assembly program for every make and model of CPU you want to run it on. High-level languages have a level of abstraction between the hardware and the source code which allows the compiler to do the job of compiling your program for various architectures, all using the same source code.
