.ORIG x3000

LD R6, PRINTMATRIX_ADDRESS		; R6 <- pointer to the  stack

; loading the prameters to the stack

LD R1, POINTER_ARRAY
LD R2, SIZE

STR R1, R6, #-2			; loading the first parameter to the stack - ARRAY
STR R2, R6, #-1			; loading the second parameter to the stack - SIZE
ADD R6, R6, #-2			; Update R6
JSR GetMatrix		    ; calling to the function
ADD R6, R6, #2			; folding the stack

LEA R0, BETWEENFUNC
PUTS
GETC
OUT
LD R6, PRINTMATRIX_ADDRESS		; R6 <- pointer to the  stack

; loading the prameters to the stack
LD R1, POINTER_ARRAY
LD R2, SIZE
AND R3, R1, #0

STR R1, R6, #-3			; loading the first parameter to the stack - ARRAY
STR R2, R6, #-2			; loading the second parameter to the stack - SIZE
ADD R6, R6, #-2			; Update R6
JSR printMatrix		    ; calling to the function
ADD R6, R6, #2			; folding the stack


HALT
POINTER_ARRAY .fill ARRAY
BETWEENFUNC .stringz "pass function"
;delete after~~~~~~~~~~~~~~~~~~~~

Mul:
        ;save values
	ST R7, R7_SAVE_MUL
	ST R3, R3_SAVE_MUL; save R1
	ST R4, R4_SAVE_MUL; save mul result
	ST R5, R5_SAVE_MUL; flag for mul sign
	ST R6, R6_SAVE_MUL
	ST R1, R1_SAVE_MUL
	ST R0, R0_SAVE_MUL

	AND R4, R4, #0; resets registers
	AND R3, R3, #0;
	AND R2, R2, #0;
	AND R5, R5, #0;

	ADD R0, R0, #0; if one is zero, end mul return zero
	BRz END_MUL
	ADD R1, R1, #0; if one is zero, end mul return zero
	BRz END_MUL

	ADD R2, R0, #0
	ADD R3, R1, #0

	ADD R2, R2, #0; if R0 negative - test msb is 1, turn into posi and save old sign (in R5)
	BRp WHILE_LOOP
	NOT R2, R2; turn R0 to positive
	ADD R2, R2, #1

	WHILE_LOOP:
		AND R5, R2, R2; while we still need to mul - R2 - counter > 0
		BRz END_LOOP
		ADD R4, R4, R3; mul_res = mul_res + R3
		ADD R2, R2, #-1
		BR WHILE_LOOP

	END_LOOP:
		ADD R0, R0, #0; if R0 was negative (R5 == R0) negatiev->neg * neg / neg * posi - need to change sign
		BRp END_MUL
		NOT R4, R4
		ADD R4, R4, #1

	END_MUL:
		ADD R2, R4, #0 ;add TO R2 the mul 

	LD R7, R7_SAVE_MUL
	LD R3, R3_SAVE_MUL
	LD R4, R4_SAVE_MUL
	LD R5, R5_SAVE_MUL
	LD R1, R1_SAVE_MUL
	LD R0, R0_SAVE_MUL
	LD R6, R6_SAVE_MUL
RET

R7_SAVE_MUL .FILL #0
R5_SAVE_MUL .FILL #0
R4_SAVE_MUL .FILL #0
R3_SAVE_MUL .FILL #0
R6_SAVE_MUL .FILL #0
R1_SAVE_MUL .FILL #0
R0_SAVE_MUL .FILL #0

; delete afer~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRINTMATRIX_ADDRESS	.fill	XBFFF
SIZE 		.fill 	#3

;___________________________________________________________________________________;

POINTER_MINUS_SPACE .fill MINUS_SPACE
POINTER_PLUS_SPACE .fill PLUS_SPACE
POINTER_MINUS_ENTER .fill MINUS_ENTER
POINTER_PLUS_ENTER .fill PLUS_ENTER
POINTER_HOURS_IN_A_DAY .fill HOURS_IN_A_DAY
POINTER_RHOURS_IN_A_DAY .fill RHOURS_IN_A_DAY
POINTER_MINUS_ASCII .fill MINUS_ASCII
HOURS_LEFT_IN_THE_NEXT_DAY .fill #-1
CURRENT_CELL .fill #0
NUMBER_OF_LAST_MACHINE .fill #0
CLOSING_FACTORY_HOUR .fill #0
POINTER_MATRIX_Productivity .fill #0
POINTER_MATRIX_DIV1 .fill #0
SIZE_OF_ARRAY .fill #0
GET_MATRIX_STRING .stringz "Please enter the maze matrix:"

GetMatrix:
    ; גיבוי רגיסטרים
	ADD R6, R6, #-6
	STR R7, R6, #0
	STR R5, R6, #1
	STR R4, R6, #2
	STR R3, R6, #3
	STR R2, R6, #4
	STR R1, R6, #5

    LDR R1, R6, #6			; R1 <- ARRAY
    LDR R2, R6, #7			; R2 <- SIZE

    ; the body of the function
    LEA R0, GET_MATRIX_STRING
    PUTS
    LDI R0, POINTER_PLUS_ENTER
    OUT
    	AND R4, R4, #0 ; tracking the current row
    	AND R3, R3, #0
        AND R5, R5, #0
		ADD R5, R5, R2
        
	INPUT_NEXT_ROW:
        AND R0, R0, #0
	ADD R0, R4, #0
        LD R1, ROW_LENGTH

        JSR Mul ; R2 contain the number of the cells in the metrix
        LEA R1, ARRAY
        ADD R3, R2, R1

        LOOP_INPUT: ; enter to the whole row the input that the user insert
            GETC
            OUT
            LDI R7, POINTER_MINUS_SPACE
            ADD R0, R0, R7
            BRz LOOP_INPUT
            LDI R7, POINTER_PLUS_SPACE
            ADD R0, R0, R7
            LDI R7, POINTER_MINUS_ENTER
            ADD R0, R0, R7
            BRz END_ROW
            LDI R7, POINTER_PLUS_ENTER
            ADD R0, R0, R7

            LDI R7, POINTER_MINUS_ASCII
            ADD R0, R0, R7             
            STR R0, R3, #0

            ADD R3, R3, #1
            BR LOOP_INPUT
        END_ROW:
            ADD R4, R4, #1
            ADD R5, R5, #-1
            BRp INPUT_NEXT_ROW

    ; restoring the registers
    LDR R7, R6, #0
    LDR R5, R6, #1
    LDR R4, R6, #2
    LDR R3, R6, #3
    LDR R2, R6, #4
    LDR R1, R6, #5

    ADD R6, R6, #6		; pop stack frame = #local variables + #register save
RET

ROW_LENGTH .fill #20
R3_TEMP .fill #0
R3_COUNTER .fill #0
QQQQ .fill #48
NUMBER_OF_ROWS .fill #0
NUMBER_OF_COLS .fill #0
R4_SAVE_TEMP .fill #0
PrintNum_PTR .fill PrintNum
POINTER_Mul .fill Mul
AAA .fill #240
BBB .fill #-240
R0_SAVE_DailyProduction .fill #0
R1_SAVE_DailyProduction .fill #0
R2_SAVE_DailyProduction .fill #0
R3_SAVE_DailyProduction .fill #0 
R4_SAVE_DailyProduction .fill #0
R5_SAVE_DailyProduction .fill #0
R6_SAVE_DailyProduction .fill #0
R7_SAVE_DailyProduction .fill #0

HOURS_IN_A_DAY .fill #24
RHOURS_IN_A_DAY .fill #-24
ENTER_INSERTED .fill #0
CURRENT_CELL_IN_MATRIX .fill #0
PREV_DIGIT .fill #0
CURRENT_DIGIT .fill #0
COUNTER_DAILY .fill #0
IF_SPACE_AGAIN .fill #0

MINUS_SPACE .fill #-32
MINUS_ENTER .fill #-10
MINUS_ASCII .fill #-48
PLUS_SPACE .fill #32
PLUS_ENTER .fill #10
PLUS_ASCII .fill #48


printMatrix: ; VOID printMatrix(int **arr, int length)
    ; storing the registers
	ADD R6, R6, #-6
	STR R7, R6, #0
	STR R5, R6, #1
	STR R4, R6, #2
	STR R3, R6, #3
	STR R2, R6, #4
	STR R1, R6, #5

	LDR R1, R6, #6			; R1 <- ARRAY
    LDR R2, R6, #7			; R2 <- SIZE
    

	; start of the function content
	AND R4, R4, #0
	AND R5, R5, #0
	ADD R5, R5, R2 ; storing the size of the array in R5
	ADD R3, R3, R2 ; storing the size of the array in R5
	GETC
	OUT
	COL_LOOP_printMatrix:
		ADD R0, R0, #0
		ADD R0, R4, #0
        	LD R1, ROW_LENGTH
        	JSR Mul ; R2 contain the number of the cells in the metrix
        	LEA R1, ARRAY
        	ADD R1, R2, R1
		ROW_LOOP_printMatrix:
        		LDR R0, R1, #0
        		LD R7, PLUS_ASCII
        		ADD R0, R0, R7
        		OUT
			
        		ADD R3, R3, #-1
        		BRz IF_ROW_ENDED
			LDI R0, POINTER_PLUS_SPACE
	    		OUT
        		ADD R1, R1, #1
    			BR ROW_LOOP_printMatrix
    		
		IF_ROW_ENDED:
	    		LD R0, PLUS_ENTER
        		OUT
	    		ADD R5, R5, #-1
	    		BRz IF_COL_ENDED
	    		ADD R4, R4, #1
			BR COL_LOOP_printMatrix
    IF_COL_ENDED:
; end of the function content

        ; restoring the registers
		LDR R7, R6, #0
		LDR R5, R6, #1
		LDR R4, R6, #2
		LDR R3, R6, #3
		LDR R2, R6, #4
		LDR R1, R6, #5

		ADD R6, R6, #6		; pop stack frame = #local variables + #register save
RET

ARRAY   .blkw #20 #-1 ; row 1
		.blkw #20 #-1 ; row 2
		.blkw #20 #-1 ; row 3
		.blkw #20 #-1 ; row 4
		.blkw #20 #-1 ; row 5
		.blkw #20 #-1 ; row 6
		.blkw #20 #-1 ; row 7
		.blkw #20 #-1 ; row 8
		.blkw #20 #-1 ; row 9
		.blkw #20 #-1 ; row 10
		.blkw #20 #-1 ; row 11
		.blkw #20 #-1 ; row 12
		.blkw #20 #-1 ; row 13
		.blkw #20 #-1 ; row 14
		.blkw #20 #-1 ; row 15
		.blkw #20 #-1 ; row 16
		.blkw #20 #-1 ; row 17
		.blkw #20 #-1 ; row 18
		.blkw #20 #-1 ; row 19
		.blkw #20 #-1 ; row 20

.END

isSafe: (R1: **arr, R3: x, R4: y R5: n)	
	NOT R5, R5
	ADD R5, R5, #1
	ADD R3, R3, R5
	BRnp FALSE
	ADD R4, R4, R5
	BRnp FALSE
		ADD R2, R1, #0
		ADD R1, R5, #0
		ADD R5, R2, #0
		ADD R0, R3, #0
		JSR Mul
		ADD R2, R2, R4
		ADD R5, R5, R2
		AND R0, R0, #0
		ADD R0, R0, #1
		LDR R0, R5, #0
		ADD R0, R0, #-1
		BRnp FALSE
		BR END_isSafe
	FALSE:
		AND R0, R0, #0
	END_isSafe:
RET

COCAVIT .fill #42
ratinMaze(R1: **arr, R2: x, R3: y, R4: n, R5: **solArr)
	AND R7, R7, #0
	ADD R7, R7, R4
	NOT R7, R7
	ADD R7, R7, #1
	ADD R7, R7, R2
	BRnp NEXT_CHECK1
	AND R7, R7, #0
	ADD R7, R7, R4
	NOT R7, R7
	ADD R7, R7, #1
	ADD R7, R7, R3
	BRnp NEXT_CHECK1 ; TO FIX!!
		ADD R2, R1, #0
		ADD R1, R5, #0
		ADD R5, R2, #0
		ADD R0, R3, #0
		JSR Mul
		ADD R2, R2, R4
		ADD R5, R5, R2
		AND R0, R0, #0
		ADD R0, R0, #1
		STR R0, R5, #0
		BR END_ratinMaze
		; END OF TO FIX!!
	NEXT_CHECK1:
		JSR isSafe ; need to put the "מעטפת"
		ADD R0, R0, #-1
		BRnp FALSE_ratinMaze
		AND R0, R0, #0
		ADD R0, R0, #1
		BR END_ratinMaze

	FALSE_ratinMaze:
		AND R0, R0, #0
	END_ratinMaze: