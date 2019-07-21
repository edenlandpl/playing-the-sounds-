;Program imitujacy dzwiek syreny
;zmiana czestotliwosci dzwieku od 450 Hz do 2100 Hz
;Opoznienie adekwatne dla procesora P5

format MZ
stack stk:256
entry text:main

;makro opoznienia
;Na wejsciu wartosc opoznienia (w mks)

macro delay time
{
local ext,iter
    push cx
    mov cx,time
ext:
    push cx
;w cx jedna mks, te wartosc mo≈ºna zmienic w zaleznosci od wydajnosci procesora
    mov cx,0FFFFh
iter:
    loop iter
    pop cx
    loop ext
    pop cx
}

segment data_16 use16
tonelow dw     9121, 6088, 4651, 6088, 9151, 6088, 4651, 6088, 9151	       ;dolna granica dzwieku 450 Hz
cnt	db	0					;licznik dla wyjscia z programu
temp	dw	?					 ;gorna granica dzwieku
iteracja dw	0
segment text use16
main:	
	mov	ax,data_16
	mov	ds,ax
	xor	ax,ax

go:
	mov	al,0B6h 				; slowo stanu 10110110b (0B6h)-wybor 2-ego kanalu portu (glosnik)
	out	43h,al					;do portu 43h
	in	al,61h		
	or	al,3		
	out	61h,al		

	mov	cx,5
	petlaWew:
		 push cx
		  push bx			 ; reset i zapamietanie wczeúniejszych informacji na rejestrach
		  xor	bx, bx
		  mov dx, [iteracja]		  ;przeniesienie wartosci iteracji do rejestru
		  add bx, [tonelow+edx] 	  ; dodajemy do adresu tablicy iteracje, kolejna wartosc z tabeli [edx to wieksza czesc dl ]
		  mov [temp], bx		    ; przenosimy nowa wartosc do xk
		  ; mov dx,9121
		  ; mov [temp],dx
		  mov	  cx,4
		  music:
			mov	ax,[temp]
			out	42h,al
			mov	al,ah
			out	42h,al
			delay	10
		  loop	  music
		  inc [iteracja]
		  inc [iteracja]
		  pop bx
		  pop cx
	loop petlaWew

nosound:
	in	al,61h		
	and	al,0fch
	out	61h,al		
	mov	dx,51					;dla kolejnych petli
	mov	[tonelow],dx
	inc	byte  [cnt]				;inkrementacja ilosci przejsc
	cmp	byte  [cnt],1
	jne	go
exit:
	mov	ax,4c00h
	int	21h
	ret
segment stk use16
    db 256 dup (?)