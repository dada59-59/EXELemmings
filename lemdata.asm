; ============================================================================
; Genere par EXELLEM -- ne pas editer a la main.
;
; Sprites transparents, format du moteur bitmap EXL100 :
;   en-tete  : wseg, hblock
;   donnees  : par ligne, puis par segment de 8 px : M, B, G, R
;   rendu    : dst = (fond & ~M) | (sprite & M), plan par plan
; Masque a 1 = pixel du sprite ; a 0 = le decor reste visible.
; Plans B/G/R dans cet ordre (manuel TMS3556) ; bit 7 = pixel gauche.
; ============================================================================

LEM_NTYPES      .equ    15
LEM_WSEG        .equ    1        ; 8 pixels de large
LEM_HLINES      .equ    10
LEM_FRAME_BYTES .equ    40       ; HLINES*WSEG*4, en-tete non comprise

; --- type 0 : marche -----------------------------------
lem_t0_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3E,$00,$3E,$00   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $18,$18,$10,$10   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $18,$18,$18,$18   ; ligne 9
lem_t0_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $38,$38,$20,$20   ; ligne 5
        .byte   $3A,$3A,$22,$22   ; ligne 6
        .byte   $1A,$1A,$02,$02   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $30,$30,$30,$30   ; ligne 9
lem_t0_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $54,$00,$54,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $38,$38,$30,$30   ; ligne 4
        .byte   $38,$38,$20,$20   ; ligne 5
        .byte   $7C,$7C,$60,$60   ; ligne 6
        .byte   $1C,$1C,$00,$00   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t0_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3C,$08,$3C,$08   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $38,$38,$20,$20   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4C,$4C,$4C,$4C   ; ligne 9
lem_t0_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $18,$18,$08,$08   ; ligne 5
        .byte   $18,$18,$10,$10   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $18,$18,$18,$18   ; ligne 9
lem_t0_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $18,$18,$08,$08   ; ligne 5
        .byte   $1A,$1A,$0A,$0A   ; ligne 6
        .byte   $1A,$1A,$02,$02   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $30,$30,$30,$30   ; ligne 9
lem_t0_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $28,$00,$28,$00   ; ligne 1
        .byte   $38,$00,$38,$00   ; ligne 2
        .byte   $18,$08,$18,$08   ; ligne 3
        .byte   $1C,$1C,$1C,$1C   ; ligne 4
        .byte   $18,$18,$08,$08   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $1C,$1C,$04,$04   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t0_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3C,$08,$3C,$08   ; ligne 2
        .byte   $3C,$1C,$3C,$1C   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4C,$4C,$4C,$4C   ; ligne 9

; --- type 1 : chute -----------------------------------
lem_t1_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $38,$08,$38,$08   ; ligne 1
        .byte   $1C,$1C,$1C,$1C   ; ligne 2
        .byte   $5A,$5A,$42,$42   ; ligne 3
        .byte   $3C,$3C,$24,$24   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $58,$58,$48,$48   ; ligne 8
        .byte   $24,$24,$24,$24   ; ligne 9
lem_t1_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $28,$00,$28,$00   ; ligne 0
        .byte   $38,$08,$38,$08   ; ligne 1
        .byte   $1C,$1C,$1C,$1C   ; ligne 2
        .byte   $18,$18,$00,$00   ; ligne 3
        .byte   $7E,$7E,$66,$66   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $1C,$1C,$0C,$0C   ; ligne 8
        .byte   $70,$70,$60,$60   ; ligne 9
lem_t1_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $38,$08,$38,$08   ; ligne 1
        .byte   $1C,$1C,$1C,$1C   ; ligne 2
        .byte   $18,$18,$00,$00   ; ligne 3
        .byte   $3C,$3C,$24,$24   ; ligne 4
        .byte   $5A,$5A,$42,$42   ; ligne 5
        .byte   $1A,$1A,$02,$02   ; ligne 6
        .byte   $1C,$1C,$04,$04   ; ligne 7
        .byte   $30,$30,$20,$20   ; ligne 8
        .byte   $40,$40,$40,$40   ; ligne 9
lem_t1_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $28,$00,$28,$00   ; ligne 0
        .byte   $38,$08,$38,$08   ; ligne 1
        .byte   $3C,$1C,$3C,$1C   ; ligne 2
        .byte   $18,$18,$00,$00   ; ligne 3
        .byte   $7E,$7E,$66,$66   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7E,$7E,$66,$66   ; ligne 8
        .byte   $08,$08,$00,$00   ; ligne 9

; --- type 2 : creuse -----------------------------------
lem_t2_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $01,$01,$01,$01   ; ligne 3
        .byte   $1A,$02,$1A,$02   ; ligne 4
        .byte   $3C,$24,$3C,$24   ; ligne 5
        .byte   $78,$78,$60,$60   ; ligne 6
        .byte   $98,$98,$80,$80   ; ligne 7
        .byte   $E7,$E7,$81,$81   ; ligne 8
        .byte   $00,$00,$00,$00   ; ligne 9
lem_t2_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $01,$01,$01,$01   ; ligne 3
        .byte   $1A,$02,$1A,$02   ; ligne 4
        .byte   $3C,$3C,$24,$24   ; ligne 5
        .byte   $78,$78,$60,$60   ; ligne 6
        .byte   $D8,$D8,$C0,$C0   ; ligne 7
        .byte   $67,$67,$41,$41   ; ligne 8
        .byte   $40,$40,$40,$40   ; ligne 9
lem_t2_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $21,$01,$21,$01   ; ligne 3
        .byte   $19,$01,$19,$01   ; ligne 4
        .byte   $3E,$3E,$26,$26   ; ligne 5
        .byte   $78,$78,$60,$60   ; ligne 6
        .byte   $D8,$D8,$C0,$C0   ; ligne 7
        .byte   $67,$67,$41,$41   ; ligne 8
        .byte   $20,$20,$20,$20   ; ligne 9
lem_t2_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $20,$00,$20,$00   ; ligne 3
        .byte   $18,$00,$18,$00   ; ligne 4
        .byte   $1F,$07,$1F,$07   ; ligne 5
        .byte   $38,$38,$20,$20   ; ligne 6
        .byte   $58,$58,$40,$40   ; ligne 7
        .byte   $7F,$7F,$41,$41   ; ligne 8
        .byte   $38,$38,$38,$38   ; ligne 9
lem_t2_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $00,$00,$00,$00   ; ligne 3
        .byte   $18,$00,$18,$00   ; ligne 4
        .byte   $18,$08,$18,$08   ; ligne 5
        .byte   $3F,$3F,$27,$27   ; ligne 6
        .byte   $39,$39,$21,$21   ; ligne 7
        .byte   $7F,$7F,$41,$41   ; ligne 8
        .byte   $78,$78,$78,$78   ; ligne 9
lem_t2_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $90,$80,$90,$80   ; ligne 3
        .byte   $98,$80,$98,$80   ; ligne 4
        .byte   $5C,$50,$5C,$50   ; ligne 5
        .byte   $3F,$3F,$27,$27   ; ligne 6
        .byte   $39,$39,$21,$21   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$42,$42   ; ligne 9
lem_t2_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $80,$80,$80,$80   ; ligne 2
        .byte   $90,$80,$90,$80   ; ligne 3
        .byte   $98,$80,$98,$80   ; ligne 4
        .byte   $5C,$50,$5C,$50   ; ligne 5
        .byte   $3E,$3E,$06,$06   ; ligne 6
        .byte   $39,$39,$01,$01   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$42,$42   ; ligne 9
lem_t2_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $80,$80,$80,$80   ; ligne 2
        .byte   $50,$40,$50,$40   ; ligne 3
        .byte   $38,$20,$38,$20   ; ligne 4
        .byte   $1C,$08,$1C,$08   ; ligne 5
        .byte   $1E,$1E,$06,$06   ; ligne 6
        .byte   $1B,$1B,$03,$03   ; ligne 7
        .byte   $3E,$3E,$02,$02   ; ligne 8
        .byte   $66,$66,$42,$42   ; ligne 9
lem_t2_f8:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $80,$80,$80,$80   ; ligne 2
        .byte   $50,$40,$50,$40   ; ligne 3
        .byte   $38,$20,$38,$20   ; ligne 4
        .byte   $1C,$08,$1C,$08   ; ligne 5
        .byte   $7E,$7E,$66,$66   ; ligne 6
        .byte   $9B,$9B,$83,$83   ; ligne 7
        .byte   $BE,$BE,$82,$82   ; ligne 8
        .byte   $06,$06,$02,$02   ; ligne 9

; --- type 3 : bloque -----------------------------------
lem_t3_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $30,$00,$30,$00   ; ligne 0
        .byte   $1C,$00,$1C,$00   ; ligne 1
        .byte   $3C,$0C,$3C,$0C   ; ligne 2
        .byte   $B9,$99,$B9,$99   ; ligne 3
        .byte   $FF,$FF,$E7,$E7   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $24,$24,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t3_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3C,$18,$3C,$18   ; ligne 2
        .byte   $99,$99,$99,$99   ; ligne 3
        .byte   $FF,$FF,$E7,$E7   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $26,$26,$02,$02   ; ligne 8
        .byte   $64,$64,$64,$64   ; ligne 9
lem_t3_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3E,$38,$3E,$38   ; ligne 2
        .byte   $99,$99,$99,$99   ; ligne 3
        .byte   $FF,$FF,$E7,$E7   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $24,$24,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t3_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3E,$38,$3E,$38   ; ligne 2
        .byte   $99,$99,$99,$99   ; ligne 3
        .byte   $FF,$FF,$E7,$E7   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $64,$64,$40,$40   ; ligne 8
        .byte   $26,$26,$26,$26   ; ligne 9

; --- type 4 : meurt -----------------------------------
lem_t4_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$18,$3C,$18   ; ligne 1
        .byte   $19,$19,$19,$19   ; ligne 2
        .byte   $7E,$7E,$66,$66   ; ligne 3
        .byte   $98,$98,$80,$80   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $19,$19,$01,$01   ; ligne 6
        .byte   $9A,$9A,$82,$82   ; ligne 7
        .byte   $7C,$7C,$64,$64   ; ligne 8
        .byte   $18,$00,$00,$18   ; ligne 9
lem_t4_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $38,$10,$38,$10   ; ligne 2
        .byte   $9C,$9C,$9C,$9C   ; ligne 3
        .byte   $78,$78,$60,$60   ; ligne 4
        .byte   $5C,$1C,$04,$44   ; ligne 5
        .byte   $1A,$1A,$02,$02   ; ligne 6
        .byte   $59,$18,$00,$41   ; ligne 7
        .byte   $7E,$1C,$04,$66   ; ligne 8
        .byte   $5A,$40,$40,$5A   ; ligne 9
lem_t4_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $01,$00,$00,$01   ; ligne 0
        .byte   $40,$00,$00,$40   ; ligne 1
        .byte   $11,$00,$10,$01   ; ligne 2
        .byte   $8D,$80,$8C,$81   ; ligne 3
        .byte   $DE,$48,$50,$C6   ; ligne 4
        .byte   $5C,$1C,$14,$54   ; ligne 5
        .byte   $DA,$1A,$02,$C2   ; ligne 6
        .byte   $59,$18,$00,$41   ; ligne 7
        .byte   $7E,$1C,$04,$66   ; ligne 8
        .byte   $5A,$40,$40,$5A   ; ligne 9
lem_t4_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $01,$00,$00,$01   ; ligne 0
        .byte   $44,$00,$00,$44   ; ligne 1
        .byte   $29,$00,$00,$29   ; ligne 2
        .byte   $19,$00,$00,$19   ; ligne 3
        .byte   $96,$00,$10,$86   ; ligne 4
        .byte   $58,$08,$08,$58   ; ligne 5
        .byte   $D8,$18,$00,$C0   ; ligne 6
        .byte   $49,$08,$00,$41   ; ligne 7
        .byte   $7A,$18,$00,$62   ; ligne 8
        .byte   $1A,$00,$00,$1A   ; ligne 9
lem_t4_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $44,$00,$00,$44   ; ligne 1
        .byte   $20,$00,$00,$20   ; ligne 2
        .byte   $11,$00,$00,$11   ; ligne 3
        .byte   $82,$00,$00,$82   ; ligne 4
        .byte   $59,$00,$08,$51   ; ligne 5
        .byte   $DD,$19,$01,$C5   ; ligne 6
        .byte   $49,$08,$08,$49   ; ligne 7
        .byte   $7A,$18,$00,$62   ; ligne 8
        .byte   $1A,$00,$00,$1A   ; ligne 9
lem_t4_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $00,$00,$00,$00   ; ligne 3
        .byte   $02,$00,$00,$02   ; ligne 4
        .byte   $10,$00,$00,$10   ; ligne 5
        .byte   $0D,$09,$01,$05   ; ligne 6
        .byte   $C1,$00,$00,$C1   ; ligne 7
        .byte   $7E,$18,$14,$72   ; ligne 8
        .byte   $1A,$00,$00,$1A   ; ligne 9
lem_t4_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $00,$00,$00,$00   ; ligne 3
        .byte   $00,$00,$00,$00   ; ligne 4
        .byte   $40,$00,$00,$40   ; ligne 5
        .byte   $01,$00,$00,$01   ; ligne 6
        .byte   $08,$00,$00,$08   ; ligne 7
        .byte   $90,$00,$00,$90   ; ligne 8
        .byte   $02,$00,$00,$02   ; ligne 9
lem_t4_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $00,$00,$00,$00   ; ligne 3
        .byte   $00,$00,$00,$00   ; ligne 4
        .byte   $00,$00,$00,$00   ; ligne 5
        .byte   $00,$00,$00,$00   ; ligne 6
        .byte   $89,$00,$00,$89   ; ligne 7
        .byte   $04,$00,$00,$04   ; ligne 8
        .byte   $50,$00,$00,$50   ; ligne 9

; --- type 5 : flotte -----------------------------------
lem_t5_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $7E,$00,$7E,$7E   ; ligne 0
        .byte   $CB,$08,$CB,$C3   ; ligne 1
        .byte   $18,$10,$18,$10   ; ligne 2
        .byte   $1C,$1C,$1C,$1C   ; ligne 3
        .byte   $1E,$1E,$02,$02   ; ligne 4
        .byte   $1C,$1C,$04,$04   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $1A,$1A,$02,$02   ; ligne 7
        .byte   $3C,$3C,$24,$24   ; ligne 8
        .byte   $38,$38,$20,$20   ; ligne 9
lem_t5_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $7E,$00,$7E,$7E   ; ligne 0
        .byte   $D3,$10,$D3,$C3   ; ligne 1
        .byte   $14,$10,$14,$00   ; ligne 2
        .byte   $3E,$3C,$16,$14   ; ligne 3
        .byte   $1F,$1E,$17,$16   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $5C,$5C,$44,$44   ; ligne 6
        .byte   $78,$78,$40,$40   ; ligne 7
        .byte   $18,$18,$08,$08   ; ligne 8
        .byte   $0C,$0C,$04,$04   ; ligne 9
lem_t5_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $7E,$00,$7E,$7E   ; ligne 0
        .byte   $D3,$10,$D3,$C3   ; ligne 1
        .byte   $10,$10,$10,$10   ; ligne 2
        .byte   $3E,$38,$16,$10   ; ligne 3
        .byte   $1F,$1E,$17,$16   ; ligne 4
        .byte   $1C,$1C,$04,$04   ; ligne 5
        .byte   $5C,$5C,$40,$40   ; ligne 6
        .byte   $7A,$7A,$42,$42   ; ligne 7
        .byte   $18,$18,$00,$00   ; ligne 8
        .byte   $0C,$0C,$0C,$0C   ; ligne 9
lem_t5_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $7E,$00,$7E,$7E   ; ligne 0
        .byte   $D3,$10,$D3,$C3   ; ligne 1
        .byte   $1C,$10,$1C,$00   ; ligne 2
        .byte   $3C,$38,$14,$10   ; ligne 3
        .byte   $18,$18,$10,$10   ; ligne 4
        .byte   $1C,$1C,$04,$04   ; ligne 5
        .byte   $1E,$1E,$02,$02   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $70,$70,$40,$40   ; ligne 8
        .byte   $2C,$2C,$2C,$2C   ; ligne 9
lem_t5_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $7E,$00,$7E,$7E   ; ligne 0
        .byte   $D3,$10,$D3,$C3   ; ligne 1
        .byte   $1C,$10,$1C,$00   ; ligne 2
        .byte   $3C,$3C,$14,$14   ; ligne 3
        .byte   $1E,$1E,$16,$16   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $3C,$3C,$04,$04   ; ligne 8
        .byte   $64,$64,$64,$64   ; ligne 9

; --- type 6 : frappe -----------------------------------
lem_t6_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $1C,$00,$1C,$00   ; ligne 0
        .byte   $F8,$C8,$F8,$C8   ; ligne 1
        .byte   $DC,$DC,$DC,$DC   ; ligne 2
        .byte   $38,$38,$30,$30   ; ligne 3
        .byte   $18,$18,$00,$00   ; ligne 4
        .byte   $38,$38,$00,$00   ; ligne 5
        .byte   $3C,$3C,$04,$04   ; ligne 6
        .byte   $3C,$3C,$04,$04   ; ligne 7
        .byte   $68,$68,$00,$00   ; ligne 8
        .byte   $CC,$CC,$CC,$CC   ; ligne 9
lem_t6_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $30,$30,$30,$30   ; ligne 0
        .byte   $38,$30,$38,$30   ; ligne 1
        .byte   $1E,$1E,$16,$16   ; ligne 2
        .byte   $1C,$1C,$10,$10   ; ligne 3
        .byte   $1C,$1C,$10,$10   ; ligne 4
        .byte   $1E,$1E,$02,$02   ; ligne 5
        .byte   $3C,$3C,$00,$00   ; ligne 6
        .byte   $38,$38,$00,$00   ; ligne 7
        .byte   $6C,$6C,$00,$00   ; ligne 8
        .byte   $C6,$C6,$C6,$C6   ; ligne 9
lem_t6_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $1E,$06,$1E,$06   ; ligne 0
        .byte   $3E,$06,$3E,$06   ; ligne 1
        .byte   $1E,$0E,$16,$06   ; ligne 2
        .byte   $1D,$0C,$15,$05   ; ligne 3
        .byte   $18,$10,$08,$00   ; ligne 4
        .byte   $1E,$1E,$02,$02   ; ligne 5
        .byte   $1C,$1C,$00,$00   ; ligne 6
        .byte   $39,$38,$01,$01   ; ligne 7
        .byte   $6C,$6C,$00,$00   ; ligne 8
        .byte   $C6,$C6,$C6,$C6   ; ligne 9
lem_t6_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $19,$00,$19,$01   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3B,$03,$3B,$03   ; ligne 2
        .byte   $1B,$1B,$03,$03   ; ligne 3
        .byte   $1F,$17,$0F,$07   ; ligne 4
        .byte   $7C,$7C,$60,$60   ; ligne 5
        .byte   $1C,$1C,$00,$00   ; ligne 6
        .byte   $3A,$38,$02,$02   ; ligne 7
        .byte   $6C,$6C,$00,$00   ; ligne 8
        .byte   $7C,$7C,$7C,$7C   ; ligne 9
lem_t6_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $19,$00,$19,$01   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $1F,$1F,$07,$07   ; ligne 3
        .byte   $D9,$D9,$C1,$C1   ; ligne 4
        .byte   $7C,$7C,$60,$60   ; ligne 5
        .byte   $1D,$1C,$01,$01   ; ligne 6
        .byte   $B8,$38,$80,$80   ; ligne 7
        .byte   $2C,$2C,$00,$00   ; ligne 8
        .byte   $3C,$3C,$3C,$3C   ; ligne 9
lem_t6_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $58,$00,$58,$40   ; ligne 0
        .byte   $3A,$00,$3A,$02   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $9E,$9E,$86,$86   ; ligne 3
        .byte   $DB,$DB,$C3,$C3   ; ligne 4
        .byte   $7B,$7B,$63,$63   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $B8,$38,$80,$80   ; ligne 7
        .byte   $2D,$2C,$01,$01   ; ligne 8
        .byte   $3C,$3C,$3C,$3C   ; ligne 9
lem_t6_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $39,$00,$39,$01   ; ligne 1
        .byte   $38,$08,$38,$08   ; ligne 2
        .byte   $D8,$D8,$C0,$C0   ; ligne 3
        .byte   $DC,$DC,$C4,$C4   ; ligne 4
        .byte   $3B,$3B,$23,$23   ; ligne 5
        .byte   $5B,$1B,$43,$43   ; ligne 6
        .byte   $38,$38,$00,$00   ; ligne 7
        .byte   $2C,$2C,$00,$00   ; ligne 8
        .byte   $BC,$3C,$BC,$BC   ; ligne 9
lem_t6_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $99,$00,$99,$81   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $F9,$C8,$F9,$C9   ; ligne 2
        .byte   $D8,$D8,$C0,$C0   ; ligne 3
        .byte   $38,$38,$20,$20   ; ligne 4
        .byte   $1C,$1C,$04,$04   ; ligne 5
        .byte   $1A,$1A,$02,$02   ; ligne 6
        .byte   $BB,$3B,$83,$83   ; ligne 7
        .byte   $2F,$2F,$03,$03   ; ligne 8
        .byte   $78,$78,$78,$78   ; ligne 9

; --- type 7 : explose -----------------------------------
lem_t7_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3C,$18,$3C,$18   ; ligne 2
        .byte   $3C,$3C,$3C,$3C   ; ligne 3
        .byte   $18,$18,$00,$00   ; ligne 4
        .byte   $FF,$FF,$E7,$E7   ; ligne 5
        .byte   $08,$08,$00,$00   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $98,$98,$80,$80   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t7_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $01,$00,$00,$01   ; ligne 0
        .byte   $9C,$00,$18,$84   ; ligne 1
        .byte   $3D,$18,$3C,$19   ; ligne 2
        .byte   $35,$14,$14,$35   ; ligne 3
        .byte   $52,$52,$42,$42   ; ligne 4
        .byte   $BC,$BC,$A4,$A4   ; ligne 5
        .byte   $18,$08,$00,$10   ; ligne 6
        .byte   $5E,$18,$00,$46   ; ligne 7
        .byte   $1A,$18,$00,$02   ; ligne 8
        .byte   $6E,$28,$28,$6E   ; ligne 9
lem_t7_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $51,$00,$10,$41   ; ligne 0
        .byte   $1C,$00,$10,$0C   ; ligne 1
        .byte   $3D,$10,$34,$19   ; ligne 2
        .byte   $B5,$14,$14,$B5   ; ligne 3
        .byte   $72,$42,$42,$72   ; ligne 4
        .byte   $BD,$3C,$24,$A5   ; ligne 5
        .byte   $9C,$00,$00,$9C   ; ligne 6
        .byte   $3D,$18,$00,$25   ; ligne 7
        .byte   $59,$18,$00,$41   ; ligne 8
        .byte   $68,$08,$08,$68   ; ligne 9
lem_t7_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $83,$01,$81,$83   ; ligne 0
        .byte   $52,$00,$00,$52   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $50,$00,$50,$40   ; ligne 3
        .byte   $42,$02,$02,$42   ; ligne 4
        .byte   $40,$00,$00,$40   ; ligne 5
        .byte   $01,$00,$01,$01   ; ligne 6
        .byte   $92,$10,$00,$82   ; ligne 7
        .byte   $0E,$00,$04,$0E   ; ligne 8
        .byte   $C0,$00,$40,$C0   ; ligne 9
lem_t7_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $08,$00,$08,$08   ; ligne 0
        .byte   $81,$00,$80,$81   ; ligne 1
        .byte   $C0,$00,$80,$C0   ; ligne 2
        .byte   $00,$00,$00,$00   ; ligne 3
        .byte   $44,$00,$00,$44   ; ligne 4
        .byte   $01,$00,$00,$01   ; ligne 5
        .byte   $80,$00,$80,$80   ; ligne 6
        .byte   $13,$00,$03,$13   ; ligne 7
        .byte   $41,$00,$00,$41   ; ligne 8
        .byte   $10,$00,$10,$10   ; ligne 9
lem_t7_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $04,$00,$04,$04   ; ligne 1
        .byte   $40,$00,$40,$40   ; ligne 2
        .byte   $01,$00,$01,$01   ; ligne 3
        .byte   $00,$00,$00,$00   ; ligne 4
        .byte   $10,$00,$00,$10   ; ligne 5
        .byte   $00,$00,$00,$00   ; ligne 6
        .byte   $40,$00,$40,$40   ; ligne 7
        .byte   $46,$00,$46,$46   ; ligne 8
        .byte   $08,$00,$08,$08   ; ligne 9
lem_t7_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $00,$00,$00,$00   ; ligne 1
        .byte   $00,$00,$00,$00   ; ligne 2
        .byte   $02,$00,$02,$02   ; ligne 3
        .byte   $00,$00,$00,$00   ; ligne 4
        .byte   $20,$00,$20,$20   ; ligne 5
        .byte   $10,$00,$00,$10   ; ligne 6
        .byte   $00,$00,$00,$00   ; ligne 7
        .byte   $02,$00,$02,$02   ; ligne 8
        .byte   $40,$00,$40,$40   ; ligne 9

; --- type 8 : construit -----------------------------------
lem_t8_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$18   ; ligne 0
        .byte   $18,$18,$18,$18   ; ligne 1
        .byte   $18,$00,$18,$00   ; ligne 2
        .byte   $18,$00,$18,$00   ; ligne 3
        .byte   $18,$00,$18,$00   ; ligne 4
        .byte   $18,$00,$18,$00   ; ligne 5
        .byte   $18,$00,$18,$00   ; ligne 6
        .byte   $1C,$04,$1C,$04   ; ligne 7
        .byte   $0F,$00,$0F,$0F   ; ligne 8
        .byte   $00,$00,$00,$00   ; ligne 9
lem_t8_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$18   ; ligne 0
        .byte   $18,$18,$18,$18   ; ligne 1
        .byte   $18,$00,$18,$00   ; ligne 2
        .byte   $18,$00,$18,$00   ; ligne 3
        .byte   $18,$00,$18,$00   ; ligne 4
        .byte   $18,$00,$18,$00   ; ligne 5
        .byte   $1C,$04,$1C,$04   ; ligne 6
        .byte   $18,$00,$18,$00   ; ligne 7
        .byte   $00,$00,$00,$00   ; ligne 8
        .byte   $0F,$00,$0F,$0F   ; ligne 9

; --- type 9 : attend -----------------------------------
lem_t9_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $30,$00,$30,$00   ; ligne 0
        .byte   $1C,$00,$1C,$00   ; ligne 1
        .byte   $3C,$0C,$3C,$0C   ; ligne 2
        .byte   $38,$18,$38,$18   ; ligne 3
        .byte   $7E,$7E,$66,$66   ; ligne 4
        .byte   $18,$18,$00,$00   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $24,$24,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t9_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3C,$18,$3C,$18   ; ligne 2
        .byte   $19,$19,$19,$19   ; ligne 3
        .byte   $7E,$7E,$66,$66   ; ligne 4
        .byte   $98,$98,$80,$80   ; ligne 5
        .byte   $18,$18,$00,$00   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $26,$26,$02,$02   ; ligne 8
        .byte   $64,$64,$64,$64   ; ligne 9
lem_t9_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3E,$38,$3E,$38   ; ligne 2
        .byte   $18,$18,$18,$18   ; ligne 3
        .byte   $7E,$7E,$66,$66   ; ligne 4
        .byte   $5A,$5A,$42,$42   ; ligne 5
        .byte   $98,$98,$80,$80   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $24,$24,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t9_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $18,$00,$18,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3E,$38,$3E,$38   ; ligne 2
        .byte   $98,$98,$98,$98   ; ligne 3
        .byte   $7E,$7E,$66,$66   ; ligne 4
        .byte   $19,$19,$01,$01   ; ligne 5
        .byte   $19,$19,$01,$01   ; ligne 6
        .byte   $3C,$3C,$00,$00   ; ligne 7
        .byte   $64,$64,$40,$40   ; ligne 8
        .byte   $26,$26,$26,$26   ; ligne 9

; --- type 10 : grimpe -----------------------------------
lem_t10_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $0D,$0D,$09,$09   ; ligne 1
        .byte   $3D,$1D,$39,$19   ; ligne 2
        .byte   $3E,$0E,$32,$02   ; ligne 3
        .byte   $3E,$0E,$30,$00   ; ligne 4
        .byte   $0E,$0E,$00,$00   ; ligne 5
        .byte   $0E,$0E,$00,$00   ; ligne 6
        .byte   $06,$06,$00,$00   ; ligne 7
        .byte   $03,$03,$01,$01   ; ligne 8
        .byte   $01,$01,$01,$01   ; ligne 9
lem_t10_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $09,$09,$09,$09   ; ligne 0
        .byte   $0D,$0D,$09,$09   ; ligne 1
        .byte   $3E,$1E,$32,$12   ; ligne 2
        .byte   $3E,$0E,$30,$00   ; ligne 3
        .byte   $3E,$0E,$30,$00   ; ligne 4
        .byte   $2E,$0E,$20,$00   ; ligne 5
        .byte   $46,$06,$40,$00   ; ligne 6
        .byte   $03,$03,$01,$01   ; ligne 7
        .byte   $01,$01,$01,$01   ; ligne 8
        .byte   $00,$00,$00,$00   ; ligne 9
lem_t10_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $09,$09,$09,$09   ; ligne 0
        .byte   $0D,$0D,$09,$09   ; ligne 1
        .byte   $3F,$1F,$33,$13   ; ligne 2
        .byte   $3E,$1E,$30,$10   ; ligne 3
        .byte   $3E,$0E,$30,$00   ; ligne 4
        .byte   $3E,$0E,$30,$00   ; ligne 5
        .byte   $46,$06,$40,$00   ; ligne 6
        .byte   $06,$06,$00,$00   ; ligne 7
        .byte   $06,$06,$02,$02   ; ligne 8
        .byte   $02,$02,$02,$02   ; ligne 9
lem_t10_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $11,$11,$11,$11   ; ligne 0
        .byte   $36,$36,$22,$22   ; ligne 1
        .byte   $7E,$3E,$74,$34   ; ligne 2
        .byte   $7E,$1E,$70,$10   ; ligne 3
        .byte   $1E,$0E,$10,$00   ; ligne 4
        .byte   $0E,$0E,$00,$00   ; ligne 5
        .byte   $06,$06,$00,$00   ; ligne 6
        .byte   $06,$06,$02,$02   ; ligne 7
        .byte   $06,$06,$02,$02   ; ligne 8
        .byte   $02,$02,$02,$02   ; ligne 9
lem_t10_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $11,$11,$11,$11   ; ligne 0
        .byte   $36,$36,$32,$32   ; ligne 1
        .byte   $7E,$3E,$64,$24   ; ligne 2
        .byte   $FE,$1E,$E0,$00   ; ligne 3
        .byte   $DE,$1E,$C0,$00   ; ligne 4
        .byte   $1E,$1E,$00,$00   ; ligne 5
        .byte   $1E,$1E,$00,$00   ; ligne 6
        .byte   $06,$06,$02,$02   ; ligne 7
        .byte   $06,$06,$02,$02   ; ligne 8
        .byte   $00,$00,$00,$00   ; ligne 9
lem_t10_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $11,$11,$11,$11   ; ligne 0
        .byte   $36,$36,$32,$32   ; ligne 1
        .byte   $7E,$3E,$64,$24   ; ligne 2
        .byte   $FE,$1E,$E0,$00   ; ligne 3
        .byte   $FE,$1E,$E0,$00   ; ligne 4
        .byte   $1E,$1E,$00,$00   ; ligne 5
        .byte   $1E,$1E,$00,$00   ; ligne 6
        .byte   $06,$06,$02,$02   ; ligne 7
        .byte   $03,$03,$03,$03   ; ligne 8
        .byte   $01,$01,$01,$01   ; ligne 9

; --- type 11 : mine -----------------------------------
lem_t11_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $4C,$40,$4C,$40   ; ligne 0
        .byte   $8E,$84,$8E,$84   ; ligne 1
        .byte   $CC,$CC,$CC,$CC   ; ligne 2
        .byte   $BE,$BE,$B0,$B0   ; ligne 3
        .byte   $8E,$8E,$88,$88   ; ligne 4
        .byte   $46,$46,$40,$40   ; ligne 5
        .byte   $06,$06,$00,$00   ; ligne 6
        .byte   $06,$06,$00,$00   ; ligne 7
        .byte   $06,$06,$00,$00   ; ligne 8
        .byte   $06,$06,$06,$06   ; ligne 9
lem_t11_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $6C,$60,$6C,$60   ; ligne 0
        .byte   $CE,$C4,$CE,$C4   ; ligne 1
        .byte   $AC,$AC,$AC,$AC   ; ligne 2
        .byte   $1E,$1E,$10,$10   ; ligne 3
        .byte   $0E,$0E,$08,$08   ; ligne 4
        .byte   $06,$06,$00,$00   ; ligne 5
        .byte   $06,$06,$00,$00   ; ligne 6
        .byte   $06,$06,$00,$00   ; ligne 7
        .byte   $06,$06,$00,$00   ; ligne 8
        .byte   $06,$06,$06,$06   ; ligne 9
lem_t11_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $E6,$06,$E6,$06   ; ligne 0
        .byte   $C3,$43,$C3,$43   ; ligne 1
        .byte   $F5,$75,$F5,$75   ; ligne 2
        .byte   $78,$78,$28,$28   ; ligne 3
        .byte   $70,$70,$00,$00   ; ligne 4
        .byte   $70,$70,$00,$00   ; ligne 5
        .byte   $70,$70,$00,$00   ; ligne 6
        .byte   $70,$70,$00,$00   ; ligne 7
        .byte   $60,$60,$00,$00   ; ligne 8
        .byte   $60,$60,$60,$60   ; ligne 9
lem_t11_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $F0,$00,$F0,$00   ; ligne 0
        .byte   $E0,$20,$E0,$20   ; ligne 1
        .byte   $70,$30,$70,$30   ; ligne 2
        .byte   $62,$62,$22,$22   ; ligne 3
        .byte   $71,$71,$01,$01   ; ligne 4
        .byte   $7E,$7E,$0E,$0E   ; ligne 5
        .byte   $F1,$F1,$01,$01   ; ligne 6
        .byte   $F2,$F2,$02,$02   ; ligne 7
        .byte   $60,$60,$00,$00   ; ligne 8
        .byte   $60,$60,$60,$60   ; ligne 9
lem_t11_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $70,$00,$70,$00   ; ligne 0
        .byte   $78,$18,$78,$18   ; ligne 1
        .byte   $30,$30,$30,$30   ; ligne 2
        .byte   $30,$30,$20,$20   ; ligne 3
        .byte   $70,$70,$00,$00   ; ligne 4
        .byte   $78,$78,$08,$08   ; ligne 5
        .byte   $F9,$F9,$09,$09   ; ligne 6
        .byte   $F5,$F5,$05,$05   ; ligne 7
        .byte   $63,$63,$03,$03   ; ligne 8
        .byte   $6C,$6C,$6C,$6C   ; ligne 9
lem_t11_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $38,$00,$38,$00   ; ligne 0
        .byte   $38,$18,$38,$18   ; ligne 1
        .byte   $30,$30,$30,$30   ; ligne 2
        .byte   $70,$70,$20,$20   ; ligne 3
        .byte   $70,$70,$00,$00   ; ligne 4
        .byte   $78,$78,$08,$08   ; ligne 5
        .byte   $F9,$F9,$09,$09   ; ligne 6
        .byte   $F5,$F5,$05,$05   ; ligne 7
        .byte   $A3,$A3,$A3,$A3   ; ligne 8
        .byte   $2C,$2C,$2C,$2C   ; ligne 9
lem_t11_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $38,$00,$38,$00   ; ligne 0
        .byte   $38,$18,$38,$18   ; ligne 1
        .byte   $30,$30,$30,$30   ; ligne 2
        .byte   $70,$70,$20,$20   ; ligne 3
        .byte   $70,$70,$00,$00   ; ligne 4
        .byte   $78,$78,$08,$08   ; ligne 5
        .byte   $F9,$F9,$09,$09   ; ligne 6
        .byte   $F5,$F5,$05,$05   ; ligne 7
        .byte   $A3,$A3,$A3,$A3   ; ligne 8
        .byte   $2C,$2C,$2C,$2C   ; ligne 9

; --- type 12 : marche parachute -----------------------------------
lem_t12_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3E,$00,$3E,$00   ; ligne 1
        .byte   $38,$08,$18,$28   ; ligne 2
        .byte   $7C,$3C,$7C,$7C   ; ligne 3
        .byte   $78,$38,$70,$70   ; ligne 4
        .byte   $78,$38,$70,$70   ; ligne 5
        .byte   $D8,$18,$D0,$D0   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $18,$18,$18,$18   ; ligne 9
lem_t12_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $38,$08,$18,$28   ; ligne 2
        .byte   $7C,$3C,$7C,$7C   ; ligne 3
        .byte   $78,$38,$70,$70   ; ligne 4
        .byte   $78,$38,$60,$60   ; ligne 5
        .byte   $7A,$3A,$62,$62   ; ligne 6
        .byte   $DA,$1A,$C2,$C2   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $30,$30,$30,$30   ; ligne 9
lem_t12_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $54,$00,$54,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $B8,$08,$98,$A8   ; ligne 2
        .byte   $FC,$3C,$FC,$FC   ; ligne 3
        .byte   $78,$38,$70,$70   ; ligne 4
        .byte   $78,$38,$60,$60   ; ligne 5
        .byte   $7C,$3C,$60,$60   ; ligne 6
        .byte   $1C,$1C,$00,$00   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t12_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $BC,$08,$9C,$A8   ; ligne 2
        .byte   $7C,$3C,$7C,$7C   ; ligne 3
        .byte   $78,$38,$70,$70   ; ligne 4
        .byte   $78,$38,$70,$70   ; ligne 5
        .byte   $B8,$38,$A0,$A0   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4C,$4C,$4C,$4C   ; ligne 9
lem_t12_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $38,$08,$18,$28   ; ligne 2
        .byte   $7C,$3C,$7C,$7C   ; ligne 3
        .byte   $78,$38,$70,$70   ; ligne 4
        .byte   $F8,$38,$E8,$E8   ; ligne 5
        .byte   $18,$18,$10,$10   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $18,$18,$18,$18   ; ligne 9
lem_t12_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $38,$08,$18,$28   ; ligne 2
        .byte   $7C,$1C,$7C,$7C   ; ligne 3
        .byte   $78,$18,$70,$70   ; ligne 4
        .byte   $F8,$18,$E8,$E8   ; ligne 5
        .byte   $1A,$1A,$0A,$0A   ; ligne 6
        .byte   $1A,$1A,$02,$02   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $30,$30,$30,$30   ; ligne 9
lem_t12_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $28,$00,$28,$00   ; ligne 1
        .byte   $38,$00,$18,$20   ; ligne 2
        .byte   $78,$08,$78,$68   ; ligne 3
        .byte   $FC,$1C,$FC,$FC   ; ligne 4
        .byte   $F8,$18,$E8,$E8   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $1C,$1C,$04,$04   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t12_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3C,$08,$1C,$28   ; ligne 2
        .byte   $7C,$1C,$7C,$7C   ; ligne 3
        .byte   $78,$18,$70,$70   ; ligne 4
        .byte   $F8,$18,$F0,$F0   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4C,$4C,$4C,$4C   ; ligne 9

; --- type 13 : marche grimpeur -----------------------------------
lem_t13_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3E,$00,$3E,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $1E,$1E,$1E,$1C   ; ligne 3
        .byte   $1C,$1C,$14,$10   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $18,$18,$10,$10   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $1C,$1C,$1C,$18   ; ligne 9
lem_t13_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $1E,$1E,$1E,$1C   ; ligne 3
        .byte   $1C,$1C,$14,$10   ; ligne 4
        .byte   $38,$38,$20,$20   ; ligne 5
        .byte   $3B,$3B,$23,$22   ; ligne 6
        .byte   $1B,$1B,$03,$02   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $38,$38,$38,$30   ; ligne 9
lem_t13_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $54,$00,$54,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $1E,$1E,$1E,$1C   ; ligne 3
        .byte   $3C,$3C,$34,$30   ; ligne 4
        .byte   $38,$38,$20,$20   ; ligne 5
        .byte   $7C,$7C,$60,$60   ; ligne 6
        .byte   $1C,$1C,$00,$00   ; ligne 7
        .byte   $BD,$BD,$81,$00   ; ligne 8
        .byte   $67,$67,$67,$66   ; ligne 9
lem_t13_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $1E,$1E,$1E,$1C   ; ligne 3
        .byte   $1C,$1C,$14,$10   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $38,$38,$20,$20   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7E,$7E,$42,$40   ; ligne 8
        .byte   $CC,$CC,$CC,$4C   ; ligne 9
lem_t13_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $1E,$1E,$1E,$1C   ; ligne 3
        .byte   $1C,$1C,$14,$10   ; ligne 4
        .byte   $18,$18,$08,$08   ; ligne 5
        .byte   $18,$18,$10,$10   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $78,$78,$60,$20   ; ligne 8
        .byte   $1C,$1C,$1C,$18   ; ligne 9
lem_t13_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $1E,$1E,$1E,$1C   ; ligne 3
        .byte   $1C,$1C,$14,$10   ; ligne 4
        .byte   $18,$18,$08,$08   ; ligne 5
        .byte   $1B,$1B,$0B,$0A   ; ligne 6
        .byte   $1B,$1B,$03,$02   ; ligne 7
        .byte   $B4,$B4,$84,$04   ; ligne 8
        .byte   $70,$70,$70,$30   ; ligne 9
lem_t13_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $28,$00,$28,$00   ; ligne 1
        .byte   $3E,$06,$3E,$00   ; ligne 2
        .byte   $1A,$0A,$1A,$08   ; ligne 3
        .byte   $1C,$1C,$1C,$18   ; ligne 4
        .byte   $18,$18,$08,$08   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $1D,$1D,$05,$04   ; ligne 7
        .byte   $BD,$BD,$81,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t13_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3E,$0E,$3E,$08   ; ligne 2
        .byte   $3E,$1E,$3E,$1C   ; ligne 3
        .byte   $1C,$1C,$14,$10   ; ligne 4
        .byte   $18,$18,$10,$10   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $98,$98,$80,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4F,$4F,$4F,$4C   ; ligne 9

; --- type 14 : marche athlete -----------------------------------
lem_t14_f0:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3E,$00,$3E,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $7E,$3E,$7E,$7C   ; ligne 3
        .byte   $7C,$3C,$74,$70   ; ligne 4
        .byte   $78,$18,$70,$70   ; ligne 5
        .byte   $D8,$18,$D0,$D0   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $18,$18,$18,$18   ; ligne 9
lem_t14_f1:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $7E,$1E,$7E,$7C   ; ligne 3
        .byte   $7C,$1C,$74,$70   ; ligne 4
        .byte   $F8,$18,$E0,$E0   ; ligne 5
        .byte   $FA,$3A,$E2,$E2   ; ligne 6
        .byte   $1A,$1A,$02,$02   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $30,$30,$30,$30   ; ligne 9
lem_t14_f2:
        .byte   1,10        ; wseg, hblock
        .byte   $54,$00,$54,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $7E,$1E,$7E,$7C   ; ligne 3
        .byte   $FC,$1C,$F4,$F0   ; ligne 4
        .byte   $F8,$38,$E0,$E0   ; ligne 5
        .byte   $7C,$3C,$60,$60   ; ligne 6
        .byte   $1C,$1C,$00,$00   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t14_f3:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $FE,$1E,$FE,$FC   ; ligne 3
        .byte   $FC,$3C,$F4,$F0   ; ligne 4
        .byte   $78,$18,$70,$70   ; ligne 5
        .byte   $38,$38,$20,$20   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4C,$4C,$4C,$4C   ; ligne 9
lem_t14_f4:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $3C,$00,$3C,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $7E,$1E,$7E,$7C   ; ligne 3
        .byte   $7C,$1C,$74,$70   ; ligne 4
        .byte   $F8,$38,$E8,$E8   ; ligne 5
        .byte   $18,$18,$10,$10   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $38,$38,$20,$20   ; ligne 8
        .byte   $18,$18,$18,$18   ; ligne 9
lem_t14_f5:
        .byte   1,10        ; wseg, hblock
        .byte   $14,$00,$14,$00   ; ligne 0
        .byte   $38,$00,$38,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $7E,$1E,$7E,$7C   ; ligne 3
        .byte   $FC,$3C,$F4,$F0   ; ligne 4
        .byte   $78,$38,$68,$68   ; ligne 5
        .byte   $1A,$1A,$0A,$0A   ; ligne 6
        .byte   $1A,$1A,$02,$02   ; ligne 7
        .byte   $34,$34,$04,$04   ; ligne 8
        .byte   $30,$30,$30,$30   ; ligne 9
lem_t14_f6:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $28,$00,$28,$00   ; ligne 1
        .byte   $3E,$06,$1E,$20   ; ligne 2
        .byte   $FA,$0A,$FA,$E8   ; ligne 3
        .byte   $FC,$3C,$FC,$F8   ; ligne 4
        .byte   $78,$38,$68,$68   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $1C,$1C,$04,$04   ; ligne 7
        .byte   $3C,$3C,$00,$00   ; ligne 8
        .byte   $66,$66,$66,$66   ; ligne 9
lem_t14_f7:
        .byte   1,10        ; wseg, hblock
        .byte   $00,$00,$00,$00   ; ligne 0
        .byte   $18,$00,$18,$00   ; ligne 1
        .byte   $3E,$0E,$1E,$28   ; ligne 2
        .byte   $7E,$1E,$7E,$7C   ; ligne 3
        .byte   $7C,$1C,$74,$70   ; ligne 4
        .byte   $F8,$38,$F0,$F0   ; ligne 5
        .byte   $18,$18,$08,$08   ; ligne 6
        .byte   $18,$18,$00,$00   ; ligne 7
        .byte   $7C,$7C,$40,$40   ; ligne 8
        .byte   $4C,$4C,$4C,$4C   ; ligne 9

; --- definitions de type ---------------------------------------------------
; nb de vignettes, vitesse, boucle (1) ou une seule fois (0)
lem_def0:
        .byte   8,6,1     ; marche
lem_def1:
        .byte   4,4,1     ; chute
lem_def2:
        .byte   9,5,1     ; creuse
lem_def3:
        .byte   4,9,1     ; bloque
lem_def4:
        .byte   8,6,0     ; meurt
lem_def5:
        .byte   5,1,1     ; flotte
lem_def6:
        .byte   8,5,1     ; frappe
lem_def7:
        .byte   7,10,0     ; explose
lem_def8:
        .byte   2,5,1     ; construit
lem_def9:
        .byte   4,4,1     ; attend
lem_def10:
        .byte   6,4,1     ; grimpe
lem_def11:
        .byte   7,4,1     ; mine
lem_def12:
        .byte   8,6,1     ; marche parachute
lem_def13:
        .byte   8,6,1     ; marche grimpeur
lem_def14:
        .byte   8,6,1     ; marche athlete

; --- tables d'acces, poids fort puis poids faible --------------------------
lem_frames0_hi:
        .byte   lem_t0_f0>>8,lem_t0_f1>>8,lem_t0_f2>>8,lem_t0_f3>>8,lem_t0_f4>>8,lem_t0_f5>>8,lem_t0_f6>>8,lem_t0_f7>>8
lem_frames0_lo:
        .byte   lem_t0_f0&$FF,lem_t0_f1&$FF,lem_t0_f2&$FF,lem_t0_f3&$FF,lem_t0_f4&$FF,lem_t0_f5&$FF,lem_t0_f6&$FF,lem_t0_f7&$FF
lem_frames1_hi:
        .byte   lem_t1_f0>>8,lem_t1_f1>>8,lem_t1_f2>>8,lem_t1_f3>>8
lem_frames1_lo:
        .byte   lem_t1_f0&$FF,lem_t1_f1&$FF,lem_t1_f2&$FF,lem_t1_f3&$FF
lem_frames2_hi:
        .byte   lem_t2_f0>>8,lem_t2_f1>>8,lem_t2_f2>>8,lem_t2_f3>>8,lem_t2_f4>>8,lem_t2_f5>>8,lem_t2_f6>>8,lem_t2_f7>>8,lem_t2_f8>>8
lem_frames2_lo:
        .byte   lem_t2_f0&$FF,lem_t2_f1&$FF,lem_t2_f2&$FF,lem_t2_f3&$FF,lem_t2_f4&$FF,lem_t2_f5&$FF,lem_t2_f6&$FF,lem_t2_f7&$FF,lem_t2_f8&$FF
lem_frames3_hi:
        .byte   lem_t3_f0>>8,lem_t3_f1>>8,lem_t3_f2>>8,lem_t3_f3>>8
lem_frames3_lo:
        .byte   lem_t3_f0&$FF,lem_t3_f1&$FF,lem_t3_f2&$FF,lem_t3_f3&$FF
lem_frames4_hi:
        .byte   lem_t4_f0>>8,lem_t4_f1>>8,lem_t4_f2>>8,lem_t4_f3>>8,lem_t4_f4>>8,lem_t4_f5>>8,lem_t4_f6>>8,lem_t4_f7>>8
lem_frames4_lo:
        .byte   lem_t4_f0&$FF,lem_t4_f1&$FF,lem_t4_f2&$FF,lem_t4_f3&$FF,lem_t4_f4&$FF,lem_t4_f5&$FF,lem_t4_f6&$FF,lem_t4_f7&$FF
lem_frames5_hi:
        .byte   lem_t5_f0>>8,lem_t5_f1>>8,lem_t5_f2>>8,lem_t5_f3>>8,lem_t5_f4>>8
lem_frames5_lo:
        .byte   lem_t5_f0&$FF,lem_t5_f1&$FF,lem_t5_f2&$FF,lem_t5_f3&$FF,lem_t5_f4&$FF
lem_frames6_hi:
        .byte   lem_t6_f0>>8,lem_t6_f1>>8,lem_t6_f2>>8,lem_t6_f3>>8,lem_t6_f4>>8,lem_t6_f5>>8,lem_t6_f6>>8,lem_t6_f7>>8
lem_frames6_lo:
        .byte   lem_t6_f0&$FF,lem_t6_f1&$FF,lem_t6_f2&$FF,lem_t6_f3&$FF,lem_t6_f4&$FF,lem_t6_f5&$FF,lem_t6_f6&$FF,lem_t6_f7&$FF
lem_frames7_hi:
        .byte   lem_t7_f0>>8,lem_t7_f1>>8,lem_t7_f2>>8,lem_t7_f3>>8,lem_t7_f4>>8,lem_t7_f5>>8,lem_t7_f6>>8
lem_frames7_lo:
        .byte   lem_t7_f0&$FF,lem_t7_f1&$FF,lem_t7_f2&$FF,lem_t7_f3&$FF,lem_t7_f4&$FF,lem_t7_f5&$FF,lem_t7_f6&$FF
lem_frames8_hi:
        .byte   lem_t8_f0>>8,lem_t8_f1>>8
lem_frames8_lo:
        .byte   lem_t8_f0&$FF,lem_t8_f1&$FF
lem_frames9_hi:
        .byte   lem_t9_f0>>8,lem_t9_f1>>8,lem_t9_f2>>8,lem_t9_f3>>8
lem_frames9_lo:
        .byte   lem_t9_f0&$FF,lem_t9_f1&$FF,lem_t9_f2&$FF,lem_t9_f3&$FF
lem_frames10_hi:
        .byte   lem_t10_f0>>8,lem_t10_f1>>8,lem_t10_f2>>8,lem_t10_f3>>8,lem_t10_f4>>8,lem_t10_f5>>8
lem_frames10_lo:
        .byte   lem_t10_f0&$FF,lem_t10_f1&$FF,lem_t10_f2&$FF,lem_t10_f3&$FF,lem_t10_f4&$FF,lem_t10_f5&$FF
lem_frames11_hi:
        .byte   lem_t11_f0>>8,lem_t11_f1>>8,lem_t11_f2>>8,lem_t11_f3>>8,lem_t11_f4>>8,lem_t11_f5>>8,lem_t11_f6>>8
lem_frames11_lo:
        .byte   lem_t11_f0&$FF,lem_t11_f1&$FF,lem_t11_f2&$FF,lem_t11_f3&$FF,lem_t11_f4&$FF,lem_t11_f5&$FF,lem_t11_f6&$FF
lem_frames12_hi:
        .byte   lem_t12_f0>>8,lem_t12_f1>>8,lem_t12_f2>>8,lem_t12_f3>>8,lem_t12_f4>>8,lem_t12_f5>>8,lem_t12_f6>>8,lem_t12_f7>>8
lem_frames12_lo:
        .byte   lem_t12_f0&$FF,lem_t12_f1&$FF,lem_t12_f2&$FF,lem_t12_f3&$FF,lem_t12_f4&$FF,lem_t12_f5&$FF,lem_t12_f6&$FF,lem_t12_f7&$FF
lem_frames13_hi:
        .byte   lem_t13_f0>>8,lem_t13_f1>>8,lem_t13_f2>>8,lem_t13_f3>>8,lem_t13_f4>>8,lem_t13_f5>>8,lem_t13_f6>>8,lem_t13_f7>>8
lem_frames13_lo:
        .byte   lem_t13_f0&$FF,lem_t13_f1&$FF,lem_t13_f2&$FF,lem_t13_f3&$FF,lem_t13_f4&$FF,lem_t13_f5&$FF,lem_t13_f6&$FF,lem_t13_f7&$FF
lem_frames14_hi:
        .byte   lem_t14_f0>>8,lem_t14_f1>>8,lem_t14_f2>>8,lem_t14_f3>>8,lem_t14_f4>>8,lem_t14_f5>>8,lem_t14_f6>>8,lem_t14_f7>>8
lem_frames14_lo:
        .byte   lem_t14_f0&$FF,lem_t14_f1&$FF,lem_t14_f2&$FF,lem_t14_f3&$FF,lem_t14_f4&$FF,lem_t14_f5&$FF,lem_t14_f6&$FF,lem_t14_f7&$FF

; --- table a plat : index = type*LEM_MAXFRAMES + vignette -------------------
LEM_MAXFRAMES   .equ    9
lem_fr_hi:
        .byte   lem_t0_f0>>8,lem_t0_f1>>8,lem_t0_f2>>8,lem_t0_f3>>8,lem_t0_f4>>8,lem_t0_f5>>8,lem_t0_f6>>8,lem_t0_f7>>8,lem_t0_f7>>8   ; type 0 : marche
        .byte   lem_t1_f0>>8,lem_t1_f1>>8,lem_t1_f2>>8,lem_t1_f3>>8,lem_t1_f3>>8,lem_t1_f3>>8,lem_t1_f3>>8,lem_t1_f3>>8,lem_t1_f3>>8   ; type 1 : chute
        .byte   lem_t2_f0>>8,lem_t2_f1>>8,lem_t2_f2>>8,lem_t2_f3>>8,lem_t2_f4>>8,lem_t2_f5>>8,lem_t2_f6>>8,lem_t2_f7>>8,lem_t2_f8>>8   ; type 2 : creuse
        .byte   lem_t3_f0>>8,lem_t3_f1>>8,lem_t3_f2>>8,lem_t3_f3>>8,lem_t3_f3>>8,lem_t3_f3>>8,lem_t3_f3>>8,lem_t3_f3>>8,lem_t3_f3>>8   ; type 3 : bloque
        .byte   lem_t4_f0>>8,lem_t4_f1>>8,lem_t4_f2>>8,lem_t4_f3>>8,lem_t4_f4>>8,lem_t4_f5>>8,lem_t4_f6>>8,lem_t4_f7>>8,lem_t4_f7>>8   ; type 4 : meurt
        .byte   lem_t5_f0>>8,lem_t5_f1>>8,lem_t5_f2>>8,lem_t5_f3>>8,lem_t5_f4>>8,lem_t5_f4>>8,lem_t5_f4>>8,lem_t5_f4>>8,lem_t5_f4>>8   ; type 5 : flotte
        .byte   lem_t6_f0>>8,lem_t6_f1>>8,lem_t6_f2>>8,lem_t6_f3>>8,lem_t6_f4>>8,lem_t6_f5>>8,lem_t6_f6>>8,lem_t6_f7>>8,lem_t6_f7>>8   ; type 6 : frappe
        .byte   lem_t7_f0>>8,lem_t7_f1>>8,lem_t7_f2>>8,lem_t7_f3>>8,lem_t7_f4>>8,lem_t7_f5>>8,lem_t7_f6>>8,lem_t7_f6>>8,lem_t7_f6>>8   ; type 7 : explose
        .byte   lem_t8_f0>>8,lem_t8_f1>>8,lem_t8_f1>>8,lem_t8_f1>>8,lem_t8_f1>>8,lem_t8_f1>>8,lem_t8_f1>>8,lem_t8_f1>>8,lem_t8_f1>>8   ; type 8 : construit
        .byte   lem_t9_f0>>8,lem_t9_f1>>8,lem_t9_f2>>8,lem_t9_f3>>8,lem_t9_f3>>8,lem_t9_f3>>8,lem_t9_f3>>8,lem_t9_f3>>8,lem_t9_f3>>8   ; type 9 : attend
        .byte   lem_t10_f0>>8,lem_t10_f1>>8,lem_t10_f2>>8,lem_t10_f3>>8,lem_t10_f4>>8,lem_t10_f5>>8,lem_t10_f5>>8,lem_t10_f5>>8,lem_t10_f5>>8   ; type 10 : grimpe
        .byte   lem_t11_f0>>8,lem_t11_f1>>8,lem_t11_f2>>8,lem_t11_f3>>8,lem_t11_f4>>8,lem_t11_f5>>8,lem_t11_f6>>8,lem_t11_f6>>8,lem_t11_f6>>8   ; type 11 : mine
        .byte   lem_t12_f0>>8,lem_t12_f1>>8,lem_t12_f2>>8,lem_t12_f3>>8,lem_t12_f4>>8,lem_t12_f5>>8,lem_t12_f6>>8,lem_t12_f7>>8,lem_t12_f7>>8   ; type 12 : marche parachute
        .byte   lem_t13_f0>>8,lem_t13_f1>>8,lem_t13_f2>>8,lem_t13_f3>>8,lem_t13_f4>>8,lem_t13_f5>>8,lem_t13_f6>>8,lem_t13_f7>>8,lem_t13_f7>>8   ; type 13 : marche grimpeur
        .byte   lem_t14_f0>>8,lem_t14_f1>>8,lem_t14_f2>>8,lem_t14_f3>>8,lem_t14_f4>>8,lem_t14_f5>>8,lem_t14_f6>>8,lem_t14_f7>>8,lem_t14_f7>>8   ; type 14 : marche athlete
lem_fr_lo:
        .byte   lem_t0_f0&$FF,lem_t0_f1&$FF,lem_t0_f2&$FF,lem_t0_f3&$FF,lem_t0_f4&$FF,lem_t0_f5&$FF,lem_t0_f6&$FF,lem_t0_f7&$FF,lem_t0_f7&$FF
        .byte   lem_t1_f0&$FF,lem_t1_f1&$FF,lem_t1_f2&$FF,lem_t1_f3&$FF,lem_t1_f3&$FF,lem_t1_f3&$FF,lem_t1_f3&$FF,lem_t1_f3&$FF,lem_t1_f3&$FF
        .byte   lem_t2_f0&$FF,lem_t2_f1&$FF,lem_t2_f2&$FF,lem_t2_f3&$FF,lem_t2_f4&$FF,lem_t2_f5&$FF,lem_t2_f6&$FF,lem_t2_f7&$FF,lem_t2_f8&$FF
        .byte   lem_t3_f0&$FF,lem_t3_f1&$FF,lem_t3_f2&$FF,lem_t3_f3&$FF,lem_t3_f3&$FF,lem_t3_f3&$FF,lem_t3_f3&$FF,lem_t3_f3&$FF,lem_t3_f3&$FF
        .byte   lem_t4_f0&$FF,lem_t4_f1&$FF,lem_t4_f2&$FF,lem_t4_f3&$FF,lem_t4_f4&$FF,lem_t4_f5&$FF,lem_t4_f6&$FF,lem_t4_f7&$FF,lem_t4_f7&$FF
        .byte   lem_t5_f0&$FF,lem_t5_f1&$FF,lem_t5_f2&$FF,lem_t5_f3&$FF,lem_t5_f4&$FF,lem_t5_f4&$FF,lem_t5_f4&$FF,lem_t5_f4&$FF,lem_t5_f4&$FF
        .byte   lem_t6_f0&$FF,lem_t6_f1&$FF,lem_t6_f2&$FF,lem_t6_f3&$FF,lem_t6_f4&$FF,lem_t6_f5&$FF,lem_t6_f6&$FF,lem_t6_f7&$FF,lem_t6_f7&$FF
        .byte   lem_t7_f0&$FF,lem_t7_f1&$FF,lem_t7_f2&$FF,lem_t7_f3&$FF,lem_t7_f4&$FF,lem_t7_f5&$FF,lem_t7_f6&$FF,lem_t7_f6&$FF,lem_t7_f6&$FF
        .byte   lem_t8_f0&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF,lem_t8_f1&$FF
        .byte   lem_t9_f0&$FF,lem_t9_f1&$FF,lem_t9_f2&$FF,lem_t9_f3&$FF,lem_t9_f3&$FF,lem_t9_f3&$FF,lem_t9_f3&$FF,lem_t9_f3&$FF,lem_t9_f3&$FF
        .byte   lem_t10_f0&$FF,lem_t10_f1&$FF,lem_t10_f2&$FF,lem_t10_f3&$FF,lem_t10_f4&$FF,lem_t10_f5&$FF,lem_t10_f5&$FF,lem_t10_f5&$FF,lem_t10_f5&$FF
        .byte   lem_t11_f0&$FF,lem_t11_f1&$FF,lem_t11_f2&$FF,lem_t11_f3&$FF,lem_t11_f4&$FF,lem_t11_f5&$FF,lem_t11_f6&$FF,lem_t11_f6&$FF,lem_t11_f6&$FF
        .byte   lem_t12_f0&$FF,lem_t12_f1&$FF,lem_t12_f2&$FF,lem_t12_f3&$FF,lem_t12_f4&$FF,lem_t12_f5&$FF,lem_t12_f6&$FF,lem_t12_f7&$FF,lem_t12_f7&$FF
        .byte   lem_t13_f0&$FF,lem_t13_f1&$FF,lem_t13_f2&$FF,lem_t13_f3&$FF,lem_t13_f4&$FF,lem_t13_f5&$FF,lem_t13_f6&$FF,lem_t13_f7&$FF,lem_t13_f7&$FF
        .byte   lem_t14_f0&$FF,lem_t14_f1&$FF,lem_t14_f2&$FF,lem_t14_f3&$FF,lem_t14_f4&$FF,lem_t14_f5&$FF,lem_t14_f6&$FF,lem_t14_f7&$FF,lem_t14_f7&$FF

; nombre REEL de vignettes par type (pour boucler l'animation)
lem_nframes:
        .byte   8,4,9,4,8,5,8,7,2,4,6,7,8,8,8

lem_def_hi:
        .byte   lem_def0>>8,lem_def1>>8,lem_def2>>8,lem_def3>>8,lem_def4>>8,lem_def5>>8,lem_def6>>8,lem_def7>>8,lem_def8>>8,lem_def9>>8,lem_def10>>8,lem_def11>>8,lem_def12>>8,lem_def13>>8,lem_def14>>8
lem_def_lo:
        .byte   lem_def0&$FF,lem_def1&$FF,lem_def2&$FF,lem_def3&$FF,lem_def4&$FF,lem_def5&$FF,lem_def6&$FF,lem_def7&$FF,lem_def8&$FF,lem_def9&$FF,lem_def10&$FF,lem_def11&$FF,lem_def12&$FF,lem_def13&$FF,lem_def14&$FF
