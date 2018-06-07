#lang pollen

◊chapter[#:index "5"]{Language abstractions}

Assembly is extremely literal. Each instruction corresponds to a machine operation, which makes assembly straightforward to translate into machine code. For this reason, assembly languages (though not x86_64 specifically) were the first programming languages ever created. However, the same traits that make assembly natural for computers to process also make assembly highly ◊em{unnatural} for human programmers to use. People soon started creating ◊keyword{high-level languages}, languages that express logical intent and abstract away hardware details like registers and instructions.

High-level languages tend to look like this:

◊pre[#:class "swift"]{
    let c:Int = a + b/2 - 76
}

Rather than this:

◊pre[#:class "x86asm"]{
    movq    %rax, %rcx
    sarq    $1, %rbx
    addq    %rbx, %rcx
    subq    $76, %rcx
}
