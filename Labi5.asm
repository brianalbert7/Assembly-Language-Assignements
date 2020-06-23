TITLE Lab 05			(main.asm)

; Program Description:		     Lab 5
; Author:					     Brian Albert
; 							based on Kip Irvine's Template
; Date Created:		          9/26/19		
; Last Modification Date:	

INCLUDE Irvine32.inc

; (insert symbol definitions here)
NUMBER_DAYS = 3 ; # of days for entry

.data

; (insert variables here - flush left)

questionToDisplay byte "Enter the name of your operating system: ",0    ; asking the user to input their OS
answerToQuestion byte "Your operating system is: ",0                    ; displaying the users OS
operatingSystem byte 30 dup (0)                                         ; variable for OS
messagesSentEachDay dword NUMBER_DAYS dup(?)                            ; messagesSentEachDay array holds number of messages
                                                                        ; sent per day
numberMessages byte "Enter # of messages sent today: ",0                ; asking the user to input # of messages sent that day
arrayMessage byte "This is the number of messages you sent each day:",0 ; displaying the array to user
messagesTotal dword ?                                                   ; total number of messages sent
zeroMessage byte "You sent no messages!",0                              ; message displayed if zero messages are sent
totalMessage byte "Total number of messages: ",0                        ; message for array total
fiftyMessage byte "Wow! You sent over 50!"                              ; message for over 50
lessTenMessage byte "You sent in the single digits, nice!"              ; message for under 10
normalMessage byte "That's pretty normal..."                            ; message for <= 50 and >= 10
.code
main PROC
	; (insert executable instructions here -- indented)

     call randomize                       ; reseed random number generator


     ; Getting users OS
     MOV EAX, CYAN                        ; load EAX with code for CYAN
     CALL setTextColor                    ; change the color
     mov edx, offset questionToDisplay    ; load edx with address of question to display
     call writeString          		  ; display String
     mov ecx, LENGTHOF operatingSystem    ; specifies max num of chars
     mov edx, offset operatingSystem      ; writes to OS variable
     call ReadString                      ; reads string from keyboard
     call crlf                            ; \n


     ; Getting users # of messages per day
     MOV EAX, GREEN                               ; load EAX with code for GREEN
     CALL setTextColor                            ; change the color
     mov esi, offset messagesSentEachDay          ; address of messagesSentEachDay
     mov ecx,NUMBER_DAYS                          ; loop counter
     mov edi,0                                    ; zero the accumulator
L1:                                               ; loop to get data and store in array
     mov edx, offset numberMessages               ; points to address of numberMessages
     call writeString          		          ; display String
     mov edx, offset messagesSentEachDay          ; points to address of messagesSentEachDay
     call readInt                                 ; reads an int from keyboard
     mov [esi], eax
     add esi, 4                                   ; points to next integer
     Loop L1                                      ; repeat until ecx = 0


     ; Displaying the users OS
     MOV EAX, Red                       ; load EAX with code for red
     CALL setTextColor                  ; change the color
     mov eax, 10                        ; load eax with 10 for random number
     call randomRange                   ; eax will have random #
     inc eax                            ; increment eax
     mov ecx, eax
L4:
     call crlf                            ; \n
     mov edx, offset answerToQuestion     ; loads edx with address of answer to question
     call writeString                     ; displays the string
     mov edx, offset operatingSystem      ; loads edx with address of OS
     call writeString                     ; displays the string
     LOOP L4
     call crlf                            ; \n
     call crlf                            ; \n


     ; Displaying array
     MOV EAX, YELLOW                      ; load EAX with code for YELLOW
     CALL setTextColor                    ; change the color
     mov edx, offset arrayMessage         ; load edx with address of question to display
     call writeString          		  ; display String
     call crlf                            ; \n
     call dumpNeatArray                   ; displays the messagesSentEachDay array

     ; Totalling the array
     mov edi, offset messagesSentEachDay     ; address of messagesSentEachDay
     mov ecx, NUMBER_DAYS                    ; loop counter
     mov edx, 0                              ; zero the accumulator
L3:
     add edx,[edi]                                     ; adds an integer
     add edi,TYPE messagesSentEachDay                  ; point to the next integer
     Loop L3                                           ; repeat until ecx = 0
     mov messagesTotal, edx                            ; moves the total into messagesTotal variable

     ; Displaying the total
     call crlf
     mov edx, offset totalMessage
     call writeString
     mov eax, messagesTotal
     call writeDec
     call crlf

     mov eax, messagesTotal
     CMP eax, 50
     JG overFifty        ; if total is over 50 go to overFifty

     CMP eax, 0
     JE isZero           ; if total is zero go to isZero

     CMP eax, 10
     JL lessTen          ; if total is under 10 go to lessTen
     JMP moveOn          ; if this point is reached go to move on

overFifty:
     call crlf
     mov edx, offset fiftyMessage
     call writeString
     call crlf
     JMP done

isZero:
     call crlf
     mov edx, offset zeroMessage
     call writeString
     call crlf
     JMP done

lessTen:
     call crlf
     mov edx, offset lessTenMessage
     call writeString
     call crlf
     JMP done

moveOn:
     call crlf
     mov edx, offset normalMessage
     call writeString
     call crlf

done:
	exit					; exit to operating system
main ENDP

; (insert additional procedures here)

dumpNeatArray PROC USES ESI ECX EAX

	mov ESI, offset messagesSentEachDay	; load ESI with address of array
	mov ECX, LENGTHOF messagesSentEachDay   ; load ecx with # of elements
	
L2:
	mov EAX, [ESI]		; load into EAX element from array
	CALL writeDec		; display the element that is in EAX
	
	MOV EAX, ' '		; load space into EAX
	CALL writeChar		; display space

	ADD ESI, 4		; advance to next element
	LOOP L2

	CALL CRLF			; \n

	ret
dumpNeatArray ENDP

END main
