				; 8080 assembler code
        .hexfile Receiver.hex
        .binfile Receiver.com
        ; try "hex" for downloading in hex format
        .download bin  
        .objcopy gobjcopy
        .postbuild echo "OK!"
        ;.nodump

	; OS call list
PRINT_B		    equ 4
PRINT_MEM	    equ 3
READ_B		    equ 7
READ_MEM	    equ 2
PRINT_STR	    equ 1
READ_STR	    equ 8
LOAD_EXEC 	    equ 5
PROCESS_EXIT	equ 9
SET_QUANTUM 	equ 6
RAND_INT	    equ 12
WAIT 			equ 13
SIGNAL 			equ 14	
INSERT_MEM      equ 15
REMOVE_MEM		equ 16
SET_MUTEX_SMFR	equ 17
	
	; Position for stack pointer
stack   equ 0F000h

	org 000H
	jmp begin

	; Start of our Operating System
GTU_OS:
	DI
	PUSH D
	push D
	push H
	push psw
	nop	; This is where we run our OS in C++, see the CPU8080::isSystemCall()
		; function for the detail.
	pop psw
	pop h
	pop d
	pop D
	EI
	ret
	; ---------------------------------------------------------------
	; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE        


begin:
	MVI H,200d			  ; Load loop count/2
	MVI L,1				  ; Load loop count multiplier
	;;;;;;;;; MVI B,1				  ; Mutex id 	
	;;;;;;;;; MVI A, SET_MUTEX_SMFR ; Set Mutex and Semaphore 
	;;;;;;;;; call GTU_OS			  ;

loop:
	JMP loop_control   ; Check loop condition 
loop_body:
	;;;;;;;;; JMP wait_func	   ; Call wait function  		
critical_region:
	MVI B,1	   			; ID of MB	
	MVI C,3   			; Address off message box counter 
	MVI A,REMOVE_MEM 	; Call insert system call 
	call GTU_OS	
	DCR H		  	    ; Decrease the loop counter
	;;;;;;;;; JMP signal_func    ; Call signal function 
	JMP loop

loop_control:
	MOV A, H 			;
	CPI 0		  		; Check loop is over 
	JZ handle_or_not  	; Call handle or not 
	JMP loop_body 		;
handle_or_not:
	MOV A, L 			;
	CPI 2				;
	JZ exit 			; The loop over and call exit
	MVI H, 200d			;
	MVI L, 2 			;
	JMP loop_body		;

;;;;;;;;; wait_func:          	; wait function 
;;;;;;;;; 	MVI B,1	   			; ID of MB	
;;;;;;;;; 	MVI C,2   			; Address of Cond Var (&FULL)
;;;;;;;;; 	MVI A,WAIT 			; Call wait system call 
;;;;;;;;; 	call GTU_OS			;
;;;;;;;;; 
;;;;;;;;; 	MVI B,1	   			; ID of MB	
;;;;;;;;; 	MVI C,0   			; Address of Cond Var (&MUTEX)
;;;;;;;;; 	MVI A,WAIT 			; Call wait system call 
;;;;;;;;; 	call GTU_OS			;
;;;;;;;;; 	JMP critical_region ; Enter the critical regin		

;;;;;;;;; signal_func:
;;;;;;;;; 	MVI B,1	   			; ID of MB	
;;;;;;;;; 	MVI C,0   			; Address of Cond Var (&MUTEX)
;;;;;;;;; 	MVI A,SIGNAL 		; Call signal system call 
;;;;;;;;; 	call GTU_OS	
;;;;;;;;; 
;;;;;;;;; 	MVI B,1	   			; ID of MB	
;;;;;;;;; 	MVI C,1   			; Address of Cond Var (&EMPTY)
;;;;;;;;; 	MVI A,SIGNAL 		; Call signal system call 
;;;;;;;;; 	call GTU_OS	
;;;;;;;;; 	JMP loop

exit:		    		; terminate the process	
	MVI A,PROCESS_EXIT
	call GTU_OS	