@R0
D = M 

@R5
M=D

@R1
D = M

@R5
D=D-M

// R1-R5 < 0 
// R1 < R5 -> < 0
// R1-R5 > 0 
// R1 > R5 -> > 0

@SKIPR1 // skoci na Skipr1 ako je d<=0 
D;JLE

@R1
D=M

@R5
M=D

(SKIPR1)

@R2
D=M

@R5
D=D-M
// R1-R5 < 0 
// R1 < R5 -> < 0
// R1-R5 > 0 
// R1 > R5 -> > 0
@SKIPR2
D;JLE

@R2
D=M
@R5
M=D

(SKIPR2)
@R3
D=M
@R5
D=D-M
@SKIPR3
D;JLE

@R3
D=M
@R5
M=D

(SKIPR3)
@R4
D=M

@R5
D=D-M

@SKIPR4
D;JLE

@R4
D=M
@R5
M=D

(SKIPR4)

(END)
@END
0;JMP