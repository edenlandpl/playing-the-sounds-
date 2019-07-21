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
;w cx jedna mks, te wartosc mo¿na zmienic w zaleznosci od wydajnosci procesora
    mov cx,0FFFFh
iter:
    loop iter
    pop cx
    loop ext
    pop cx
}

segment data_16 use16
tonelow dw	9121		;dolna granica dzwieku 450 Hz
cnt	db	0		;licznik dla wyjscia z programu
temp	dw	?		;gorna granica dzwieku
segment text use16
main:	
	mov	ax,data_16
	mov	ds,ax
	xor	ax,ax
go:
	mov	al,0B6h 	; slowo stanu 10110110b (0B6h)-wybor 2-ego kanalu portu (glosnik)
	out	43h,al		;do portu 43h
	in	al,61h		
	or	al,3		
	out	61h,al		

	mov	cx,6
petla:
	push cx
	
	mov	dx,9121
	mov	[temp],dx
	
	music1:
		mov	ax,[temp]		
		out	42h,al		
		mov	al,ah		
		out	42h,al				
		delay	10		
		loop	music1	
	
	mov	cx,5
	mov	dx,6088
	mov	[temp],dx
	
	music2:
		mov	ax,[temp]		
		out	42h,al		
		mov	al,ah		
		out	42h,al				
		delay	10		
		loop	music2	
	
	mov	cx,5
	mov	dx,4651
	mov	[temp],dx
	
	music3:
		mov	ax,[temp]		
		out	42h,al		
		mov	al,ah		
		out	42h,al			
		delay	10		
		loop	music3	
	
	mov	cx,5
	mov	dx,6088
	mov	[temp],dx
	
	music4:
		mov	ax,[temp]		
		out	42h,al		
		mov	al,ah		
		out	42h,al		
		delay	10		
		loop	music4	
	
	mov	cx,5
	mov	dx,7240
	mov	[temp],dx
	
	music5:
		mov	ax,[temp]		
		out	42h,al		
		mov	al,ah		
		out	42h,al		
		delay	10		
		loop	music5	
	
	mov	cx,5
	mov	dx,9121
	mov	[temp],dx
	
	music6:
		mov	ax,[temp]		
		out	42h,al		
		mov	al,ah		
		out	42h,al		
		delay	10	
		loop	music6		

	
nosound:
	in	al,61h		
	and	al,0fch
	out	61h,al		
	mov	dx,51		;dla kolejnych petli
	mov	[tonelow],dx
	inc	byte  [cnt]		;inkrementacja ilosci przejsc
	cmp	byte  [cnt],2		
	jne	go
exit:
	mov	ax,4c00h
	int	21h
	ret
segment stk use16
    db 256 dup (?)
