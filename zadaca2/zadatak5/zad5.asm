@SCREEN
D=A

@address // @16
M=D
@cursor // Globalna lokacija cursora @17
M=D
@cursor_count // Broj brojeva u trenutnom redu @18
M=0
@broj_count // Broj brojeva opcenito @19
M=0

@1000
D=A
@broj1 // broj 1 pocinje na 1000
M=D
@1016
D=A
@broj2 // broj 2 pocinje na 1016
M=D
@1032
D=A
@broj3 // broj 3 pocinje na 1032
M=D
@1048
D=A
@broj4 // broj 4 pocinje na 1048
M=D
@1064
D=A
@broj5 // broj 5 pocinje na 1064
M=D

//
// PISANJE SLOVA U RAM
//

// Pisanje broja 1  u RAM
    @960
    D=A
    @1000
    M=D
    @1002
    M=D
    @1002
    M=D
    @1003
    M=D
    @1004
    M=D
    @1005
    M=D
    @1006
    M=D
    @1007
    M=D
    @1008
    M=D
    @1009
    M=D
    @1010
    M=D
    @1011
    M=D
    @1012
    M=D
    @1013
    M=D
    @1014
    M=D
    @1015
    M=D


// Pisanje broja 2  u RAM
    @7800
    D=A
    @1016
    M=D
    @1017
    M=D
    @1018
    M=D
    @1019
    M=D
    @1020
    M=D
    @1021
    M=D
    @1022
    M=D
    @1025
    M=D
    @1026
    M=D
    @1027
    M=D
    @1028
    M=D
    @1029
    M=D
    @1023
    M=D
    @1024
    M=D
    @1030
    M=D
    @1031
    M=D

// Pisanje broja 3 u RAM
    @62415
    D=A
    @1032
    M=D
    @1033
    M=D
    @1034
    M=D
    @1035
    M=D
    @1036
    M=D
    @1037
    M=D
    @1038
    M=D
    @1039
    M=D
    @1040
    M=D
    @1041
    M=D
    @1042
    M=D
    @1043
    M=D
    @1044
    M=D
    @1045
    M=D
    @1046
    M=D
    @1047
    M=D


// Pisanje broja 4 u RAM
    @57575
    D=A
    @1048
    M=D
    @1049
    M=D
    @1050
    M=D
    @1051
    M=D
    @1052
    M=D
    
    @29127
    D=A
    @1053
    M=D
    @1054
    M=D
    @1055
    M=D
    @1056
    M=D
    @1057
    M=D
    @1058
    M=D

    @15239
    D=A
    @1059
    M=D
    @1060
    M=D
    @1061
    M=D

    @7943
    D=A
    @1062
    M=D
    @1063
    M=D

// Pisanje broja 5 u RAM

    @57351
    D=A
    @1064
    M=D
    @1065
    M=D
    @1066
    M=D
    @1067
    M=D

    @28686
    D=A
    @1068
    M=D
    @1069
    M=D
    @1070
    M=D
    @1071
    M=D
    
    @14364
    D=A
    @1072
    M=D
    @1073
    D=A
    @1074
    M=D
    @1075
    M=D

    @7224
    D=A
    @1076
    M=D
    @1077
    M=D

    @3696
    D=M
    @1078
    M=D
    
    @960
    D=M
    @1079
    M=D

(KEY_START)
    @KBD
    D=M;
    @48
    D=D-A
    @BACKSPACE
    D; JEQ

    @KBD
    D=M;
    @49
    D=D-A
    @BROJ_1
    D; JEQ
    
    @KBD
    D=M;
    @50
    D=D-A
    @BROJ_2
    D; JEQ

    @KBD
    D=M;
    @51
    D=D-A
    @BROJ_3
    D; JEQ

    @KBD
    D=M;
    @52
    D=D-A
    @BROJ_4
    D; JEQ

    @KBD
    D=M;
    @53
    D=D-A
    @BROJ_5
    D; JEQ
    @KEY_START
    0;JMP
(KEY_END)

// Buffer da ne ispise 20 slova sa jednim stiskom
(KEY_BUFFER)
    @KBD
    D=M
    @KEY_START
    D;JEQ

    @KEY_BUFFER
    //@KEY_START
    0;JMP
(KEY_BUFFER_END)

(CURSOR_LOGIC)

    // RJEŠAVANJE CURSORA

    // Provjeravanje je li zadnji u redu, ako je pomakni cursor u iduci red
    @32
    D=A
    @cursor_count
    D=D-M
    @CONTINUE
    D; JGT // Nastavi dalje ako je vece od 0, odnosno ako je manje od 32
    (NEW_LINE)
    @cursor_count
    M=0
    @512
    D=A
    @cursor // Prelazak u novi red, odnosno preskakanje 16 redova
    M=M+D

    (CONTINUE)
    @cursor
    M=M+1

    @KEY_BUFFER
    0;JMP

(CURSOR_LOGIC_END)

(BROJ_1)

    @broj_count
        D=M
        @480
        D=A-D
        @KEY_START
        D;JLE

        @broj_count
        M=M+1

    @cursor // Vidi gdje je cursor
    D=M

    @cursor_count // Povecaj broj brojeva u redu za 1
    M=M+1

    @address // Postavi adresu na cursor
    M=D

    @broj1 // Slovo koje stavljamo
    D=M

    @readAddr // Privremena adresa za citanje broja
    M=D

    // PISANJE broja

    @i
    M=0
        (LOOP_START_A)
            @16 // Broj iteracija
            D = A
            @i
            D = D - M
            @LOOP_END_A
            D; JEQ

            @readAddr
            A=M // Address pointer ode na dio broja
            D=M // Ucitamo to u D
            @readAddr
            M=M+1 // Povecaj address pointer u tempadd za 1

            @address // Crtanje
            A = M
            M = D
            @address
            D=M
            @32 // preskoci red
            D = D + A
            @address
            M = D

            @i
            M = M + 1
            @LOOP_START_A
            0; JMP
        (LOOP_END_A)

        @CURSOR_LOGIC
        0;JMP

(BROJ_1_END)

@KEY_BUFFER
0;JMP

(BROJ_2)

    @broj_count
        D=M
        @480
        D=A-D
        @KEY_START
        D;JLE

        @broj_count
        M=M+1

    @cursor // Vidi gdje je cursor
    D=M

    @cursor_count // Povecaj broj brojeva u redu za 1
    M=M+1

    @address // Postavi adresu na cursor
    M=D

    @broj2 // Slovo koje stavljamo
    D=M

    @readAddr // Privremena adresa za citanje broja
    M=D

    // PISANJE broja

    @i
    M=0
        (LOOP_START_B)
            @16 // Broj iteracija
            D = A
            @i
            D = D - M
            @LOOP_END_B
            D; JEQ

            @readAddr
            A=M // Address pointer ode na dio broja
            D=M // Ucitamo to u D
            @readAddr
            M=M+1 // Povecaj address pointer u tempadd za 1

            @address // Crtanje
            A = M
            M = D
            @address
            D=M
            @32 // preskoci red
            D = D + A
            @address
            M = D

            @i
            M = M + 1
            @LOOP_START_B
            0; JMP
        (LOOP_END_B)

        @CURSOR_LOGIC
        0;JMP

(BROJ_2_END)

@KEY_BUFFER
0;JMP

(BROJ_3)

    @broj_count
        D=M
        @480
        D=A-D
        @KEY_START
        D;JLE

        @broj_count
        M=M+1

    @cursor // Vidi gdje je cursor
    D=M

    @cursor_count // Povecaj broj brojeva u redu za 1
    M=M+1

    @address // Postavi adresu na cursor
    M=D

    @broj3 // Broj koji stavljamo
    D=M

    @readAddr // Privremena adresa za citanje broja
    M=D

    // PISANJE broja

    @i
    M=0
        (LOOP_START_C)
            @16 // Broj iteracija
            D = A
            @i
            D = D - M
            @LOOP_END_C
            D; JEQ

            @readAddr
            A=M // Address pointer ode na dio broja
            D=M // Ucitamo to u D
            @readAddr
            M=M+1 // Povecaj address pointer u tempadd za 1

            @address // Crtanje
            A = M
            M = D
            @address
            D=M
            @32 // preskoci red
            D = D + A
            @address
            M = D

            @i
            M = M + 1
            @LOOP_START_C
            0; JMP
        (LOOP_END_C)

        @CURSOR_LOGIC
        0;JMP
    
(BROJ_3_END)

@KEY_BUFFER
0;JMP

(BROJ_4)

    @broj_count
        D=M
        @480
        D=A-D
        @KEY_START
        D;JLE

        @broj_count
        M=M+1

    @cursor // Vidi gdje je cursor
    D=M

    @cursor_count // Povecaj broj brojeva u redu za 1
    M=M+1

    @address // Postavi adresu na cursor
    M=D

    @broj4 // broj koje stavljamo
    D=M

    @readAddr // Privremena adresa za citanje broja
    M=D

    // PISANJE broja

    @i
    M=0
        (LOOP_START_D)
            @16 // Broj iteracija
            D = A
            @i
            D = D - M
            @LOOP_END_D
            D; JEQ

            @readAddr
            A=M // Address pointer ode na dio broja
            D=M // Ucitamo to u D
            @readAddr
            M=M+1 // Povecaj address pointer u tempadd za 1

            @address // Crtanje
            A = M
            M = D
            @address
            D=M
            @32 // preskoci red
            D = D + A
            @address
            M = D

            @i
            M = M + 1
            @LOOP_START_D
            0; JMP
        (LOOP_END_D)

        @CURSOR_LOGIC
        0;JMP
    
(BROJ_4_END)

@KEY_BUFFER
0;JMP

(BROJ_5)

    @broj_count
        D=M
        @480
        D=A-D
        @KEY_START
        D;JLE

        @broj_count
        M=M+1

    @cursor // Vidi gdje je cursor
    D=M

    @cursor_count // Povecaj broj brojeva u redu za 1
    M=M+1

    @address // Postavi adresu na cursor
    M=D

    @broj5 // broj koje stavljamo
    D=M

    @readAddr // Privremena adresa za citanje broja
    M=D

    // PISANJE broja

    @i
    M=0
        (LOOP_START_E)
            @16 // Broj iteracija
            D = A
            @i
            D = D - M
            @LOOP_END_E
            D; JEQ

            @readAddr
            A=M // Address pointer ode na dio broja
            D=M // Ucitamo to u D
            @readAddr
            M=M+1 // Povecaj address pointer u tempadd za 1

            @address // Crtanje
            A = M
            M = D
            @address
            D=M
            @32 // preskoci red
            D = D + A
            @address
            M = D

            @i
            M = M + 1
            @LOOP_START_E
            0; JMP
        (LOOP_END_E)

        @CURSOR_LOGIC
        0;JMP
    
(BROJ_5_END)

@KEY_BUFFER
0;JMP


(BACKSPACE)

    @broj_count
        D=M
        @KEY_START
        D;JLE

        @broj_count
        M=M-1

    // LOGIKA CURSORA
    @cursor_count // Ucita broj brojeva u redu
    D=M
    @CONTINUE_BACK // Ako je broj brojeva veci od 0, nastavi
    D;JGT

    (OLD_LINE) // Inace se vrati u prosli red
    @32
    D=A
    @cursor_count // Postavi broj charova na 32, svejedno se kasnije jos 1 skine
    M=D
    @512
    D=A
    @cursor // Odi u nazad za 16 redova
    M=M-D

    (CONTINUE_BACK)
    @cursor
    M=M-1
    D=M
    @cursor_count
    M=M-1

    @address
    M=D

    @i
    M=0

        (LOOP_START_BACK)
            @16 // Broj iteracija
            D = A 
            @i
            D = D - M
            @LOOP_END_BACK
            D; JEQ

            @address // Crtanje
            A = M
            M = 0 // Pisanje brojeva
            @address
            D=M
            @32 // preskoci red
            D = D + A
            @address
            M = D

            @i
            M = M + 1
            @LOOP_START_BACK
            0; JMP
        (LOOP_END_BACK)
        

(BACKSPACE_END)

@KEY_BUFFER
0;JMP

(END)
@END
0;JMP