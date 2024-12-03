; Irvine Template - by Raggy Gaggy
;include \masm32\include\windows.inc
;TITLE MASM PlaySound	
;include \masm32\include\kernel32.inc
;include \masm32\include\user32.inc
;include \masm32\include\masm32.inc

;includelib \masm32\include\kernel32.lib
;includelib \masm32\include\user32.lib
;includelib \masm32\include\masm32.lib
Include irvine32.inc
Include macros.inc
Includelib Winmm.lib 


.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

question BYTE "Are you sure you want to quit the game?",0
easteregg db "/\/\(o.o)/\/\ , yes this is an easter egg by Tauha ... ",0
filename db "HighScores.txt",0
answer   DWORD ?




;/--- audio stuff ---
deviceConnect BYTE "DeviceConnect",0
SND_ALIAS    DWORD 20009h
SND_RESOURCE DWORD 00040005h
SND_FILENAME DWORD 20009h
file BYTE "PacMan Original Theme.wav",0
tele db "teleportsound",0
file1 db "pacman_electric_theme.wav",0
file2 db "Pac-man theme remix - By Arsenic1987.wav",0
file3 db "selectionsmusic.wav",0
filex db "PAC-MAN Remix (Trap Remix) - Joe Monday (Official Audio).wav",0

; -- file handiling stuff
BUFFER_SIZE = 9999999
fileHandle HANDLE ?
buffer BYTE BUFFER_SIZE DUP(?)
bufferx BYTE BUFFER_SIZE DUP(?)
 
;//make data variables here...
;CreateFileA Proto, a1:ptr byte, a2: dword, a3: Dword, a4: dword, a5: dword, a6: dword, a7: dword
;ReadFile PROTO, a1:DWORD, a2: PTR BYTE, a3: Dword, a4: ptr dword, a5: dword
;WriteFile PROTO, a1:DWORD, a2: PTR BYTE, a3: Dword, a4: ptr dword, a5: dword
;CloseHandle proto, a1:dword

;.*-*-*-*-*-*-*- NOTES -*-*-*-*-*-*-*-*-
	; my screen , x - axis = [0,72], y - axis = [0,2]

soundPath db "/PacMan Original Theme.wav", 0
;//---graphic assets---
main_name db "  || ",0
strlvl1a db	"||     ||==== \\    // ||==== ||       /||  ",0
strlvl1b db	"||     ||====  \\  //  ||==== ||        ||  ",0
strlvl1c db"||==== ||====   \\//   ||==== ||====  ====== ",0
strlvl1d db	"................The Beginning...............",0

strlvl2x db	"                                     _____  ",0
strlvl2a db	"||     ||==== \\    // ||==== ||          | ",0
strlvl2b db	"||     ||====  \\  //  ||==== ||     |====| ",0
strlvl2c db"||==== ||====   \\//   ||==== ||==== |_____  ",0
strlvl2d db	"................The Challenge...............",0

strlvl3a db	"||     ||==== \\    // ||==== ||     `````| ",0
strlvl3b db	"||     ||====  \\  //  ||==== ||     =====| ",0
strlvl3c db"||==== ||====   \\//   ||==== ||==== _____|  ",0
strlvl3d db	"................The Showdown................",0

pacnameY db ".................................................................................",0
pacnamea db	". @@@@@@    @@@      @@@@@@@   @     @    @@@   @@     @@  @@@@@@@@@@@@@@@@@@@@ .",0
pacnameb db	". @@    @  @   @    @@        @@@   @@@  @   @  @@     @@  @@@@@          @@@@@ .",0
pacnamec db ". @@    @ @     @  @@        @@@@  @@@@ @     @ @@@    @@  @@@@      O     @@@@ .",0
pacnamed db	". @@@@@@  @@@@@@@ @@         @@ @  @ @@ @@@@@@@ @@ @@  @@  @@@              @@@ .",0
pacnamee db	". @@      @     @ @@         @@  @@  @@ @     @ @@  @@ @@  @@@ -------      @@@ .",0
pacnamef db	". @@      @     @  @@        @@      @@ @     @ @@   @@@@  @@@@            @@@@ .",0
pacnameg db ". @@      @     @   @@       @@      @@ @     @ @@    @@@  @@@@@          @@@@@ .",0
pacnameh db	". @@      @     @   @@@@@@@@ @@      @@ @     @ @@     @@  @@@@@@@@@@@@@@@@@@@@ .",0
pacnameX db "...........................press any key to continue.............................",0

 
;/-------012345679|put a pause then rest anmation
ani1 db "Level 1 : the beginning...",0
ani2 db "Level 2 : the challenge...",0
ani3 db "Level 3 : the showdown... ",0

;//----->>123456789|103456789|20345789|303456789|403456789|503456789|603456789|70 (72)
maze1_top db "-----------------------------------------------------------------------",10,
		     "|                                                                     |",10,
			 "|        X################X X X X     ##########################      |",10,
			 "|        X################X X X X     ##########################      |",10,
			 "|                                                                     |",10,
			 "|        X X X X X X #####X X X X     X X X X X X X X X X X#####      |",10,0
;//-> y at 5
maze1_mid1 db"|        X X X X X X #####X X X X     X X X X X X X X X X X#####      |",10,
		     "|                                                          #####      |",10,
			 "|        X X X X X X #####X X X X     X#########################      |",10,
			 "|        X X X X X X #####X X X X     X#########################      |",10,
			 "|        X X X X X X #####X X X X     X####X X X X X X X X X X X      |",10,
			 "|        X X X X X X #####X X X X     X####X X X X X X X X X X X      |",10,0	 
;//-> y at 10
maze1_mid2 db"|        X X X X X X #####X X X X     X####X X X X X X X X X X X      |",10,
		     "|        X X X X X X #####X X X X     X#########################      |",10,
			 "|        X X X X X X #####X X X X     X#########################      |",10,
			 "|        X#######################     X X X X X X X X X X X#####      |",10,
			 "|        X#######################     X X X X X X X X X X X#####      |",10,
			 "|        X X X X X X X X X ######     X#####X X X X X X X X#####      |",10,0	 
;//-> y at 15 
maze1_mid3 db"|        X X X X X X X X X ######     X#####X X X X X X X X#####      |",10,
		     "|        X#######################     X#####X X X X X X X X#####      |",10,
			 "|        X#######################     X#####X X X X X X X X#####      |",10,
			 "|        X X X X X X X X X ######     X############## X X X#####      |",10,
			 "|        X X X X X X X X X ######     X############## X X X#####      |",10,
			 "|        X X X X X X X X X X X X      X X X X X X X X X X X#####      |",10,0	 
;//-> y at 20
maze1_end  db"|                                                          #####      |",10,
			 "|        X#######################X    X X X X X X X X X X X#####      |",10,
		     "|        X#######################X    X X X X X X X X X X X#####      |",10,
			 "|                                                                     |",10,
			 "-----------------------------------------------------------------------",10,0


PAUSED   db "|  ....... GAME PAUSED .......  |",0
help     db "|  (spress spacebar to resume)  |",0
clrpause db "                                 ",0

lostgame   db " GAME OVER | you lost the game      ",0
wongame    db " CONGRATULATONS | you won the game! ",0
credits    db " Credits : made by Tauha Imran      ", 0
final_mssg db " press any key to continue...       ",0
clrline    db "                                    ",0

loadingscrn db " loading...",0
askname db "Enter player name : ",0
endscore db "total score : " ,0
instructions db " INSTRUCTIONS:                              ",0
insta db "> If you touch the ghosts you lose a life!  ",0
instb db "> There are three levels to beat the game   ",0
inst1 db "> a,w,s,d  - move right,up,down,left        ",0
inst2 db "> spacebar - pause game                     ",0
inst3 db "> shift+R  - restart level                  ",0
inst4 db "> shift+h  - quit/go home                   ",0
inst5 db "                                            ",0
inst6 db "                                            ",0

hiscrX db "  NAME -------------- SCORE ---------- LEVEL ",0 
hiscrY db "                                             ",0
         
menu0 db "|---------------------------------------|    ",0
menu1 db "|               MAIN MENU               |    ",0
menu2 db "|=======================================|    ",0
menu3 db "|     Press any key to start playing    |    ",0
menu4 db "|---------------------------------------|    ",0
menu5 db "|       Press 1 - for instructions      |    ",0
menu6 db "|---------------------------------------|    ",0
menu7 db "|       Press 2 - for leaderboard       |    ",0
menu8 db "|---------------------------------------|    ",0


regular   db " press 'b' to return / any other key to start game  ",0

xtra db "Pacman's current position :",0

inkypinkyponky db  "inkypinkyponky...",0
lives_box db "YOU GAINED 2 LIVES!.",0
points_box db " YOU GAINED 200 POINTS!.",0
troll_box db " ..you got pranked buddy :p.",0
boollives db 1
boolpoints db 1
booltroll db 1


strScore db "Your Score : " ,0
strlives db "Lives remaining : ",0
strplayer db "Current player : ",0
strtotal db  "Total sore : ",0

colours DB 2, 4, 6, 8, 10  ; Colors: 2 - Green, 4 - Red, 6 - Brown, 8 - Blue, 10 - Light Green

playername db 255 dup(0),0 ; just a default size of 15 charactors per name
 playername1 db 255 dup(0),0 ; just a default size of 15 charactors per name
 playername2 db 255 dup(0),0 ; just a default size of 255 charactors per name

 namesize db 0

;// ----- sprite assets ----

;//->pacman...
pacman_right db "(`<" ,0
pacman_left  db ">`)" ,0
pacman_up    db ".\/" ,0
pacman_down  db "/\^" ,0
pacman_clear db "   " ,0

xpos_pacman db 33
ypos_pacman db 27
xpacprev db 33
ypacprev db 27
pacpoint db 0,0 ; (x,y)
lives db 3
 score word 0
 total word 0

 totalchar db 3 dup(0),0
 
 pac_direction db "d"

;//->ghosts...
ghost_blue   db  "^.^"  ,0
ghost_red    db  "+.+"  ,0
ghost_yellow db  "*~*"  ,0
ghost_pink   db  ">#<"  ,0

gbX db 0
gbY db 0 
	grX db 0 
	grY db 0 
		gyX db 0 
		gyY db 0 
			gpX db 0 
			gpY db 0 
gprevX db 0
gprevY db 0

; 0lft,1rt , 3up ,
gbd db 0	;ghost  blue   direction
grd db 1	;ghost  red    direction
gyd db 0	;ghost  yellow direction
gpd db 1	;ghost  pink   direction

;//------game play variables-----
 inputChar db 0
current_lvl db 1
gdelay db 30

 
 ;//arrays for the path of pacman
 pathx db 2100 dup(0)
 pathy db 2100 dup(0)

 ;//arrays for the food of pacman
 foodx db 1809 dup(0)
 foody db 1809 dup(0)

 ;//arrays for the walls of the levels
 wallx db 1809 dup(0)
 wally db 1809 dup(0)
 oldwalls db 609 dup(0)

 
resetter dword 0
boolean db 0
randomizer db 0
ghost_bool db  0

maze_moves dword 0

PlaySound PROTO,
        pszSound:PTR BYTE, 
        hmod:DWORD, 
        fdwSound:DWORD


.code

;*******************************************************
main proc

;-----testing------
;mov current_lvl , 3
	;call Level3 ; level 2
;-----testing------


;main proc calls and simulatations...
pacman:
call Clrscr
;call filehandling

mov lives,5
mov score ,0
mov current_lvl , 1
;some file reading functions will do ig 

; starter sound...
invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
invoke PlaySound, OFFSET file, NULL, SND_FILENAME

call MainMenu

; sfx1
invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
invoke PlaySound, OFFSET file3, NULL, SND_FILENAME


call loading

;call PlaySound
;call inkypinkyponky

;electric bckgrnd sound...
;invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
;invoke PlaySound, OFFSET file1, NULL, SND_FILENAME


call selections

 

call getplayername
call Clrscr

; lvl1 sound...
invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
invoke PlaySound, OFFSET file, NULL, SND_FILENAME

mov esi, offset ani1
call level_animation
call Clrscr
mov gdelay,30	
	call Level1 ; level 1
	
	cmp inputChar, 01Bh ; ESC = 01Bh (ascii)
	je game_over

cmp lives,0
je game_over

mov gdelay,20

call Clrscr

; lvl2 sound...
invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
invoke PlaySound, OFFSET file1, NULL, SND_FILENAME

mov esi, offset ani2
call level_animation
call Clrscr
mov current_lvl , 2
	call Level2 ; level 2

	cmp inputChar, 01Bh ; ESC = 01Bh (ascii)
	je game_over

cmp lives,0
je game_over
	
mov gdelay,10

call Clrscr

; lvl3 sound...
invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
invoke PlaySound, OFFSET filex, NULL, SND_FILENAME

mov esi, offset ani3
call level_animation
call Clrscr
mov current_lvl , 3
	call Level3; level 3

	cmp inputChar, 01Bh ; ESC = 01Bh (ascii)
	je game_over

cmp lives,0
je game_over

;if you actually won TuT
mov boolean,1
jmp end_game

game_over:
mov boolean,0

end_game:
call Clrscr
call showScore
call Clrscr
call gameover
call clearfood
mov boolean,1

;calls the proc that sets highscore...
;call filehandling

jmp pacman

invoke ExitProcess, 0

main endp
;*******************************************************

;make functions/proc implementations here...

;...................................
;PlaySound proc
;INVOKE PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
;	mov edi , offset deviceConnect
;        pszSound: edi
;        hmod:DWORD
;        fdwSound:DWORD [SND_ALIAS]
;PlaySound endp
;
;PlaySoundx proc
;mov edi , offset file
 ;       pszSound: edi,
 ;       hmod:NULL ,
 ;       fdwSound:DWORD [SND_FILENAME]
;PlaySoundx endp

	;INVOKE PlaySound, OFFSET file, NULL, SND_FILENAME
;...................................

;inkypinkyponky proc
;invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
;ret
;inkypinkyponky endp

;moyemoye proc
;INVOKE PlaySound, OFFSET file, NULL, SND_FILENAME
;ret
;moyemoye endp
;..................................

;**-------------------------------------------------------------------------------------------**
;**--------------------------------------- MAIN MENUS ----------------------------------------**
;**-------------------------------------------------------------------------------------------**

MainMenu Proc
mov ecx,0
cmp ecx,0
je orignial_menu_start


re_start_menu:
call Clrscr
;call loading_scrn
;call background_design
orignial_menu_start:
mov edi , offset colours

mov ebx,0
mov eax,1000
	call Delay

	mov eax , brown
	call SetTextColor
;...............................................
mov dl,20
mov dh,9
call Gotoxy
mov edx,offset pacnameY
call WriteString
mov eax,5
call Delay
	mov dl,20
	mov dh,10
	call Gotoxy
	mov edx,offset pacnamea
	call WriteString
	mov eax,5
	call Delay
		mov dl,20
		mov dh,11
		call Gotoxy
		mov edx,offset pacnameb
		call WriteString
		mov eax,5
		call Delay
			mov dl,20
			mov dh,12
			call Gotoxy
			mov edx,offset pacnamec
			call WriteString
			mov eax,5
			call Delay
					mov dl,20
					mov dh,13
					call Gotoxy
					mov edx,offset pacnamed
					call WriteString
					mov eax,5
					call Delay
						mov dl,20
						mov dh,14
						call Gotoxy
						mov edx,offset pacnamee
						call WriteString
						mov eax,5
						call Delay
							mov dl,20
							mov dh,15
							call Gotoxy
							mov edx,offset pacnamef
							call WriteString
							mov eax,5
							call Delay
								mov dl,20
								mov dh,16
								call Gotoxy
								mov edx,offset pacnameg
								call WriteString
								mov eax,5
								call Delay
										mov dl,20
										mov dh,17
										call Gotoxy
										mov edx,offset pacnameh
										call WriteString
										mov eax,5
										call Delay
											mov dl,20
											mov dh,18
											call Gotoxy
											mov edx,offset pacnameX
											call WriteString
											mov eax,5
											call Delay
												mov dl,0
												mov dh,0
												call Gotoxy
;.........................................................................
main_menu:
;//---getting user ker input...
call ReadKey
jz main_menu ;if no key , the zero flag is on
;.........
cmp al,'R'
je re_start_menu
;.........................................................................
ret
MainMenu ENDP


;**-------------------------------------------------------------------------------------------**
;**--------------------------------------- selections ----------------------------------------**
;**-------------------------------------------------------------------------------------------**
selections proc
mov esi, offset colours
mov dl,40
mov dh,28
call Gotoxy
mov eax,lightgray
call SetTextColor
mov edx ,offset regular
call WriteString
jmp main_choices
;call rgb_background

;..............................................
 leaderboard_showcase:
;call leaderboard function here
	mov eax,brown
	call SetTextColor
		mov dl,40
		mov dh,10
		call Gotoxy
		mov edx, offset hiscrX
		call WriteString
mov eax,100
call Delay

		mov ebx,0
		mov bl,11
		mov ecx,10
		fillspace:
		mov dl,40
		mov dh,bl
		call Gotoxy
		mov edx, offset hiscrY
		call WriteString
		inc bl
		mov eax,100
		call Delay
		loop fillspace

 jmp read_the_key

;..............................................
instructions_screen:
mov eax,cyan
call SetTextColor
		mov dl,42
		mov dh,10
		call Gotoxy
		mov edx, offset instructions
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,11
		call Gotoxy
		mov edx, offset insta
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,12
		call Gotoxy
		mov edx, offset instb
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,13
		call Gotoxy
		mov edx, offset inst1
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,14
		call Gotoxy
		mov edx, offset inst2
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,15
		call Gotoxy
		mov edx, offset inst3
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,16
		call Gotoxy
		mov edx, offset inst4
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,17
		call Gotoxy
		mov edx, offset inst5
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,18
		call Gotoxy
		mov edx, offset inst6
		call WriteString
jmp read_the_key

;...........................................................
main_choices:


mov eax,green
call SetTextColor
	mov dl,42
	mov dh,10
	call Gotoxy
	mov edx, offset menu0
	call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,11
		call Gotoxy
		mov edx, offset menu1
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,12
		call Gotoxy
		mov edx, offset menu2
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,13
		call Gotoxy
		mov edx, offset menu3
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,14
		call Gotoxy
		mov edx, offset menu4
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,15
		call Gotoxy
		mov edx, offset menu5
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,16
		call Gotoxy
		mov edx, offset menu6
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,17
		call Gotoxy
		mov edx, offset menu7
		call WriteString
mov eax,100
call Delay
		mov dl,42
		mov dh,18
		call Gotoxy
		mov edx, offset menu8
		call WriteString
	
;..............................................

read_the_key:
call rgb_background
;call moyemoye
call ReadKey
jz read_the_key ;if no key , the zero flag is on

cmp al,'b'
je main_choices

cmp al,'1'
je instructions_screen

cmp al,'2'
je leaderboard_showcase

ret
selections endp
;**-------------------------------------------------------------------------------------------**
;**--------------------------------------- LEVEL # 1 -----------------------------------------**
;**-------------------------------------------------------------------------------------------**


;//level1 - proc
Level1 Proc
mov current_lvl , 1
;level number show...
call formPath1 ; draws the food ye
call lvl1_setup
call display_lvl1

    ; Play sound
   ; invoke PlaySound, addr soundPath, 0, SND_FILENAME


mov  eax,lightGray
call SetTextColor 
mov dl ,  73
mov dh , 22
call Gotoxy
mov  eax,lightGreen
call SetTextColor 
mov edx , offset instructions
call WriteString
mov dl ,  73
mov dh , 23
call Gotoxy
mov edx , offset inst1
call WriteString
mov dl ,  73
mov dh , 24
call Gotoxy
mov edx , offset inst2
call WriteString
mov dl ,  73
mov dh , 25
call Gotoxy
mov edx , offset inst3
call WriteString
mov dl ,  73
mov dh , 26
call Gotoxy
mov edx , offset inst4
call WriteString

mov  eax,brown
call SetTextColor 
mov dl ,  72
mov dh , 28
call Gotoxy
mov edx , offset xtra
call WriteString


mov dl , 75
mov dh , 9
call Gotoxy
mov edx, offset strScore
call WriteString
				
mov dl , 75
mov dh , 11
call Gotoxy
mov edx, offset strlives
call WriteString


mov dl , 75
mov dh , 13
call Gotoxy
mov edx, offset strplayer
call WriteString

mov eax,yellow
call SetTextColor

mov edx, offset playername
call WriteString

mov eax,brown
call SetTextColor

mov dl , 75
mov dh , 19
call Gotoxy
mov edx, offset strtotal
call WriteString
 


;setting the color of the maze blue
mov  eax,blue
call SetTextColor 


	;drawing maze - lvl1  here...
	mov dl,0
	mov dh,0
	call Gotoxy
	mov edx, offset maze1_top ;draws draws top
	call WriteString
		mov dl,0
		mov dh,6
		call Gotoxy
		mov edx, offset maze1_mid1 ;draws mid1
		call WriteString
			mov dl,0
			mov dh,12
			call Gotoxy
			mov edx, offset maze1_mid2 ;draws mid2
			call WriteString
				mov dl,0
				mov dh,18
				call Gotoxy
				mov edx, offset maze1_mid3 ;draws mid3
				call WriteString
	mov dl,0
	mov dh,24
	call Gotoxy
	mov edx, offset maze1_end ;draws end
	call WriteString

	call playerGameplay

ret
Level1 ENDP

;//--------------------  clear_path ----------------
clearpath proc
mov esi , offset pathx
mov edi , offset pathy

	mov ecx, sizeof pathx
	mov dh,0
	clearpaths:
	mov byte ptr [esi],dh
	mov byte ptr [edi],dh	
	inc esi
	inc edi
	loop clearpaths

ret
clearpath endp

;//--------------------  clear_path ----------------
clearfood proc
mov esi , offset foodx
mov edi , offset foody

	mov ecx, sizeof foodx
	mov dh,0
	clearpaths:
	mov byte ptr [esi],dh
	mov byte ptr [edi],dh
	inc esi
	inc edi
	loop clearpaths

ret
clearfood endp
;//--------------------  forms-pathPath1 ----------------
formPath1 proc
call clearpath
mov esi , offset foodx
mov edi , offset foody
mov eax , offset pathx
mov ebx , offset pathy

	;line 3 print... (V-left)
	mov dl,5
	mov dh,2
	mov ecx,0
	mov cx,13
	call Gotoxy
	path1c:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], 4
		inc ebx
		inc eax
		inc edi
		inc esi
		inc dh
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], 4
		inc ebx
		inc eax
		inc dh
		inc edi
		inc esi
	LOOP path1c

	;line 4 print... (V-middle)
	mov dl,35
	mov dh,2
	mov ecx,0
	mov cx,13
	call Gotoxy
	path1d:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], 34
		inc ebx
		inc eax
		inc dh
		inc edi

		inc esi
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], 34
		inc ebx
		inc eax
		inc dh
		inc edi
		inc esi
	LOOP path1d

	;line 5 print... (V-right)
	mov dl,67
	mov dh,2
	mov ecx,0
	mov cx,13
	call Gotoxy
	path1e: 
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], 66
		inc ebx
		inc eax
		inc dh
		inc edi
		inc esi
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], 66 
		inc ebx
		inc eax
		inc dh
		inc edi
		inc esi
	LOOP path1e

	;line 1 print... (top)
	mov dl,4
	mov dh,1
	mov ecx,0
	mov cx,31
	call Gotoxy
	path1a:

		mov byte ptr [esi], dl
		mov byte ptr [edi], dh
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc esi
		inc edi
		inc ebx
		inc eax
		inc dl
		mov byte ptr [ebx], 1
		mov byte ptr [eax], dl
		inc esi
		inc edi
		inc dl
	LOOP path1a

	;line 2 print... (bottom)
	mov dl,4
	mov dh,27
	mov ecx,0
	mov cx,31
	call Gotoxy
	path1b:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
	LOOP path1b


	;line 6 print... (H-mid1)
	mov dl,4
	mov dh,4
	mov ecx,0
	mov cx,31
	call Gotoxy
	path1f:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		;cmp ecx , 33
		;jg not_this_one1
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		;not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP path1f

	;line 7 print... (H-mid2)
	mov dl,4
	mov dh,7
	mov ecx,0
	mov cx,26
	call Gotoxy
	path1g:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
	LOOP path1g

	;line 8 print... (H-mid3)
	mov dl,4
	mov dh,24
	mov ecx,0
	mov cx,27
	call Gotoxy
	path1h:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
	cmp cx,1
	je not_this_one1
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
	not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP path1h


ret
formPath1 endp


;**-------------------------------------------------------------------------------------------**
;**--------------------------------------- LEVEL # 2 -----------------------------------------**
;**-------------------------------------------------------------------------------------------**


Level2 Proc
mov current_lvl,2
call formPath2
;call walls_lvl2
call lvl2_setup
call display_lvl2
call playerGameplay
ret
Level2 ENDP

;//--------------------  forms-pathPath2 ----------------
formPath2 proc
call clearpath
call formPath1

	;mov esi , offset foodx
	;mov edi , offset foody
	;mov eax , offset pathx
	;mov ebx , offset pathy

	;gettilpathend:
	;mov dl,byte ptr[eax]
	;;cmp dl,0
	;je getfoodend
	;inc eax
	;inc ebx
	;jmp gettilpathend
	;
	;getfoodend:
	;mov dl,byte ptr[esi]
	;cmp dl,0
	;je setlevl2
	;inc esi
	;inc edi
	;jmp getfoodend


setlevl2:
	mov dl,55
	mov dh,15
	mov ecx,0
	mov ecx,7
	newline1:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dh
		inc edi
		inc esi
		cmp cx,1
	;je not_this_one1
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
	;not_this_one1:
		inc ebx
		inc eax
		inc dh
	LOOP newline1

	mov dl,33
	mov dh,15
	mov ecx,0
	mov ecx,11
	newline2:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], 15
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		cmp cx,1
	;je not_this_one1
		mov byte ptr [ebx], 15
		mov byte ptr [eax], dl
	;not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP newline2

	mov dl,4
	mov dh,18
	mov ecx,0
	mov ecx,10
	newline3:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		cmp cx,1
	;je not_this_one1
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
	;not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP newline3

	mov dl,4
	mov dh,21
	mov ecx,0
	mov ecx,10
	newline4:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		cmp cx,1
	;je not_this_one1
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
	;not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP newline4

	mov dl,3
	mov dh,14
	mov ecx,0
	mov ecx,8
	newline5:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		cmp cx,1
	;je not_this_one1
		mov byte ptr [ebx], dh
		mov byte ptr [eax], dl
	;not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP newline5


	mov dl,45
	mov dh,11
	mov ecx,0
	mov ecx,11
	newline6:
		mov byte ptr [edi], dh
		mov byte ptr [esi], dl
		mov byte ptr [ebx], 11
		mov byte ptr [eax], dl  
		inc ebx
		inc eax
		inc dl
		inc edi
		inc esi
		cmp cx,1
	;je not_this_one1
		mov byte ptr [ebx], 11
		mov byte ptr [eax], dl
	;not_this_one1:
		inc ebx
		inc eax
		inc dl
	LOOP newline6
ret
formPath2 endp
;**-------------------------------------------------------------------------------------------**
;**--------------------------------------- LEVEL # 3 -----------------------------------------**
;**-------------------------------------------------------------------------------------------**


Level3 Proc
mov current_lvl,3
call formPath2
call lvl2_setup
call display_lvl3
call playerGameplay

ret
Level3 ENDP


;**-------------------------------------------------------------------------------------------**
;**------------------------------------ GAME MECHANICS ---------------------------------------**
;**-------------------------------------------------------------------------------------------**

;// ------ *** player gameplay *** -----
playerGameplay proc


;GAMEPLAY HERE
restart1:

mov boolean,0
call setupGhost 
call displayMaze
		;mWrite "   " ; clears old sprite
mov xpos_pacman,34
mov ypos_pacman,27
mov dl , 90
mov dh , 9
call Gotoxy
mov edx,offset pacman_clear
call WriteString


;mov ecx,10
;startup_animation:
;call DrawEatables;draws the food
;mov eax,10
;call Delay
;LOOP startup_animation


	 cmp randomizer,1
	 je skip_randomizer
	
	 mov edx, offset pacman_right
	 call randomizeFood
	mov score,0000h

	skip_randomizer:
	mov randomizer,0
	
	;call DrawEatables;draws the food
	call DrawEatables_fwancy;draws the food ina fwancy way

	call DrawPlayer; draws pacman
	

	
;--gameplay loop for level 1 ---
	gameLoop1:
	
	;saves history of pacamn`s position
	mov bl , xpos_pacman
	mov xpacprev , bl
	mov bl , ypos_pacman
	mov ypacprev , bl

	call movingmaze

	call DrawEatables;draws the food
	call livesXtra
	call pointsXtra
	call trollXtra


	call ghost_collision
	call MoveGhost

	cmp boolean,1
	je restart1

	cmp lives,0
	je exitgame1

	cmp score , 333 ; ( 300+ point , means next level)
	jge skip_level
	;mov  eax,25 ;delay 1 sec
     ; call Delay
	
	call DrawGhost
				;show updated score all the time...
				mov dl , 90
				mov dh , 9
				call Gotoxy
				mov eax,0
				mov ax,score
				call WriteDec
					;shows updated lives all the time...
					mov dl , 93
					mov dh , 11
					call Gotoxy
					mov eax,0
					mov al,lives
					add al,30h
					call WriteChar
						;show updated total-score all the time...
						mov dl , 89
						mov dh , 19
						call Gotoxy
						mov eax,0
						mov ax,total
						call WriteDec
				


	;mov eax,0000h		
	;//--CHECK IF FOOD BEING EATEN
	CALL search_food
	
	;//---getting user ker input...
	call ReadKey
	jz call_automatic_movement ;if no key , the zero flag is on
	mov inputChar,al

	cmp eax , 3B00h ; F1 - 3B00 = ax (for skipping levels)
	je skip_level

	;ESC key pressed to exit...
	cmp inputChar, 01Bh ; ESC = 01Bh (ascii)
	je exitgame1


	cmp inputChar,'R' ; 'R'(capital)- restart
	je restart1
	
	cmp inputChar,'H' ; 'R'(capital)- restart
	je homebox
	
	cmp inputChar,' ' ; ' '(spacebar)- pauses game
	je pausegame
		
	cmp inputChar,'l' ; 'l',xtra life adder 
	jne no_dev_livs_inc
	inc lives
	no_dev_livs_inc:

					;player cordinates display...
					mov  eax,brown
					call SetTextColor 
					mov dl ,  99
					mov dh , 28
					call Gotoxy
					mov al, '('
					call WriteChar				
					mov eax,0
					mov al, xpos_pacman
					call WriteInt
					mov eax,0
					mov al, ','
					call WriteChar
					mov eax,0
					mov al, ypos_pacman
					call WriteInt
					mov eax,0
					mov al, ')'
					call WriteChar
					mov eax,0
					;exxxtra help sdnfls
					mov al, pac_direction
					call WriteChar
					
					;error_help....
					;checks for maze collisions
					;jc gameloop1
					
					


		;//--- W is up
		cmp inputChar,'w'
		je move_up

			;//--- S is down
			cmp inputChar,'s'
			je move_dn

				;//--- D is right
				cmp inputChar,'d'
				je move_rt

					;//--- A is left
					cmp inputChar,'a'
					je move_lt

					;if irrelevant keys pressed...
					jmp gameLoop1

		move_up:
			call UpdatePlayer
			mov pac_direction,'w'
			dec ypos_pacman
			;cmp current_lvl , 1
			;	je level1up
			;	call player_maze_collisionx
			;	jmp level1upx
			;	level1up:
				call player_maze_collision1

			;	level1upx:
			mov esi , offset pacman_up
			call DrawPlayer
		jmp gameLoop1


			move_dn:
				call UpdatePlayer
				mov pac_direction,'s'
				inc ypos_pacman
				;cmp current_lvl , 1
				;	je level1dn
				;	call player_maze_collisionx
				;	jmp level1dnx
				;	level1dn:
					call player_maze_collision1
				;	level1dnx:
				mov esi , offset pacman_down
				call DrawPlayer
			jmp gameLoop1
				
				move_rt:
					call UpdatePlayer
					mov pac_direction,'d'
					inc xpos_pacman
					;cmp current_lvl , 1
					;	je level1rt
					;	call player_maze_collisionx
					;	jmp level1rtx
					;	level1rt:
						call player_maze_collision1
					;	level1rtx:
					mov esi , offset pacman_right
					call DrawPlayer
				jmp gameLoop1
			
					move_lt:
						call UpdatePlayer
						mov pac_direction,'a'
						dec xpos_pacman
						;cmp current_lvl , 1
						;	je level1lft
						;	call player_maze_collisionx
						;	jmp level1lftx
						;	level1lft:
							call player_maze_collision1
						;	level1lftx:
					mov esi , offset pacman_left
					call DrawPlayer
					jmp gameLoop1
	
	
					; incase no key was pressed lol
					call_automatic_movement:				
					mov  eax,50          ; sleep, to allow OS to time slice
					call Delay           ; (otherwise, some key presses are lost)
						;//--- a is left
						cmp pac_direction,'a'
						je move_lt
							;//--- w is up
							cmp pac_direction,'w'
							je move_up
								;//--- s is down
								cmp pac_direction,'s'
								je move_dn
									;//--- d is right
									cmp pac_direction,'d'
									je move_rt
			
			;-*-*-* PAUSING MECHANICS!*-*-*-
			pausegame:
				stay_paused:
				 mov  eax,white+(green*16)
				call SetTextColor
				mov dl , 75
				mov dh , 16
				call Gotoxy
				mov edx,offset PAUSED
				call WriteString
				mov dl , 75
				mov dh , 17
				call Gotoxy
				mov edx,offset help
				call WriteString

					mov  eax,50          ; sleep, to allow OS to time slice
					call Delay           ; (otherwise, some key presses are lost)
					mov eax,0
					call ReadKey         ; look for keyboard input
					jz   stay_paused      ; no key pressed yet
	
					cmp al,' ' ;spacebar...
					jne stay_paused
					je resume_game

				;-*-*-* QUITcmd MECHANICS!*-*-*-
				homebox:
					mov  edx,offset question
					mov  ebx,offset easteregg  ; no caption
					call MsgBoxAskmine
					cmp  eax,IDYES
					je exitgame1
					cmp  eax,IDNO
					je resume_game
				

				resume_game:
				mov  eax,black+(black*16)
				call SetTextColor
				mov dl , 75
				mov dh , 17
				call Gotoxy
				mov edx,offset clrpause
				call WriteString
				mov dl , 75
				mov dh , 16
				call Gotoxy
				mov edx,offset clrpause
				call WriteString
				
	jmp gameLoop1

	skip_level:
	inc current_lvl
	jmp leavelevel

exitgame1:
mov inputChar, 01Bh 
leavelevel:
ret
playerGameplay endp

;//-------ghost_collision------
ghost_collision proc
mov boolean , 0
mov bl, ypos_pacman
;..for y values

	
	cmp current_lvl,2
	jle ignore_pinky ; ignore pinky
	mov bl, ypos_pacman	
	cmp gpY, bl ;inkypinkyponky - y val matchs 0
	inc bl
	cmp gpY, bl ;inkypinkyponky - y val matchs 1
	jne ignore_pinky
	je NO_checkXrangePINKy
	NO_checkXrangePINKy:
			mov bl, xpos_pacman
					cmp gpX, bl ;inkypinkyponky x-val0
					je collision
				inc bl
					cmp gpX, bl ;inkypinkyponky x-val1
					je collision
				inc bl
					cmp gpX, bl ;inkypinkyponky x-val2
					je collision

	;if pinky no get inky or ponky
	ignore_pinky:
	mov bl, ypos_pacman	
	; checking Y values (blue,red,yellow)
	cmp gbY, bl
	je checkXrange
	cmp grY, bl
	je checkXrange
	;...
	cmp current_lvl,1
	je ignore_yellow1 ; ignore
	cmp gyY, bl
	je checkXrange
	ignore_yellow1:
				inc bl
	cmp gbY, bl
	je checkXrange
	cmp grY, bl
	je checkXrange
	;...
	cmp current_lvl,1
	je ignore_yellow2 ; ignore
	cmp gyY, bl
	je checkXrange
	ignore_yellow2:

	; if noting found
	jmp no_collision

	checkXrange:
	mov bl, xpos_pacman
	
	cmp gbX, bl
	je collision
	cmp grX, bl
	je collision
	;...
	cmp current_lvl,1
	je ignore_yellow3 ; ignore
	cmp gyX, bl
	je collision
	ignore_yellow3:
		;cmp pac_direction , 'd'
		;je right_adjust
		
		;cmp pac_direction , 'a'
		;je left_adjust

			left_adjust:
			mov bl, xpos_pacman
					cmp gbX, bl
					je collision
					cmp grX, bl
					je collision
					;...
					cmp current_lvl,1
					je ignore_yellow4 ; ignore
					cmp gyX, bl
					je collision
					ignore_yellow4:
				inc bl
					cmp gbX, bl
					je collision
					cmp grX, bl
					je collision
					;...
					cmp current_lvl,1
					je ignore_yellow5 ; ignore
					cmp gyX, bl
					je collision
					ignore_yellow5:
				inc bl
					cmp gbX, bl
					je collision
					cmp grX, bl
					je collision
					;...
					cmp current_lvl,1
					je ignore_yellow6 ; ignore
					cmp gyX, bl
					je collision
					ignore_yellow6:
				
			right_adjust:
			mov bl, xpos_pacman
				dec bl
					cmp gbX, bl
					je collision
					cmp grX, bl
					je collision
					;...
					cmp current_lvl,1
					je ignore_yellow7 ; ignore
					cmp gyX, bl
					je collision
					ignore_yellow7:
			;	dec bl
			;		cmp gbX, bl
			;		je collision
			;		cmp grX, bl
			;		je collision
			;		cmp gyX, bl
			;		je collision
			;	dec bl
			;		cmp gbX, bl
			;		je collision
			;		cmp grX, bl
			;		je collision
			;		cmp gyX, bl
			;		je collision
				jmp no_collision	
			
collision:
dec lives
mov boolean ,1
mov randomizer,1
no_collision:
ret
ghost_collision endp


;//-------------------- DrawPlayer ---------------
DrawPlayer Proc

no_draw:

;setting the color of the maze blue
  mov  eax,yellow
  call SetTextColor

	mov dl,xpos_pacman
	mov dh,ypos_pacman

	cmp dl,0 ; check for x-axis > 0
	jle setx_left
	cmp dl,68 ; check for x-axis < 72
	jge setx_right

	cmp dh,0 ; check for y-axis > 0
	jle sety_up
	cmp dh,28 ; check for y-axis < 29
	jge sety_dn

	jmp drawSprite

setx_left:
	mov xpos_pacman,1 
	jmp no_draw

setx_right:
	mov xpos_pacman,66
	jmp no_draw

sety_up:
	inc ypos_pacman
jmp no_draw

sety_dn:
	dec ypos_pacman
jmp no_draw
	

;---------------
drawSprite:
mov  eax,brown
call SetTextColor 
	call Gotoxy
	mov edx,esi
	call WriteString

Ret
DrawPlayer EndP

;//-------------------- UpdatePlayer -------------
UpdatePlayer proc
	
	call Teleportation	
	
	mov dl,xpos_pacman
	mov dh,ypos_pacman
	call Gotoxy
	mov edx, offset pacman_clear
	call WriteString


ret
UpdatePlayer endp

;//----------- livesXtra --------
livesXtra proc
cmp current_lvl,2
jle noXtra
cmp boollives,0
je noXtra
		
		mov dl,55 
		mov dh,15
		call Gotoxy
		mov eax,red+(white*16)
		call SetTextColor
		mov eax,0
		mov al,'?'
		call WriteChar
		mov eax,black+(black*16)
		call SetTextColor
		mov eax,0

		cmp xpos_pacman,55
		jne noXtra
			cmp ypos_pacman,15
			jne noXtra
			;mov eax,offset lives_box
			;mov ebx, offset inkypinkyponky
			;call MsgBoxAskmine
			inc lives
			inc lives
			mov boollives,0
	
noXtra:
ret
livesXtra endp

;//----------- trollXtra --------
trollXtra proc
cmp current_lvl,2
jle noXtra
cmp booltroll,0
je noXtra

	mov dl,4
		mov dh,1
		call Gotoxy
		mov eax,white+(red*16)
		call SetTextColor
		mov eax,0
		mov al,'?'
		call WriteChar
		mov eax,black+(black*16)
		call SetTextColor
		mov eax,0

		cmp xpos_pacman,4
		jne noXtra
			cmp ypos_pacman,1
			jne noXtra
			;mov eax,offset lives_box
			;mov ebx, offset inkypinkyponky
			;call MsgBoxAskmine
			add score,200
			add total,200
			mov boolpoints,0



noXtra:
ret
trollXtra endp

;//----------- pointsXtra --------
pointsXtra proc
cmp current_lvl,1
je noXtra
cmp boolpoints,0
je noXtra

noXtra:
ret
pointsXtra endp

;//----------- Teleportation --------
Teleportation proc

cmp current_lvl,1
je no_tel

;cmp current_lvl,3
;je no_tel

mov eax,magenta+(white*16)
call SetTextColor

	mov dl,3 
	mov dh,14
	call Gotoxy
	mov al,'{'
	call WriteChar


	mov dl,69
	mov dh,14
	call Gotoxy
	mov al,'}'
	call WriteChar

	mov eax,0
	mov eax,black+(black*16)
	call SetTextColor

	cmp ypos_pacman,14
	je checkgate
	jne no_tel

	checkgate:
	cmp xpos_pacman,3
	jne next_gate
	mov xpos_pacman,67
	mov dl,3
	mov dh,14
	call Gotoxy
	mov edx , offset pacman_clear
	call WriteString
	cmp current_lvl,2
	jg no_tel
	invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
		invoke PlaySound, OFFSET tele, NULL, SND_FILENAME
		mov eax,500
		call Delay
		jmp sound_check

	next_gate:
	cmp xpos_pacman,66
	jne no_tel
	cmp pac_direction ,'d'
	jne no_tel
	mov dl,66
	mov dh,14
	call Gotoxy
	mov edx , offset pacman_clear
	call WriteString
	mov xpos_pacman,3
	cmp current_lvl,2
	jg no_tel
	invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
		invoke PlaySound, OFFSET tele, NULL, SND_FILENAME
		mov eax,5
		call Delay
		jmp sound_check


	sound_check:
	; lvl2 sound...
	mov eax,1000
	call Delay
	invoke PlaySound, OFFSET deviceConnect, NULL, SND_ALIAS
	invoke PlaySound, OFFSET file1, NULL, SND_FILENAME

no_tel:
ret
Teleportation endp
;//---------------------player_maze_collisionx----------------

player_maze_collisionx proc

mov edi, offset wally
mov esi, offset wallx
mov ecx, sizeof wally

	check_if_on_path_ydom:

		;checking y value
		cmp ah,byte ptr[edi]
		je checkX_vals
		jmp next_point	
		cmp ah,1
		je checkX_vals

		checkX_vals:
		cmp al,byte ptr [esi]
		je return_collision

	next_point:
	inc edi
	inc esi
	LOOP check_if_on_path_ydom

jmp let_roam

	return_collision:
	mov eax,0
	mov al,xpacprev
	mov xpos_pacman , al
	mov eax,0
	mov al,ypacprev
	mov ypos_pacman , al

let_roam:	
ret
player_maze_collisionx endp

;//---------------------player_maze_collision1----------------
player_maze_collision1 proc
;pmc1xy 1,2,3,4,5,6.....are skips for when collision is not detected

mov esi , offset pathx
mov edi , offset pathy
	
mov ecx , 0
mov ecx , sizeof pathx
mov al, xpos_pacman ;x-axis
mov ah , ypos_pacman;y-axis

cmp ah,1
je return_collision

	mov ecx, sizeof pathx
	check_if_on_path_ydom:

		;checking y value
		cmp ah,byte ptr[edi]
		je checkX_vals
		jmp next_point	
		cmp ah,1
		je checkX_vals
		jne next_point

		checkX_vals:
		cmp al,byte ptr [esi]
		je return_collision

	next_point:
	inc edi
	inc esi
	LOOP check_if_on_path_ydom
	

;collision correction
correct_collision:
	mov al , xpacprev
	mov xpos_pacman , al
	mov ah , ypacprev
	mov ypos_pacman , ah
 
return_collision:
;returning to the gameplay manager....
ret
player_maze_collision1 endp


;//-------------------- RandomPlayerPosition -------------
RandomPlayerPosition PROC
Ret
RandomPlayerPosition ENDP

;//-------------------- DrawGhost ---------------
DrawGhost Proc

	cmp current_lvl , 1
	je level1_drawghosts
	cmp current_lvl , 2
	je level2_drawghosts


level3_drawghosts:
	
	;--drawing ghost_pink
	mov dl , gpX
	mov dh , gpY
	call Gotoxy
	mov  eax,lightMagenta
    call SetTextColor
	mov edx , offset ghost_pink
	call WriteString
	mov eax,0
	mov al, gdelay
	call Delay


level2_drawghosts:

	;--drawing ghost_yellow
	mov dl , gyX
	mov dh , gyY
	call Gotoxy
	mov  eax,yellow
    call SetTextColor
	mov edx , offset ghost_yellow
	call WriteString
	mov eax,0
	mov al,gdelay
	call Delay


level1_drawghosts:
	
	;--drawing ghost_blue
	mov dl , gbX
	mov dh , gbY
	call Gotoxy
	mov  eax,lightBlue
    call SetTextColor
	mov edx , offset ghost_blue
	call WriteString
	mov eax,0
	mov al, gdelay
	call Delay

	;--drawing ghost_red
	mov dl , grX
	mov dh , grY
	call Gotoxy
	mov  eax,lightRed
    call SetTextColor
	mov edx , offset ghost_red
	call WriteString
	mov eax,0
	mov al,gdelay
	call Delay



Ret
DrawGhost ENDP

;//-------------------- MoveGhost ---------------
MoveGhost proc

;.................................................	
	blueghost:
	mov al,gbX
	mov ah,gbY
	mov gprevX,al
	mov gprevY,ah
	

		cmp gbd,0
		je moveblueleft
		cmp gbd,1
		je moveblueright
		cmp gbd,2
		je moveblueup
		cmp gbd,3
		je movebluedown

		moveblueleft:
			mov al,gbX
			dec al
			mov ah,gbY
			call search_path_point
			cmp ghost_bool,1
			je moveBlue
			inc gbd
			jmp blueghost

		moveblueright:
			mov al,gbX
			inc al
			mov ah,gbY
			call search_path_point
			cmp ghost_bool,1
			je moveBlue
			inc gbd
			jmp blueghost

		moveblueup:
			mov al,gbX
			mov ah,gbY
			dec ah
			call search_path_point
			cmp ghost_bool,1
			je moveBlue
			inc gbd
			jmp blueghost

		movebluedown:
			mov al,gbX
			mov ah,gbY
			inc ah
			call search_path_point
			cmp ghost_bool,1
			je moveBlue
			mov gbd,0
			jmp blueghost

moveBlue:
mov dl,gprevX
mov dh,gprevY
call Gotoxy
mov edx,offset pacman_clear
call writeString
mov gbX,al
mov gbY,ah
mov eax,0
mov ghost_bool,0
;.................................................

redghost:
	mov al,grX
	mov ah,grY
	mov gprevX,al
	mov gprevY,ah
	

		cmp grd,0
		je moveredleft
		cmp grd,1
		je moveredright
		cmp grd,2
		je moveredup
		cmp grd,3
		je movereddown

		moveredleft:
			mov al,grX
			dec al
			mov ah,grY
			call search_path_point
			cmp ghost_bool,1
			je moveRed
			inc grd
			jmp redghost

		moveredright:
			mov al,grX
			inc al
			mov ah,grY
			call search_path_point
			cmp ghost_bool,1
			je moveRed
			inc grd
			jmp redghost

		moveredup:
			mov al,grX
			mov ah,grY
			dec ah
			call search_path_point
			cmp ghost_bool,1
			je moveRed
			inc grd
			jmp redghost

		movereddown:
			mov al,grX
			mov ah,grY
			inc ah
			call search_path_point
			cmp ghost_bool,1
			je moveRed
			mov grd,0
			jmp redghost

moveRed:
mov dl,gprevX
mov dh,gprevY
call Gotoxy
mov edx,offset pacman_clear
call writeString
mov grX,al
mov grY,ah
mov eax,0
mov ghost_bool,0
;.................................................
cmp current_lvl,1
jle next2

yellowghost:
	mov al,gyX
	mov ah,gyY
	mov gprevX,al
	mov gprevY,ah
	

		cmp gyd,0
		je movyellowleft
		cmp gyd,1
		je movyellowright
		cmp gyd,2
		je movyellowup
		cmp gyd,3
		je movyellowdown

		movyellowleft:
			mov al,gyX
			dec al
			mov ah,gyY
			call search_path_point
			cmp ghost_bool,1
			je moveYellow
			inc gyd
			jmp yellowghost

		movyellowright:
			mov al,gyX
			inc al
			mov ah,gyY
			call search_path_point
			cmp ghost_bool,1
			je moveYellow
			mov gyd,0
			jmp yellowghost

		movyellowup:
			mov al,gyX
			mov ah,gyY
			dec ah
			call search_path_point
			cmp ghost_bool,1
			je moveYellow
			mov gyd,1
			jmp yellowghost

		movyellowdown:
			mov al,gyX
			mov ah,gyY
			inc ah
			call search_path_point
			cmp ghost_bool,1
			je moveYellow
			mov gyd,0
			jmp yellowghost

moveYellow:
mov dl,gprevX
mov dh,gprevY
call Gotoxy
mov edx,offset pacman_clear
call writeString
mov gyX,al
mov gyY,ah
mov eax,0
mov ghost_bool,0
;.................................................................
cmp current_lvl,2
jle next2

pinkghost:
	mov al,gpX
	mov ah,gpY
	mov gprevX,al
	mov gprevY,ah
	

		cmp gpd,0
		je movpinkleft
		cmp gpd,1
		je movpinkright
		cmp gpd,2
		je movpinkup
		cmp gpd,3
		je movpinkdown

		movpinkleft:
			mov al,gpX
			dec al
			mov ah,gpY
			call search_path_point
			cmp ghost_bool,1
			je movePink
			inc gpd
			jmp pinkghost

		movpinkright:
			mov al,gpX
			inc al
			mov ah,gpY
			call search_path_point
			cmp ghost_bool,1
			je movePink
			inc gpd
			jmp pinkghost

		movpinkup:
			mov al,gpX
			mov ah,gpY
			dec ah
			call search_path_point
			cmp ghost_bool,1
			je movePink
			inc gpd
			jmp pinkghost

		movpinkdown:
			mov al,gpX
			mov ah,gpY
			inc ah
			call search_path_point
			cmp ghost_bool,1
			je movePink
			mov gpd,0
			jmp pinkghost

movePink:
mov dl,gprevX
mov dh,gprevY
call Gotoxy
mov edx,offset pacman_clear
call writeString
mov gpX,al
mov gpY,ah
mov eax,0
mov ghost_bool,0
;..................................................................

next2:
ret
MoveGhost endp

;//-------------------- setupGhost ---------------
setupGhost proc
mov eax,0

mov gbd,0
mov grd,1
mov gyd,0
mov gpd,1

	cmp current_lvl , 1
	je level1_setupghosts
	
	cmp current_lvl , 2
	je level2_setupghosts
	
	mov gpX,0
	mov gpY,0
	;--setting ghost_pink
	mov eax,62 ; 0-62 range
	call RandomRange
	inc eax ; 1-63 range
	inc eax ; 2-64 range
	inc eax ; 3-65 range
	inc eax ; 4-66 range
	add gpX,al
	add gpY,1

level2_setupghosts:
	;--moving ghost_yellow
	mov gyX,0
	mov gyY,0
	mov eax,62 ; 0-62 range
	call RandomRange
	inc eax ; 1-63 range
	inc eax ; 2-64 range
	inc eax ; 3-65 range
	inc eax ; 4-66 range
	add gyX,al
	add gyY,1

level1_setupghosts:

	;--moving ghost_blue
	mov gbX,0
	mov gbY,0
	mov eax,62 ; 0-62 range
	call RandomRange
	inc eax ; 1-63 range
	inc eax ; 2-64 range
	inc eax ; 3-65 range
	inc eax ; 4-66 range
	add gbX,al
	add gbY,1

	;--moving ghost_red
	mov grX,0
	mov grY,0
	mov eax,62 ; 0-62 range
	call RandomRange
	inc eax ; 1-63 range
	inc eax ; 2-64 range
	inc eax ; 3-65 range
	inc eax ; 4-66 range
	add grX,al
	add grY,1

	

ret
setupGhost endp


;//-------------------- DrawEatables ---------------
DrawEatables Proc

mov  eax,magenta
call SetTextColor

mov esi , offset foodx
mov edi , offset foody
	mov ecx,0
	mov ecx,1806

	drawfood:
	mov dl, byte ptr[esi]
		cmp dl,0
		je no_draw_food
		mov dh, byte ptr[edi]
		cmp dh,0
		je no_draw_food
			call Gotoxy
			mov al,'*'
			call WriteChar
			

	no_draw_food:
	inc esi
	inc edi
	LOOP drawfood

Ret
DrawEatables ENDP


;//-------------------- DrawEatables ---------------
DrawEatables_fwancy Proc

mov  eax,magenta
call SetTextColor

mov esi , offset foodx
mov edi , offset foody
	mov ecx,0
	mov ecx,1806

	drawfood:
	mov dl, byte ptr[esi]
		cmp dl,0
		je no_draw_food
		mov dh, byte ptr[edi]
		cmp dh,0
		je no_draw_food
			call Gotoxy
			mov al,'*'
			call WriteChar
			mov eax,50
			call Delay

	no_draw_food:
	inc esi
	inc edi
	LOOP drawfood

Ret
DrawEatables_fwancy ENDP


;----------- randomizeFood -------
randomizeFood proc

mov edi, offset foodx
mov edi, offset foody
mov ecx,0
mov ecx, sizeof foodx

reduce_food:
inc esi
inc edi
dec ecx
	mov byte ptr[esi],0
	mov byte ptr[edi],0
	inc esi
	inc edi
	dec ecx
		mov byte ptr[esi],0
		mov byte ptr[edi],0
		inc esi
		inc edi

LOOP reduce_food
ret
randomizeFood endp
; ---------- search_path_point --------
search_path_point proc
; al = x value
; ah = y value
mov edi , offset pathx
mov esi , offset pathy
mov ecx,0
mov ecx , sizeof pathx

	find_point_in_path:

		cmp al , byte ptr [edi]		 
		je checky_inpath
		cmp al , 66	  ; right edge x value
		jge return_false
		cmp al , 4	  ; left edge x value
		jle return_false
		cmp ah , 0	  ; up edge x value
		jle return_false
		cmp ah , 28	  ; down edge y value
		jge return_false	

			checky_inpath:
			cmp ah , byte ptr[esi]
			je return_true

	LOOP find_point_in_path

return_true:
	;stc ; carry flag = 1 true/found
	mov ghost_bool,1
	jmp return
return_false:
	mov ghost_bool,0 ; carry flag = 0 false/not-found
	jmp return

return:
ret
search_path_point endp
; -- searches for the food and updates score and sheetuff

;//-------------------- search_food ---------------
search_food proc

mov esi , offset foodx
mov edi , offset foody

mov ecx , 0
mov ecx , sizeof foodx

	searchf_point:
		mov bl , byte ptr [esi]
		mov bh , byte ptr [edi]

;if the cordinate is already clear for
cmp bl , 0 ;x - coordinate
je noxt
cmp bh , 0 ;y - coordinate
je noxt

		; some hardcoded veritical individualities...
		;cmp xpos_pacman ,67 ; V- rightR
		;je check_yaxis
		cmp xpos_pacman ,66; V- rightM
		je inc_x
		;cmp xpos_pacman ,65; V- rightL
		;je check_yaxis
		;cmp xpos_pacman ,35 ; V- MiddleR
		;je check_yaxis
		cmp xpos_pacman ,34; V- MiddleM
		je inc_x
		;cmp xpos_pacman ,33; V- MiddleL
		;je check_yaxis
		;cmp xpos_pacman ,5 ; V- leftR
		;je check_yaxis
		cmp xpos_pacman ,4; V- leftM
		je inc_x
		;cmp xpos_pacman ,3; V- leftL
		;je check_yaxis


		cmp xpos_pacman ,bl
		jne noxt
		jmp check_yaxis

		inc_x:
		mov al, xpos_pacman
		inc al
		cmp al ,bl
		jne noxt
		jmp check_yaxis

		check_yaxis:
			cmp ypos_pacman,bh
			je foodfound
	noxt:
		inc esi
		inc edi
	loop searchf_point
	
	jmp end_food_search

foodfound:
	mov byte ptr [esi],00h
	mov byte ptr [edi],00h
	add score,5
	add total,5

end_food_search:
ret
search_food endp

;**-------------------------------------------------------------------------------------------**
;**------------------------------------ ENVIRONMENTALS ---------------------------------------**
;**-------------------------------------------------------------------------------------------**

walls_reset proc

mov esi , offset wallx
mov edi , offset wally
mov ecx,sizeof wallx

reset_walls:
	mov byte ptr [esi] ,0
	mov byte ptr [edi] ,0
	inc edi
	inc esi
LOOP reset_walls

ret
walls_reset endp

;//----------- search for a point in the walls ---------
wall_find_point proc
; al - x point
; ah - y point
	
	mov esi , offset wallx
	mov edi , offset wally
	mov ecx,sizeof wallx

	find_x:
	 cmp al,byte ptr [esi]
	 je searchy
	 inc esi
	LOOP find_x

	searchy:
	mov ecx,sizeof wally

	find_y:
	 cmp al,byte ptr [edi]
	 je return_true
	 inc edi
	LOOP find_x
	
	;if false go home
	clc
	jmp home

return_true:
stc
home:
ret
wall_find_point endp

;//----------- walls for level 1 ---------
walls_lvl2 proc
mov esi , offset wallx
mov edi , offset wally
	
	;...the top two lines...
	mov dl,7
	wall1a:
		mov byte ptr [esi],dl
		mov byte ptr [edi],2
		inc esi
		inc edi
		mov byte ptr [esi],dl
		mov byte ptr [edi],3
		inc esi
		inc edi
		inc dl
	cmp dl,32
	jle wall1a
	
	mov dl,35
	wall1b:
		mov byte ptr [esi],dl
		mov byte ptr [edi],2
		inc esi
		inc edi
		mov byte ptr [esi],dl
		mov byte ptr [edi],3
		inc esi
		inc edi
		inc dl
	cmp dl,63
	jle wall1b

		;...the next two lines ...
		mov dl,7
		wall1c:
			mov byte ptr [esi],dl
			mov byte ptr [edi],5
			inc esi
			inc edi
			mov byte ptr [esi],dl
			mov byte ptr [edi],6
			inc esi
			inc edi
			inc dl
		cmp dl,32
		jle wall1c

		mov dl,35
		wall1d:
		mov byte ptr [esi],dl
		mov byte ptr [edi],5
		inc esi
		inc edi
		mov byte ptr [esi],dl
		mov byte ptr [edi],6
		inc esi
		inc edi
		inc dl
	cmp dl,63
	jle wall1d

			;...the bottom two lines ...
				mov dl,7
				wall1e:
					mov byte ptr [esi],dl
					mov byte ptr [edi],25
					inc esi
					inc edi
					mov byte ptr [esi],dl
					mov byte ptr [edi],26
					inc esi
					inc edi
					inc dl
				cmp dl,32
				jle wall1e

				mov dl,35
				wall1f:
				mov byte ptr [esi],dl
				mov byte ptr [edi],25
				inc esi
				inc edi
				mov byte ptr [esi],dl
				mov byte ptr [edi],26
				inc esi
				inc edi
				inc dl
			cmp dl,63
			jle wall1e

ret
walls_lvl2 endp 

;**-------------------------------------------------------------------------------------------**
;**----------------------------------- UI/UX + screens ---------------------------------------**
;**-------------------------------------------------------------------------------------------**


;end score screen
showScore proc
mov eax,green
call SetTextColor
mov dl,20
mov dh,15
call Gotoxy
mov edx, offset playername
call WriteString 
mov al,'`'
call WriteChar
mov al,'s'
call WriteChar
mov dl,20
mov dh,16
call Gotoxy
mov edx, offset strtotal
call WriteString
mov ecx,0
countscore:
cmp cx,total
je letthemsee
mov eax,0
mov eax,ecx
call WriteDec
mov eax,10h
call Delay
mov eax,0
inc ecx
mov dl,34
mov dh,16
call Gotoxy
jmp countscore

letthemsee:
mov eax,5000h
call Delay

ret
showScore endp

;//================
MsgBoxAskmine proc
call MsgBoxAsk
ret
MsgBoxAskmine endp

MsgBoxmine proc
call MsgBox
ret
MsgBoxmine endp
;//------------ pausegame ----------
gameover proc

;.......................................
	mov  eax,green
	call SetTextColor
	
	cmp boolean,1
	je winner

	cmp boolean,0
	je loser

;.......................................
	loser:
		mov dl , 45
		mov dh , 15
		call Gotoxy

		mov ecx,11
		mov esi , offset  lostgame 

			gameover_mssg1:
			mov al, byte ptr [esi]
			call WriteChar
			inc esi
			mov eax,9
			call Delay
			loop gameover_mssg1
	
			mov ecx,25

				gameover_mssg2:
				mov al, byte ptr [esi]
				call WriteChar
				inc esi
				mov eax,9
				call Delay
				loop gameover_mssg2

					mov eax,3000
					call Delay

			jmp credits_scene

;.......................................
	winner:

		mov dl , 45
		mov dh , 15
		call Gotoxy

		mov ecx,17
		mov esi , offset wongame 

			gameover_mssg3:
			mov al, byte ptr [esi]
			call WriteChar
			inc esi
			mov eax,9
			call Delay
			loop gameover_mssg3
	
			mov ecx,sizeof wongame 
			sub ecx,17

				gameover_mssg4:
				mov al, byte ptr [esi]
				call WriteChar
				inc esi
				mov eax,9
				call Delay
				loop gameover_mssg4

				mov eax,3000
					call Delay

			jmp credits_scene


;................................................
credits_scene:

		mov dl , 45
		mov dh , 15
		call Gotoxy

		mov ecx, sizeof credits
		mov esi , offset credits

			writecredits:
				mov al, byte ptr [esi]
				call WriteChar
				inc esi
				mov eax,9
				call Delay
			loop writecredits

				mov eax,3000
				call Delay

;.................................................
		mov dl , 45
		mov dh , 15
		call Gotoxy

		mov ecx, sizeof final_mssg
		mov esi , offset final_mssg

		ending_line:
				mov al, byte ptr [esi]
				call WriteChar
				inc esi
				mov eax,9
				call Delay
		loop ending_line
;.................................................
waiting:
	call ReadKey
	jz waiting

ret
gameover endp

;//------------ getplayername ----------
getplayername proc

;basic settings
call Clrscr
mov  eax, green
call SetTextColor

; this is where we set our location and all
	mov dl,45
	mov dh,15
	call Gotoxy
	mov esi , offset askname
	mov ecx,0
	mov ecx, sizeof askname
	; this is where wtype the question
	type_prompt:
		mov al, byte ptr [esi]
		call WriteChar
		mov eax,7
		call Delay
		inc esi
	loop type_prompt
	
	; this is where we take the input
		mov  eax, yellow
		call SetTextColor

			mov edx, offset playername
			mov ecx,15
			call ReadString
			mov namesize , al

			mov edx,0
			mov ecx,0
			mov eax,0
			mov edx , offset playername
			mov edi , offset playername1 
			mov esi , offset playername2 
			mov ecx, sizeof playername

			copyname:
			mov al, byte ptr [edx]
			mov byte ptr [esi],al
			mov byte ptr [esi],al
			inc esi
			inc edi
			inc edx
			loop copyname



ret
getplayername endp


;**-------------------------------------------------------------------------------------------**
;**------------------------------------ GAME GRAPHICS ----------------------------------------**
;**-------------------------------------------------------------------------------------------**

;//--- display maze ---
displayMaze proc
;setting the color of the maze blue
mov  eax,blue
call SetTextColor 


	;drawing maze - lvl1  here...
	mov dl,0
	mov dh,0
	call Gotoxy
	mov edx, offset maze1_top ;draws draws top
	call WriteString
		mov dl,0
		mov dh,6
		call Gotoxy
		mov edx, offset maze1_mid1 ;draws mid1
		call WriteString
			mov dl,0
			mov dh,12
			call Gotoxy
			mov edx, offset maze1_mid2 ;draws mid2
			call WriteString
				mov dl,0
				mov dh,18
				call Gotoxy
				mov edx, offset maze1_mid3 ;draws mid3
				call WriteString
	mov dl,0
	mov dh,24
	call Gotoxy
	mov edx, offset maze1_end ;draws end
	call WriteString

ret
displayMaze endp

;///////////////////////////////////////////////////////////////////////////////////////////
lvl1_setup proc

mov esi , offset oldwalls	
mov ecx,sizeof oldwalls
jmp skip
;cmp boolean,0
;je skip

		resettingXs:
		mov edi , [esi]
		mov byte ptr [edi],'X'
		add esi,4
		sub ecx,4
		cmp ecx,0
		jle resettingXs

skip:
ret
lvl1_setup endp

;///////////////////////////////////////////////////////////////////////////////////////////
lvl2_setup proc
mov al,'X'
mov ah ,' '
mov esi, offset oldwalls	
	;adjusting top
	mov edi, offset maze1_top
		mov ecx, sizeof maze1_top
		topX:
			cmp byte ptr [edi],al
			jne topX_next
			mov byte ptr [edi],ah
			mov [esi] , edi
			add esi,4
			topX_next:
			inc edi
		LOOP topx
		;adjusting mid1
		mov edi, offset maze1_mid1
			mov ecx, sizeof maze1_mid1
				midX1:
			cmp byte ptr [edi],al
			jne midX1_next
			mov byte ptr [edi],ah
			mov [esi] , edi
			add esi,4
			midX1_next:
			inc edi
		LOOP midX1
		;adjusting mid2
		mov edi, offset maze1_mid2
			mov ecx, sizeof maze1_mid2
				midX2:
			cmp byte ptr [edi],al
			jne midX2_next
			mov byte ptr [edi],ah
			mov [esi] , edi
			add esi,4
			midX2_next:
			inc edi
		LOOP midX2
		;adjusting mid3
		mov edi, offset maze1_mid3
			mov ecx, sizeof maze1_mid3
				midX3:
			cmp byte ptr [edi],al
			jne midX3_next
			mov byte ptr [edi],ah
			mov [esi] , edi
			add esi,4
			midX3_next:
			inc edi
		LOOP midX3
		;adjusting end
		mov edi, offset maze1_end
			mov ecx, sizeof maze1_end
				endX3:
			cmp byte ptr [edi],al
			jne endX3_next
			mov byte ptr [edi],ah
			mov [esi] , edi
			add esi,4
			endX3_next:
			inc edi
		LOOP endX3
;display call of new stuff lol
call displayMaze

ret

lvl2_setup endp

;///////////////////////////////////////////////////////////////////////////////////////////

;...................................................................................
display_lvl1 proc

	mov  eax,lightGreen
	call SetTextColor 

	mov dl , 73
	mov dh , 2
	call Gotoxy
	mov eax,0
	mov edx, offset strlvl1a ;draws level 1 graphica
	call WriteString

	mov dl , 73
	mov dh , 3
	call Gotoxy
	mov eax,0
	mov edx, offset strlvl1b ;draws level 1 graphica
	call WriteString

	mov dl , 73
	mov dh , 4
	call Gotoxy
	mov eax,0
	mov edx, offset strlvl1c ;draws level 1 graphica
	call WriteString

	mov dl , 73
	mov dh , 5
	call Gotoxy
	mov eax,0
	mov edx, offset strlvl1d ;draws level 1 graphica
	call WriteString

ret
display_lvl1 endp

;............................................................................
movingmaze proc
cmp current_lvl,10
jle maze_no_move

mov eax,blue
call SetTextColor


	cmp maze_moves,3000h
	jg other_two
	CMP maze_moves,0
	jne maze_no_move
				mov dl,3
				mov dh,6
				call Gotoxy
				mov edx, offset maze1_mid1 ;draws mid1
				call WriteString
					mov dl,3
					mov dh,12
					call Gotoxy
					mov edx, offset maze1_mid2 ;draws mid2
					call WriteString
						mov dl,3
						mov dh,18
						call Gotoxy
						mov edx, offset maze1_mid3 ;draws mid3
						call WriteString
			mov dl,3
			mov dh,24
			call Gotoxy
			mov edx, offset maze1_end ;draws end
			call WriteString

;///////////////////////////////////////
		other_two:
		;drawing maze - lvl2  here...
			mov dl,0
			mov dh,0
			call Gotoxy
			mov edx, offset maze1_top ;draws draws top
			call WriteString
				mov dl,0
				mov dh,6
				call Gotoxy
				mov edx, offset maze1_mid1 ;draws mid1
				call WriteString
					mov dl,0
					mov dh,12
					call Gotoxy
					mov edx, offset maze1_mid2 ;draws mid2
					call WriteString
						mov dl,0
						mov dh,18
						call Gotoxy
						mov edx, offset maze1_mid3 ;draws mid3
						call WriteString
			mov dl,0
			mov dh,24
			call Gotoxy
			mov edx, offset maze1_end ;draws end
			call WriteString
	
	mov maze_moves,-1
;////////////////////////////////////
maze_no_move:
inc maze_moves
ret
movingmaze endp

;.............................................................................
display_lvl2 proc


mov  eax,lightGray
call SetTextColor 
mov dl ,  73
mov dh , 22
call Gotoxy
mov  eax,lightGreen
call SetTextColor 
mov edx , offset instructions
call WriteString
mov dl ,  73
mov dh , 23
call Gotoxy
mov edx , offset inst1
call WriteString
mov dl ,  73
mov dh , 24
call Gotoxy
mov edx , offset inst2
call WriteString
mov dl ,  73
mov dh , 25
call Gotoxy
mov edx , offset inst3
call WriteString
mov dl ,  73
mov dh , 26
call Gotoxy
mov edx , offset inst4
call WriteString

mov  eax,brown
call SetTextColor 
mov dl ,  72
mov dh , 28
call Gotoxy
mov edx , offset xtra
call WriteString


mov dl , 75
mov dh , 9
call Gotoxy
mov edx, offset strScore
call WriteString
				
mov dl , 75
mov dh , 11
call Gotoxy
mov edx, offset strlives
call WriteString


mov dl , 75
mov dh , 13
call Gotoxy
mov edx, offset strplayer
call WriteString

mov eax,yellow
call SetTextColor

mov edx, offset playername
call WriteString

mov eax,brown
call SetTextColor

mov dl , 75
mov dh , 19
call Gotoxy
mov edx, offset strtotal
call WriteString


		mov  eax,lightGreen
		call SetTextColor 

		mov dl , 73
		mov dh , 1
		call Gotoxy
		mov eax,0
		mov edx, offset strlvl2X ;draws level 2 graphica
		call WriteString
		
			mov dl , 73
			mov dh , 2
			call Gotoxy
			mov eax,0
			mov edx, offset strlvl2a ;draws level 2 graphica
			call WriteString

				mov dl , 73
				mov dh , 3
				call Gotoxy
				mov eax,0
				mov edx, offset strlvl2b ;draws level 2 graphica
				call WriteString

					mov dl , 73
					mov dh , 4
					call Gotoxy
					mov eax,0
					mov edx, offset strlvl2c ;draws level 2 graphica
					call WriteString

						mov dl , 73
						mov dh , 5
						call Gotoxy
						mov eax,0
						mov edx, offset strlvl2d ;draws level 2 graphica
						call WriteString

ret
display_lvl2 endp
;.............................................................................
;.............................................................................
display_lvl3 proc


mov  eax,lightGray
call SetTextColor 
mov dl ,  73
mov dh , 22
call Gotoxy
mov  eax,lightGreen
call SetTextColor 
mov edx , offset instructions
call WriteString
mov dl ,  73
mov dh , 23
call Gotoxy
mov edx , offset inst1
call WriteString
mov dl ,  73
mov dh , 24
call Gotoxy
mov edx , offset inst2
call WriteString
mov dl ,  73
mov dh , 25
call Gotoxy
mov edx , offset inst3
call WriteString
mov dl ,  73
mov dh , 26
call Gotoxy
mov edx , offset inst4
call WriteString

mov  eax,brown
 call SetTextColor 
mov dl ,  72
mov dh , 28
call Gotoxy
mov edx , offset xtra
call WriteString


mov dl , 75
mov dh , 9
call Gotoxy
mov edx, offset strScore
call WriteString
				
mov dl , 75
mov dh , 11
call Gotoxy
mov edx, offset strlives
call WriteString

mov dl , 75
mov dh , 13
call Gotoxy
mov edx, offset strplayer
call WriteString

mov eax,yellow
call SetTextColor

mov edx, offset playername2
call WriteString

mov eax,brown
call SetTextColor

mov dl , 75
mov dh , 19
call Gotoxy
mov edx, offset strtotal
call WriteString

		mov  eax,lightGreen
		call SetTextColor 

		
			mov dl , 73
			mov dh , 2
			call Gotoxy
			mov eax,0
			mov edx, offset strlvl3a ;draws level 2 graphica
			call WriteString

				mov dl , 73
				mov dh , 3
				call Gotoxy
				mov eax,0
				mov edx, offset strlvl3b ;draws level 2 graphica
				call WriteString

					mov dl , 73
					mov dh , 4
					call Gotoxy
					mov eax,0
					mov edx, offset strlvl3c ;draws level 2 graphica
					call WriteString

						mov dl , 73
						mov dh , 5
						call Gotoxy
						mov eax,0
						mov edx, offset strlvl3d ;draws level 2 graphica
						call WriteString

ret
display_lvl3 endp
;.............................................................................

level_animation proc
mov eax,0
mov ecx,0
mov ecx,9

	mov  eax,lightGreen
	call SetTextColor 

	mov dl , 45
	mov dh , 15
	call Gotoxy

	levelnum:
	mov al,byte ptr [esi]
	call WriteChar
	mov eax,9
	call Delay
	inc esi
	LOOP levelnum
call Delay
mov ecx,18
	levelname:
	mov al,byte ptr [esi]
	call WriteChar
	mov eax,7
	call Delay
	inc esi
	LOOP levelname
mov eax,3000
call Delay
ret
level_animation endp
;.........................................................



;//-------------loading-----------
loading proc
call Clrscr
mov eax,green
call SetTextColor

mov ecx,0
mov esi , offset loadingscrn

	mov dl , 53
	mov dh , 15
	call Gotoxy
	mov ecx,8

	;writes the loading
	loadingstr:
		mov al,byte ptr [esi]
		call WriteChar
		mov eax,7
		call Delay
		inc esi
	loop loadingstr


	mov ecx,5

	loadingdots:
	mov esi , offset loadingscrn
	add esi,8
	mov dl , 61
	mov dh , 15
	call Gotoxy
		;writes teh dots
		mov al,byte ptr [esi]
		call WriteChar
		mov eax,100
		call Delay
		inc esi
		mov al,byte ptr [esi]
		call WriteChar
		mov eax,100
		call Delay
		inc esi
		mov al,byte ptr [esi]
		call WriteChar
		mov eax,100
		call Delay
			cmp ecx,1
			je ignorethisclr
				;clears the dots with spaces
				inc esi
				mov dl , 61
				mov dh , 15
				call Gotoxy
				mov edx, offset pacman_clear
				call WriteString
				mov eax,100
				call Delay
			ignorethisclr:
	loop loadingdots

	mov eax,1000
	call Delay

	mov dl , 45
	mov dh , 15
	call Gotoxy
	mov ecx,25; clears the laoding scrn
			clearall:
				mov al,' '
				call WriteChar
			loop clearall
ret
loading endp
;..........................................................

rgb_background proc
mov al,byte ptr [esi]
call SetTextColor
cmp al,10
je resett_colorpointer
jne continue_changing_colours

resett_colorpointer:
mov esi, offset colours
continue_changing_colours:

;...right triangle
mov bh,29
La:
mov dl,114
mov dh,bh
	Lb:
	mov al,'*'
	call Gotoxy
	call WriteChar
	dec dh
	dec dl
	cmp dh,0
	jge Lb
dec bh
mov eax,1
	call Delay
cmp bh,0
jge La


;...left triangle
mov bh,0
Lo:
mov dl,5
mov dh,bh
	L1:
	mov al,'*'
	call Gotoxy
	call WriteChar
	inc dh
	inc dl
	cmp dh,29
	jle L1
inc bh
mov eax,1
	call Delay
cmp bh,29
jle Lo




inc esi
ret
rgb_background endp

;**-------------------------------------------------------------------------------------------**
;**------------------------------------- file handling ---------------------------------------**
;**-------------------------------------------------------------------------------------------**


filehandling proc
call convert_to_char_arr

	mov edx,OFFSET filename
	call OpenInputFile
	mov fileHandle, eax

; Open the file for input
	  mov  eax,fileHandle
      mov  edx,OFFSET buffer
      mov  ecx,BUFFER_SIZE
      call ReadFromFile
	

		 mov esi,edx ; our file`s buffer
		 mov edi, offset bufferx
	
		 ;esi - read from file buffer
		 ;edi - new string to write
		 ;eax - '!' symbol for new entry in new string
		 ;ebx - temp on to check totalchar

	MakeNewFileData:
			
			mov al, byte ptr [esi]

			cmp al,'&'
			je checkscore
				
			cmp al,'!'
			je updateptr

			cmp al,'@'
			je endloop

			jmp noupdate

	 updateptr:
			mov eax,0
			mov eax,edi

			noupdate:
				mov byte ptr [edi],al
			jmp NoScoreCheck


	checkscore:
		mov byte ptr [edi],al;mov & into new string
		inc edi
		inc esi
		mov ebx, offset totalchar
			;H-unit comparison
			mov al, byte ptr [ebx];Hunitmove
			cmp byte ptr [esi],al
			jl newentry
			inc esi
			inc ebx
				;T - unit check
				mov al, byte ptr [ebx];Tunitmov
				cmp byte ptr [esi],al
				jl newentry
				inc esi
				inc ebx
					;U - units check
					mov al, byte ptr [ebx];Uunitmov
					cmp byte ptr [esi],al
					jl newentry
					
					;if nothing go threespaces back
					dec esi;totensnow
					dec esi;toUnitsnow
					jmp MakeNewFileData
	
	NoScoreCheck:
	inc edi
	inc esi
	jmp MakeNewFileData

	newEntry:
		
	mov edi,eax
	inc edi
	mov ebx, offset playername
	mov ecx,sizeof playername
	addname:
		mov eax,0
		mov al , byte ptr[ebx]
		mov byte ptr [edi] , al
		inc ebx
		inc edi
	loop addname
	mov byte ptr [edi],'&'
	inc edi
	mov ebx, offset totalchar
	mov ecx,sizeof totalchar
	addscore:
		mov eax,0
		mov al , byte ptr[ebx]
		mov byte ptr [edi] , al
		inc ebx
		inc edi
	loop addname
	inc edi
	mov al,current_lvl
	add al,48
	mov byte ptr [edi] , al
	inc edi
	mov byte ptr [edi] , '!'
	inc edi
	jmp MakeNewFileData
	
	endloop:
	mov byte ptr [edi],al ; to move the '@' character

	mov  eax,fileHandle
    mov  edx,OFFSET bufferx
    mov  ecx,BUFFER_SIZE
    call WriteToFile

	;close the file
	mov eax,fileHandle
	call CloseFile

ret
filehandling  endp

;..........................................................

convert_to_char_arr proc

	cmp total,1000
	jge defualtHighest

	;- H-unit conversion
	mov eax,0
	mov ebx,0
	mov edx,0
	mov esi, offset totalchar
	mov bx,100
	mov ax,total
	div bx
	add dx,48
	mov byte ptr [esi],dl
	;- T-unit conversion
	mov edx,0
	mov ebx,0
	mov bx,10
	mov ax,total
	div bx
	add dx,48
	mov byte ptr [esi+1],dl
	;- T-unit conversion
	mov byte ptr [esi+2],al

	jmp return_conversions

defualtHighest:
mov esi , offset totalchar
mov byte ptr [esi],'9'
mov byte ptr [esi+1],'9'
mov byte ptr [esi+2],'9'
mov byte ptr [esi+3],0

return_conversions:
ret
convert_to_char_arr endp

;..........................................................
;..........................................................
;..........................................................
just_because proc
;this is to get the above procs running and keep the game from dying out procedurally 
just_because endp

;----END OF PROJECT --- ye
end main