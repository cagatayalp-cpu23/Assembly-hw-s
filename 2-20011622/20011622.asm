; -----------------------------------------------------------------------
        ; Okunan işaretli iki sayının toplamını hesaplayıp ekrana yazdırır.
        ; ANA 		: Ana yordam 
        ; PUT_STR 	: Ekrana sonu 0 ile belirlenmiş dizgeyi yazdırır. 
        ; PUTC 	: AL deki karakteri ekrana yazdırır. 
        ; GETC 	: Klavyeden basılan karakteri AL’ye alır.
        ; PUTN 	: AX’deki sayeyi ekrana yazdırır. 
        ; GETN 	: Klavyeden okunan sayeyi AX’e koyar
        ; -----------------------------------------------------------------------
SSEG 	SEGMENT PARA STACK 'STACK'
	DW 32 DUP (?)
SSEG 	ENDS

DSEG	SEGMENT PARA 'DATA'
CR	EQU 13
LF	EQU 10
MSG1	DB 'Diziyi olusturmak icin 1e  yazdirmak icin 2ye diziye eleman eklemek icin 3 e cikmak icin 4 e basin: ',0
MSG2	DB '                                            CAGATAY ALPTEKIN    20011622 ',0
MSG3	DB 'EKLENECEK ELEMANI GIRIN ',0
MSG4	DB 'kac elemanli oldugunu girin ',0
GIRIS	DB 'elemanlari girin ',0
HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
SATIR	DB CR, LF, ' ', 0;bir satır atlamasını sağlıyor
BOSLUK	DB '  |  ', 0;bosluk bırakmasını sağlıyor
SECIM	Dw ?
EKLENECEK	DW ?
N	    DW ?
MIN	    DW -1
MAX	    DW ?
DIZI    DW (100) DUP (?)
DIZI2   DW (100) DUP (?)

DSEG 	ENDS 

CSEG 	SEGMENT PARA 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
ANA 	PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX, DSEG 
        MOV DS, AX
		XOR SI,SI
		MOV AX,OFFSET MSG2
		CALL PUT_STR 
		MOV AX,OFFSET SATIR
		CALL PUT_STR 
		
DONGU:  MOV AX, OFFSET MSG1
        CALL PUT_STR			       
        CALL GETN  
       MOV SECIM,AX
		CMP SECIM,1
		JZ OLUSTURR
		CMP SECIM,2
		JZ YAZDIRR
		CMP SECIM,3
		JZ EKLEE
		
		JNE SON

        
		
OLUSTURR:  

   MOV AX, OFFSET MSG4
   CALL PUT_STR 
   
   CALL GETN
   
   MOV N,AX
   MOV AX, OFFSET SATIR
   CALL PUT_STR 
   MOV AX, OFFSET GIRIS
   CALL PUT_STR 
   
   MOV CX,N
   XOR SI,SI
   
L13:
   CALL GETN
   MOV DIZI[SI],AX
   ADD SI,2
   LOOP L13
	CALL OLUSTUR
        JMP DONGU
YAZDIRR:CALL YAZDIR
        
        JMP DONGU
EKLEE:
    MOV AX,OFFSET MSG3
    CALL PUT_STR
    INC N
	MOV SI,N
	DEC SI
	SAL SI,1
	CALL GETN
	MOV DIZI[SI],AX
	CALL OLUSTUR
	jmp dongu
		
     SON:RETF
	 
ANA 	ENDP

OLUSTUR PROC NEAR
PUSH AX
PUSH CX
PUSH SI
PUSH DI 
PUSH BX
;degerler degismemesi icin registerlari push yaptım
	MOV CX,N
	XOR SI,SI
	LADS1: PUSH dizi[SI]
	MOV AX,dizi[SI]
	PUSH BX
	MOV BL,2
	IMUL BL
	POP BX
	MOV dizi[SI],AX
	ADD SI,2
	LOOP LADS1
	XOR SI,SI
	MOV CX,N
	SHR CX,1
	lk1:ADD dizi[SI],1
	ADD SI,4
	LOOP lk1
	;iki tane aynı değer girildiğinde çalışması için yazılan kısım
	
	
	
   MOV CX,N
   XOR SI,SI
   

   
   
  
;2 for döngüsüyle dizinin her elemanından büyük en küçük elemanının indisini o dizinin elemanının gösterdiği indis olarak ayarladım   
L2:    MOV AX,-1
       MOV MAX,AX
       XOR DI,DI
	   PUSH CX
	   
	   MOV CX,N
L3:    MOV AX,DIZI[DI]
       CMP AX,DIZI[SI]
	   JLE ATLA3
	   MOV AX,-1
	   CMP MAX,AX
	   JNZ ELSE1
	   MOV MAX,DI
	   MOV AX,MAX
	   JMP ATLA3
ELSE1: MOV AX,DIZI[DI] 
       MOV BX,MAX
       CMP AX,DIZI[BX]
       JG ATLA3
       MOV MAX,DI
ATLA3:	   MOV AX,MAX
         MOV DIZI2[SI],AX
       ADD DI,2
       LOOP L3
	   POP CX
	   ADD SI,2
	   LOOP L2

	   
	   
	MOV CX,N
		MOV SI,N
		DEC SI
		SHL SI,1
		LADS2:POP dizi[SI]
		SUB SI,2
		LOOP LADS2  
	   
   POP AX
POP CX
POP SI
POP DI 
POP BX
   
   
       
   
RET
OLUSTUR ENDP
;diziyi yazdırma işlemi
YAZDIR PROC NEAR
    PUSH SI
	PUSH CX
	PUSH AX
    XOR SI,SI
	MOV CX,N
	MOV AX,OFFSET SATIR
    CALL PUT_STR
	
L5: MOV AX,DIZI[SI]
    CALL PUTN
	MOV AX,OFFSET BOSLUK
	CALL PUT_STR
   ADD SI,2
	LOOP L5
	MOV AX,OFFSET SATIR
	CALL PUT_STR    
	XOR SI,SI
    MOV CX,N
L6:	MOV AX,DIZI2[SI]
    SAR AX,1
	CALL PUTN
	MOV AX,OFFSET BOSLUK
	CALL PUT_STR
	ADD SI,2
	
	LOOP L6
	MOV AX,OFFSET SATIR
    CALL PUT_STR
	POP AX
	POP CX
	POP SI
	
	
RET
YAZDIR ENDP	
	
	
		
		
		
	

GETC	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan karakteri AL yazmacına alır ve ekranda gösterir. 
        ; işlem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan sayiyi okur, sonucu AX yazmacı üzerinden dondurur. 
        ; DX: sayının işaretli olup/olmadığını belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan sayının islenmesi sırasındaki ara değeri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten dönüş değeri olarak değişmek durumundadır. Ancak diğer 
        ; yazmaçların önceki değerleri korunmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; sayının şimdilik + olduğunu varsayalım 
        XOR BX, BX 	                        ; okuma yapmadı Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam değeri de 0’dır. 
NEW:
        CALL GETC	                        ; klavyeden ilk değeri AL’ye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tuşuna basilmiş ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 arasında bir sayı mı?
NEGATIVE:
        MOV DX, -1	                        ; - basıldı ise sayı negatif, DX=-1 olur
        JMP NEW		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; değil ise HATA mesajı verilecek
        SUB AL,'0'	                        ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL	                        ; BL’ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yapılacak 
        PUSH DX		                        ; MUL komutu DX’i bozar işaret için saklanmalı
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; işareti geri al 
        MOV CX, AX	                        ; CX deki ara değer *10 yapıldı 
        ADD CX, BX 	                        ; okunan haneyi ara değere ekle 
        JMP NEW 		                ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesajını göster 
        JMP GETN_START                          ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX	                        ; sonuç AX üzerinden dönecek 
        CMP DX, 1	                        ; İşarete göre sayıyı ayarlamak lazım 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                                ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                                ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                                ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                                ; en az anlamlı hane en alta ve onu altında da 
                                                ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                           ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX’e al 
        MOV AL, BYTE PTR [BX]	                ; AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL’deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

CSEG 	ENDS 
	END ANA