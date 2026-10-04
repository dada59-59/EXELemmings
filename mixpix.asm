; ============================================================================
; MIXPIX — variante de MIXTEST avec RELIEF AU PIXEL
;
; Meme programme que mixtest.asm, a une difference pres : la marche et la
; chute ne consultent plus les PROPRIETES de la tuile (solide / vide) mais
; ses PIXELS. Un lemming s'enfonce donc dans les pixels noirs du haut d'une
; tuile, et suit une tuile dessinee en pente.
;
; Ce que cela permet, et ce que cela ne permet pas :
;   - VERTICALEMENT, la precision est au pixel. lem_y etait deja exprime en
;     lignes de balayage : seul le TEST de terrain etait par tuile.
;   - HORIZONTALEMENT, le deplacement reste par segment de 8 px. Bouger un
;     sprite d'un pixel obligerait a le decaler a cheval sur deux segments,
;     soit environ trois fois le cout du dessin -- disproportionne pour le
;     gain.
;
; Aucune donnee supplementaire : un pixel est SOLIDE si l'un des trois plans
; de la tuile a son bit a 1, autrement dit si sa couleur n'est pas le noir.
; La meme tuile sert donc a l'affichage et a la collision.
;
; Les competences (creuseur, frappeur, constructeur) restent PAR TUILE :
; elles detruisent ou posent des cases entieres, ce qui reste coherent.
; ============================================================================

; ============================================================================
; TOUCHES -- pouvoirs et commandes (voir la table KEY_* plus bas pour les
; codes exacts ; majuscule et minuscule acceptees pour toutes) :
;
;   Fleches   : deplace le viseur (case ciblee par les pouvoirs)
;   C D H B F E G M : SELECTIONNE le pouvoir dans le panneau du bas ET l'attribue
;               aussitot au lemming sous le viseur :
;               C constructeur, D creuseur, H frappeur, B bloqueur,
;               F parachutiste (aussi sur un lemming deja en chute),
;               E kamikaze (accepte quel que soit l'etat du lemming),
;               G grimpeur (permanent : escalade les parois verticales),
;               M mineur (creuse en diagonale vers le bas)
;   TAB       : pouvoir suivant (surbrillance bleue dans le panneau)
;   Espace    : attribue le pouvoir selectionne au lemming sous le viseur
;   R         : ecran suivant, redessine entierement la zone bitmap
;   S         : bascule la souris (ExelMouse, protocole P49/P50 autonome,
;               EXL100 et EXELTEL) : deplace le viseur ; bouton 1 = attribuer,
;               bouton 2 = pouvoir suivant (voir MOUSE_BTN1/2)
;
; Chaque pouvoir est limite au nombre defini pour le niveau (lv_skills,
; EXELTILE) ; il n'est decompte que si l'attribution reussit.
; Pas de grimpeur separe : franchir un obstacle bas se fait automatiquement
; (surface_find), ce n'est pas un pouvoir a attribuer comme dans l'original.
; ============================================================================

; ============================================================================
; MIXTEST — test statique du mode texte/bitmap MELANGE
;
; Disposition demandee : 2 lignes texte en haut, 20 "lignes" de decor en
; bitmap (tuiles 8x10), 3 lignes texte en bas. Objectif : evaluer la
; vitesse de reaffichage complet de la zone bitmap (touche R), avant de
; batir quoi que ce soit dessus.
;
; Base entierement sur EXL100.equ / vdp.asm / tasmEXL.TAB (Jester,
; systemcfg), PAS sur mixt_api : deux ecosystemes coherents chacun en soi,
; mieux vaut ne pas les melanger pour un premier essai. Seul le tout debut
; (dint/ldsp/init_vdp/trap13, prouve fiable sur machine reelle tout au
; long de ce projet) reste commun.
;
; CLARIFICATION IMPORTANTE (a l'origine d'une premiere erreur de calcul) :
; GRAPH_LINES, dans le mecanisme de Jester, compte des LIGNES DE BALAYAGE
; PHYSIQUES, pas des lignes-texte. "20 lignes" de decor, pour occuper la
; meme hauteur que 20 lignes de texte (chacune sur 10 balayages), valent
; donc GRAPH_LINES=200, pas 20.
;
; Sources verifiees pour chaque constante/registre utilise ici :
;   EXL100.equ    : FWHITE, BBLACK, BAGC2, REGBAGC2, REGBAPA, MIXTLEN,
;                   MAPPLEN, CM1MASK, CM2MASK, LINEZERO, BAGC3ALPHA,
;                   CM3MASK, TEXTMODE, MIXTMODE, CM4MASK, MBLACK,
;                   COL, ROW, SCRMODE, TIMEBASE, DECODER, BORDER,
;                   wvdp(r) = movp r,P46
;   vdp.asm       : vdpInitDefault (sequence CM1/CM2/CM4 reprise telle
;                   quelle), InitMixedPage (algorithme reproduit ici a la
;                   main, wvdp() etant un simple #DEFINE)
;   tasmEXL.TAB   : LVDP confirmee comme vraie instruction (D728), non
;                   utilisee ici (ce test n'a besoin que d'ecrire)
;   "BAPA/BAMP load COL/ROW + 1. BAGC0..BAGC3 load COL/ROW + 2." --
;   exactement la compensation deja etablie a la main dans Exeltris pour
;   BAGC2/BAGC3 (registre $0D/$0E, +1/+2 sur l'adresse) : confirmee ici
;   mot pour mot par la documentation, independamment retrouvee avant.
; ============================================================================

#include "7020.equ"
#include "3556.equ"

; ============================================================================
; SELECTION DES FONCTIONS DE L'API (mixt_api.asm n'assemble le code de
; chaque routine que si son #DEFINE est pose ici -- sans ce bloc :
; "Label not found", exactement comme au premier essai de lemproto.asm)
; Ce test n'utilise que init_vdp : tout le reste de l'affichage passe par
; nos propres ecritures VDP directes.
; ============================================================================
#DEFINE Finit_vdp

; --- constantes : TOUTES deja definies dans 3556.equ (FWHITE, BBLACK,
; BAGC2, REGBAPA, COL, ROW, TIMEBASE, DECODER, SCRMODE, BORDER, CM1MASK,
; CM2MASK, LINEZERO, BAGC3ALPHA, CM3MASK, MIXTMODE, CM4MASK, MBLACK,
; MIXTLEN, MAPPLEN...). Un premier essai les redeclarait ici, ce que TASM
; a refuse avec 22 "Duplicate label" -- confirmant du meme coup que notre
; 3556.equ est bien le meme fichier de constantes que celui du toolkit
; Jester, ou un equivalent exact. Seules restent ci-dessous les valeurs
; PROPRES a ce test.
BG_PTR          .equ    30              ; paire R29:R30 (= TEMP9 d'EXL100.equ,
                                        ; nomme ici pour ne pas dependre de
                                        ; 7020.equ) : pointeur VRAM de
                                        ; bg_draw_rect et de destination de
                                        ; bg_fill_buf. Utilise nulle part
                                        ; ailleurs dans ce programme.
VP_PTR          .equ    32              ; paire R31:R32 (= TEMP10 d'EXL100.equ) :
                                        ; adresse VRAM dans lem_draw. Utilise
                                        ; nulle part ailleurs.
MAPPLEN_HI_C    .equ    1               ; (MAPPLEN>>8)+1 = 0+1, en dur
; --- TEXTE : police MAISON dans BAGC3, comme Exeltris -----------------------
; La police ROM copiee par trap 13 (BAGC0) marche sur l'emulateur mais PAS
; sur machine reelle : fond blanc et lignes horizontales a la place des
; caracteres (photo EXL100), exactement le symptome deja rencontre et
; documente sur Exeltris ("barres, texte bruite ou paves pleins").
; Solution reprise d'Exeltris, validee sur EXL100 et EXELTEL : une police
; chargee par trap 19 dans BAGC3, BAGC3 reloge par ses registres de base et
; laisse ALPHAMOSAIQUE (CM2.DC5 = 1). En alphamosaique, le fond de la cellule
; vient des bits 2-0 de l'attribut (BBLACK), l'avant-plan des bits 7-5.
; Chaque glyphe est charge A SON CODE ASCII ($21..$5F) : aucune traduction
; dans les routines d'ecriture, sauf l'espace (voir CH_BLANK).
TEXT_ATTR       .equ    FWHITE|$18|BBLACK   ; $18 = banc BAGC3 (bits 4-3),
                                        ; en dur comme dans Exeltris
BAGC3_MOSAIC    .equ    $08             ; CM2.DC5 : BAGC3 alphamosaique (valeur
                                        ; de CM2 d'Exeltris : $88 ; ici $C8,
                                        ; LINEZERO en plus comme avant)
FONT_BAGC3      .equ    $6800           ; generateur BAGC3 en VRAM : 1280 octets
                                        ; ($6800-$6CFF), APRES la page mixte
                                        ; ($0600-$66E9) et sous 32 Ko
FONT_BAGC3_M2   .equ    $67FE           ; FONT_BAGC3-2, en dur : les bases de
                                        ; generateur chargent COL/ROW + 2
CH_BLANK        .equ    $60             ; glyphe VIDE dedie, ecrit a la place
                                        ; de l'espace : sur machine reelle le
                                        ; code $20 peut s'afficher comme un
                                        ; pave (delimiteur de zone VDP) --
                                        ; lecon d'Exeltris. $00 et $20 recoivent
                                        ; quand meme un glyphe vide par surete.

; Octet de controle (manuel TMS3556, section 1.3) : BM GM RM C/G MR LR IR X,
; du bit 7 au bit 0. C/G est donc le BIT 4 = $10 -- et non $18 comme une
; premiere version de ce fichier l'avait ecrit, par confusion avec le motif
; de selection du banc BAGC3 (qui vaut bien $18, mais dans l'octet
; d'ATTRIBUT d'un caractere, pas dans l'octet de controle de fin de ligne :
; deux champs sans rapport). Valeur recoupee independamment par le moteur
; de rendu du projet (MIXED_NEXT_GRAPHIC = 0x10).
; BM/GM/RM (bits 7-5) restent a 0 : marge noire pour la ligne suivante.
MIXT_NEXT_TEXT  .equ    $00             ; C/G = 0 : ligne suivante = texte
MIXT_NEXT_GRAPH .equ    $10             ; C/G = 1 : ligne suivante = graphique

; --- disposition de CE test -------------------------------------------------
TOP_TEXT_LINES  .equ    2
GRAPH_LINES     .equ    200             ; 20 lignes-texte de haut, en VRAIES
                                        ; lignes de balayage (20*10)
BOT_TEXT_LINES  .equ    3
SCREEN_BASE     .equ    $0600           ; PAS $4000 : avec 200 lignes bitmap,
                                        ; la page complete pese 24810 octets
                                        ; -- $4000+24810 depassait les 32 Ko
                                        ; de VRAM reelle mentionnes pour cette
                                        ; machine (la puce adresse jusqu'a
                                        ; 64 Ko, mais pas forcement l'EXL100).
                                        ; $0600 laisse la marge necessaire
                                        ; sous 32 Ko, et reste au-dela de la
                                        ; police ROM copiee en $0000 (trap 13,
                                        ; jusqu'a ~1280 octets pour 128 car.)
SCREEN_BASE_M1  .equ    $05FF           ; SCREEN_BASE-1, en dur : BAPA
                                        ; charge COL/ROW+1 (vdp.asm), donc
                                        ; on ecrit l'adresse cible moins un
GRAPH_BASE      .equ    $06A4           ; SCREEN_BASE + TOP_TEXT_LINES*
                                        ; MIXTLEN (2*82=164), en dur

; --- grille de tuiles decor : 8 (largeur) x 10 (hauteur), PAS 8x8 (choix
; explicite pour aligner sur la hauteur d'une ligne-texte).
; ATTENTION : ces cinq constantes DOCUMENTENT la geometrie mais ne pilotent
; rien -- draw_all_tiles utilise 40, 100 et 110 en dur. Changer une valeur
; ici ne changera pas l'affichage ; il faudra aussi toucher draw_all_tiles.
TILE_W_SEG      .equ    1               ; 8 px = 1 segment
TILE_H_LINES    .equ    10
TILES_PER_ROW   .equ    40              ; 320 px / 8
TILE_ROWS       .equ    20              ; GRAPH_LINES / TILE_H_LINES
HORIZON_ROW     .equ    10              ; tuiles 0..9 = ciel, 10..19 = sol

; --- viseur bitmap ---------------------------------------------------------
; Croix EVIDEE au centre (comme un viseur) : 16x16 pixels, soit 2 segments
; de large et 16 lignes de haut. Se deplace dans la seule zone bitmap.
CUR_W_SEG       .equ    2               ; 16 px de large
CUR_H_LINES     .equ    16
; Les deux pas doivent couvrir la MEME distance en pixels, sinon le viseur
; se deplace visiblement plus vite dans un sens que dans l'autre : un
; segment fait 8 px, le pas vertical doit donc valoir 8 lignes (il etait a
; 4, d'ou un deplacement horizontal deux fois plus rapide).
; Contrepartie : le viseur ne peut plus se poser qu'une ligne sur 8 en
; vertical. Remettre 4 ici si la precision compte plus que la symetrie.
CUR_STEP_X      .equ    1               ; pas horizontal, en segments de 8 px
CUR_STEP_Y      .equ    8               ; pas vertical, en lignes (= 8 px)
CUR_BURST_MAX   .equ    4               ; pas maximum en UNE passe : quand
                                        ; une passe dure plusieurs ticks, le
                                        ; viseur rattrape le temps perdu,
                                        ; mais sans sauter plus loin que ca
CUR_MAX_XSEG    .equ    38              ; 40 - CUR_W_SEG
CUR_MAX_Y       .equ    184             ; GRAPH_LINES - CUR_H_LINES

; Lemming : bornes et rythme. LEM_WSEG/LEM_HLINES viennent de lemdata.asm.
; 40 - LEM_WSEG, ecrit EN DUR : LEM_WSEG vient de lemdata.asm, inclus tout
; a la fin du fichier, et un .equ ne peut pas referencer un symbole defini
; plus loin. A CORRIGER A LA MAIN si vous changez la largeur du sprite dans
; EXELLEM : 39 pour un sprite de 8 px (1 segment), 38 pour 16 px.
; Borne EXCLUSIVE des colonnes : les tests s'ecrivent "xseg+1 < LEM_COLS".
; Valait 39, ce qui rendait la colonne 39 inatteignable -- la derniere case
; de chaque ecran n'etait donc jamais parcourue ni creusee.
LEM_COLS        .equ    40              ; = LV_MAP_W
LEM_LAST_XSEG   .equ    39              ; derniere colonne utilisable
NUM_LEM         .equ    10              ; lemmings au total
ST_WALK         .equ    0               ; etats d'un lemming
ST_FALL         .equ    1
FALL_STEP       .equ    2               ; lignes descendues par pas de chute
LEM_MAX_Y       .equ    190             ; GRAPH_LINES - LEM_HLINES, en dur
TILE_SOLID      .equ    $01             ; bit 0 de lv_flags : porte un lemming
LEM_FOOT        .equ    9               ; LEM_HLINES-1, en dur : derniere
                                        ; ligne du sprite (hauteur des pieds)

; --- sondage du relief au pixel --------------------------------------------
; On sonde les pixels 1 a 6 du segment (bit 7 = pixel 0, a gauche) : un
; pixel non noir parmi eux suffit. Autrefois seulement les pixels 3 et 4,
; sous le corps du lemming : suffisant pour des tuiles dessinees a la main,
; mais un decor IMPORTE d'une image a des colonnes rayees, des traits fins,
; dont les pixels tombent a cote -- les lemmings traversaient ces murs
; visibles, et le frappeur n'y voyait rien a creuser (ils restaient
; affiches). Les pixels 0 et 7, au bord du segment, restent ignores : un
; trait sur la frontiere entre deux tuiles ne fait pas un mur.
PROBE_MASK      .equ    $7E             ; bits 6 a 1 = pixels 1 a 6
MAX_STEP_UP_N   .equ    11              ; MAX_STEP_UP+1 tours de boucle : le
                                        ; premier examine la ligne de depart
                                        ; elle-meme. Avec 10 tours, une
                                        ; marche de 10 px etait refusee alors
                                        ; qu'elle devait passer.
MAX_STEP_UP     .equ    10              ; denivele franchissable en montant.
                                        ; Vaut une tuile entiere pour que
                                        ; l'escalier du constructeur reste
                                        ; praticable ; une valeur plus faible
                                        ; (4 a 6, comme l'original) donnerait
                                        ; un relief plus exigeant.
MAX_STEP_DOWN   .equ    6               ; au-dela, il tombe au lieu de
                                        ; descendre la pente
TILE_DIG        .equ    $02             ; bit 1 de lv_flags : destructible
ST_DIG          .equ    2               ; troisieme etat : creuse vers le bas
ST_BLOCK        .equ    3               ; type 3 = "bloque" : il reste sur
                                        ; place et fait faire demi-tour aux
                                        ; lemmings qui l'abordent
ST_DEAD         .equ    4               ; type 4 = "meurt"
ST_FLOAT        .equ    5               ; type 5 = "flotte" : chute freinee
                                        ; par un parachute, jamais mortelle
FLOAT_STEP      .equ    1               ; lignes par pas en parachute
FLOAT_OPEN      .equ    12              ; le parachute ne s'ouvre qu'apres
                                        ; 12 lignes de chute : une marche du
                                        ; tunnel du mineur (10 px) se descend
                                        ; sans lui, un trou de 2 tuiles l'ouvre.
                                        ; Tres en dessous de MAX_FALL : un
                                        ; parachutiste ne s'ecrase jamais.
                                        ; (deux fois plus lent qu'une chute)
ST_BASH         .equ    6               ; type 6 = "frappe" : creuse a
                                        ; l'horizontale, dans son sens de
                                        ; marche

; --- kamikaze --------------------------------------------------------------
; Le terrain etant une grille de tuiles 8x10, le cratere circulaire de
; l'original (~16 px de diametre) n'est pas reproductible : on detruit un
; carre de tuiles centre sur le lemming. 3x3 = 24x30 px, la surface la plus
; proche du cratere d'origine, et de quoi percer une paroi ou degager un
; bloqueur. L'ACIER resiste, comme partout ailleurs.
ST_BUILD        .equ    8               ; type 8 = "construit" : pose un
                                        ; escalier d'une tuile par marche
ST_MINE         .equ    11              ; type 11 = "mine" : creuse en
                                        ; diagonale vers le bas (competence M)
ST_CLIMB        .equ    10              ; type 10 = "grimpe" : escalade une
                                        ; paroi verticale (competence G)
CLIMB_STEP      .equ    2               ; lignes gagnees par pas d'escalade
                                        ; (le test de plafond verifie les 2)
EQUIP_FLOAT     .equ    $01             ; lem_float, bit 0 : parachute
EQUIP_CLIMB     .equ    $02             ; lem_float, bit 1 : grimpeur
; types de SPRITE du marcheur selon ses competences permanentes (ce ne sont
; pas des etats : l'etat reste ST_WALK, voir lem_sprite_type)
LT_WALK_F       .equ    12              ; marche, parachute sur le dos
LT_WALK_C       .equ    13              ; marche, grimpeur
LT_WALK_FC      .equ    14              ; marche, les deux ("athlete")
ST_WAIT         .equ    9               ; type 9 = "attend" : plus de
                                        ; briques, bras leves -- signale
                                        ; qu'on peut le reselectionner pour
                                        ; lui donner une nouvelle competence
                                        ; (construire plus haut, par exemple)
WAIT_STEPS      .equ    10              ; duree de la pause, en pas DE CE
                                        ; LEMMING (pas en tics bruts) : son
                                        ; propre pas revient tous les
                                        ; LEM_STEP_DELAY(16) tics a 50 Hz,
                                        ; soit ~0,32 s -- 10 pas font ~3,2 s,
                                        ; le "quelques secondes" demande.
                                        ; S'il n'est pas reselectionne d'ici
                                        ; la, il repart marcher tout seul.
; Proportions de l'escalier. L'original pose 12 marches de ~4 px de large
; et ~2 px de haut : 48 px d'avance pour 24 px de montee, soit 26,6 deg.
; Rapporte a nos tuiles de 8x10 px, cela fait 6 tuiles de large pour 2,4 de
; haut. Une premiere version montait d'une tuile a CHAQUE brique, soit 12
; tuiles de haut -- cinq fois trop raide.
; 6 briques avec une montee toutes les 3 donnent 48x20 px et 22,6 deg :
; la combinaison la plus proche de l'original sur les deux dimensions.
BUILD_STEPS     .equ    3               ; briques posees
BUILD_CLEARANCE .equ    4               ; BUILD_STEPS+1, EN DUR (a mettre a
                                        ; jour a la main si BUILD_STEPS
                                        ; change) : nombre de tuiles de
                                        ; marge exigees au-dessus du
                                        ; lemming avant d'accepter de le
                                        ; faire construire -- une de plus
                                        ; que la hauteur reelle de
                                        ; l'escalier, pour laisser la place
                                        ; au controle de plafond de sa
                                        ; toute derniere brique.
BUILD_TILE      .equ    1               ; tuile posee : "terre", solide et
                                        ; destructible (pas besoin d'un
                                        ; nouveau type dans EXELTILE)
KEY_BUILD       .equ    $43             ; 'C' : constructeur
KEY_BUILD_LC    .equ    $63

; --- tuiles POSEES ---------------------------------------------------------
; La couche de destruction ne stocke qu'un bit "creusee". Construire demande
; de memoriser l'inverse, et une seconde couche a 1 bit/case couterait 300
; octets alors qu'il n'en reste que ~240 en SRAM.
; Les constructions etant rares (12 par escalier), on tient donc une LISTE :
; 64 entrees de 2 octets = 128 octets, soit cinq escaliers complets.
; Elle est consultee UNE FOIS PAR RANGEE lors du remplissage de tile_row,
; pas une fois par case -- sinon le redessin complet couterait 40x plus.
; MAX_BUILT : d'abord reduit de 64 a 40 pour liberer la place du tableau
; build_tile (chaque entree "construite" a maintenant SA PROPRE tuile, pas
; toujours BUILD_TILE). Puis chaque marche s'est mise a consommer DEUX
; entrees, pas une : elle comble aussi la rangee du dessous pour rester
; soudee au terrain d'origine, meme irregulier (voir le comblement dans
; lst_build). Remonte a 48 (marge SRAM verifiee) : BUILD_STEPS=6 x 2
; entrees = 12 par escalier complet, soit 4 escaliers simultanes.
MAX_BUILT       .equ    48

; --- tuiles d'escalier, progressives -------------------------------------
; Un escalier reel a une contremarche basse puis de plus en plus haute,
; pas un bloc plein d'un coup. Trois "marches" couvrent une hauteur de
; tuile complete (10 px) :
;   TILE_MARCHEA (nommee dans EXELTILE) : 3 px pleins en bas
;   TILE_MARCHEB (nommee dans EXELTILE) : 7 px pleins en bas
;   (la 3e marche est BUILD_TILE lui-meme : entierement pleine)
; Ces index correspondent aux tuiles A DESSINER dans EXELTILE ; ajuster
; si vous les placez ailleurs dans votre lv_tiles.
; Les index des deux tuiles NE SONT PLUS ICI : TILE_MARCHEA et TILE_MARCHEB
; sont desormais exportes directement par EXELTILE (voir leveldata.asm),
; nommes d'apres le champ "Nom" de la tuile plutot que fixes en dur. Une
; tuile qui change de position (une autre ajoutee ou supprimee avant elle)
; ne desynchronise donc plus jamais le code : l'export les recalcule a
; chaque fois. C'est directement ce qui manquait la fois ou la suppression
; d'une tuile de test a decale marcheA/marcheB d'un cran sans que ces
; constantes, alors figees ici, ne le sachent.
STAIR_DELTA_A   .equ    5               ; px montes lors de la toute
                                        ; premiere marche (A) -- doit
                                        ; correspondre au seuil dessine
                                        ; pour marcheA dans EXELTILE
STAIR_DELTA_C   .equ    5               ; px montes par brique, a partir de
                                        ; la 2e (cycle B+C) -- doit
                                        ; correspondre au seuil de
                                        ; remplissage dessine pour marcheC
                                        ; dans EXELTILE (5 px par defaut).
                                        ; INDEPENDANT de STAIR_DELTA_A : B,
                                        ; qui suit A, est TOUJOURS pleine
                                        ; sur toute sa rangee, donc son
                                        ; appui ne depend pas du seuil
                                        ; exact utilise par A.

ST_BOOM         .equ    7               ; type 7 = "explose" : gerbe de
                                        ; pixels rouges, puis disparition.
                                        ; Se comporte comme ST_DEAD, mais
                                        ; avec sa propre animation.
; (duree de la gerbe : plus de constante BOOM_STEPS, c'est le nombre REEL de
; vignettes du type "explose" dans lemdata.asm -- voir lem_explode)
EXPLODE_R       .equ    1               ; rayon en tuiles (1 -> zone 3x3)
EXPLODE_STEPS   .equ    31              ; ~5 s : 31 pas de 160 ms, comme
                                        ; le compte a rebours d'origine
KEY_BOMB        .equ    $45             ; 'E' : amorce le compte a rebours
KEY_BOMB_LC     .equ    $65
MAX_FALL        .equ    60              ; chute fatale a partir de 60 lignes
                                        ; (6 tuiles). Les transitions d'ecran
                                        ; n'en font que 20 : sans danger.
DEATH_STEPS     .equ    6               ; pas avant disparition du corps
KEY_DIG         .equ    $44             ; 'D' : creuseur
KEY_DIG_LC      .equ    $64
KEY_BLOCK       .equ    $42             ; 'B' : bloqueur
KEY_BLOCK_LC    .equ    $62
KEY_FLOAT       .equ    $46             ; 'F' : parachutiste
KEY_FLOAT_LC    .equ    $66
KEY_BASH        .equ    $48             ; 'H' : frappeur (creuseur
KEY_BASH_LC     .equ    $68             ; horizontal)

; --- couche de destruction --------------------------------------------------
; Les cartes sont en ROM : impossible d'y effacer une tuile. On tient donc
; a cote, en RAM, UN BIT par case disant "cette case a ete creusee".
; 40x20 = 800 bits = 100 octets par ecran ; 3 ecrans = 300 octets, ce qui
; tient dans la SRAM libre. Une copie complete des cartes aurait demande
; 800 octets par ecran, soit bien trop.
DIG_BYTES_SCR   .equ    100             ; (LV_MAP_W*LV_MAP_H)/8, en dur
SPAWN_TICKS     .equ    200             ; 200 ticks de 10 ms = 2 secondes
                                        ; entre deux apparitions
; Delais exprimes en TICKS de 10 ms. Doubles en meme temps que l'horloge
; passait de 50 a 100 Hz, pour que le lemming garde EXACTEMENT le meme
; rythme : 16 ticks = 160 ms entre deux pas, comme avant.
LEM_STEP_DELAY  .equ    16

; ---------------------------------------------------------------------------
; HORLOGE MATERIELLE -- remplace l'ancienne boucle d'attente logicielle.
;
; Une attente logicielle mesure des INSTRUCTIONS, pas du temps : des qu'une
; image demande plus de travail (deplacer le viseur, par exemple), elle dure
; plus longtemps, et tout ce qui en depend ralentit. C'est ce qui faisait
; ralentir le lemming pendant les deplacements du viseur.
;
; Le timer du TMS7020 donne une vraie base de temps, independante du travail
; effectue. Periode : F = 307200 / ((PT+1) * (DT+1))  (doc EXL100, 3.3.2).
;   PT = 11, DT = 255  ->  307200 / (12*256) = 100,00 Hz, soit 10 ms pile.
; P3 = bit 7 (TIMER ENABLE) | predisviseur sur les bits 4..0 -> $80|11 = $8B.
; (PT = 23 donnait 50 Hz ; PT = 5 donnerait 200 Hz si besoin d'aller encore
; plus vite -- le viseur avance d'un pas par tick, sa vitesse suit donc
; directement cette frequence.)
;
; L'interruption passe par le vecteur systeme BRTIME ($C004) : le moniteur
; sauvegarde A et B, appelle la routine pointee, qui doit se terminer par un
; RETS et preserver elle-meme les autres registres qu'elle utilise
; (TMS7020_AND_EXL100, sections 1309 et 1543).
TIMER_DT        .equ    255             ; diviseur    (P2)
TIMER_P3        .equ    $8B             ; marche + predisviseur 11 (P3)

; Repetition automatique quand une touche reste enfoncee : un premier delai
; plus long (pour ne pas partir au quart de tour sur une pression breve),
; puis une cadence rapide. Meme principe que le DAS d'Exeltris.
KEY_RPT_FIRST   .equ    16              ; ticks avant la 1re repetition
                                        ; (160 ms, inchange)
KEY_RPT_NEXT    .equ    1               ; un pas par tick : le viseur avance
                                        ; desormais a 100 cases par seconde,
                                        ; soit 800 px/s dans les deux sens

; Valeurs reprises telles quelles d'Exeltris (eprouvees sur machine reelle),
; SAUF la fleche haut, jamais utilisee dans ce projet : $80 est une
; deduction par symetrie, A VERIFIER a l'usage.
KEY_ARR_LEFT    .equ    $83
KEY_ARR_RIGHT   .equ    $81
KEY_ARR_DOWN    .equ    $82
KEY_ARR_UP      .equ    $80             ; NON VERIFIE

KEY_REDRAW      .equ    $52             ; 'R' majuscule
KEY_REDRAW_LC   .equ    $72             ; 'r' minuscule -- les deux sont
                                        ; testees : on ne sait pas laquelle
                                        ; le clavier envoie selon l'etat de
                                        ; Verr.Maj., et un test sur la seule
                                        ; majuscule echouait silencieusement
KEY_SPACE       .equ    $20             ; ESPACE : attribue le pouvoir
                                        ; selectionne (n'est plus un secours
                                        ; de R, qui marche seul sur machine)
KEY_TAB         .equ    $09             ; TAB : pouvoir suivant (code tire de
                                        ; la KB clavier, a confirmer)

; --- panneau des pouvoirs (3 lignes texte du bas) ---------------------------
NUM_SKILLS      .equ    8               ; ordre : C D H B F E G M
ICON_FIRST      .equ    $61             ; icones des 7 premiers pouvoirs :
                                        ; $61..$7C ; le 8e (M) en $01..$04 :
                                        ; il n'y a que 31 codes libres apres
                                        ; la police. Voir icon_base.
ICON_FIRST_M    .equ    $01             ; icone du 8e pouvoir (M). 4 glyphes
                                        ; par icone : HG, HD, BG, BD
PNL_SEL_BG      .equ    $04             ; fond BLEU (bits 2-0 = B G R) du
                                        ; pouvoir selectionne
PNL_FG_ZERO     .equ    $20             ; libelle en ROUGE quand il n'en reste
                                        ; plus (bits 7-5 = B G R)
MOUSE_BTN1      .equ    $40             ; bit du bouton 1 (attribuer) dans
MOUSE_BTN2      .equ    $20             ; l'octet P49 : NON VERIFIE lequel est
                                        ; le gauche -- permuter ces deux
                                        ; valeurs si les boutons sont inverses

KEY_MOUSE       .equ    $53             ; 'S' majuscule : bascule la souris
KEY_MOUSE_LC    .equ    $73             ; 's' minuscule

; --- variables (SRAM) -------------------------------------------------------
tmp_a           .equ    $C400           ; ligne de balayage courante (0..199)
tmp_b           .equ    $C40C           ; 2e motif, dans cur_draw
tmp_c           .equ    $C40D           ; octet de fond relu, dans cd_getsave
; --- parcours de la carte de tuiles ----------------------------------------
cur_screen      .equ    $C40E           ; ecran affiche, 0..LV_NSCREENS-1
tline           .equ    $C40F           ; ligne DANS la tuile, 0..9
mrow_hi         .equ    $C410           ; debut de la rangee de tuiles
mrow_lo         .equ    $C411           ; courante, dans la carte
tb_hi           .equ    $C412           ; lv_tiles + tline*3 : adresse de la
tb_lo           .equ    $C413           ; bonne ligne dans CHAQUE tuile
tid             .equ    $C414           ; index de tuile lu dans la carte
; --- parametres de vram_line_addr (routine partagee) -----------------------
a_xseg          .equ    $C415           ; colonne, en segments de 8 px
a_yline         .equ    $C416           ; ligne de balayage absolue
; --- lemming ---------------------------------------------------------------
; ERREUR DE CONCEPTION CORRIGEE : lem_tick etait un compteur UNIQUE,
; commun a tous les lemmings. Consequence : toutes les LEM_STEP_DELAY
; lignes de tick, les DIX marchaient exactement au meme instant -- jamais
; etales dans le temps. Quand ils se trouvent tous sur l'ecran affiche,
; chacun declenche un redessin complet (~2.9 ms) plus l'effacement de sa
; trace (~1.6 ms) : jusqu'a ~45 ms d'un coup, toutes les 160 ms, alors
; qu'un seul tick ne vaut que 10 ms -- le jeu n'a plus le temps de
; rattraper son retard, d'ou le ralentissement observe (viseur ET
; lemmings, puisque les deux passent par le meme mecanisme de rattrapage).
; Un compteur INDEPENDANT par lemming etale naturellement leurs pas : le
; delai entre deux naissances (SPAWN_TICKS=200) et le rythme de marche
; (LEM_STEP_DELAY=16) ne sont pas multiples l'un de l'autre (200 mod 16
; = 8), donc des compteurs qui repartent chacun de zero a la naissance se
; decalent d'eux-memes, sans code special pour ca.
lem_tick        .equ    $C7B9           ; [NUM_LEM] rythme de marche,
                                        ; INDIVIDUEL
ll_ctr          .equ    $C41C           ; compteur de lignes du sprite
lp_hi           .equ    $C41D           ; pointeur courant dans les donnees
lp_lo           .equ    $C41E           ; de la vignette (lecture sequentielle)
lem_mask        .equ    $C41F           ; octet de masque du segment en cours
lem_spr         .equ    $C4C0           ; octet de plan du sprite
; Un lemming par indice : toutes ces variables sont des TABLEAUX de
; NUM_LEM octets, lus et ecrits via "lda @cur_lem / mov A,B / lda @tab(B)".
; cur_lem designe le lemming en cours de traitement.
cur_lem         .equ    $C4C1           ; indice du lemming traite
spawn_timer     .equ    $C4C2           ; ticks avant la prochaine apparition
spawn_next      .equ    $C4C9           ; indice du prochain a faire naitre
lem_xseg        .equ    $C520           ; [NUM_LEM] colonne, en segments
lem_y           .equ    $C52A           ; [NUM_LEM] ligne de balayage
lem_frame       .equ    $C534           ; [NUM_LEM] vignette courante
lem_screen      .equ    $C53E           ; [NUM_LEM] ecran ou il se trouve
lem_old_xseg    .equ    $C548           ; [NUM_LEM] position avant le pas
lem_alive       .equ    $C552           ; [NUM_LEM] 1 = deja apparu
lem_state       .equ    $C55C           ; [NUM_LEM] ST_WALK ou ST_FALL
lem_old_y       .equ    $C566           ; [NUM_LEM] ligne avant le pas
lem_dir         .equ    $C570           ; [NUM_LEM] 0 = vers la droite,
                                        ; 1 = vers la gauche
lem_float       .equ    $C6BB           ; [NUM_LEM] competences PERMANENTES :
                                        ; bit 0 = parachute (EQUIP_FLOAT),
                                        ; bit 1 = grimpeur (EQUIP_CLIMB).
                                        ; C'est un ATTRIBUT durable, pas un
                                        ; etat : le lemming marche et creuse
                                        ; normalement, le parachute ne sert
                                        ; qu'au moment des chutes.
tile_row        .equ    $C6D0           ; 40 octets : index de tuile resolu
                                        ; pour la rangee courante ($C6D0-F7)
lem_bomb        .equ    $C6F8           ; [NUM_LEM] compte a rebours du
                                        ; kamikaze ; 0 = non amorce
bx0             .equ    $C702           ; bornes de la zone detruite,
bx1             .equ    $C703           ; en tuiles
by0             .equ    $C704
by1             .equ    $C705
bw              .equ    $C708           ; largeur et hauteur de la zone,
bh              .equ    $C709           ; en tuiles
bcol            .equ    $C706           ; parcours de cette zone
brow            .equ    $C707
bcol_n          .equ    $C70A           ; compteurs de parcours
brow_n          .equ    $C70B
bomb_bar        .equ    $C70C           ; barre de compte a rebours dessinee
                                        ; sur la ligne 0 du sprite ; 0 si le
                                        ; lemming n'est pas amorce
lem_build       .equ    $C79E           ; [NUM_LEM] briques restantes
                                        ; derniere montee
; liste des tuiles posees : cle = ecran*LV_MAP_H + rangee, plus la colonne
build_key       .equ    $C70D           ; [MAX_BUILT] (48) $C70D-$C73C
build_col       .equ    $C73D           ; [MAX_BUILT] (48) $C73D-$C76C
build_tile      .equ    $C76D           ; [MAX_BUILT] (48) QUELLE tuile
                                        ; par entree : $C76D-$C79C. Avant,
                                        ; une case "construite" valait
                                        ; toujours BUILD_TILE ; les marches
                                        ; d'escalier ont chacune leur propre
                                        ; tuile (A, B, pleine), il faut donc
                                        ; s'en souvenir au lieu de la deduire.
build_n         .equ    $C79D           ; nombre d'entrees utilisees
bkey            .equ    $C7A8           ; cle recherchee, variable de travail
bidx            .equ    $C7A9           ; index de parcours de la liste
any_stepped     .equ    $C7CE           ; 1 si au moins un lemming a
                                        ; reellement bouge ce passage --
                                        ; evite de redessiner le viseur en
                                        ; pure perte quand personne n'a
                                        ; encore atteint son tour
rtc_scr         .equ    $C7D3           ; ecran memorise (fait partie de la
                                        ; cle : voir rect_tileptr)
sf_ovh          .equ    $C511           ; surface_find : bas d'un surplomb
                                        ; trouve au-dessus d'une base vide
bt_arg          .equ    $C510           ; (deplace de $C7DE : place du 8e
                                        ; compteur de pouvoir)           ; tuile a memoriser, passee a
                                        ; built_add (voir sa note)
bt_found        .equ    $C7DF           ; index trouve par built_test --
                                        ; l'appelant lit build_tile(bt_found)
tmp_d           .equ    $C7E0           ; scratch, lst_build (escalier)
tmp_g           .equ    $C7E1           ; scratch, lst_build : rangee de
                                        ; tuiles ciblee (B), sauvegardee
                                        ; avant qu'un appel ne l'ecrase
saved_count     .equ    $C7E2           ; nombre de lemmings sauves (a la
                                        ; sortie) depuis le debut du niveau

; --- souris ExelMouse, protocole P49/P50 autonome (sans dependance ROM,
; comme dans exelnoid) : mouse_enabled bascule avec S, conserve entre les
; niveaux. mouse_btn_old est l'octet BRUT lu au port P49 lors de la passe 1
; (boutons dans les bits 6-5) ; mouse_btn_latch empeche un bouton maintenu
; d'agir a chaque tick (detection de FRONT, pas de niveau).
mouse_enabled   .equ    $C7E3
mouse_dy        .equ    $C7E4           ; delta Y signe (delta X reutilise
                                        ; TEMP1, comme dans exelnoid)
mouse_btn_old   .equ    $C7E5
mouse_btn_latch .equ    $C7E6

; --- deplacement du viseur "au temps reel" (voir cur_move_n) ---------------
pass_ticks      .equ    $C7E7           ; ticks consommes depuis le debut de
                                        ; ce passage dans main_loop
cur_nx          .equ    $C7E8           ; position VISEE, calculee avant de
cur_ny          .equ    $C7E9           ; toucher a l'ecran (cur_commit)
cur_steps       .equ    $C7EA           ; nombre de pas a faire
cur_bdir        .equ    $C7EB           ; 0=gauche 1=droite 2=haut 3=bas

; --- filtre rapide de built_test : 1 bit par rangee (cle = ecran*20 +
; rangee, 0..99), pose a chaque built_add, efface seulement au demarrage.
; Les entrees de la liste ne sont jamais retirees (une brique creusee garde
; son entree, tuile 0), donc un bit a 0 garantit qu'AUCUNE tuile posee
; n'existe dans cette rangee : on evite le parcours complet de la liste.
cur_pending     .equ    $C7F9           ; 1 = un deplacement du viseur est
                                        ; demande (cur_nx/cur_ny), a appliquer
                                        ; a ml_next
skill_sel       .equ    $C7FA           ; pouvoir selectionne (0..5)
give_ok         .equ    $C7FB           ; 1 = la derniere attribution a reussi
spawn_count     .equ    $C7FD           ; lemmings deja sortis (0..LV_LEM_COUNT)
level_over      .equ    $C7FE           ; 1 = niveau termine (GAGNE / PERDU)
mouse_act       .equ    $C7FC           ; appuis de boutons a traiter
                                        ; (MOUSE_BTN1 / MOUSE_BTN2)
built_rows      .equ    $C7EC           ; 13 octets : $C7EC..$C7F8 (cle max
                                        ; 4*20+19 = 99 avec 5 ecrans EXELTILE)
rtc_valid       .equ    $C7CF           ; cache de rect_tileptr : 0 = vide
rtc_col         .equ    $C7D0           ; colonne memorisee
rtc_row         .equ    $C7D1           ; rangee memorisee
rtc_tid         .equ    $C7D2           ; index de tuile resolu
tk_i            .equ    $C7CD           ; index de parcours des rythmes
sf_ctr          .equ    $C7B8           ; compteur des boucles de sondage --
                                        ; PAS TEMP5 : built_test l'utilise
                                        ; aussi comme compteur (parcours de
                                        ; sa propre liste), et l'appelle
                                        ; depuis PIX_SOLID a chaque tour de
                                        ; ces boucles. TEMP5 se faisait donc
                                        ; ecraser silencieusement a chaque
                                        ; iteration -- le nombre reel de
                                        ; tours dependait de build_n (le
                                        ; nombre de briques deja posees), pas
                                        ; de MAX_STEP_UP/DOWN. Explique
                                        ; exactement le profil observe : la
                                        ; marche 1 passait par chance (peu
                                        ; d'entrees dans la liste a ce
                                        ; moment), la marche 2 echouait
                                        ; (plus d'entrees, plus de
                                        ; corruption).
; --- niveau courant (plusieurs niveaux, plusieurs jeux de tuiles "themes") :
; valeurs copiees depuis les tables de leveldata.asm par level_load, au
; debut de chaque niveau. Deux trous libres de la SRAM : $C7AA-$C7B3 et
; $C7D4-$C7DD (ancien lem_cyc_y, supprime).
cur_level       .equ    $C7AA           ; 0..LV_NLEVELS-1, garde d'un niveau
                                        ; a l'autre (seul le demarrage a
                                        ; froid le remet a 0)
tiles_lo        .equ    $C7AB           ; adresse des tuiles du THEME du
tiles_hi        .equ    $C7AC           ; niveau (ex-constante lv_tiles)
flags_lo        .equ    $C7AD           ; adresse de leurs proprietes
flags_hi        .equ    $C7AE           ; (ex-constante lv_flags)
cur_map_base    .equ    $C7AF           ; cur_level*3 : index de son premier
                                        ; ecran dans lv_map_hi/lo
cur_nscr        .equ    $C7B0           ; nombre d'ecrans du niveau (1..3)
cur_lem_count   .equ    $C7B1           ; lemmings a faire sortir
cur_to_save     .equ    $C7B2           ; lemmings a sauver
cur_spawn_scr   .equ    $C7B3           ; point de depart : ecran,
cur_spawn_col   .equ    $C7D4           ; colonne (segments),
cur_spawn_y     .equ    $C7D5           ; ligne de balayage
level_won       .equ    $C7D6           ; 1 = GAGNE (Espace -> niveau suivant)
skill_cnt       .equ    $C7D7           ; 8 octets ($C7D7-$C7DE) : pouvoirs
                                        ; restants, dans l'ordre du panneau
                                        ; (C D H B F E G M)
build_up        .equ    $C7B4           ; 1 = la brique en cours fait monter
sf_base         .equ    $C7B5           ; ligne de depart du sondage
sf_s            .equ    $C7B6           ; ligne courante du sondage
sf_y            .equ    $C7B7           ; lem_y resultant
drow_hi         .equ    $C6C9           ; pointeur sur les 5 octets de bits
drow_lo         .equ    $C6CA           ; creuses de la rangee courante
dig_cur         .equ    $C6CB           ; octet de bits en cours de lecture
dig_bit         .equ    $C6CC           ; masque du bit de la colonne
new_col         .equ    $C6C8           ; colonne d'arrivee apres transition
new_scr         .equ    $C6C7           ; ecran vise lors d'une transition.
                                        ; PAS tmp_c : rect_mapptr s'en sert,
                                        ; et l'effacement de l'ancienne
                                        ; position passe par elle -- le
                                        ; numero d'ecran etait ecrase en
                                        ; cours de route.
spr_mirror      .equ    $C6C6           ; 1 = dessiner le sprite en miroir
fall_step       .equ    $C6C5           ; hauteur du pas de descente courant
                                        ; (FALL_STEP ou FLOAT_STEP)
blk_col         .equ    $C6B6           ; colonne testee par blocker_at
blk_self        .equ    $C6B7           ; le marcheur qui pose la question
blk_scr         .equ    $C6B8           ; son ecran et sa ligne, pour le
blk_y           .equ    $C6B9           ; test de recouvrement vertical
blk_i           .equ    $C6BA           ; index de parcours
lem_fall        .equ    $C6AC           ; [NUM_LEM] lignes deja parcourues
                                        ; dans la chute en cours, puis
                                        ; compte a rebours apres la mort
dig_map         .equ    $C580           ; 3 x 100 octets : 1 bit par case
d_col           .equ    $C4CB           ; colonne interrogee par dig_locate
dig_mask        .equ    $C4CE           ; masque du bit dans son octet
sel_lem         .equ    $C4CF           ; lemming designe par le viseur,
                                        ; $FF si aucun
; --- rectangle de fond a regenerer depuis la carte -------------------------
r_xseg          .equ    $C4C3
r_wseg          .equ    $C4C4
r_yline         .equ    $C4C5
r_hlines        .equ    $C4C6
q_row           .equ    $C4C7           ; rangee de tuiles correspondant a
q_line          .equ    $C4C8           ; r_yline, et ligne dans la tuile
map_screen      .equ    $C4CA           ; ecran dont on consulte la carte
; Fond regenere sous le lemming, AVANT composition : 2 segments x 3 plans
; x 10 lignes = 60 octets. Ce n'est plus une copie de l'ecran (qui pouvait
; contenir un autre sprite) mais le decor recalcule depuis la carte.
LEM_BG_SIZE     .equ    60
lem_bg          .equ    $C4D0
; ($C510-$C515 : libres -- ancien skill_cnt, deplace en $C7D7 a l'ajout du
; 7e pouvoir, le grimpeur)
key_rpt         .equ    $C516           ; images restantes avant repetition
rpt_flag        .equ    $C517           ; 1 = l'action courante vient d'une
                                        ; repetition, pas d'un nouvel appui
tick_cnt        .equ    $C518           ; incremente par l'interruption timer
tick_seen       .equ    $C519           ; derniere valeur traitee par la
                                        ; boucle principale
lem_pending     .equ    $C7C3           ; [NUM_LEM] 1 = pas du POUR CE
                                        ; lemming precisement (plus un
                                        ; drapeau global commun)
spawn_pending   .equ    $C51B           ; 1 = une naissance est due
cur_xseg        .equ    $C406           ; position du viseur, en segments
cur_y           .equ    $C407           ; et en lignes de balayage
cur_dirty       .equ    $C408           ; 1 = une sauvegarde est valide
; Sauvegarde des pixels REELS sous le viseur : 16 lignes x 2 segments x 3
; plans = 96 octets. C'est tout l'interet du bitmap ici -- on se SOUVIENT
; de ce qui etait la, au lieu de le reconstruire logiquement comme il a
; fallu le faire en mode texte (get_cell_char dans lemproto.asm).
CUR_SAVE_SIZE   .equ    96
cur_save        .equ    $C420

key_cur         .equ    $C402
key_last        .equ    $C403

        .org    $1000

; ============================================================================
; INITIALISATION
; ============================================================================
start:
        ; --- demarrage A FROID seulement : premier niveau, souris eteinte.
        ; Tout le reste est refait a chaque niveau (level_start), y compris
        ; l'initialisation du VDP : c'est la facon la plus sure de repartir
        ; d'un etat propre.
        dint
        mov     %$58,B
        ldsp
        clr     A
        sta     @cur_level
        sta     @mouse_enabled          ; la souris reste active d'un niveau
                                        ; a l'autre une fois allumee (S)
level_start:
        dint
        mov     %$58,B
        ldsp
        movp    P40,A
        movp    P36,A
        call    @init_vdp               ; reprise mixt_api : eprouvee tout
        eint                            ; au long de ce projet

        movd    %$0000,TEMP8
        trap    13                      ; police ROM en BAGC0 -- non
                                        ; utilisee pour l'affichage ici,
                                        ; l'appel reste necessaire (meme
                                        ; raison que dans Exeltris/lemproto)

        ; --- CM1/CM2/CM4 : repris tels quels de vdpInitDefault (vdp.asm),
        ; valeurs eprouvees, pas les notres -- seul CM3 (SCRMODE) change
        ; ci-dessous pour activer le mode mixte au lieu du texte pur.
        movp    %TIMEBASE,P45
        movp    %CM1MASK,P45
        movp    %DECODER,P45
        movp    %CM2MASK|LINEZERO|BAGC3_MOSAIC,P45 ; DC5=1 : BAGC3 mosaique
        movp    %SCRMODE,P45
        movp    %CM3MASK|MIXTMODE,P45   ; SEULE difference avec vdpInitDefault
        movp    %BORDER,P45
        movp    %CM4MASK|MBLACK,P45

        ; --- BAGC3 -> FONT_BAGC3 (registre de base REGBAGC3 = $0E), puis
        ; chargement de NOTRE police par trap 19. Meme sequence qu'Exeltris
        ; (COL/ROW = adresse-2, registre, deux octets 0), validee sur
        ; machine reelle. trap 19 : TEMP3 = source, TEMP2 = base VRAM du
        ; generateur, TEMP7 = premier code, TEMP4-1 = nombre de glyphes ;
        ; 10 octets par glyphe, le premier = ligne du BAS.
        movp    %COL,P45
        movp    %FONT_BAGC3_M2&$FF,P45
        movp    %ROW,P45
        movp    %FONT_BAGC3_M2>>8,P45
        movp    %$0E,P45                ; registre REGBAGC3 (14), en dur comme
                                        ; dans Exeltris (3556.equ non verifie)
        movp    %0,P45
        movp    %0,P45

        movd    %font_chr,TEMP3         ; codes $20..$60 : espace (vide),
        movd    %FONT_BAGC3,TEMP2       ; ponctuation, chiffres, majuscules,
        mov     %$20,TEMP7              ; puis CH_BLANK ($60, vide)
        mov     %65,TEMP4-1
        trap    19
        movd    %font_chr,TEMP3         ; code $00 : vide aussi (build_mixed_page
        movd    %FONT_BAGC3,TEMP2       ; et l'API remplissent avec $00 --
        clr     A                       ; ecrit desormais CH_BLANK, mais par
        mov     A,TEMP7                 ; surete)
        mov     %1,TEMP4-1
        trap    19
        movd    %icon_chr,TEMP3         ; icones du panneau des pouvoirs :
        movd    %FONT_BAGC3,TEMP2       ; 28 glyphes a partir de ICON_FIRST
        mov     %ICON_FIRST,TEMP7
        mov     %28,TEMP4-1
        trap    19
        movd    %icon_chr+280,TEMP3     ; icone du 8e pouvoir (M), 4 glyphes,
        movd    %FONT_BAGC3,TEMP2       ; codes $01..$04
        mov     %ICON_FIRST_M,TEMP7
        mov     %4,TEMP4-1
        trap    19

        ; --- BAPA = SCREEN_BASE : le VDP affiche desormais NOTRE page,
        ; plus celle de mixt_api. BAPA charge COL/ROW+1 (vdp.asm) : on
        ; ecrit donc SCREEN_BASE-1, precalcule en dur (SCREEN_BASE_M1) --
        ; pas de calcul de retenue a l'execution pour une constante fixe.
        mov     %SCREEN_BASE_M1>>8,A
        mov     %SCREEN_BASE_M1&$FF,B
        movp    %COL,P45
        movp    B,P45
        movp    %ROW,P45
        movp    A,P45
        movp    %REGBAPA,P45
        movp    %0,P45
        movp    %0,P45

        ; ORDRE IMPORTANT : cur_screen doit etre pose AVANT draw_all_tiles,
        ; qui s'en sert desormais pour choisir la carte (lv_map_hi/lo). Une
        ; premiere version l'initialisait apres : le tout premier dessin
        ; partait donc d'un numero d'ecran residuel, lisait la table hors
        ; limites et dessinait depuis des donnees arbitraires.
        clr     A
        sta     @cur_dirty              ; aucune sauvegarde valide au depart
        sta     @rtc_valid              ; cache de rect_tileptr vide AVANT
                                        ; tout dessin : sinon il garderait
                                        ; une tuile du niveau precedent (ou
                                        ; du hasard, au demarrage a froid)
        mov     VALUE0,A                ; touche tenue en ce moment (Espace
        sta     @key_last               ; qui vient de lancer ce niveau) :
                                        ; vue comme une REPETITION, ignoree
        mov     %KEY_RPT_FIRST,A
        sta     @key_rpt

        mov     %13,B                   ; filtre de built_test : aucune
br_clr:                                 ; rangee n'a de tuile posee
        clr     A
        sta     @built_rows-1(B)
        djnz    B,@br_clr
        clr     A                       ; liste des tuiles posees : vide.
        sta     @build_n                ; SANS cette remise a zero, elle
                                        ; contiendrait un nombre d'entrees
                                        ; residuel et le decor afficherait
                                        ; des briques au hasard.
        clr     A
        sta     @saved_count            ; aucun lemming sauve au demarrage
        sta     @mouse_act
        sta     @pass_ticks
        sta     @cur_pending
        sta     @skill_sel              ; premier pouvoir selectionne
        sta     @spawn_count            ; personne n'est encore sorti
        sta     @level_over
        sta     @level_won
        mov     %$60,A                  ; boutons de la souris consideres
        sta     @mouse_btn_latch        ; deja enfonces : celui qui a lance
                                        ; ce niveau ne compte pas
        call    @level_load             ; tuiles, cartes, parametres du niveau
        lda     @cur_spawn_scr          ; on demarre sur l'ecran d'arrivee
        sta     @cur_screen             ; des lemmings
        lda     @cur_level              ; pouvoirs disponibles : ceux du
        rl      A                       ; niveau, lv_lvl_skills[niveau*8..]
        rl      A                       ; (niveau <= 31 : 8 x niveau tient
        rl      A                       ; dans un octet, rien ne deborde)
        mov     A,TEMP5
        mov     %NUM_SKILLS,TEMP6
sk_init:
        mov     TEMP5,A
        add     TEMP6,A
        mov     A,B
        lda     @lv_lvl_skills-1(B)
        mov     TEMP6,B
        sta     @skill_cnt-1(B)
        djnz    TEMP6,@sk_init
        call    @dig_clear_all          ; aucune case creusee au depart --
                                        ; AVANT le premier dessin, qui
                                        ; consulte deja cette couche : sans
                                        ; cela, des trous apparaitraient au
                                        ; hasard dans le decor
        call    @build_mixed_page       ; remplit TOUT le contenu VRAM de
        call    @draw_all_tiles         ; la page, puis le decor
        call    @draw_texts             ; puis les lignes de texte

        mov     %19,A                   ; viseur au centre de la zone bitmap
        sta     @cur_xseg
        mov     %92,A
        sta     @cur_y
        ; --- lemmings : aucun n'est encore apparu. On vide les NUM_LEM
        ; entrees de lem_alive ; le reste des tableaux sera rempli par
        ; lem_spawn au moment de chaque naissance.
        clr     A
        sta     @cur_lem
        sta     @spawn_next
        mov     %NUM_LEM,B
li_clear:
        clr     A
        dec     B
        sta     @lem_alive(B)
        mov     B,A
        jne     @li_clear

        call    @lem_spawn              ; le premier sort tout de suite
        mov     %SPAWN_TICKS,A
        sta     @spawn_timer
        call    @cur_draw               ; viseur toujours en dernier

        ; --- horloge : on installe le vecteur AVANT de lancer le timer,
        ; sinon une interruption pourrait survenir alors que BRTIME pointe
        ; encore sur une adresse residuelle.
        clr     A
        sta     @rtc_valid              ; cache de tuile vide au depart
        sta     @tick_cnt
        sta     @tick_seen
        sta     @spawn_pending
        mov     %NUM_LEM,TEMP5          ; les 10 compteurs et drapeaux a
        clr     A                       ; zero -- aucun n'est en avance sur
        mov     A,B                     ; les autres au demarrage
init_ticks:
        clr     A
        sta     @lem_tick(B)
        sta     @lem_pending(B)
        inc     B
        djnz    TEMP5,@init_ticks
        mov     %tick_isr>>8,A
        sta     @BRTIME
        mov     %tick_isr&$FF,A
        sta     @BRTIME+1
        movp    %TIMER_DT,P2            ; diviseur
        movp    %TIMER_P3,P3            ; marche + predisviseur
        eint
                                        ; qu'au premier deplacement

; ============================================================================
; BOUCLE : une seule touche testee, R, pour redessiner tout le decor et
; observer la vitesse a l'oeil (ou au chronometre, sur machine reelle).
; ============================================================================
main_loop:
        ; --- attend le PROCHAIN tick de l'horloge materielle.
        ; Le temps ecoule ne depend plus du travail effectue : si une image
        ; a demande beaucoup de dessin, l'attente est simplement plus
        ; courte, et la cadence reste la meme. C'est ce qui empeche le
        ; lemming de ralentir quand on deplace le viseur.
ml_wait:
        lda     @tick_cnt
        cmpa    @tick_seen
        jeq     @ml_wait                ; rien de nouveau : on patiente

        ; --- souris : lue ICI, UNE SEULE FOIS par passage reel dans
        ; main_loop -- surtout PAS depuis mc_key, qui est ré-exécuté à
        ; chaque tour de la boucle de rattrapage ci-dessous. Le protocole
        ; P49/P50 (voir read_mouse) coute plusieurs ticks a lui seul ; le
        ; appeler depuis mc_key faisait avancer tick_cnt PENDANT le
        ; rattrapage lui-meme, qui ne finissait donc jamais -- lem_step_all
        ; (dans la section "rendu" plus bas) n'etait plus jamais atteint
        ; tant que la souris bougeait : les lemmings restaient figes.
        ; Ici, le cout est paye UNE fois par passage, puis absorbe comme
        ; n'importe quel autre tick ecoule -- rien n'est perdu, exactement
        ; le principe deja explique ci-dessous pour le viseur au clavier.
        lda     @mouse_enabled
        jeq     @ml_consume
        call    @check_mouse

        ; --- On consomme les ticks ecoules UN PAR UN, et cette boucle ne
        ; dessine rien : elle ne fait qu'avancer des compteurs.
        ; L'ancienne version recopiait tick_cnt dans tick_seen d'un seul
        ; coup ; si un deplacement du viseur avait dure trois ticks, deux
        ; etaient purement PERDUS et le lemming ne comptait qu'un pas --
        ; d'ou le ralentissement. Ici rien ne se perd : le temps de jeu
        ; suit le temps reel, quel que soit le cout du dessin.
ml_consume:
        lda     @tick_seen
        inc     A
        sta     @tick_seen
        lda     @pass_ticks             ; duree de CE passage, en ticks :
        inc     A                       ; sert a faire avancer le viseur au
        sta     @pass_ticks             ; rythme du temps reel (cur_arrow_steps)

        ; Chaque lemming a SON PROPRE compteur (voir la note a la
        ; declaration de lem_tick) : celui qui atteint LEM_STEP_DELAY est
        ; marque pending, les autres continuent d'accumuler sans etre
        ; concernes -- c'est ce qui les etale dans le temps.
        clr     A
        sta     @tk_i
tk_loop:
        lda     @tk_i
        mov     A,B
        lda     @lem_tick(B)
        inc     A
        cmp     %LEM_STEP_DELAY,A
        jne     @tk_no
        clr     A
        sta     @lem_tick(B)
        mov     %1,A
        sta     @lem_pending(B)         ; son pas sera fait apres la boucle
        br      @tk_next
tk_no:
        sta     @lem_tick(B)
tk_next:
        lda     @tk_i
        inc     A
        sta     @tk_i
        cmp     %NUM_LEM,A
        jne     @tk_loop
mc_spawn:
        lda     @spawn_timer            ; naissance d'un lemming toutes les
        jeq     @mc_key                 ; SPAWN_TICKS (2 s)
        dec     A
        sta     @spawn_timer
        jne     @mc_key
        mov     %1,A
        sta     @spawn_pending          ; a traiter apres la boucle, comme
        mov     %SPAWN_TICKS,A          ; le pas de marche : la boucle de
        sta     @spawn_timer            ; ticks ne dessine jamais
mc_key:
        lda     @key_rpt                ; le delai de repetition clavier se
        jeq     @mc_next                ; decompte lui aussi en temps reel
        dec     A
        sta     @key_rpt
mc_next:
        lda     @tick_cnt
        cmpa    @tick_seen
        jne     @ml_consume             ; encore du retard : on rattrape

        ; --- rendu : une seule fois, meme si plusieurs ticks ont ete
        ; consommes. Un lemming en retard ne fait pas plusieurs pas d'un
        ; coup : il avance d'un cran par passage, mais son horloge, elle,
        ; n'a rien perdu.
        lda     @spawn_pending
        jeq     @mr_step
        clr     A
        sta     @spawn_pending
        call    @lem_spawn
mr_step:
        lda     @mouse_act              ; boutons de la souris : traites ici,
        jeq     @ml_key                 ; comme une touche
        call    @mouse_actions
        ; Le pas des lemmings (lem_step_all) n'est plus fait ICI mais a
        ; ml_next, APRES le clavier : voir la note a cet endroit.
ml_key:
        mov     VALUE0,A
        sta     @key_cur
        cmpa    @key_last
        jne     @ml_newkey              ; touche differente : on agit tout
                                        ; de suite
        ; Meme touche que l'image precedente : on ne rejoue l'action que
        ; lorsque le compteur de repetition arrive a zero. C'est ce qui
        ; permet de GARDER la touche enfoncee.
        lda     @key_rpt                ; decompte par la boucle de ticks
        jeq     @ml_rpt_now             ; ci-dessus, plus ici
        br      @ml_next
ml_rpt_now:
        mov     %KEY_RPT_NEXT,A
        sta     @key_rpt
        mov     %1,A
        sta     @rpt_flag
        br      @ml_edge
ml_newkey:
        mov     %KEY_RPT_FIRST,A
        sta     @key_rpt
        clr     A
        sta     @rpt_flag
ml_edge:
        lda     @key_cur

        ; --- deplacement du viseur. Un seul chemin pour les 4 fleches :
        ; direction dans cur_bdir, nombre de pas selon le temps ecoule
        ; (cur_arrow_steps), position visee calculee SANS toucher a l'ecran,
        ; puis UN effacement a l'ancienne position (cur_commit). Le dessin a
        ; la nouvelle position est differe a ml_next, apres le pas des
        ; lemmings : il n'est donc fait qu'UNE fois par passage (voir la note
        ; a ml_next).
        cmp     %KEY_ARR_LEFT,A
        jne     @ml_chk_right
        clr     A                       ; 0 = gauche
        br      @ml_arrow
ml_chk_right:
        cmp     %KEY_ARR_RIGHT,A
        jne     @ml_chk_up
        mov     %1,A                    ; 1 = droite
        br      @ml_arrow
ml_chk_up:
        cmp     %KEY_ARR_UP,A
        jne     @ml_chk_down
        mov     %2,A                    ; 2 = haut
        br      @ml_arrow
ml_chk_down:
        cmp     %KEY_ARR_DOWN,A
        jne     @ml_chk_dig
        mov     %3,A                    ; 3 = bas
ml_arrow:
        sta     @cur_bdir
        call    @cur_arrow_steps
        call    @cur_move_init
        call    @cur_move_n
        call    @cur_commit
        br      @ml_next

ml_chk_dig:
        ; --- touches de pouvoir (C D H B F E), cherchees dans skill_key_uc/lc,
        ; dans l'ordre du panneau. Une touche directe SELECTIONNE le pouvoir
        ; (surbrillance) ET l'attribue aussitot au lemming sous le viseur,
        ; comme avant. Pas de repetition : maintenir la touche redesignerait
        ; un lemming a chaque tick. cmpa ne touche pas A : la touche reste
        ; disponible pour les tests suivants.
        mov     %NUM_SKILLS,B
mcs_loop:
        cmpa    @skill_key_uc-1(B)
        jeq     @mcs_hit
        cmpa    @skill_key_lc-1(B)
        jeq     @mcs_hit
        djnz    B,@mcs_loop
        br      @ml_chk_tab
mcs_hit:
        lda     @rpt_flag
        jeq     @mcs_go
        br      @ml_next
mcs_go:
        dec     B                       ; index 0..5
        mov     B,A
        call    @skill_select
        call    @skill_use
        br      @ml_next

ml_chk_tab:
        ; TAB : pouvoir suivant (surbrillance seulement), sans repetition
        cmp     %KEY_TAB,A
        jne     @ml_chk_space
        lda     @rpt_flag
        jeq     @mtab_go
        br      @ml_next
mtab_go:
        call    @skill_next
        br      @ml_next

ml_chk_space:
        ; ESPACE : attribue le pouvoir selectionne au lemming sous le viseur
        cmp     %KEY_SPACE,A
        jne     @ml_chk_mouse
        lda     @rpt_flag
        jeq     @mspc_go
        br      @ml_next
mspc_go:
        lda     @level_over             ; niveau fini : Espace -> niveau
        jeq     @mspc_use               ; suivant (GAGNE) ou le meme (PERDU)
        br      @level_next
mspc_use:
        call    @skill_use
        br      @ml_next

ml_chk_mouse:
        ; S : bascule la souris (comme dans exelnoid). Pas de repetition --
        ; maintenir la touche ne doit pas allumer/eteindre a chaque tick.
        cmp     %KEY_MOUSE,A
        jeq     @ml_mouse_rpt
        cmp     %KEY_MOUSE_LC,A
        jne     @ml_chk_r
ml_mouse_rpt:
        lda     @rpt_flag
        jne     @ml_next
        lda     @mouse_enabled
        xor     %1,A
        sta     @mouse_enabled
        br      @ml_next

ml_chk_r:
        lda     @key_cur
        ; R (ou espace) : passe a l'ecran SUIVANT de la carte et le redessine
        ; entierement. Remplace l'ancien basculement de couleurs, qui n'a
        ; plus lieu d'etre maintenant que le decor vient de la carte : le
        ; changement d'ecran est a la fois visible et representatif du cas
        ; reel qu'on veut chronometrer.
        cmp     %KEY_REDRAW,A
        jeq     @ml_chk_rpt
        cmp     %KEY_REDRAW_LC,A
        jne     @ml_next                ; (Espace ne sert plus ici)
ml_chk_rpt:
        ; le changement d'ecran ne se repete pas : maintenir la touche
        ; ferait defiler les ecrans sans qu'on puisse s'arreter
        lda     @rpt_flag
        jeq     @ml_redraw
        br      @ml_next
ml_redraw:
        lda     @cur_screen
        inc     A
        cmpa    @cur_nscr               ; ecrans de CE niveau
        jnc     @ml_scr_ok              ; jnc : encore dans la carte
        clr     A                       ; sinon on revient au premier ecran
ml_scr_ok:
        sta     @cur_screen
        call    @draw_all_tiles
        ; Le decor entier vient d'etre redessine : il a donc efface le
        ; lemming et le viseur. On les remet, dans l'ordre voulu.
        ; cur_dirty repasse a 0 : il n'y a plus de viseur a effacer a
        ; l'ancienne position, elle a disparu avec le decor.
        clr     A
        sta     @cur_dirty
        call    @lem_draw_all
ml_cur_redraw:
        call    @cur_draw               ; le viseur toujours en dernier
ml_next:
        ; --- pas des lemmings, PUIS viseur -- dans cet ordre, et une seule
        ; fois. Avant, lem_step_all passait AVANT le clavier : il
        ; redessinait le viseur, que la fleche effacait aussitot pour le
        ; deplacer -- un cur_draw complet (16 lignes lues et reecrites)
        ; jete a chaque pas de viseur ou un lemming bougeait aussi, c'est-
        ; a-dire presque tout le temps avec du monde a l'ecran.
        ; Desormais une fleche (ou la souris) ne fait qu'EFFACER le viseur a
        ; l'ancienne position ; lem_step_all le redessine a la nouvelle s'il
        ; a fait marcher quelqu'un, sinon on le redessine ci-dessous.
        ; lem_step_all ne fait vraiment marcher que les lemmings dont le
        ; compteur individuel vient d'atteindre LEM_STEP_DELAY -- la boucle
        ; de verification reste bon marche meme quand personne n'est du.
        call    @lem_step_all           ; ne dessine plus le viseur
        call    @level_check            ; tout le monde sorti et plus
                                        ; personne en jeu : GAGNE / PERDU
        lda     @cur_pending            ; deplacement demande (souris ou
        jeq     @ml_nx_chk              ; fleche) : on l'applique MAINTENANT,
        clr     A                       ; juste avant de redessiner -- le
        sta     @cur_pending            ; viseur n'est invisible que le temps
        call    @cur_apply              ; de cet effacement
ml_nx_chk:
        lda     @cur_dirty              ; efface (deplacement, ou redessin
        jeq     @ml_nx_draw             ; d'ecran) : a redessiner
        lda     @any_stepped            ; pas efface, mais des lemmings ont pu
        jeq     @ml_next2               ; passer par-dessus : a remettre
ml_nx_draw:
        call    @cur_draw
ml_next2:
        clr     A
        sta     @pass_ticks             ; un nouveau passage commence
        lda     @key_cur
        sta     @key_last
        br      @main_loop

halt:
        dint
        br      @halt

; ============================================================================
; SOURIS EXELMOUSE -- lecteur autonome, protocole P49/P50 en 4 passes,
; repris d'exelnoid (memes ports, meme sequence) : AUCUNE dependance a une
; routine ROM, donc valable sur EXL100 comme sur EXELTEL (contrairement a
; une premiere tentative via $F03A, qui n'existe que sur EXELTEL et
; planterait ici). Voir la documentation du projet exelnoid pour le detail
; du protocole materiel.
;
; Different d'exelnoid sur un point : la ou la raquette d'Exelnoid ne bouge
; qu'horizontalement (delta Y ignore), le viseur de ce jeu bouge dans les
; DEUX sens -- delta Y conserve ici (mouse_dy), pas simplement lu et jete.
;
; check_mouse ne fait PAS de boutons une action de jeu pour l'instant :
; aucune competence unique ne correspond a un simple clic dans cette
; interface (les competences restent assignees au clavier, C/D/B/F/H/E).
; Le clic est neanmoins detecte (front, pas niveau) si besoin plus tard.
; ============================================================================
read_mouse:
        push    A
        push    B

        ; --- passe 1 : nibble haut du delta X, + boutons dans l'octet brut
        movp    %$08,P50
        movp    %$03,P49
        mov     %6,B                    ; delai plus long en 1re passe,
        call    @mouse_delay            ; comme dans exelnoid
        movp    %$02,P50
        movp    P49,A
        sta     @mouse_btn_old          ; boutons : bits 6-5 de CET octet
        and     %$0F,A
        rl      A                       ; SWAP indisponible sur ce TASM --
        rl      A                       ; equivalent a 4x RL (voir SWAP.md :
        rl      A                       ; "equivalent to four consecutive
        rl      A                       ; RL instructions")
        push    A                       ; en attente le temps de la passe 2

        ; --- passe 2 : nibble bas du delta X ---
        movp    %$08,P50
        movp    %$02,P49
        mov     %1,B
        call    @mouse_delay
        movp    %$02,P50
        movp    P49,A
        and     %$0F,A
        pop     B                       ; B = nibble haut (passe 1)
        or      B,A                     ; A = delta X complet, signe
        mov     A,TEMP1

        ; --- passe 3 : nibble haut du delta Y ---
        ; Delai porte a 6 (comme la passe 1), pas 1 (comme dans exelnoid) :
        ; les deux demandent le MEME mode $03 (nibble haut). Dans exelnoid,
        ; cette passe n'etait jamais exploitee (juste completee pour la
        ; forme puis jetee) -- personne n'avait verifie si $03 a besoin du
        ; meme delai de stabilisation qu'en passe 1, quel que soit le
        ; numero de passe. Hypothese testee suite a "bas ne fait rien,
        ; meme loin des bords" : une lecture trop rapide du nibble haut
        ; produirait un octet fausse, pas juste un signe interverti.
        movp    %$08,P50
        movp    %$03,P49
        mov     %6,B
        call    @mouse_delay
        movp    %$02,P50
        movp    P49,A
        and     %$0F,A
        rl      A                       ; SWAP indisponible sur ce TASM --
        rl      A                       ; meme equivalent 4x RL qu'en passe 1
        rl      A
        rl      A
        push    A

        ; --- passe 4 : nibble bas du delta Y ---
        movp    %$08,P50
        movp    %$02,P49
        mov     %1,B
        call    @mouse_delay
        movp    %$02,P50
        movp    P49,A
        and     %$0F,A
        pop     B
        or      B,A                     ; A = delta Y complet, signe
        sta     @mouse_dy

        pop     B
        pop     A
        rets

; Delai calibre sur le timing ROM (voir exelnoid) -- B = nombre d'iterations
; (6 en passe 1, 1 pour les passes 2 a 4). La lecture SRAM ne sert qu'a
; occuper le temps, la valeur lue n'est jamais utilisee ici.
mouse_delay:
        push    A
        push    B
md_lp:  lda     @mouse_btn_old
        lda     @mouse_btn_old
        djnz    B,@md_lp
        pop     B
        pop     A
        rets

; ============================================================================
; CHECK_MOUSE -- lit la souris et deplace le viseur d'UN pas par lecture,
; borne comme au clavier (memes constantes CUR_STEP_X/Y, CUR_MAX_XSEG/Y).
; Appelee une fois par tick depuis mc_key, uniquement si mouse_enabled=1.
; ============================================================================
; ============================================================================
; DEPLACEMENT DU VISEUR -- routines communes au clavier et a la souris.
;
; Principe : on calcule d'abord la position VISEE (cur_nx/cur_ny) pas a
; pas, avec exactement les memes bornes qu'avant, sans rien dessiner ; puis
; cur_commit efface le viseur UNE fois a l'ancienne position. Le dessin a
; la nouvelle position est fait a ml_next, une seule fois par passage.
; Plusieurs pas (ou X + Y en diagonale) ne coutent donc pas plus cher
; qu'un seul.
; ============================================================================

; --- nombre de pas pour une fleche : 1 a l'appui, puis autant que de ticks
; ecoules pendant ce passage (plafonne a CUR_BURST_MAX) en repetition.
; KEY_RPT_NEXT vaut 1 (un pas par tick) : quand une passe dure 3 ticks parce
; que beaucoup de lemmings ont ete dessines, le viseur fait 3 pas d'un coup
; au lieu d'un -- sa vitesse ne depend plus du nombre de lemmings, comme
; celle des lemmings eux-memes (voir ml_consume).
cur_arrow_steps:
        mov     %1,A
        sta     @cur_steps
        lda     @rpt_flag               ; premier appui : un seul pas, pour
        jeq     @cas_done               ; garder la precision au coup par coup
        lda     @pass_ticks
        jeq     @cas_done
        cmp     %CUR_BURST_MAX,A
        jnc     @cas_set                ; jnc : pass_ticks < plafond
        mov     %CUR_BURST_MAX,A
cas_set:
        sta     @cur_steps
cas_done:
        rets

; --- nombre de pas pour la souris : A = amplitude du deplacement lu (>= 1).
; 1 pas pour un petit mouvement (comme avant), plus pour un geste ample :
; amplitude/4 + 1, plafonne a CUR_BURST_MAX. La souris accumule son
; deplacement entre deux lectures ; quand les lectures s'espacent (passes
; longues), l'amplitude grandit et compense d'elle-meme.
; NON VERIFIE sur materiel : la conversion suppose un delta en complement a
; 2 (c'est ce que faisait la ROM d'origine avant son inversion INV/INC). Si
; un sens se met a sauter de 4 pas au moindre mouvement, remplacer le corps
; de cette routine par "mov %1,A / sta @cur_steps / rets".
mouse_steps:
        rr      A
        rr      A
        and     %$3F,A                  ; amplitude / 4 (rr fait tourner les
                                        ; bits 0-1 en haut : on les masque)
        inc     A                       ; au moins un pas
        cmp     %CUR_BURST_MAX,A
        jnc     @ms_set
        mov     %CUR_BURST_MAX,A
ms_set:
        sta     @cur_steps
        rets

; --- position visee = position actuelle
cur_move_init:
        lda     @cur_pending            ; souris ET clavier dans le meme
        jne     @cmi_keep               ; passage : on repart de la cible
        lda     @cur_xseg               ; deja demandee, pas de l'ecran
        sta     @cur_nx
        lda     @cur_y
        sta     @cur_ny
cmi_keep:
        rets

; --- cur_steps pas dans la direction cur_bdir, sur cur_nx/cur_ny. Chaque pas
; est borne comme avant : on s'arrete simplement au bord.
cur_move_n:
cmn_loop:
        call    @cur_try_dir
        lda     @cur_steps
        dec     A
        sta     @cur_steps
        jne     @cmn_loop
        rets

; --- UN pas, memes tests que l'ancien code des fleches (cmp/jc : C=1 quand
; A >= operande).
cur_try_dir:
        lda     @cur_bdir
        jne     @ctd_nl
        lda     @cur_nx                 ; 0 = gauche
        jeq     @ctd_ret                ; deja au bord gauche
        sub     %CUR_STEP_X,A
        sta     @cur_nx
ctd_ret:
        rets
ctd_nl:
        cmp     %1,A
        jne     @ctd_nr
        lda     @cur_nx                 ; 1 = droite
        add     %CUR_STEP_X,A
        cmp     %CUR_MAX_XSEG,A
        jnc     @ctd_rok                ; jnc : reste dans l'ecran
        rets
ctd_rok:
        sta     @cur_nx
        rets
ctd_nr:
        cmp     %2,A
        jne     @ctd_down
        lda     @cur_ny                 ; 2 = haut
        cmp     %CUR_STEP_Y,A
        jc      @ctd_uok                ; jc : cur_ny >= le pas
        rets
ctd_uok:
        sub     %CUR_STEP_Y,A
        sta     @cur_ny
        rets
ctd_down:
        lda     @cur_ny                 ; 3 = bas
        add     %CUR_STEP_Y,A
        cmp     %CUR_MAX_Y,A
        jnc     @ctd_dok
        rets
ctd_dok:
        sta     @cur_ny
        rets

; --- note le deplacement demande, SANS toucher a l'ecran. Tout l'affichage
; du viseur est fait a ml_next, apres le pas des lemmings : effacement puis
; redessin aussitot. Avant, la souris effacait le viseur des le debut du
; passage (check_mouse est lu juste apres l'attente du tick) et il restait
; invisible pendant tout le rattrapage, le clavier et le pas des lemmings --
; d'ou un clignotement, visible surtout a la souris qui bouge a chaque
; passage.
cur_commit:
        mov     %1,A
        sta     @cur_pending
        rets

; --- applique la position visee (appele par ml_next seulement) : si elle
; differe, efface le viseur a l'ANCIENNE position (cur_xseg/cur_y encore
; inchanges a ce moment-la), puis met a jour. Au bord, rien ne change et
; rien n'est efface.
cur_apply:
        lda     @cur_nx
        cmpa    @cur_xseg
        jne     @cc_move
        lda     @cur_ny
        cmpa    @cur_y
        jne     @cc_move
        rets
cc_move:
        call    @cur_erase
        lda     @cur_nx
        sta     @cur_xseg
        lda     @cur_ny
        sta     @cur_y
        rets

check_mouse:
        push    A
        push    B

        call    @read_mouse
        call    @cur_move_init          ; X et Y cumules sur cur_nx/cur_ny,
                                        ; UN seul effacement a la fin (avant :
                                        ; un par axe en diagonale)

        ; --- delta X. Sens verifie sur materiel : bit7=1 = DROITE,
        ; bit7=0 = GAUCHE.
        mov     TEMP1,A
        jeq     @cmm_y
        and     %$80,A
        jne     @cmm_xr
        clr     A                       ; gauche
        sta     @cur_bdir
        mov     TEMP1,A                 ; amplitude = valeur telle quelle
        br      @cmm_xgo
cmm_xr:
        mov     %1,A                    ; droite
        sta     @cur_bdir
        mov     TEMP1,A
        xor     %$FF,A                  ; amplitude = -valeur (complement a 2)
        inc     A
cmm_xgo:
        call    @mouse_steps
        call    @cur_move_n

cmm_y:
        ; --- delta Y. Sens verifie sur materiel : bit7=1 = BAS,
        ; bit7=0 = HAUT.
        lda     @mouse_dy
        jeq     @cmm_commit
        and     %$80,A
        jne     @cmm_yd
        mov     %2,A                    ; haut
        sta     @cur_bdir
        lda     @mouse_dy
        br      @cmm_ygo
cmm_yd:
        mov     %3,A                    ; bas
        sta     @cur_bdir
        lda     @mouse_dy
        xor     %$FF,A
        inc     A
cmm_ygo:
        call    @mouse_steps
        call    @cur_move_n

cmm_commit:
        call    @cur_commit             ; efface a l'ancienne position si le
                                        ; viseur a bouge ; dessin a ml_next

cmm_btn:
        ; --- boutons : on ne retient que les NOUVEAUX appuis (front), un
        ; bit par bouton, dans mouse_act ; mouse_actions les traite ensuite
        ; avec le clavier (meme profondeur de pile qu'une touche). Actifs a
        ; l'etat bas dans l'octet P49 brut, d'ou l'inversion.
        lda     @mouse_btn_old
        xor     %$FF,A
        and     %$60,A                  ; boutons enfonces maintenant
        mov     A,B
        lda     @mouse_btn_latch        ; enfonces au passage precedent
        inv     A
        and     B,A                     ; = appuis nouveaux
        mov     A,TEMP2
        lda     @mouse_act
        or      TEMP2,A
        sta     @mouse_act
        mov     B,A
        sta     @mouse_btn_latch
cmm_done:
        pop     B
        pop     A
        rets

; ============================================================================
; build_mixed_page -- reproduit l'algorithme d'InitMixedPage (vdp.asm),
; wvdp(x) etant simplement "movp %x,P46" (EXL100.equ). Positionne d'abord
; ACMPxy sur SCREEN_BASE (via setAcmpxy, meme sequence que vdp.asm), puis
; ecrit sequentiellement TOP_TEXT_LINES lignes texte, GRAPH_LINES lignes
; bitmap (vides), BOT_TEXT_LINES lignes texte -- chacune suivie de son
; octet de controle (type de la ligne SUIVANTE) + un octet de reserve.
; ============================================================================
build_mixed_page:
        mov     %SCREEN_BASE>>8,A
        mov     %SCREEN_BASE&$FF,B
        call    @setAcmpxy

        mov     %TOP_TEXT_LINES,TEMP5
        jeq     @bmp_after_top
bmp_top:
        mov     %40,B
bmp_topc:
        movp    %TEXT_ATTR,P46
        movp    %CH_BLANK,P46           ; glyphe vide (plus le code 0)
        djnz    B,@bmp_topc
        cmp     %1,TEMP5
        jeq     @bmp_top_graph          ; derniere ligne texte du haut :
        movp    %MIXT_NEXT_TEXT,P46     ; suivante = bitmap (GRAPH_LINES
        br      @bmp_top2               ; vaut toujours 200 dans ce test,
                                        ; pas besoin de tester s'il est nul
                                        ; comme le fait vdp.asm, generique)
bmp_top_graph:
        movp    %MIXT_NEXT_GRAPH,P46
bmp_top2:
        movp    %0,P46
        djnz    TEMP5,@bmp_top

bmp_after_top:
        mov     %GRAPH_LINES,TEMP5
bmp_gr:
        mov     %120,B
bmp_grb:
        movp    %0,P46                  ; bitmap vide au depart (0 partout)
        djnz    B,@bmp_grb
        cmp     %1,TEMP5
        jne     @bmp_grg
        movp    %MIXT_NEXT_TEXT,P46     ; derniere ligne bitmap -> texte
        br      @bmp_gr2
bmp_grg:
        movp    %MIXT_NEXT_GRAPH,P46
bmp_gr2:
        movp    %0,P46
        djnz    TEMP5,@bmp_gr

        mov     %BOT_TEXT_LINES,TEMP5
bmp_bot:
        mov     %40,B
bmp_botc:
        movp    %TEXT_ATTR,P46
        movp    %CH_BLANK,P46
        djnz    B,@bmp_botc
        movp    %MIXT_NEXT_TEXT,P46
        movp    %0,P46
        djnz    TEMP5,@bmp_bot
        rets

; ============================================================================
; setAcmpxy -- reprise exacte de vdp.asm : positionne ACMPxy sur A:B.
; ============================================================================
setAcmpxy:
        movp    %$21,P45
        movp    B,P45
        movp    A,P45
        rets

; --- setRWxy : arme la lecture ET l'ecriture sur la MEME adresse ----------
; A = poids fort, B = poids faible (meme convention que setAcmpxy).
; Le TMS3556 a des pointeurs de LECTURE et d'ECRITURE separes, qui
; s'auto-incrementent independamment. La sequence ci-dessous (procedure du
; moniteur ROM $F932, decrite dans le quickref VDP section 5.1.1) les arme
; tous les deux d'un coup : P40 initialise la lecture depuis COL/ROW, le
; MOVP P36 qui suit est un DUMMY READ dont la valeur est ignoree mais qui
; fait avancer le pointeur lecture, et le transfert BAMP ($09 deux fois)
; prepare le pointeur ecriture ACMP sur la meme adresse.
; Ensuite, une boucle LVDP / MOVP A,P46 lit et reecrit la meme case, les
; deux pointeurs avancant en parallele -- exactement ce qu'il faut pour du
; lire-modifier-reecrire sur les trois plans couleur.
; Gain : UNE programmation de pointeur par ligne au lieu de DEUX.
setRWxy:
        decd    B                       ; INDISPENSABLE : le dummy read
                                        ; ci-dessous fait avancer le pointeur
                                        ; lecture d'un octet. On pre-decremente
                                        ; donc l'adresse (paire A:B, A = poids
                                        ; fort) pour que le premier LVDP tombe
                                        ; bien sur la case voulue. C'est ce que
                                        ; fait le moniteur ROM en $F932.
        movp    %$01,P45
        movp    B,P45
        movp    %$02,P45
        movp    A,P45
        movp    P40,B                   ; arme la lecture
        movp    P36,B                   ; dummy read : fait avancer le
                                        ; pointeur lecture
        movp    %$09,P45                ; BAMP : prepare le pointeur
        movp    %$09,P45                ; ecriture sur la meme adresse
        rets

; ============================================================================
; draw_all_tiles -- redessine TOUTE la zone bitmap (200 lignes de balayage),
; horizon fixe (10 lignes-tuiles de ciel, 10 de sol) : pas de plan de
; niveau ici, ce test ne mesure que la vitesse d'un reaffichage complet.
; Chaque ligne de balayage appartient a UNE seule rangee de tuiles, donc
; ses 40 segments partagent le meme motif -- pas besoin de lire une carte
; case par case pour ce test statique.
; ============================================================================
; --- resout une rangee complete de tuiles dans tile_row : index reel de
; chaque case, ou 0 si elle a ete creusee. Appelee UNE FOIS par rangee de
; tuiles, pas a chaque ligne de balayage -- les bits creuses ne changent
; que d'une rangee a l'autre. Sans ce cache, le redessin complet testait
; 8000 cases au lieu de 800 et prenait plus d'une seconde.
build_tile_row:
        lda     @mrow_lo
        mov     A,TEMP2
        lda     @mrow_hi
        mov     A,TEMP2-1
        lda     @cur_screen
        sta     @map_screen
        call    @dig_row_start
        clr     A
        sta     @tmp_b
btr_loop:
        lda     @dig_cur
        mov     A,TEMP4
        lda     @dig_bit
        and     TEMP4,A
        jeq     @btr_map
        clr     A                       ; creusee : vue comme vide
        br      @btr_store
btr_map:
        lda     *TEMP2
btr_store:
        sta     @tmp_c
        lda     @tmp_b
        mov     A,B
        lda     @tmp_c
        sta     @tile_row(B)
        inc     TEMP2                   ; case suivante de la carte
        adc     %0,TEMP2-1
        lda     @dig_bit                ; bit suivant ; tous les 8, on
        clrc                            ; recharge l'octet
        rlc     A
        sta     @dig_bit
        jne     @btr_next
        call    @dig_load_byte
        mov     %1,A
        sta     @dig_bit
btr_next:
        lda     @tmp_b
        inc     A
        sta     @tmp_b
        cmp     %LV_MAP_W,A
        jne     @btr_loop

        ; --- tuiles POSEES : un seul balayage de la liste pour toute la
        ; rangee. Les tester case par case reviendrait a parcourir la liste
        ; 40 fois par rangee au lieu d'une.
        ; L'index de parcours est garde en MEMOIRE (bidx) et non dans B :
        ; B sert aussi a indexer build_key, build_col et tile_row, et une
        ; premiere version melangeait les deux usages.
        lda     @build_n
        jne     @btr_built
        rets                            ; liste vide
btr_built:
        call    @built_key              ; cle de la rangee courante
        clr     A
        sta     @bidx
btr_bloop:
        lda     @bidx
        mov     A,B
        lda     @build_key(B)
        cmpa    @bkey
        jne     @btr_bnext              ; autre rangee ou autre ecran
        ; QUELLE tuile pour cette entree : lue AVANT d'ecraser B avec la
        ; colonne (build_tile et build_col sont tous deux indexes par
        ; bidx, pas par la colonne -- il faut lire l'un avant de perdre
        ; l'index en le remplacant par l'autre).
        lda     @bidx
        mov     A,B
        lda     @build_tile(B)
        sta     @tmp_c                  ; tuile, gardee de cote
        lda     @bidx
        mov     A,B
        lda     @build_col(B)           ; colonne concernee
        mov     A,B
        lda     @tmp_c
        sta     @tile_row(B)
btr_bnext:
        lda     @bidx
        inc     A
        sta     @bidx
        cmpa    @build_n
        jne     @btr_bloop
        rets

draw_all_tiles:
        ; ====================================================================
        ; Dessine la zone bitmap a partir de la carte de tuiles ET de la
        ; couche de destruction, via le cache tile_row reconstruit a chaque
        ; changement de rangee.
        ; Adresse d'une ligne de tuile = lv_tiles + index*30 + tline*3.
        ; ====================================================================
        lda     @cur_screen             ; carte de l'ecran courant : index =
        mov     A,B                     ; premier ecran du niveau + ecran
        lda     @cur_map_base
        add     B,A
        mov     A,B
        lda     @lv_map_hi(B)
        sta     @mrow_hi
        lda     @lv_map_lo(B)
        sta     @mrow_lo

        mov     %GRAPH_BASE>>8,A        ; pointeur VRAM
        sta     @tv_hi
        mov     %GRAPH_BASE&$FF,A
        sta     @tv_lo

        clr     A
        sta     @tline
        sta     @q_row
        sta     @tmp_a                  ; ligne de balayage, 0..199
        call    @build_tile_row         ; premiere rangee

dat_line:
        ; --- tb = lv_tiles + tline*3 --------------------------------------
        lda     @tline
        mov     A,B
        add     B,A
        add     B,A                     ; A = tline*3
        mov     A,TEMP4
        lda     @tiles_lo               ; tuiles du theme du niveau
        add     TEMP4,A
        jnc     @dat_tb_nc              ; retenue AVANT le sta
        sta     @tb_lo
        lda     @tiles_hi
        inc     A
        sta     @tb_hi
        br      @dat_tb_ok
dat_tb_nc:
        sta     @tb_lo
        lda     @tiles_hi
        sta     @tb_hi
dat_tb_ok:
        lda     @tv_lo                  ; pointeur VDP sur la ligne
        mov     A,B
        lda     @tv_hi
        call    @setAcmpxy

        clr     A
        sta     @tmp_b                  ; colonne, 0..39
        mov     %LV_MAP_W,TEMP5
dat_col:
        lda     @tmp_b                  ; index deja resolu par le cache
        mov     A,B
        lda     @tile_row(B)
        sta     @tid

        lda     @tb_lo                  ; TEMP1 = tb + index*30
        mov     A,TEMP1
        lda     @tb_hi
        mov     A,TEMP1-1
        lda     @tid
        mpy     %LV_TILE_BYTES,A
        mov     A,TEMP6
        mov     B,TEMP7
        add     TEMP7,TEMP1
        adc     TEMP6,TEMP1-1

        lda     *TEMP1                  ; plan Bleu
        movp    A,P46
        inc     TEMP1
        adc     %0,TEMP1-1
        lda     *TEMP1                  ; plan Vert
        movp    A,P46
        inc     TEMP1
        adc     %0,TEMP1-1
        lda     *TEMP1                  ; plan Rouge
        movp    A,P46

        lda     @tmp_b
        inc     A
        sta     @tmp_b
        djnz    TEMP5,@dat_col

        ; --- ligne suivante : avance le pointeur VRAM de MAPPLEN ----------
        lda     @tv_lo
        add     %MAPPLEN&$FF,A
        jnc     @dat_ptr_nc
        sta     @tv_lo
        lda     @tv_hi
        add     %MAPPLEN_HI_C,A
        sta     @tv_hi
        br      @dat_ptr_done
dat_ptr_nc:
        sta     @tv_lo
dat_ptr_done:

        ; --- tline 0..9, puis rangee suivante -----------------------------
        lda     @tline
        inc     A
        cmp     %TILE_H_LINES,A
        jne     @dat_same_row
        clr     A
        sta     @tline
        lda     @q_row
        inc     A
        sta     @q_row
        lda     @mrow_lo
        add     %LV_MAP_W,A
        jnc     @dat_mr_nc
        sta     @mrow_lo
        lda     @mrow_hi
        inc     A
        sta     @mrow_hi
        br      @dat_newrow
dat_mr_nc:
        sta     @mrow_lo
dat_newrow:
        call    @build_tile_row         ; le cache suit la rangee
        br      @dat_row_done
dat_same_row:
        sta     @tline
dat_row_done:

        lda     @tmp_a
        inc     A
        sta     @tmp_a
        cmp     %GRAPH_LINES,A
        jeq     @dat_done
        br      @dat_line
dat_done:
        rets

; --- variables 16 bits pour draw_all_tiles (ajoutees ici, pas dans le
; bloc principal, pour rester pres de leur seul usage) ---------------------
tv_hi           .equ    $C404
tv_lo           .equ    $C405
sv_hi           .equ    $C409           ; pointeur dans cur_save
sv_lo           .equ    $C40A
cl_ctr          .equ    $C40B           ; compteur de lignes du viseur

; ============================================================================
; vram_line_addr -- routine PARTAGEE : tv_hi:tv_lo = GRAPH_BASE
;   + a_yline*MAPPLEN + a_xseg*3   (3 octets par segment : B, G, R)
; Utilisee par le viseur ET par le lemming, pour n'avoir qu'un seul endroit
; ou ce calcul peut etre faux.
; ============================================================================
vram_line_addr:
        ; MULTIPLICATION, pas addition repetee. La premiere version ajoutait
        ; MAPPLEN autant de fois que le numero de ligne : jusqu'a 199 tours
        ; de boucle, pour UN appel. Multiplie par les ~42 appels que coute
        ; un deplacement du viseur, cela representait plus de 30000
        ; instructions, soit environ 120 ms -- du meme ordre que les 160 ms
        ; separant deux pas du lemming. C'etait la vraie cause du
        ; ralentissement, et aucune gestion de ticks ne pouvait la corriger.
        ; MPY fait le calcul en une instruction : a_yline*MAPPLEN tient sur
        ; 16 bits (199*122 = 24278).
        mov     %GRAPH_BASE>>8,A
        mov     A,TEMP1-1
        mov     %GRAPH_BASE&$FF,A
        mov     A,TEMP1

        lda     @a_yline                ; + a_yline * MAPPLEN
        mpy     %MAPPLEN,A              ; A = poids fort, B = poids faible
        mov     A,TEMP6
        mov     B,TEMP7
        add     TEMP7,TEMP1             ; l'ADD pose la retenue,
        adc     TEMP6,TEMP1-1           ; l'ADC la consomme aussitot

        lda     @a_xseg                 ; + a_xseg * 3 (3 octets B,G,R)
        mpy     %3,A
        mov     A,TEMP6
        mov     B,TEMP7
        add     TEMP7,TEMP1
        adc     TEMP6,TEMP1-1

        mov     TEMP1,A
        sta     @tv_lo
        mov     TEMP1-1,A
        sta     @tv_hi
        rets

; ============================================================================
; cur_addr -- adresse de la ligne cl_ctr du viseur. Simple mise en place des
; parametres de vram_line_addr, depuis que celle-ci est partagee.
; ============================================================================
cur_addr:
        ; Meme principe que ldw_line / bdr_line : seule la premiere ligne
        ; du viseur demande le calcul complet (2 MPY), les quinze suivantes
        ; s'obtiennent en ajoutant MAPPLEN. Sur les 16 lignes, cela evite
        ; 15 calculs d'adresse complets a CHAQUE dessin du viseur -- et le
        ; viseur est redessine a chaque deplacement, donc tres souvent.
        lda     @cl_ctr
        jne     @ca_next
        lda     @cur_y
        sta     @a_yline
        lda     @cur_xseg
        sta     @a_xseg
        call    @vram_line_addr
        rets
ca_next:
        lda     @tv_lo                  ; tv += MAPPLEN
        add     %MAPPLEN&$FF,A
        jnc     @ca_nc
        sta     @tv_lo
        lda     @tv_hi
        add     %MAPPLEN_HI_C,A
        sta     @tv_hi
        rets
ca_nc:
        sta     @tv_lo
        rets

; ============================================================================
; VISEUR -- dessine PAR-DESSUS ce qui est deja a l'ecran
;
; Plus de fond sauvegarde : le viseur lit l'ecran tel qu'il est (P36), y
; ajoute son motif par un OU, et reecrit. Il passe donc toujours au-dessus
; du decor ET du lemming, sans avoir a les connaitre.
; Pour l'effacer, on regenere le decor puis on redessine le lemming --
; l'ancienne version recopiait a la place le fond qu'elle avait memorise,
; lequel contenait parfois des pixels de lemming : c'est ce qui laissait
; des morceaux de lemming derriere le viseur.
; ============================================================================

; --- efface le viseur : decor regenere, puis lemming par-dessus -----------
cur_erase:
        lda     @cur_dirty
        jne     @ce_go
        rets
ce_go:
        lda     @cur_xseg
        sta     @r_xseg
        mov     %CUR_W_SEG,A
        sta     @r_wseg
        lda     @cur_y
        sta     @r_yline
        mov     %CUR_H_LINES,A
        sta     @r_hlines
        call    @bg_draw_rect

        ; Chaque lemming n'est redessine que si la zone effacee le touche.
        ; Sans ce test, dix lemmings seraient redessines a chaque
        ; deplacement du viseur, meme a l'autre bout de l'ecran.
        clr     A
        sta     @cur_lem
ce_loop:
        call    @ce_one
        lda     @cur_lem
        inc     A
        sta     @cur_lem
        cmp     %NUM_LEM,A
        jne     @ce_loop
        ; le viseur n'est plus a l'ecran : ml_next le redessinera. Evite
        ; aussi un second effacement inutile si la souris ET une fleche
        ; deplacent le viseur dans le meme passage (cur_erase ressort alors
        ; tout de suite, voir son test d'entree).
        clr     A
        sta     @cur_dirty
        rets

; redessine le lemming cur_lem si son rectangle croise celui du viseur.
; Deux rectangles se touchent SAUF si l'un est entierement a gauche, a
; droite, au-dessus ou en dessous de l'autre. cmp/jc : C=1 quand A >= op.
ce_one:
        lda     @cur_lem
        mov     A,B
        lda     @lem_alive(B)
        jne     @ceo_alive
        rets
ceo_alive:
        ; MANQUAIT : sel_find (sfo_notdead) verifie l'ecran avant de comparer
        ; les coordonnees ; ce_one, lui, comparait directement -- un lemming
        ; sur un AUTRE ecran, mais partageant par coincidence des xseg/y
        ; proches de ceux du viseur, declenchait un redessin superflu (et
        ; potentiellement incorrect, compose contre le mauvais decor).
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        cmpa    @cur_screen
        jeq     @ceo_scr
        rets
ceo_scr:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        add     %LEM_WSEG,A
        mov     A,TEMP4
        lda     @cur_xseg
        cmp     TEMP4,A
        jnc     @ceo_x2
        rets                            ; viseur entierement a droite
ceo_x2:
        lda     @cur_xseg
        add     %CUR_W_SEG,A
        mov     A,TEMP4
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        cmp     TEMP4,A
        jnc     @ceo_y1
        rets                            ; viseur entierement a gauche
ceo_y1:
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        mov     A,TEMP4
        lda     @cur_y
        cmp     TEMP4,A
        jnc     @ceo_y2
        rets                            ; viseur entierement en dessous
ceo_y2:
        lda     @cur_y
        add     %CUR_H_LINES,A
        mov     A,TEMP4
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        cmp     TEMP4,A
        jnc     @ceo_draw
        rets                            ; viseur entierement au-dessus
ceo_draw:
        call    @lem_draw               ; ils se touchent : on le remet
        rets

; --- dessine le viseur par-dessus l'ecran actuel --------------------------
; Une ligne du viseur = 2 segments x 3 plans = 6 octets, lus, composes et
; reecrits un par un en alternance (voir cd_line) : un seul positionnement
; des pointeurs VDP par ligne, et aucun tampon intermediaire.
cur_draw:
        clr     A
        sta     @cl_ctr
cd_line:
        ; UNE seule programmation de pointeur par ligne, au lieu de deux.
        ; setRWxy arme la lecture ET l'ecriture sur la meme adresse ; les
        ; deux pointeurs avancent ensuite en parallele, donc la reecriture
        ; ci-dessous tombe pile sur les octets qu'on vient de lire, sans
        ; avoir a se repositionner. C'est le pattern documente pour le
        ; lire-modifier-reecrire sur les trois plans (quickref VDP 5.1.1).
        ; Sur les 16 lignes du viseur : 16 programmations au lieu de 32.
        call    @cur_addr               ; tv = debut de la ligne du viseur
        lda     @tv_lo
        mov     A,B
        lda     @tv_hi
        call    @setRWxy

        ; --- lire-composer-reecrire ENTRELACE, sans tampon : LVDP lit un
        ; octet (pointeur lecture), on y ajoute le motif, MOVP A,P46 le
        ; reecrit a la meme adresse (pointeur ecriture) ; les deux pointeurs
        ; avancent en parallele. C'est le motif de la routine ROM $F932
        ; (quickref VDP 5.1.1, et commentaire de setRWxy ci-dessus).
        ; L'ancienne version lisait d'abord les 6 octets dans cur_ln (index
        ; tenu en SRAM), puis les relisait pour les reecrire : ~1330 cycles
        ; par ligne, soit ~8,7 ms pour les 16 lignes -- presque un tick
        ; entier a chaque dessin du viseur. Ici, deroule : ~360 par ligne.
        lda     @cl_ctr                 ; --- motifs de cette ligne
        mov     A,B
        lda     @cur_bmp_l(B)
        mov     A,TEMP7                 ; segment gauche
        lda     @cur_bmp_r(B)
        mov     A,TEMP8                 ; segment droit

        lvdp                            ; segment gauche : plan Bleu
        or      TEMP7,A
        movp    A,P46
        lvdp                            ; plan Vert
        or      TEMP7,A
        movp    A,P46
        lvdp                            ; plan Rouge
        or      TEMP7,A
        movp    A,P46
        lvdp                            ; segment droit : plan Bleu
        or      TEMP8,A
        movp    A,P46
        lvdp                            ; plan Vert
        or      TEMP8,A
        movp    A,P46
        lvdp                            ; plan Rouge
        or      TEMP8,A
        movp    A,P46

        lda     @cl_ctr
        inc     A
        sta     @cl_ctr
        cmp     %CUR_H_LINES,A
        jeq     @cd_done                ; jne @cd_line etait hors de portee
        br      @cd_line                ; (corps de boucle long)
cd_done:
        mov     %1,A
        sta     @cur_dirty
        rets

; Motifs corriges : une premiere version ne posait qu'UN pixel par bord
; (colonnes 7 et 8 du bloc 16 px), ce qui donnait un rectangle noir avec
; deux traits, pas une croix. Ici les barres verticale ET horizontale sont
; presentes, avec le centre evide :
;   .......##.......
;   .......##.......   (x5)
;   ................   (x2)
;   #####......#####   (x2)
;   ................   (x2)
;   .......##.......   (x5)
; Chaque branche a ete raccourcie d'un pixel vers l'exterieur :
;   ................
;   .......##.......   (x4)
;   ................   (x2)
;   .####......####.   (x2)
;   ................   (x2)
;   .......##.......   (x4)
;   ................
cur_bmp_l:
        .byte   $00,$01,$01,$01,$01,$00,$00,$78
        .byte   $78,$00,$00,$01,$01,$01,$01,$00
cur_bmp_r:
        .byte   $00,$80,$80,$80,$80,$00,$00,$1E
        .byte   $1E,$00,$00,$80,$80,$80,$80,$00

; ============================================================================
; FOND REGENERE DEPUIS LA CARTE
;
; Remplace l'ancienne technique du "fond sauvegarde" (lire l'ecran avant de
; dessiner, le remettre ensuite). Celle-ci avait trois defauts, tous
; constates a l'usage :
;   - elle capturait AUSSI les autres sprites deja dessines, qu'elle
;     recopiait ensuite ailleurs (pixels de lemming laisses par le viseur) ;
;   - effacer puis redessiner fait disparaitre le sprite un instant, d'ou
;     le clignotement ;
;   - deux sprites qui se croisent ne peuvent pas s'accorder.
; Le decor etant entierement decrit par la carte de tuiles, il est moins
; couteux et plus sur de le RECALCULER que de le memoriser.
;
; Ordre de dessin desormais respecte partout : decor, puis lemming, puis
; viseur. Le viseur etant dessine en dernier, il passe toujours au-dessus.
; ============================================================================

; --- q_row / q_line : rangee de tuiles et ligne dans la tuile pour r_yline.
; Division par 10 par soustractions successives (au plus 20 tours).
rect_rowline:
        ; Division par 10 par TABLE, plus par soustractions successives :
        ; l'ancienne boucle faisait y/10 tours (~78 cycles chacun), soit
        ; ~1500 cycles en bas de l'ecran -- et cette routine est appelee a
        ; CHAQUE test de pixel (pix_solid), plusieurs fois par pas de chaque
        ; lemming. Ici : ~70 cycles, quel que soit y. B est preserve (aucun
        ; appelant n'a donc a s'en soucier, comme avant).
        push    B
        lda     @r_yline
        mov     A,B
        lda     @yrow_tbl(B)            ; y / TILE_H_LINES
        sta     @q_row
        lda     @yline_tbl(B)           ; y mod TILE_H_LINES
        sta     @q_line
        pop     B
        rets

; --- tables de rect_rowline, pour y = 0..255 (TILE_H_LINES = 10, en dur ici :
; si la hauteur des tuiles change, regenerer ces deux tables) -------------
yrow_tbl:
        .byte   0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
        .byte   1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3
        .byte   3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4
        .byte   4,4,5,5,5,5,5,5,5,5,5,5,6,6,6,6
        .byte   6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7
        .byte   8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9
        .byte   9,9,9,9,10,10,10,10,10,10,10,10,10,10,11,11
        .byte   11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12
        .byte   12,12,13,13,13,13,13,13,13,13,13,13,14,14,14,14
        .byte   14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15
        .byte   16,16,16,16,16,16,16,16,16,16,17,17,17,17,17,17
        .byte   17,17,17,17,18,18,18,18,18,18,18,18,18,18,19,19
        .byte   19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20
        .byte   20,20,21,21,21,21,21,21,21,21,21,21,22,22,22,22
        .byte   22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23
        .byte   24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25
yline_tbl:
        .byte   0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5
        .byte   6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1
        .byte   2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7
        .byte   8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3
        .byte   4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9
        .byte   0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5
        .byte   6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1
        .byte   2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7
        .byte   8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3
        .byte   4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9
        .byte   0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5
        .byte   6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1
        .byte   2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7
        .byte   8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3
        .byte   4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9
        .byte   0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5

; --- tb_hi:tb_lo = lv_tiles + q_line*3 (debut de la bonne ligne dans
; n'importe quelle tuile) --------------------------------------------------
rect_tilebase:
        lda     @q_line
        mov     A,B
        add     B,A
        add     B,A                     ; A = q_line*3
        mov     A,TEMP4
        lda     @tiles_lo               ; tuiles du theme du niveau
        add     TEMP4,A
        jnc     @rtb_nc                 ; retenue AVANT le sta
        sta     @tb_lo
        lda     @tiles_hi
        inc     A
        sta     @tb_hi
        rets
rtb_nc:
        sta     @tb_lo
        lda     @tiles_hi
        sta     @tb_hi
        rets

; --- TEMP2 = adresse dans la carte de la case (q_row, r_xseg + colonne) ----
; Entree : q_row pose, A = numero de colonne a ajouter a r_xseg.
; L'ecran consulte est map_screen, PAS cur_screen : on doit pouvoir
; interroger la carte d'un lemming qui se trouve sur un autre ecran que
; celui affiche (pour savoir s'il a du sol sous les pieds).
rect_mapptr:
        sta     @tmp_c                  ; colonne relative
        lda     @map_screen             ; index = premier ecran du niveau +
        mov     A,B                     ; ecran consulte
        lda     @cur_map_base
        add     B,A
        mov     A,B
        lda     @lv_map_hi(B)
        mov     A,TEMP2-1
        lda     @lv_map_lo(B)
        mov     A,TEMP2
        lda     @q_row                  ; + q_row * LV_MAP_W
        mpy     %LV_MAP_W,A
        mov     A,TEMP6
        mov     B,TEMP7
        add     TEMP7,TEMP2
        adc     TEMP6,TEMP2-1
        lda     @r_xseg                 ; + r_xseg + colonne
        mov     A,B
        lda     @tmp_c
        add     B,A
        mov     A,TEMP7
        clr     A
        mov     A,TEMP6
        add     TEMP7,TEMP2
        adc     TEMP6,TEMP2-1
        rets

; --- TEMP1 = adresse des 3 octets de la tuile pointee par TEMP2 ------------
; Consulte la couche de destruction AVANT la carte : une case creusee doit
; s'afficher vide, sinon le trou creuse resterait invisible a l'ecran.
; La colonne reelle est r_xseg + tmp_b (tmp_b = rang dans le rectangle en
; cours de parcours), d'ou le passage par d_col.
; --- CACHE DE RESOLUTION -------------------------------------------------
; La resolution d'une case (liste des briques posees, couche creusee, puis
; carte ROM) coute ~70 instructions, dominees par dig_locate (MPY + trois
; decalages + calcul d'adresse). Or bg_fill_buf et bg_draw_rect appellent
; cette routine UNE FOIS PAR LIGNE : pour un sprite d'un segment de large
; et dix lignes de haut, cela fait 20 appels par lemming et par pas, alors
; que le sprite ne couvre qu'UNE colonne et au plus DEUX rangees de tuiles
; -- donc au plus deux resultats distincts. Environ 51 ms de recalcul
; strictement identique sur dix lemmings, pour un budget de 10 ms par tick.
; On memorise donc la derniere case resolue : tant que la colonne ET la
; rangee n'ont pas change, on reutilise le resultat.
; rtc_valid est invalide des qu'une case est creusee ou une brique posee.
rect_tileptr:
        lda     @r_xseg
        mov     A,B
        lda     @tmp_b
        add     B,A
        sta     @d_col

        lda     @rtc_valid              ; le cache est-il utilisable ?
        jeq     @rtp_resolve
        lda     @map_screen             ; l'ECRAN fait partie de la cle :
        cmpa    @rtc_scr                ; rect_tileptr sert aussi bien le
        jne     @rtp_resolve            ; decor affiche que la carte d'un
                                        ; lemming hors champ
        lda     @d_col
        cmpa    @rtc_col
        jne     @rtp_resolve
        lda     @q_row
        cmpa    @rtc_row
        jne     @rtp_resolve
        lda     @rtc_tid                ; meme case : on reutilise
        sta     @tid
        br      @rtp_addr
rtp_resolve:
        ; Les tuiles POSEES sont consultees ici aussi. Sans cela, seul le
        ; redessin plein ecran les affichait : une brique fraichement posee
        ; restait invisible, l'escalier ne se voyait pas se construire.
        call    @built_test
        jeq     @rtp_nobuild
        lda     @bt_found               ; QUELLE tuile : plus toujours
        mov     A,B                     ; BUILD_TILE (marches d'escalier)
        lda     @build_tile(B)
        sta     @tid
        br      @rtp_addr
rtp_nobuild:
        call    @dig_test               ; n'ecrase pas TEMP2 (il n'utilise
                                        ; que TEMP1, TEMP3 et TEMP6-8)
        jeq     @rtp_map
        clr     A                       ; creusee : tuile 0 (vide)
        sta     @tid
        br      @rtp_addr
rtp_map:
        lda     *TEMP2
        sta     @tid
        lda     @map_screen             ; memorise la case resolue
        sta     @rtc_scr
        lda     @d_col
        sta     @rtc_col
        lda     @q_row
        sta     @rtc_row
        lda     @tid
        sta     @rtc_tid
        mov     %1,A
        sta     @rtc_valid
rtp_addr:
        lda     @tb_lo
        mov     A,TEMP1
        lda     @tb_hi
        mov     A,TEMP1-1
        lda     @tid
        mpy     %LV_TILE_BYTES,A
        mov     A,TEMP6
        mov     B,TEMP7
        add     TEMP7,TEMP1
        adc     TEMP6,TEMP1-1
        rets

; --- redessine directement en VRAM le rectangle (r_xseg, r_yline,
; r_wseg x r_hlines) depuis la carte. Sert a effacer un sprite. ------------
bg_draw_rect:
        ; --- PAR COLONNE, et la tuile n'est resolue qu'une fois par rangee
        ; (1 a 2 fois pour 10 a 16 lignes). Avant, chaque LIGNE refaisait
        ; rect_tilebase + rect_mapptr (un MPY) + rect_tileptr (un 2e MPY et
        ; une dizaine de comparaisons en SRAM, meme sur le cache) : ~1000
        ; cycles par ligne, soit ~10 000 pour effacer un lemming et ~23 000
        ; pour effacer le viseur. Ici : pointeur de tuile (TEMP1) et adresse
        ; VRAM (BG_PTR) en REGISTRES, avances de 3 octets et d'une ligne
        ; ecran : ~250 cycles par ligne. Les lignes d'une tuile sont
        ; contigues (3 octets B,G,R par ligne), d'ou le simple +3.
        ; BG_PTR (R29:R30) et PAS TEMP3 : dig_test, appele par la
        ; resolution d'une tuile, se sert de TEMP3 (erreur trouvee par
        ; simulation : le decor s'ecrivait en SRAM, dans dig_map). BG_PTR
        ; n'est utilise nulle part ailleurs dans ce programme.
        lda     @cur_screen             ; le decor dessine est celui affiche
        sta     @map_screen
        clr     A
        sta     @tmp_b                  ; colonne dans le rectangle
bdr_col:
        call    @rect_rowline           ; q_row / q_line de la 1re ligne
        lda     @r_yline                ; adresse VRAM de la 1re ligne de
        sta     @a_yline                ; cette colonne
        lda     @r_xseg
        mov     A,B
        lda     @tmp_b
        add     B,A
        sta     @a_xseg
        call    @vram_line_addr
        lda     @tv_lo
        mov     A,BG_PTR
        lda     @tv_hi
        mov     A,BG_PTR-1
        call    @bg_resolve             ; TEMP1 = octets de la tuile, ligne q_line
        lda     @r_hlines
        sta     @ll_ctr
bdr_line:
        movp    %$21,P45                ; pointeur d'ecriture VRAM (setAcmpxy
        mov     BG_PTR,A                 ; en ligne : poids faible puis fort)
        movp    A,P45
        mov     BG_PTR-1,A
        movp    A,P45
        lda     *TEMP1                  ; plan Bleu
        movp    A,P46
        inc     TEMP1
        adc     %0,TEMP1-1
        lda     *TEMP1                  ; plan Vert
        movp    A,P46
        inc     TEMP1
        adc     %0,TEMP1-1
        lda     *TEMP1                  ; plan Rouge
        movp    A,P46
        inc     TEMP1                   ; -> meme tuile, ligne suivante
        adc     %0,TEMP1-1
        add     %MAPPLEN&$FF,BG_PTR      ; VRAM : ligne ecran suivante
        adc     %MAPPLEN>>8,BG_PTR-1
        lda     @ll_ctr
        dec     A
        sta     @ll_ctr
        jeq     @bdr_coldone
        lda     @q_line
        inc     A
        cmp     %TILE_H_LINES,A
        jeq     @bdr_newrow
        sta     @q_line
        br      @bdr_line
bdr_newrow:
        clr     A                       ; rangee suivante : nouvelle tuile
        sta     @q_line
        lda     @q_row
        inc     A
        sta     @q_row
        call    @bg_resolve
        br      @bdr_line
bdr_coldone:
        lda     @tmp_b
        inc     A
        sta     @tmp_b
        cmpa    @r_wseg
        jeq     @bdr_done
        br      @bdr_col
bdr_done:
        rets

; --- TEMP1 = adresse des octets de la ligne q_line de la tuile de la case
; (colonne r_xseg+tmp_b, rangee q_row), couche creusee et tuiles posees
; comprises. Commun a bg_draw_rect et bg_fill_buf.
bg_resolve:
        call    @rect_tilebase
        lda     @tmp_b
        call    @rect_mapptr
        call    @rect_tileptr
        rets

bg_fill_buf:
        ; --- meme principe que bg_draw_rect : par colonne, tuile resolue
        ; une fois par rangee, pointeurs en registres. Destination : lem_bg,
        ; ligne par ligne (r_wseg x 3 octets par ligne) -- inchange pour
        ; lem_draw. Avant : ~100 cycles PAR OCTET rien que pour tenir le
        ; pointeur de destination en SRAM.
        lda     @cur_screen             ; idem : on ne compose qu'a l'ecran
        sta     @map_screen
        clr     A
        sta     @tmp_b
bfb_col:
        call    @rect_rowline
        mov     %lem_bg>>8,BG_PTR-1      ; destination = lem_bg + colonne*3
        lda     @tmp_b
        mov     A,B
        add     B,A
        add     B,A
        add     %lem_bg&$FF,A
        jnc     @bfb_dnc                ; retenue lue AVANT le MOV
        inc     BG_PTR-1
bfb_dnc:
        mov     A,BG_PTR
        call    @bfb_resolve
        lda     @r_hlines
        sta     @ll_ctr
bfb_line:
        lda     *TEMP1                  ; 3 plans de la ligne de tuile
        sta     *BG_PTR
        inc     TEMP1
        adc     %0,TEMP1-1
        inc     BG_PTR
        adc     %0,BG_PTR-1
        lda     *TEMP1
        sta     *BG_PTR
        inc     TEMP1
        adc     %0,TEMP1-1
        inc     BG_PTR
        adc     %0,BG_PTR-1
        lda     *TEMP1
        sta     *BG_PTR
        inc     TEMP1
        adc     %0,TEMP1-1
        inc     BG_PTR
        adc     %0,BG_PTR-1
        add     TEMP5,BG_PTR             ; + (r_wseg-1)*3 : debut de la ligne
        adc     %0,BG_PTR-1              ; suivante, meme colonne
        lda     @ll_ctr
        dec     A
        sta     @ll_ctr
        jeq     @bfb_coldone
        lda     @q_line
        inc     A
        cmp     %TILE_H_LINES,A
        jeq     @bfb_newrow
        sta     @q_line
        br      @bfb_line
bfb_newrow:
        clr     A
        sta     @q_line
        lda     @q_row
        inc     A
        sta     @q_row
        call    @bfb_resolve
        br      @bfb_line
bfb_coldone:
        lda     @tmp_b
        inc     A
        sta     @tmp_b
        cmpa    @r_wseg
        jeq     @bfb_done
        br      @bfb_col
bfb_done:
        rets

; --- bg_resolve, puis TEMP5 = (r_wseg-1)*3, le pas de destination entre
; deux lignes (recalcule ici : built_test, appele par la resolution, se
; sert de TEMP5)
bfb_resolve:
        call    @bg_resolve
        lda     @r_wseg
        dec     A
        mov     A,B
        add     B,A
        add     B,A
        mov     A,TEMP5
        rets


; ============================================================================
; LEMMING -- sprite masque issu de lemdata.asm (EXELLEM)
;
; Format d'une vignette : en-tete "wseg, hblock", puis, par ligne et par
; segment de 8 px, quatre octets M, B, G, R.
;   masque a 1 = le pixel du sprite s'affiche
;   masque a 0 = le decor reste visible
; Composition, plan par plan : dst = (fond & ~M) | (sprite & M)
; ============================================================================

; --- miroir horizontal du segment : evite de dessiner et de stocker un
; second jeu de vignettes pour la marche vers la gauche -- le sprite ne
; faisant qu'un segment de large, retourner ses octets suffit.
; --- bitrev_tbl : octet a bits inverses (bit 7 <-> bit 0...), pour dessiner
; un sprite en miroir. Remplace l'ancienne routine bitrev (boucle de 8 tours,
; ~266 cycles par octet, 40 appels par lemming tourne vers la gauche : ~4 ms
; par dessin, pres de la moitie d'un tick). Usage : mov A,B / lda @bitrev_tbl(B).
; B n'est pas utilise dans la boucle ldw_seg, verifie avant le changement.
bitrev_tbl:
        .byte   $00,$80,$40,$C0,$20,$A0,$60,$E0,$10,$90,$50,$D0,$30,$B0,$70,$F0
        .byte   $08,$88,$48,$C8,$28,$A8,$68,$E8,$18,$98,$58,$D8,$38,$B8,$78,$F8
        .byte   $04,$84,$44,$C4,$24,$A4,$64,$E4,$14,$94,$54,$D4,$34,$B4,$74,$F4
        .byte   $0C,$8C,$4C,$CC,$2C,$AC,$6C,$EC,$1C,$9C,$5C,$DC,$3C,$BC,$7C,$FC
        .byte   $02,$82,$42,$C2,$22,$A2,$62,$E2,$12,$92,$52,$D2,$32,$B2,$72,$F2
        .byte   $0A,$8A,$4A,$CA,$2A,$AA,$6A,$EA,$1A,$9A,$5A,$DA,$3A,$BA,$7A,$FA
        .byte   $06,$86,$46,$C6,$26,$A6,$66,$E6,$16,$96,$56,$D6,$36,$B6,$76,$F6
        .byte   $0E,$8E,$4E,$CE,$2E,$AE,$6E,$EE,$1E,$9E,$5E,$DE,$3E,$BE,$7E,$FE
        .byte   $01,$81,$41,$C1,$21,$A1,$61,$E1,$11,$91,$51,$D1,$31,$B1,$71,$F1
        .byte   $09,$89,$49,$C9,$29,$A9,$69,$E9,$19,$99,$59,$D9,$39,$B9,$79,$F9
        .byte   $05,$85,$45,$C5,$25,$A5,$65,$E5,$15,$95,$55,$D5,$35,$B5,$75,$F5
        .byte   $0D,$8D,$4D,$CD,$2D,$AD,$6D,$ED,$1D,$9D,$5D,$DD,$3D,$BD,$7D,$FD
        .byte   $03,$83,$43,$C3,$23,$A3,$63,$E3,$13,$93,$53,$D3,$33,$B3,$73,$F3
        .byte   $0B,$8B,$4B,$CB,$2B,$AB,$6B,$EB,$1B,$9B,$5B,$DB,$3B,$BB,$7B,$FB
        .byte   $07,$87,$47,$C7,$27,$A7,$67,$E7,$17,$97,$57,$D7,$37,$B7,$77,$F7
        .byte   $0F,$8F,$4F,$CF,$2F,$AF,$6F,$EF,$1F,$9F,$5F,$DF,$3F,$BF,$7F,$FF

; (lem_getspr_m, lem_getspr, lem_getbg : mis en ligne dans ldw_seg pour
;  eviter les CALL dans la boucle chaude -- ces routines separees
;  n'existent plus)

; --- BARRE DE COMPTE A REBOURS
; Dessinee sur la LIGNE 0 du sprite, donc a l'interieur de son rectangle :
; aucune zone supplementaire a effacer, et l'effet marche pour les sept
; etats sans dupliquer le moindre sprite.
; Elle est ROUGE : on force donc les plans Bleu et Vert a 0 et le plan
; Rouge a 1 sur les pixels concernes.
; bar_clear sert aux plans B et G, bar_set au plan R. Hors de la ligne 0,
; ou si le lemming n'est pas amorce, les deux laissent A inchange.
; (bar_clear, bar_set : mis en ligne dans ldw_seg, meme raison)

; --- calcule la barre du lemming cur_lem : (compte>>2)+1 pixels, plafonne
; a 8, alignes a gauche. Elle retrecit donc a mesure que le temps passe.
bomb_bar_calc:
        lda     @cur_lem
        mov     A,B
        lda     @lem_bomb(B)
        jne     @bbc_armed
        sta     @bomb_bar               ; 0 : pas de barre
        rets
bbc_armed:
        rr      A                       ; compte / 4
        rr      A
        and     %$3F,A                  ; les rr font tourner, pas decaler :
                                        ; on jette les bits remontes en haut
        inc     A
        cmp     %9,A
        jnc     @bbc_ok                 ; jnc : <= 8
        mov     %8,A
bbc_ok:
        mov     A,TEMP7                 ; nombre de pixels
        clr     A
bbc_loop:
        setc
        rrc     A                       ; amene un 1 par la gauche
        dec     TEMP7
        jne     @bbc_loop
        sta     @bomb_bar
        rets

; (lem_compose : mise en ligne dans ldw_seg, meme raison)

; --- dessine le lemming : fond recalcule + composition + UNE seule ecriture
; par octet. Ne fait rien si le lemming n'est pas sur l'ecran affiche. ------
lem_draw:
        ; Dessine le lemming cur_lem. Ne fait rien s'il n'est pas encore
        ; apparu, ou s'il se trouve sur un autre ecran que celui affiche.
        lda     @cur_lem
        mov     A,B
        lda     @lem_alive(B)
        jne     @ld_alive
        rets
ld_alive:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        cmpa    @cur_screen
        jeq     @lem_draw_go
        rets
lem_draw_go:
        lda     @cur_lem                ; le fond sous sa position courante
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_fill_buf

        ; --- adresse de la vignette : index = etat*LEM_MAXFRAMES + vignette
        ; Les etats ST_WALK/ST_FALL/ST_DIG valent 0/1/2 et correspondent
        ; exactement aux types 0/1/2 dessines dans EXELLEM (marche, chute,
        ; creuse) : le sprite suit donc l'etat sans table de correspondance.
        ; Une version anterieure lisait toujours lem_frames0_* : le lemming
        ; gardait son allure de marcheur en tombant comme en creusant.
        call    @lem_sprite_type        ; etat, ou variante du marcheur
        mpy     %LEM_MAXFRAMES,A
        mov     B,A
        mov     A,TEMP4                 ; etat*MAXFRAMES
        lda     @cur_lem
        mov     A,B
        lda     @lem_frame(B)
        add     TEMP4,A
        mov     A,B                     ; index a plat
        lda     @lem_fr_hi(B)
        sta     @lp_hi
        call    @lem_sprite_type        ; etat, ou variante du marcheur
        mpy     %LEM_MAXFRAMES,A
        mov     B,A
        mov     A,TEMP4
        lda     @cur_lem
        mov     A,B
        lda     @lem_frame(B)
        add     TEMP4,A
        mov     A,B
        lda     @lem_fr_lo(B)
        sta     @lp_lo
        lda     @lp_lo                  ; sauter l'en-tete (wseg, hblock)
        add     %2,A
        jnc     @ldw_nc
        sta     @lp_lo
        lda     @lp_hi
        inc     A
        sta     @lp_hi
        br      @ldw_ok
ldw_nc:
        sta     @lp_lo
ldw_ok:
        call    @bomb_bar_calc          ; barre du compte a rebours
        ; --- composition sprite + fond, ecrite directement en VRAM. Pointeurs
        ; en REGISTRES (conseil de la KB) : sprite dans TEMP1, fond (lem_bg,
        ; rempli par bg_fill_buf juste avant) dans BG_PTR, adresse VRAM dans
        ; VP_PTR. Masque et masque inverse calcules une fois par segment
        ; (TEMP6 / TEMP2), barre du compte a rebours une fois par ligne
        ; (TEMP8 / TEMP3, neutres apres la 1re ligne), et deux boucles --
        ; normale et miroir -- au lieu d'un test du sens a chaque octet.
        ; L'ancienne version rechargeait et reecrivait ses pointeurs en SRAM
        ; a chaque octet : ~15 000 cycles la composition, ~5 000 ici.
        lda     @cur_lem                ; adresse VRAM de la 1re ligne
        mov     A,B
        lda     @lem_y(B)
        sta     @a_yline
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @a_xseg
        call    @vram_line_addr         ; (se sert de TEMP1 : avant le reste)
        lda     @tv_lo
        mov     A,VP_PTR
        lda     @tv_hi
        mov     A,VP_PTR-1
        lda     @lp_hi                  ; vignette
        mov     A,TEMP1-1
        lda     @lp_lo
        mov     A,TEMP1
        mov     %lem_bg>>8,BG_PTR-1     ; fond
        mov     %lem_bg&$FF,BG_PTR
        lda     @bomb_bar               ; barre (1re ligne)
        mov     A,TEMP8
        inv     A
        mov     A,TEMP3
        clr     A
        sta     @ll_ctr
        lda     @cur_lem                ; sens de marche -> miroir
        mov     A,B
        lda     @lem_dir(B)
        jeq     @ldwp_line
        br      @ldwm_line
ldwp_line:
        movp    %$21,P45                ; pointeur d'ecriture VRAM de la ligne
        mov     VP_PTR,A
        movp    A,P45
        mov     VP_PTR-1,A
        movp    A,P45
        mov     %LEM_WSEG,TEMP5
ldwp_seg:
        ; masque (1 = pixel du sprite)
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        mov     A,TEMP6
        inv     A
        mov     A,TEMP2
        ; plan Bleu
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        and     TEMP6,A                 ; sprite & M
        mov     A,TEMP7
        lda     *BG_PTR                 ; fond (lem_bg)
        inc     BG_PTR
        adc     %0,BG_PTR-1
        and     TEMP2,A                 ; fond & ~M
        or      TEMP7,A
        and     TEMP3,A                 ; barre : bleu efface
        movp    A,P46
        ; plan Vert
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        and     TEMP6,A                 ; sprite & M
        mov     A,TEMP7
        lda     *BG_PTR                 ; fond (lem_bg)
        inc     BG_PTR
        adc     %0,BG_PTR-1
        and     TEMP2,A                 ; fond & ~M
        or      TEMP7,A
        and     TEMP3,A                 ; barre : vert efface
        movp    A,P46
        ; plan Rouge
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        and     TEMP6,A                 ; sprite & M
        mov     A,TEMP7
        lda     *BG_PTR                 ; fond (lem_bg)
        inc     BG_PTR
        adc     %0,BG_PTR-1
        and     TEMP2,A                 ; fond & ~M
        or      TEMP7,A
        or      TEMP8,A                 ; barre : rouge pose
        movp    A,P46
        djnz    TEMP5,@ldwp_seg
        add     %MAPPLEN&$FF,VP_PTR     ; ligne ecran suivante
        adc     %MAPPLEN>>8,VP_PTR-1
        clr     A                       ; la barre n'est que sur la 1re ligne
        mov     A,TEMP8
        mov     %$FF,TEMP3
        lda     @ll_ctr
        inc     A
        sta     @ll_ctr
        cmp     %LEM_HLINES,A
        jne     @ldwp_more
        br      @ldw_done               ; (jeq hors de portee)
ldwp_more:
        br      @ldwp_line
ldwm_line:
        movp    %$21,P45                ; pointeur d'ecriture VRAM de la ligne
        mov     VP_PTR,A
        movp    A,P45
        mov     VP_PTR-1,A
        movp    A,P45
        mov     %LEM_WSEG,TEMP5
ldwm_seg:
        ; masque (1 = pixel du sprite)
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        mov     A,B                     ; miroir par table
        lda     @bitrev_tbl(B)
        mov     A,TEMP6
        inv     A
        mov     A,TEMP2
        ; plan Bleu
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        mov     A,B                     ; miroir par table
        lda     @bitrev_tbl(B)
        and     TEMP6,A                 ; sprite & M
        mov     A,TEMP7
        lda     *BG_PTR                 ; fond (lem_bg)
        inc     BG_PTR
        adc     %0,BG_PTR-1
        and     TEMP2,A                 ; fond & ~M
        or      TEMP7,A
        and     TEMP3,A                 ; barre : bleu efface
        movp    A,P46
        ; plan Vert
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        mov     A,B                     ; miroir par table
        lda     @bitrev_tbl(B)
        and     TEMP6,A                 ; sprite & M
        mov     A,TEMP7
        lda     *BG_PTR                 ; fond (lem_bg)
        inc     BG_PTR
        adc     %0,BG_PTR-1
        and     TEMP2,A                 ; fond & ~M
        or      TEMP7,A
        and     TEMP3,A                 ; barre : vert efface
        movp    A,P46
        ; plan Rouge
        lda     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        mov     A,B                     ; miroir par table
        lda     @bitrev_tbl(B)
        and     TEMP6,A                 ; sprite & M
        mov     A,TEMP7
        lda     *BG_PTR                 ; fond (lem_bg)
        inc     BG_PTR
        adc     %0,BG_PTR-1
        and     TEMP2,A                 ; fond & ~M
        or      TEMP7,A
        or      TEMP8,A                 ; barre : rouge pose
        movp    A,P46
        djnz    TEMP5,@ldwm_seg
        add     %MAPPLEN&$FF,VP_PTR     ; ligne ecran suivante
        adc     %MAPPLEN>>8,VP_PTR-1
        clr     A                       ; la barre n'est que sur la 1re ligne
        mov     A,TEMP8
        mov     %$FF,TEMP3
        lda     @ll_ctr
        inc     A
        sta     @ll_ctr
        cmp     %LEM_HLINES,A
        jne     @ldwm_more
        br      @ldw_done               ; (jeq hors de portee)
ldwm_more:
        br      @ldwm_line
ldw_done:
        rets

; --- efface le rectangle courant seulement si le lemming cur_lem est
; visible (deja apparu ET sur l'ecran affiche) ------------------------------
bg_erase_if_visible:
        lda     @cur_lem
        mov     A,B
        lda     @lem_alive(B)
        jeq     @beiv_skip
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        cmpa    @cur_screen
        jne     @beiv_skip
        call    @bg_draw_rect
beiv_skip:
        rets

; ============================================================================
; COUCHE DE DESTRUCTION
;
; Les cartes sont en ROM : on ne peut pas y effacer une tuile. On tient donc
; a cote, en RAM, UN BIT par case disant "creusee". 40x20 = 800 bits = 100
; octets par ecran ; 3 ecrans = 300 octets. Une copie complete des cartes
; aurait demande 800 octets par ecran, soit bien trop pour la SRAM.
;
; dig_locate -- pour la case (q_row, d_col) de l'ecran map_screen, calcule
; l'adresse de l'octet (dans TEMP3) et le masque de bit (dig_mask).
;   index = (map_screen*LV_MAP_H + q_row) * LV_MAP_W + d_col
;   octet = dig_map + index/8   ;   masque = 1 << (index & 7)
; d_col est un parametre distinct de r_xseg : les routines de dessin
; parcourent plusieurs colonnes a partir de r_xseg, il leur faut pouvoir
; interroger chacune d'elles.
; ============================================================================
dig_locate:
        ; --- index de la case = k*40 + colonne, k = ecran*20 + rangee
        ; (0..59). 40 etant multiple de 8 : octet = k*5 + colonne/8, bit =
        ; colonne & 7. Par TABLES (dig_row_lo/hi : dig_map + k*5 ;
        ; scr20_tbl : ecran*20) au lieu de deux MPY et d'une boucle de
        ; division : ~260 cycles au lieu de ~430, pour une routine appelee
        ; une dizaine de fois par pas de lemming (chaque test de terrain).
        ; Sorties inchangees : adresse de l'octet dans TEMP1 ET TEMP3,
        ; masque dans dig_mask.
        lda     @map_screen
        mov     A,B
        lda     @scr20_tbl(B)           ; ecran * LV_MAP_H
        mov     A,TEMP6
        lda     @q_row
        add     TEMP6,A                 ; k
        mov     A,B
        lda     @dig_row_hi(B)          ; dig_map + k*5
        mov     A,TEMP1-1
        lda     @dig_row_lo(B)
        mov     A,TEMP1
        lda     @d_col
        mov     A,TEMP7
        and     %7,A                    ; bit = colonne & 7
        mov     A,B
        lda     @bit_tbl(B)
        sta     @dig_mask
        mov     TEMP7,A                 ; + colonne / 8
        rr      A
        rr      A
        rr      A
        and     %$1F,A
        mov     A,TEMP7
        add     TEMP7,TEMP1
        adc     %0,TEMP1-1
        mov     TEMP1,A
        mov     A,TEMP3
        mov     TEMP1-1,A
        mov     A,TEMP3-1
        rets

; tables de dig_locate (LV_MAP_H = 20 et LV_MAP_W = 40 en dur : les regenerer
; si la taille de la carte change) -- 3 ecrans x 20 rangees
scr20_tbl:
        .byte   0,20,40
dig_row_lo:
        .byte   $80,$85,$8A,$8F,$94,$99,$9E,$A3,$A8,$AD,$B2,$B7
        .byte   $BC,$C1,$C6,$CB,$D0,$D5,$DA,$DF,$E4,$E9,$EE,$F3
        .byte   $F8,$FD,$02,$07,$0C,$11,$16,$1B,$20,$25,$2A,$2F
        .byte   $34,$39,$3E,$43,$48,$4D,$52,$57,$5C,$61,$66,$6B
        .byte   $70,$75,$7A,$7F,$84,$89,$8E,$93,$98,$9D,$A2,$A7
dig_row_hi:
        .byte   $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
        .byte   $C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$C5
        .byte   $C5,$C5,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
        .byte   $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6
        .byte   $C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6,$C6

dig_load_byte:
        lda     @drow_hi
        mov     A,TEMP3-1
        lda     @drow_lo
        mov     A,TEMP3
        lda     *TEMP3
        sta     @dig_cur
        lda     @drow_lo
        inc     A
        sta     @drow_lo
        jne     @dlb_nc
        lda     @drow_hi
        inc     A
        sta     @drow_hi
dlb_nc:
        rets

; --- pose drow sur le debut de la rangee q_row de l'ecran map_screen ------
dig_row_start:
        lda     @map_screen
        mpy     %LV_MAP_H,A
        mov     B,A
        mov     A,TEMP4
        lda     @q_row
        add     TEMP4,A                 ; ecran*LV_MAP_H + rangee (max 59)
        mpy     %5,A                    ; 5 octets par rangee
        mov     A,TEMP6
        mov     B,TEMP7
        mov     %dig_map>>8,A
        mov     A,TEMP1-1
        mov     %dig_map&$FF,A
        mov     A,TEMP1
        add     TEMP7,TEMP1
        adc     TEMP6,TEMP1-1
        mov     TEMP1,A
        sta     @drow_lo
        mov     TEMP1-1,A
        sta     @drow_hi
        call    @dig_load_byte
        mov     %1,A                    ; la colonne 0 est le bit 0
        sta     @dig_bit
        rets

; ============================================================================
; TUILES POSEES -- liste (cle, colonne), cle = map_screen*LV_MAP_H + q_row
; ============================================================================
; calcule la cle de la case courante dans bkey
built_key:
        lda     @map_screen
        mpy     %LV_MAP_H,A
        mov     B,A
        mov     A,TEMP4
        lda     @q_row
        add     TEMP4,A
        sta     @bkey
        rets

; --- cette case porte-t-elle une tuile posee ? Sortie : A != 0 si oui ------
built_test:
        call    @built_key
        lda     @build_n
        jne     @bt_filter
        rets                            ; liste vide : A = 0
bt_filter:
        ; --- filtre rapide : cette rangee a-t-elle deja recu une tuile
        ; posee ? Sinon, inutile de parcourir la liste (~58 cycles par
        ; entree, jusqu'a MAX_BUILT entrees, a CHAQUE test de pixel).
        lda     @bkey
        and     %7,A
        mov     A,B
        lda     @bit_tbl(B)             ; masque du bit (bkey & 7)
        mov     A,TEMP5
        lda     @bkey
        rr      A
        rr      A
        rr      A
        and     %$1F,A                  ; octet = bkey / 8
        mov     A,B
        lda     @built_rows(B)
        and     TEMP5,A
        jne     @bt_scan0
        rets                            ; A = 0 : rien de pose dans la rangee
bt_scan0:
        lda     @build_n
bt_scan:
        mov     A,TEMP5                 ; compteur
        clr     A
        mov     A,B                     ; index
bt_loop:
        lda     @build_key(B)
        cmpa    @bkey
        jne     @bt_next
        lda     @build_col(B)
        cmpa    @d_col
        jne     @bt_next
        mov     B,A
        sta     @bt_found               ; index memorise : l'appelant lira
                                        ; build_tile(bt_found) pour savoir
                                        ; QUELLE tuile afficher ici
        mov     %1,A
        rets                            ; trouvee
bt_next:
        mov     B,A
        inc     A
        mov     A,B
        djnz    TEMP5,@bt_loop
        clr     A
        rets

; --- ajoute la case courante a la liste (silencieux si elle est pleine) ----
; Entree : A = index de la tuile a memoriser pour cette case (pas toujours
; BUILD_TILE desormais : une marche d'escalier peut poser TILE_MARCHEA ou
; TILE_MARCHEB). Sauvegarde d'abord dans bt_arg : built_key (via MPY) et le
; calcul d'adresse ecrasent A et B plusieurs fois avant qu'on en ait besoin.
built_add:
        sta     @bt_arg
        lda     @build_n
        cmp     %MAX_BUILT,A
        jnc     @ba_room
        rets                            ; liste saturee : on ignore
ba_room:
        clr     A                       ; le terrain change : cache invalide
        sta     @rtc_valid
        ; built_key utilise MPY, qui ECRASE B : il faut donc l'appeler
        ; AVANT de charger l'index de la liste dans B. Une premiere version
        ; faisait l'inverse et ecrivait l'entree a un index arbitraire --
        ; la brique n'etait jamais retrouvee, et le lemming tombait.
        call    @built_key
        lda     @build_n
        mov     A,B
        lda     @bkey
        sta     @build_key(B)
        lda     @d_col
        sta     @build_col(B)
        lda     @bt_arg
        sta     @build_tile(B)
        lda     @build_n
        inc     A
        sta     @build_n
        lda     @bkey                   ; marque la rangee pour le filtre
        and     %7,A                    ; rapide de built_test
        mov     A,B
        lda     @bit_tbl(B)
        mov     A,TEMP5
        lda     @bkey
        rr      A
        rr      A
        rr      A
        and     %$1F,A
        mov     A,B
        lda     @built_rows(B)
        or      TEMP5,A
        sta     @built_rows(B)
        rets

; masque d'un bit : bit_tbl(n) = 1 << n
bit_tbl:
        .byte   $01,$02,$04,$08,$10,$20,$40,$80

; --- une marche d'escalier fraichement sondee (via pix_solid, qui laisse
; l'index trouve dans tid) est-elle franchissable pour CE lemming, selon
; SON propre sens de marche ? Sortie : A = 0 si c'est un mur (marche
; construite dans le sens oppose), A != 0 sinon (bon sens, OU tuile
; ordinaire qui n'a aucune notion de sens).
; Sans ce controle, un escalier construit dans un sens etait grimpe tout
; aussi lissement dans l'AUTRE sens (chaque marche, prise isolement, reste
; sous MAX_STEP_UP) -- alors qu'un escalier ne devrait bloquer, comme un
; vrai mur, que ceux qui l'abordent a contresens.
stair_dir_ok:
        lda     @tid
        cmp     %TILE_MARCHEA,A
        jeq     @sdo_right
        cmp     %TILE_MARCHEB,A
        jeq     @sdo_right
        cmp     %TILE_MARCHEC,A
        jeq     @sdo_right
        lda     @tid
        cmp     %TILE_MARCHEAG,A
        jeq     @sdo_left
        cmp     %TILE_MARCHEBG,A
        jeq     @sdo_left
        cmp     %TILE_MARCHECG,A
        jeq     @sdo_left
        mov     %1,A                    ; tuile ordinaire : toujours ok
        rets
sdo_right:
        ; construite pour un lemming qui avance vers la DROITE (lem_dir=0)
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        jne     @sdo_no
        mov     %1,A
        rets
sdo_left:
        ; construite pour un lemming qui avance vers la GAUCHE (lem_dir!=0)
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        jeq     @sdo_no
        mov     %1,A
        rets
sdo_no:
        clr     A
        rets

; --- cette case a-t-elle ete creusee ? Sortie : A != 0 si oui --------------
dig_test:
        call    @dig_locate
        lda     *TEMP3
        mov     A,TEMP6
        lda     @dig_mask
        and     TEMP6,A
        rets

; --- marque la case comme creusee -----------------------------------------
dig_set:
        clr     A                       ; le terrain change : le cache de
        sta     @rtc_valid              ; rect_tileptr devient faux

        ; --- une tuile POSEE, si elle existe pour cette case, doit AUSSI
        ; etre "detruite" ici. ERREUR DE CONCEPTION EVITEE : built_test
        ; passe toujours avant dig_test dans tile_flags_at/pix_solid --
        ; poser simplement le bit de creusement n'aurait donc RIEN change
        ; pour une case construite : elle serait restee visuellement et
        ; physiquement intacte, meme apres une explosion sur une marche
        ; d'escalier destructible. On bascule donc directement son entree
        ; construite vers la tuile "vide" (index 0) : les lectures futures
        ; la trouveront toujours via built_test (l'entree reste dans la
        ; liste), mais liront desormais des donnees vides -- exactement
        ; comme si elle avait ete creusee. built_test ne modifie jamais
        ; d_col (verifie), aucune sauvegarde necessaire.
        call    @built_test
        jeq     @ds_notbuilt
        lda     @bt_found
        mov     A,B
        clr     A
        sta     @build_tile(B)
        rets                            ; case construite : c'est fait, pas
                                        ; besoin de toucher le bitmap creuse
ds_notbuilt:
        call    @dig_locate
        lda     *TEMP3
        mov     A,TEMP6
        lda     @dig_mask
        or      TEMP6,A
        sta     *TEMP3
        rets

; --- efface toute la couche au demarrage -----------------------------------
dig_clear_all:
        mov     %dig_map>>8,A
        mov     A,TEMP1-1
        mov     %dig_map&$FF,A
        mov     A,TEMP1
        mov     %3,TEMP5                ; les 3 ecrans possibles (place en
dca_scr:                                ; SRAM : 3 x DIG_BYTES_SCR)
        mov     %DIG_BYTES_SCR,TEMP6
dca_byte:
        clr     A
        sta     *TEMP1
        inc     TEMP1
        adc     %0,TEMP1-1
        djnz    TEMP6,@dca_byte
        djnz    TEMP5,@dca_scr
        rets

; ============================================================================
; tile_flags_at -- proprietes de la tuile situee en (r_xseg, r_yline) sur
; l'ecran map_screen. Sortie : A = octet de lv_flags.
; Une case marquee comme creusee est vue comme VIDE, quelle que soit la
; tuile d'origine dans la carte ROM.
; ============================================================================
tile_flags_at:
        call    @rect_rowline           ; r_yline -> q_row, q_line
        lda     @r_xseg
        sta     @d_col
        call    @built_test             ; une tuile POSEE prime sur tout :
        jeq     @tfa_nobuild            ; on construit apres avoir creuse
        lda     @bt_found               ; QUELLE tuile : plus toujours
        mov     A,B                     ; BUILD_TILE (marches d'escalier)
        lda     @build_tile(B)
        mov     A,B
        call    @tile_flags_B
        rets
tfa_nobuild:
        call    @dig_test
        jeq     @tfa_map
        clr     A                       ; creusee : ni solide ni destructible
        rets
tfa_map:
        clr     A
        call    @rect_mapptr            ; TEMP2 = case (q_row, r_xseg)
        lda     *TEMP2
        mov     A,B
        call    @tile_flags_B
        rets

; --- B = indice de tuile -> A = ses proprietes, dans le THEME du niveau.
; La table n'est plus a une adresse fixe (un theme par groupe de niveaux) :
; lecture indirecte par TEMP2, que tile_flags_at n'utilisait deja plus
; apres la lecture de la carte (aucun appelant ne le relit, verifie).
tile_flags_B:
        lda     @flags_hi
        mov     A,TEMP2-1
        lda     @flags_lo
        add     B,A
        jnc     @tfb_nc                 ; retenue lue AVANT tout LDA/MOV
        inc     TEMP2-1
tfb_nc:
        mov     A,TEMP2
        lda     *TEMP2
        rets

; ============================================================================
; surface_find -- ou se poserait le lemming cur_lem s'il avancait dans le
; segment r_xseg ?
; Sortie : A = 0  mur infranchissable (demi-tour)
;          A = 1  praticable, sf_y contient la nouvelle valeur de lem_y
;          A = 2  aucun sol a portee : il tombe
;
; On part de la ligne juste sous ses pieds :
;   - si elle est solide, on REMONTE tant qu'elle l'est (pente montante ou
;     marche), dans la limite de MAX_STEP_UP ;
;   - sinon on DESCEND tant qu'elle est vide (pente descendante ou creux),
;     dans la limite de MAX_STEP_DOWN.
; Les pieds se posent juste au-dessus du premier pixel solide trouve.
; ============================================================================
surface_find:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A           ; premiere ligne sous ses pieds
        sta     @sf_base
        sta     @sf_s
        sta     @r_yline
        call    @pix_solid
        jeq     @sf_base_empty          ; rien a la base : chercher plus haut
        ; --- solide directement a la base : MEME controle de sens que dans
        ; la boucle de recherche plus bas. ERREUR DE CONCEPTION CORRIGEE :
        ; ce test-ci, le tout premier de surface_find, sautait directement
        ; a sf_up SANS jamais passer par stair_dir_ok -- un lemming qui
        ; REDESCEND un escalier a contresens a, a chaque pas, sa hauteur
        ; ACTUELLE qui correspond DEJA a la marche suivante : elle est
        ; trouvee ICI, pas dans la boucle de recherche vers le haut, et
        ; traversait donc l'escalier sans jamais etre bloque.
        call    @stair_dir_ok
        jeq     @sf_wrongdir
        br      @sf_up                  ; deja du sol : chercher son sommet
sf_base_empty:

        ; --- rien au niveau de base : une marche PLUS HAUTE existe peut-
        ; etre juste au-dessus (une brique de montee, sans rien en dessous
        ; d'elle a cette colonne precise -- exactement le cas d'une marche
        ; d'escalier qui n'est pas adossee au sol naturel).
        ; ERREUR DE CONCEPTION CORRIGEE : une premiere version, ne trouvant
        ; rien a la base, concluait DIRECTEMENT a une chute sans jamais
        ; regarder vers le haut. La premiere marche d'un escalier passait
        ; par chance (le sol naturel existe encore en dessous d'elle), mais
        ; la deuxieme -- une plateforme isolee, sans rien en dessous a sa
        ; propre colonne -- n'etait jamais retrouvee.
        mov     %MAX_STEP_UP,A
        sta     @sf_ctr
sf_probe_up:
        lda     @sf_s
        jne     @sf_probe_up_in
        br      @sf_go_down             ; haut de l'ecran : rien trouve
sf_probe_up_in:
        dec     A
        sta     @sf_s
        sta     @r_yline
        call    @pix_solid
        jeq     @sf_pu_next             ; rien ici : continue normalement
        ; --- solide trouve : est-ce une marche construite dans le SENS
        ; OPPOSE a celui dans lequel ce lemming marche ? Si oui, ce n'est
        ; PAS une marche franchissable pour lui -- c'est un mur, et un vrai
        ; mur (pas une chute) : il ne doit pas continuer a chercher plus
        ; haut, ni redescendre chercher un autre chemin, sinon il se met a
        ; grimper ou tomber sur une brique censee le bloquer net.
        call    @stair_dir_ok
        jeq     @sf_wrongdir
        lda     @sf_s                   ; bon sens (ou tuile ordinaire) :
        sta     @sf_ovh                 ; grimper jusqu'a son sommet, comme
        call    @sf_up                  ; avant (meme boucle, budget neuf --
        jeq     @sf_under               ; une brique ne fait jamais plus
        rets                            ; d'une tuile de haut). A=1 : marche
sf_under:
        ; --- trop haut pour etre gravi : ce n'est pas une marche mais le
        ; DESSOUS d'un surplomb (bas d'une colonne qui s'arrete au-dessus du
        ; sol, plafond d'un tunnel...). Il passe DESSOUS si le sol, plus bas,
        ; laisse sa tete sous ce surplomb. ERREUR CORRIGEE : sans ce test, un
        ; lemming monte d'1 px sur une tuile au sol plus haut que ses
        ; voisines voyait, des deux cotes, le bas des colonnes voisines a
        ; hauteur de sa tete : demi-tour a chaque pas, prisonnier sur place.
        call    @sf_go_down
        cmp     %1,A
        jeq     @sf_under_chk
        clr     A                       ; rien a portee dessous : mur (sa
        rets                            ; tete resterait dans le surplomb)
sf_under_chk:
        lda     @sf_y                   ; nouveau haut de sa tete, plus bas
        cmpa    @sf_ovh                 ; que le bas du surplomb ?
        jeq     @sf_under_no
        jc      @sf_under_ok            ; jc : sf_y > sf_ovh
sf_under_no:
        clr     A
        rets
sf_under_ok:
        mov     %1,A
        rets
sf_wrongdir:
        clr     A
        rets                            ; mur : mauvais sens de construction
sf_pu_next:
        lda     @sf_ctr
        dec     A
        sta     @sf_ctr
        jne     @sf_probe_up
        ; tombe ici : rien trouve dans la plage de recherche vers le haut

sf_go_down:
        ; --- rien a la base ni au-dessus : on descend --------------------
        ; NOTE : les deux sorties "chute" posent sf_y = lem_y actuel
        ; (inchange) -- lw_p_move l'utilise pour avancer a niveau constant,
        ; laissant lem_supported declencher la chute au prochain pas.
        lda     @sf_base
        sta     @sf_s
        mov     %MAX_STEP_DOWN,A
        sta     @sf_ctr
sf_down:
        lda     @sf_s
        inc     A
        cmp     %GRAPH_LINES,A
        jnc     @sf_down_in
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @sf_y
        mov     %2,A
        rets                            ; bas de l'ecran : il tombe
sf_down_in:
        sta     @sf_s
        sta     @r_yline
        call    @pix_solid
        jeq     @sf_down_next           ; rien ici : continue de descendre
        ; --- meme controle de sens qu'a la base et en montant : un
        ; lemming qui REDESCEND un escalier a contresens rencontre ses
        ; marches ICI aussi (une petite marche en dessous de lui, pas
        ; directement a sa hauteur) -- sans ce controle, il continuait de
        ; descendre a travers l'escalier entier sans jamais etre bloque.
        call    @stair_dir_ok
        jeq     @sf_wrongdir
        br      @sf_hit
sf_down_next:
        lda     @sf_ctr
        dec     A
        sta     @sf_ctr
        jne     @sf_down
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @sf_y
        mov     %2,A
        rets                            ; rien a portee : il tombe

        ; --- du sol sous ses pieds (ou trouve en remontant) : on continue
        ; de remonter tant qu'il y en a --------------------------------
sf_up:
        mov     %MAX_STEP_UP_N,A
        sta     @sf_ctr
sf_up_loop:
        lda     @sf_s
        jne     @sf_up_in
        clr     A
        rets                            ; haut de l'ecran : mur
sf_up_in:
        dec     A
        sta     @r_yline
        call    @pix_solid
        jeq     @sf_hit                 ; vide : le sommet est juste dessous
        lda     @r_yline                ; encore solide : on continue
        sta     @sf_s
        lda     @sf_ctr
        dec     A
        sta     @sf_ctr
        jne     @sf_up_loop
        clr     A
        rets                            ; trop haut : c'est un mur

sf_hit:
        ; sf_s = premiere ligne SOLIDE ; les pieds se posent juste au-dessus
        lda     @sf_s
        sub     %LEM_HLINES,A
        sta     @sf_y
        mov     %1,A
        rets

; ============================================================================
; blocker_at -- un BLOQUEUR occupe-t-il la colonne blk_col, sur le meme
; ecran et a la meme hauteur que le lemming cur_lem ?
; Sortie : A != 0 si oui.
; Le lemming qui pose la question est evidemment exclu de la recherche.
; ============================================================================
blocker_at:
        lda     @cur_lem
        sta     @blk_self
        mov     A,B
        lda     @lem_screen(B)
        sta     @blk_scr
        lda     @blk_self
        mov     A,B
        lda     @lem_y(B)
        sta     @blk_y
        clr     A
        sta     @blk_i
ba_loop:
        lda     @blk_i
        cmpa    @blk_self
        jeq     @ba_next                ; lui-meme
        mov     A,B
        lda     @lem_alive(B)
        jeq     @ba_next
        lda     @blk_i
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_BLOCK,A
        jne     @ba_next                ; pas un bloqueur
        lda     @blk_i
        mov     A,B
        lda     @lem_screen(B)
        cmpa    @blk_scr
        jne     @ba_next
        lda     @blk_i
        mov     A,B
        lda     @lem_xseg(B)
        cmpa    @blk_col
        jne     @ba_next                ; pas dans la colonne visee
        ; recouvrement vertical : les deux sprites font LEM_HLINES de haut
        lda     @blk_i
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        mov     A,TEMP4
        lda     @blk_y
        cmp     TEMP4,A
        jc      @ba_next                ; marcheur entierement en dessous
        lda     @blk_y
        add     %LEM_HLINES,A
        mov     A,TEMP4
        lda     @blk_i
        mov     A,B
        lda     @lem_y(B)
        cmp     TEMP4,A
        jc      @ba_next                ; entierement au-dessus
        mov     %1,A
        rets                            ; bloque
ba_next:
        lda     @blk_i
        inc     A
        sta     @blk_i
        cmp     %NUM_LEM,A
        jne     @ba_loop
        clr     A
        rets

; ============================================================================
; pix_solid -- le terrain est-il solide sous le corps du lemming, a la ligne
; r_yline et dans le segment r_xseg, sur l'ecran map_screen ?
; Sortie : A != 0 si oui.
;
; Lit les PIXELS de la tuile, pas ses proprietes : un pixel est solide si
; l'un des trois plans a son bit a 1 (couleur differente du noir). Les trois
; plans sont combines par OU, puis masques par PROBE_MASK.
; Une tuile creusee est vide, une tuile posee vaut BUILD_TILE -- memes
; regles de resolution qu'a l'affichage.
; ============================================================================
pix_solid:
        call    @rect_rowline           ; r_yline -> q_row, q_line
        lda     @r_xseg
        sta     @d_col
        call    @built_test
        jeq     @ps_nobuild
        lda     @bt_found               ; QUELLE tuile : plus toujours
        mov     A,B                     ; BUILD_TILE (marches d'escalier)
        lda     @build_tile(B)
        sta     @tid
        br      @ps_data
ps_nobuild:
        call    @dig_test
        jeq     @ps_map
        clr     A
        rets                            ; creusee : entierement vide
ps_map:
        clr     A
        call    @rect_mapptr
        lda     *TEMP2
        sta     @tid
ps_data:
        ; adresse = lv_tiles + tid*LV_TILE_BYTES + q_line*3
        lda     @tid
        mpy     %LV_TILE_BYTES,A
        mov     A,TEMP6
        mov     B,TEMP7
        lda     @tiles_hi
        mov     A,TEMP1-1
        lda     @tiles_lo               ; tuiles du theme du niveau
        mov     A,TEMP1
        add     TEMP7,TEMP1
        adc     TEMP6,TEMP1-1
        lda     @q_line                 ; + q_line*3
        mov     A,B
        add     B,A
        add     B,A
        mov     A,TEMP7
        clr     A
        mov     A,TEMP6
        add     TEMP7,TEMP1
        adc     TEMP6,TEMP1-1

        lda     *TEMP1                  ; plan Bleu
        mov     A,TEMP8
        inc     TEMP1
        adc     %0,TEMP1-1
        lda     *TEMP1                  ; plan Vert
        or      TEMP8,A
        mov     A,TEMP8
        inc     TEMP1
        adc     %0,TEMP1-1
        lda     *TEMP1                  ; plan Rouge
        or      TEMP8,A
        and     %PROBE_MASK,A           ; sous le corps seulement
        rets

; ============================================================================
; lem_supported -- le lemming cur_lem a-t-il du sol sous les pieds ?
; Sortie : A != 0 si oui.
;
; On ne teste QU'UN seul segment, celui de sa position (lem_xseg).
; Le sprite fait 16 px de large, donc a cheval sur deux segments ; une
; premiere version le considerait supporte des que l'UN des deux reposait
; sur du solide. Conséquence : un puits d'une seule tuile de large ne
; pouvait jamais l'avaler, il l'enjambait systematiquement.
; Avec un seul segment teste, il tombe dans un trou d'une tuile -- au prix
; d'un chevauchement visuel : la moitie du sprite se retrouve alors dans la
; paroi. C'est le compromis habituel des portages de Lemmings sur grille de
; tuiles, ou la chute depend du centre du personnage et non de sa largeur.
; ============================================================================
lem_supported:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen             ; la carte de SON ecran, pas celle
                                        ; affichee : il peut marcher hors champ
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A           ; premiere ligne SOUS ses pieds
        cmp     %GRAPH_LINES,A
        jnc     @lsup_inside
        mov     %1,A                    ; sous le bas de l'ecran : on
        rets                            ; considere qu'il y a un sol
lsup_inside:
        sta     @r_yline
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        call    @pix_solid              ; au PIXEL, plus par tuile : il peut
        rets                            ; donc s'enfoncer dans les pixels
                                        ; noirs du haut d'une tuile

; --- un pas de marche pour le lemming cur_lem.
; ORDRE VOULU : on dessine le sprite a sa NOUVELLE position d'abord, puis on
; efface seulement la colonne laissee derriere. Le sprite n'est donc jamais
; absent de l'ecran, meme un instant -- c'est ce qui supprime le
; clignotement ("produire la ligne finale avant l'ecriture VRAM").
lem_step:
        lda     @cur_lem
        mov     A,B
        lda     @lem_alive(B)
        jne     @lst_go
        rets                            ; pas encore apparu
lst_go:
        ; --- memorise la position de depart (les deux axes : la chute
        ; deplace en Y, la marche en X) --------------------------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @lem_old_xseg(B)
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @lem_old_y(B)

        ; --- mort : on laisse jouer l'animation, puis le corps disparait --
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_DEAD,A
        jeq     @lst_isdead
        cmp     %ST_BOOM,A              ; meme traitement : animer, puis
        jne     @lst_notdead            ; effacer le corps
lst_isdead:
        br      @lst_dead
lst_notdead:
        ; --- sortie atteinte ? Verifiee ICI, avant TOUTE autre activite --
        ; un lemming qui creuse, construit ou porte un compte a rebours
        ; doit etre sauve tout autant qu'un simple marcheur s'il finit par
        ; se trouver sur cette tuile. pix_solid laisse toujours l'index
        ; de la tuile resolue dans tid, qu'elle vienne du terrain naturel
        ; ou d'une case construite -- son propre resultat de solidite (A)
        ; ne nous interesse pas ici, seul tid compte.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        sta     @r_yline
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        call    @pix_solid
        lda     @tid
        cmp     %TILE_SORTIE,A
        jeq     @lst_saved
        br      @lst_nosortie
lst_saved:
        ; --- efface le sprite PENDANT que lem_alive vaut encore 1 :
        ; bg_erase_if_visible verifie cet indicateur avant de dessiner --
        ; exactement le meme ordre que la disparition du corps apres une
        ; mort (lsdd_gone).
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible
        lda     @saved_count
        inc     A
        sta     @saved_count
        call    @draw_saved_count       ; met a jour l'affichage tout de suite
        lda     @cur_lem
        mov     A,B
        clr     A
        sta     @lem_alive(B)
        rets
lst_nosortie:

        ; --- compte a rebours du kamikaze. Le lemming continue son activite
        ; normalement pendant ce temps : marcher, creuser, tomber.
        lda     @cur_lem
        mov     A,B
        lda     @lem_bomb(B)
        jeq     @lst_nobomb
        dec     A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_bomb(B)
        jne     @lst_nobomb
        br      @lem_explode            ; zero : il explose maintenant
lst_nobomb:

        ; --- creuseur : il descend en supprimant la tuile sous ses pieds ---
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_DIG,A
        jne     @lst_notdig
        br      @lst_dig
lst_notdig:
        cmp     %ST_CLIMB,A             ; accroche a une paroi : AVANT le test
        jne     @lst_notclimb           ; de sol, qui le ferait tomber (il n'a
        br      @lst_climb              ; rien sous les pieds)
lst_notclimb:

        ; --- plus de sol sous les pieds : il tombe --------------------------
        call    @lem_supported
        jeq     @lst_nofloor            ; jne @lst_grounded etait hors de
        br      @lst_grounded           ; portee depuis l'ajout du bloc de
lst_nofloor:                            ; creusement : test inverse + br
        ; ATTENTION : ce code est traverse a CHAQUE pas tant que le lemming
        ; n'a pas de sol, pas seulement au debut de la chute. Il ne faut
        ; donc reinitialiser que si l'etat CHANGE reellement -- sinon la
        ; distance parcourue repart de zero a chaque pas, ne depasse jamais
        ; le seuil, et le lemming ne meurt jamais, quelle que soit la
        ; hauteur. L'animation redemarrait au passage, elle aussi.
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_FALL,A
        jne     @lst_chkfloat
        br      @lst_fall               ; deja en chute libre : on poursuit
lst_chkfloat:
        cmp     %ST_FLOAT,A
        jne     @lst_newfall
        br      @lst_fall               ; deja en parachute : on poursuit
lst_newfall:
        ; Toute chute commence en chute LIBRE, parachutiste compris : son
        ; parachute s'ouvre dans lst_fall, seulement si la chute depasse
        ; FLOAT_OPEN lignes. Avant, il s'ouvrait des la premiere ligne, y
        ; compris pour chaque marche de 10 px d'un tunnel de mineur.
lst_freefall:
        mov     %ST_FALL,A
lst_setfall:
        call    @lem_set_state          ; remet aussi l'animation au debut
        lda     @cur_lem                ; nouvelle chute : distance a zero
        mov     A,B
        clr     A
        sta     @lem_fall(B)
        ; BRANCHEMENT EXPLICITE, indispensable : ce code comptait autrefois
        ; sur un simple enchainement vers lst_fall, qui le suivait
        ; immediatement. Les blocs lst_dead et lst_dig ont depuis ete
        ; inseres entre les deux -- le lemming passait en etat de chute puis
        ; executait le code de la MORT, qui ne fait qu'animer et dessiner.
        br      @lst_fall
lst_dead:
        ; Le corps reste visible le temps de l'animation, puis disparait.
        ; lem_fall sert ici de compte a rebours (il n'a plus a mesurer de
        ; distance, le lemming ne tombera plus).
        call    @lem_anim_next
        call    @lem_draw
        lda     @cur_lem
        mov     A,B
        lda     @lem_fall(B)
        jeq     @lsdd_gone              ; deja a zero : plus rien a faire
        dec     A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_fall(B)
        jne     @lsdd_gone              ; pas encore : on laisse le corps
        ; --- fin du decompte : on efface le corps et on libere la place ---
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible    ; encore "alive" a cet instant, donc
                                        ; l'effacement a bien lieu
        lda     @cur_lem
        mov     A,B
        clr     A
        sta     @lem_alive(B)
lsdd_gone:
        rets

lst_build:
        ; Escalier en coin, BUILD_STEPS briques : chacune avance d'une
        ; colonne et monte d'une tuile complete (voir plus bas, "ESCALIER
        ; EN COIN", pour la geometrie A/B/C).
        ;
        ; ERREUR DE CONCEPTION CORRIGEE : une premiere version verifiait,
        ; pour une brique A PLAT, la case AU NIVEAU DU SOL ACTUEL -- qui,
        ; sur un terrain ordinaire, est DEJA de la terre. Le code prenait
        ; ca pour un mur et arretait la construction des la premiere
        ; brique, sur n'importe quel sol normal.
        ; Le vrai principe du constructeur (comme dans l'original) : il
        ; pose sa brique et monte dessus SANS se soucier de ce qu'il y a
        ; deja en dessous -- c'est ce qui lui permet de franchir un mur en
        ; construisant par-dessus. Le seul obstacle reel est un mur A
        ; HAUTEUR DU CORPS, exactement comme pour la marche normale.
        ; --- colonne ET ecran vises : le terrain s'etend continument sur
        ; plusieurs ecrans (une seule limitation materielle de l'EXL100,
        ; pas une frontiere du terrain) -- comme le fait deja la marche
        ; normale, le constructeur doit donc pouvoir continuer sur l'ecran
        ; suivant/precedent plutot que de traiter le bord d'ecran comme un
        ; mur permanent. new_scr est la MEME variable globale qu'utilise
        ; deja entry_blocked pour la marche normale.
        lda     @cur_lem                ; colonne visee, selon le sens
        mov     A,B
        lda     @lem_dir(B)
        jne     @lsc_left
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        inc     A
        cmp     %LEM_COLS,A
        jnc     @lsc_col                ; encore dans cet ecran
        ; --- bord droit : ecran suivant, s'il existe -----------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        inc     A
        cmpa    @cur_nscr               ; ecrans de CE niveau
        jnc     @lsc_rs_go
        br      @lsc_stop               ; dernier ecran : mur
lsc_rs_go:
        sta     @new_scr
        clr     A
        sta     @new_col
        br      @lsc_scrset
lsc_left:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        jne     @lsc_left_ok
        ; --- bord gauche : ecran precedent, s'il existe --------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        jne     @lsc_ls_go
        br      @lsc_stop               ; premier ecran : mur
lsc_ls_go:
        dec     A
        sta     @new_scr
        mov     %LEM_LAST_XSEG,A
        sta     @new_col
        br      @lsc_scrset
lsc_left_ok:
        dec     A
lsc_col:
        sta     @new_col                ; colonne de la brique ET d'arrivee
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @new_scr                ; meme ecran que sa position actuelle
lsc_scrset:
        lda     @new_scr
        sta     @map_screen             ; tout ce qui suit (mur, plafond,
                                        ; pose des briques) sonde CET ecran

        ; --- mur a hauteur du corps ? AU PIXEL PRES ------------------------
        ; ERREUR DE CONCEPTION CORRIGEE : tile_flags_at renvoie le drapeau
        ; GLOBAL de la tuile (lv_flags), sans jamais regarder QUELLE ligne
        ; interne est sondee. Pour une tuile partiellement pleine (une
        ; encoche, un relief fin), marquee "solide" dans son ensemble,
        ; tile_flags_at repondait TOUJOURS solide -- meme quand la ligne
        ; precisement sondee fait partie de sa portion VIDE. Le constructeur
        ; croyait donc buter sur un mur des qu'il approchait un tel relief,
        ; incapable d'y construire quoi que ce soit.
        ; pix_solid lit les VRAIS pixels a la ligne demandee, exactement
        ; comme le fait la marche normale -- meme precision, meme coherence.
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        lda     @new_col
        sta     @r_xseg
        call    @pix_solid
        jeq     @lsc_nowall
        br      @lsc_stop               ; "rencontre un mur"
lsc_nowall:

        ; --- ESCALIER EN COIN --------------------------------------------
        ; SIX briques (BUILD_STEPS), chacune une montee COMPLETE : la
        ; conception precedente etalait UNE tuile de hauteur sur trois
        ; marches progressives (3/7/10 px) ; celle-ci grimpe une tuile
        ; ENTIERE par brique, donc BUILD_STEPS=6 donne desormais un
        ; escalier de 6 tuiles de haut (60 px), pas 2.
        ; Nouvelle conception, plus simple que la precedente : le lemming
        ; foule A (deja au sol, tel quel -- rien ne le redessine, pour ne
        ; pas risquer de desaligner l'appui sur lequel il se trouve deja)
        ; puis grimpe DIRECTEMENT sur C. B, une rangee plus bas que C, MEME
        ; colonne, sert seulement d'appui invisible entre les deux -- le
        ; lemming ne le foule jamais. Chaque brique fait donc UNE montee
        ; complete de STAIR_DELTA_C pixels, colonne par colonne -- plus de
        ; sous-cycle a trois etats a gerer.
        ; La colonne visee (new_col) reflete DEJA le sens de marche (+1 ou
        ; -1, calcule plus haut) : cette logique fonctionne donc telle
        ; quelle dans les deux sens, sans rien coder de specifique.
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        sta     @r_yline                ; rangee de son appui ACTUEL (B)
        lda     @new_col
        sta     @r_xseg
        call    @rect_rowline
        lda     @q_row
        sta     @tmp_g                  ; sauvegarde IMMEDIATE, comme avant :
                                        ; les appels qui suivent (built_add,
                                        ; bg_erase_if_visible -> ... ->
                                        ; rect_tileptr -> rect_rowline)
                                        ; ecrasent q_row pour leur propre
                                        ; compte.

        ; --- haut de la carte : tmp_g-1 (la rangee visee, une tuile au-
        ; dessus) DOIT rester >= 0. Sans ce controle, tmp_g=0 donnerait
        ; tmp_g-1 = 255 en arithmetique non signee sur 8 bits -- une
        ; rangee totalement hors limites, potentiellement une ecriture
        ; n'importe ou en memoire. Un escalier construit plusieurs fois de
        ; suite (en reselectionnant le lemming en ST_WAIT) peut tout a
        ; fait finir par atteindre le sommet de la carte.
        lda     @tmp_g
        jne     @lsc_top_ok
        br      @lsc_stop               ; haut de la carte : mur
lsc_top_ok:

        ; --- plafond : la place au-dessus doit etre libre, AU PIXEL PRES --
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sub     %TILE_H_LINES,A
        sta     @r_yline
        lda     @new_col
        sta     @r_xseg
        call    @pix_solid
        jeq     @lsc_place
        br      @lsc_stop               ; "cogne sa tete contre un plafond"

lsc_place:
        ; --- premiere brique, ou suite du cycle B+C ? ----------------------
        ; A n'existe qu'UNE FOIS, au tout debut : le lemming grimpe DEPUIS
        ; le sol d'origine JUSQU'A A, une rangee au-dessus, a la colonne
        ; visee. Ensuite seulement commence le cycle repete B (a droite,
        ; MEME rangee que son appui actuel) puis C (au-dessus de B) --
        ; inchange depuis les versions precedentes. lem_build vaut encore
        ; BUILD_STEPS tant qu'aucune brique n'a ete posee : c'est ce qui
        ; distingue la premiere marche des suivantes, sans variable
        ; supplementaire a maintenir.
        lda     @cur_lem
        mov     A,B
        lda     @lem_build(B)
        cmp     %BUILD_STEPS,A
        jeq     @lsc_firstA
        br      @lsc_repeat

lsc_firstA:
        ; --- A : premiere marche, une rangee AU-DESSUS du sol de depart,
        ; a la colonne visee (new_col, pas sa colonne actuelle : il avance
        ; ET monte en une seule fois, ici).
        lda     @tmp_g
        dec     A
        sta     @q_row
        lda     @new_col
        sta     @d_col
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        jne     @lsc_ag
        mov     %TILE_MARCHEA,A
        br      @lsc_adone
lsc_ag:
        mov     %TILE_MARCHEAG,A
lsc_adone:
        call    @built_add

        ; Pas de comblement systematique sous A (retire a la demande) : le
        ; terrain naturel en dessous est suppose deja porter -- vrai sur un
        ; sol regulier, mais peut laisser un trou au-dessus d'un relief
        ; irregulier (une encoche, par exemple), comme celui rencontre et
        ; corrige pour le cycle B+C avant que B devienne pleine.

        ; efface la rangee de A (une seule, sans comblement)
        mov     %1,A
        sta     @r_wseg
        mov     %TILE_H_LINES,A
        sta     @r_hlines
        lda     @new_col
        sta     @r_xseg
        lda     @tmp_g
        dec     A
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        call    @bg_erase_if_visible

        ; hauteur : (tmp_g-1)*10 - STAIR_DELTA_A
        lda     @tmp_g
        dec     A
        mpy     %TILE_H_LINES,A
        mov     B,A
        mov     A,TEMP4
        mov     %STAIR_DELTA_A,A
        mov     A,B
        mov     TEMP4,A
        sub     B,A
        sta     @tmp_c
        br      @lsc_move

lsc_repeat:
        ; --- B : appui plein, MEME rangee que le sol actuel -----------------
        ; Meme raisonnement que pour C : marcheB a son propre decor, dont
        ; le sens visuel doit correspondre au sens de construction.
        lda     @tmp_g
        sta     @q_row
        lda     @new_col
        sta     @d_col
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        jne     @lsc_bg
        mov     %TILE_MARCHEB,A
        br      @lsc_bdone
lsc_bg:
        mov     %TILE_MARCHEBG,A
lsc_bdone:
        call    @built_add

        ; --- C : atterrissage, UNE rangee au-dessus, MEME colonne ----------
        ; La diagonale de marcheC penche visuellement dans un sens : vers
        ; la gauche (lem_dir != 0), il faut son miroir (marcheCG), sinon
        ; l'escalier semblerait pencher a l'envers par rapport au sens
        ; dans lequel le lemming construit. B n'a pas ce probleme : c'est
        ; un bloc plein, symetrique par nature.
        lda     @tmp_g
        dec     A
        sta     @q_row
        lda     @new_col
        sta     @d_col
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        jne     @lsc_cg
        mov     %TILE_MARCHEC,A
        br      @lsc_cdone
lsc_cg:
        mov     %TILE_MARCHECG,A
lsc_cdone:
        call    @built_add
        lda     @tmp_g                  ; revient a la rangee de B, pour ne
        sta     @q_row                  ; pas fausser le calcul qui suit

        ; --- efface sur DEUX rangees de tuiles (20 lignes) : B ET C ont
        ; toutes deux change d'etat, toutes deux doivent etre redessinees.
        mov     %1,A
        sta     @r_wseg
        mov     %TILE_H_LINES,A
        add     %TILE_H_LINES,A
        sta     @r_hlines
        lda     @tmp_g
        dec     A                       ; on part de la rangee de C (la
        mpy     %TILE_H_LINES,A         ; plus haute des deux) pour couvrir
        mov     B,A                     ; les deux d un seul rectangle
        sta     @r_yline
        call    @bg_erase_if_visible

        ; hauteur : (tmp_g-1)*10 - STAIR_DELTA_C
        lda     @tmp_g
        dec     A
        mpy     %TILE_H_LINES,A
        mov     B,A
        mov     A,TEMP4
        mov     %STAIR_DELTA_C,A
        mov     A,B
        mov     TEMP4,A
        sub     B,A
        sta     @tmp_c

lsc_move:
        ; --- il avance, et monte jusqu'a la hauteur calculee ci-dessus -----
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @lem_old_xseg(B)
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @lem_old_y(B)
        lda     @cur_lem
        mov     A,B
        lda     @new_col
        sta     @lem_xseg(B)
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_y(B)
        call    @lem_anim_next
        call    @lem_draw

        ; --- efface son ancienne position ---------------------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible

        ; --- franchit reellement l'ecran, maintenant que son ancienne
        ; position (sur l'ancien ecran) a ete effacee -- le meme ordre que
        ; lw_next_screen/lw_prev_screen pour la marche normale : l'effacer
        ; APRES aurait compare le NOUVEL ecran, et n'aurait rien efface.
        lda     @cur_lem
        mov     A,B
        lda     @new_scr
        sta     @lem_screen(B)

        ; --- marche suivante -----------------------------------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_build(B)
        dec     A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_build(B)
        jne     @lsc_done
        ; plus de briques : bras leves, en attente d'une reselection --
        ; DIFFERENT d'un obstacle (lsc_stop, plus bas), qui remet le
        ; lemming a marcher normalement.
        mov     %ST_WAIT,A
        call    @lem_set_state
        ; lem_build ne sert plus a rien (il vient d'atteindre 0) : on le
        ; reutilise comme compte a rebours de la pause, decompte dans
        ; lst_chkwait.
        lda     @cur_lem
        mov     A,B
        mov     %WAIT_STEPS,A
        sta     @lem_build(B)
        br      @lsc_done
lsc_stop:
        mov     %ST_WALK,A              ; obstacle en cours de route (mur,
                                        ; plafond) : reprend sa marche
        call    @lem_set_state
lsc_done:
        rets

lst_bash:
        ; Creuse a l'HORIZONTALE, dans son sens de marche. Regarde la tuile
        ; devant lui, a hauteur de ses pieds :
        ;   destructible -> il la retire et avance d'une colonne
        ;   acier        -> il renonce et repart a pied
        ;   deja vide    -> le tunnel debouche, il redevient marcheur
        ; (dans le jeu d'origine, un frappeur qui perce s'arrete la)
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline

        lda     @cur_lem                ; colonne visee selon le sens
        mov     A,B
        lda     @lem_dir(B)
        jne     @lsb_left
        lda     @cur_lem                ; vers la droite
        mov     A,B
        lda     @lem_xseg(B)
        inc     A
        cmp     %LEM_COLS,A
        jnc     @lsb_col
        br      @lsb_next_scr           ; bord droit : il poursuit son tunnel
                                        ; sur l'ecran suivant
lsb_left:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        jne     @lsb_left_ok
        br      @lsb_prev_scr           ; bord gauche : ecran precedent
lsb_left_ok:
        dec     A
lsb_col:
        sta     @r_xseg
        call    @bash_has_wall          ; des PIXELS devant lui, a hauteur du
        jne     @lsb_haswall            ; corps ? Sinon il a perce : il
        br      @lsb_stop               ; redevient marcheur
lsb_haswall:
        call    @tile_flags_at
        mov     A,TEMP4
        and     %TILE_SOLID,A
        jne     @lsb_chkdig             ; les deux sauts vers lsb_stop sont
        br      @lsb_stop               ; hors de portee depuis l'ajout des
lsb_chkdig:                             ; transitions d'ecran : test inverse
        mov     TEMP4,A                 ; + br
        and     %TILE_DIG,A
        jne     @lsb_go
        br      @lsb_stop               ; acier : indestructible
lsb_go:

        call    @rect_rowline           ; retire la tuile
        lda     @r_xseg
        sta     @d_col
        call    @dig_set
        mov     %1,A                    ; et redessine cette seule case
        sta     @r_wseg
        mov     %TILE_H_LINES,A
        sta     @r_hlines
        lda     @q_row                  ; le rectangle part du HAUT de la
        mpy     %TILE_H_LINES,A         ; tuile, pas de la ligne des pieds
        mov     B,A
        sta     @r_yline
        call    @bg_erase_if_visible

        ; --- avance d'une colonne, dans la case qu'il vient de vider ------
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @lem_old_xseg(B)
        lda     @lem_y(B)
        sta     @lem_old_y(B)
        ; il se POSE sur le sol de la case videe (petite pente, comme en
        ; marchant). Sans cela, partir d'un sol 1 px plus haut que la case
        ; suivante le laissait en l'air : il tombait d'1 px, et la chute
        ; mettait fin a son travail au milieu d'un mur. Une vraie chute (trou
        ; sous le tunnel) garde sa hauteur : il tombera, comme avant.
        call    @surface_find           ; colonne r_xseg (la case videe)
        cmp     %1,A
        jne     @lsb_keep_y
        lda     @sf_y
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_y(B)
lsb_keep_y:
        lda     @r_xseg                 ; la colonne visee, deja calculee
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_xseg(B)
        call    @lem_anim_next
        call    @lem_draw               ; nouvelle position d'abord

        lda     @cur_lem                ; puis la colonne laissee derriere
        mov     A,B
        lda     @lem_old_xseg(B)
        sta     @r_xseg
        mov     %1,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_y(B)           ; ancienne case : ancienne hauteur
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible
        rets
; --- le tunnel traverse le bord de l'ecran ---------------------------------
; Le frappeur ne s'arrete plus au bord : il continue sur l'ecran voisin, a
; la meme hauteur. Comme pour la marche, l'effacement de l'ancienne
; position doit avoir lieu AVANT de changer lem_screen, sinon la garde de
; bg_erase_if_visible compare le nouvel ecran et n'efface rien.
lsb_next_scr:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        inc     A
        cmpa    @cur_nscr               ; ecrans de CE niveau
        jnc     @lsb_next_ok
        br      @lsb_stop               ; dernier ecran : plus rien apres
lsb_next_ok:
        sta     @new_scr                ; PAS tmp_c : l'effacement passe par
        clr     A                       ; rect_mapptr, qui s'en sert
        sta     @new_col                ; il reprend au bord gauche
        br      @lsb_switch

lsb_prev_scr:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        jne     @lsb_prev_ok
        br      @lsb_stop               ; premier ecran : rien avant
lsb_prev_ok:
        dec     A
        sta     @new_scr
        mov     %LEM_LAST_XSEG,A        ; il reprend au bord droit
        sta     @new_col

lsb_switch:
        ; --- regarde D'ABORD la case d'arrivee, dans la carte de l'ecran
        ; voisin : il ne traverse que s'il y a vraiment de la terre a
        ; frapper. Avant, il changeait d'ecran puis regardait : de l'acier
        ; en premiere colonne le laissait dessine DANS l'acier, et une
        ; colonne deja vide le faisait "frapper" dans le vide -- sur un
        ; meme ecran, les deux cas l'arretent (lsb_stop).
        lda     @new_scr
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        lda     @new_col
        sta     @r_xseg
        call    @bash_has_wall          ; (voir lsb_col)
        jne     @lsb_sw_px
        br      @lsb_stop               ; vide : plus rien a frapper
lsb_sw_px:
        call    @tile_flags_at
        mov     A,TEMP4
        and     %TILE_SOLID,A
        jne     @lsb_sw_solid
        br      @lsb_stop               ; vide : plus rien a frapper
lsb_sw_solid:
        mov     TEMP4,A
        and     %TILE_DIG,A
        jne     @lsb_sw_go
        br      @lsb_stop               ; acier : il s'arrete de ce cote-ci
lsb_sw_go:
        call    @lsb_erase_here         ; efface AVANT de changer d'ecran
        lda     @cur_lem
        mov     A,B
        lda     @new_scr
        sta     @lem_screen(B)
        lda     @cur_lem
        mov     A,B
        lda     @new_col
        sta     @lem_xseg(B)
        lda     @new_scr                ; retire la tuile (map_screen est deja
        sta     @map_screen             ; l'ecran d'arrivee)
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        lda     @new_col
        sta     @r_xseg
        call    @rect_rowline
        lda     @r_xseg
        sta     @d_col
        call    @dig_set
        mov     %1,A
        sta     @r_wseg
        mov     %TILE_H_LINES,A
        sta     @r_hlines
        lda     @q_row
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        call    @bg_erase_if_visible
        call    @lem_anim_next
        call    @lem_draw
        rets
; --- y a-t-il VRAIMENT un mur devant le frappeur ? Des pixels dans la colonne
; r_xseg (ecran map_screen), a hauteur de son corps : 3 lignes sondees (haut,
; milieu, bas du corps). Rend A != 0 si oui ; r_yline est remis sur la ligne
; de ses pieds pour la suite. POURQUOI : les proprietes seules ne suffisent
; pas -- une tuile importee d'une image est "solide" par defaut, meme toute
; noire (ciel) ou reduite a une ligne de sol. Le frappeur y "creusait" du
; vide au lieu de s'arreter, comme il le fait dans l'original, une fois le
; mur perce.
bash_has_wall:
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %2,A
        sta     @r_yline
        call    @pix_solid
        jne     @bhw_yes
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %5,A
        sta     @r_yline
        call    @pix_solid
        jne     @bhw_yes
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %8,A
        sta     @r_yline
        call    @pix_solid
        jne     @bhw_yes
        call    @bhw_foot
        clr     A
        rets
bhw_yes:
        call    @bhw_foot
        mov     %1,A
        rets
bhw_foot:
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        rets

lsb_erase_here:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible
        rets

lsb_stop:
        mov     %ST_WALK,A              ; il redevient un simple marcheur
        call    @lem_set_state
        rets

lst_dig:
        ; Regarde la tuile sous ses pieds :
        ;   destructible -> on la marque creusee et on redessine la case
        ;   solide non destructible (acier) -> il renonce et repart a pied
        ;   deja vide -> rien a retirer, il continue simplement a descendre
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        cmp     %GRAPH_LINES,A
        jnc     @lsd_inside
        br      @lsd_stop               ; bas de l'ecran : on arrete
lsd_inside:
        sta     @r_yline
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        call    @tile_flags_at
        mov     A,TEMP4
        and     %TILE_SOLID,A
        jeq     @lsd_descend            ; deja vide : il descend
        mov     TEMP4,A
        and     %TILE_DIG,A
        jeq     @lsd_stop               ; acier : indestructible
        call    @rect_rowline           ; marque la case comme creusee
        lda     @r_xseg
        sta     @d_col
        call    @dig_set
        mov     %1,A                    ; et redessine cette seule case
        sta     @r_wseg
        mov     %TILE_H_LINES,A
        sta     @r_hlines
        lda     @q_row                  ; le rectangle doit commencer au HAUT
        mpy     %TILE_H_LINES,A         ; de la tuile, pas a la ligne des
        mov     B,A                     ; pieds
        sta     @r_yline
        call    @bg_erase_if_visible
lsd_descend:
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %FALL_STEP,A
        mov     A,TEMP4
        mov     %LEM_MAX_Y,A
        cmp     TEMP4,A
        jnc     @lsd_clamp
        mov     TEMP4,A
        br      @lsd_set
lsd_clamp:
        mov     %LEM_MAX_Y,A
lsd_set:
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_y(B)
        call    @lem_anim_next          ; le creuseur s'anime aussi
        call    @lem_draw
        lda     @cur_lem                ; bande decouverte au-dessus
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_y(B)
        sta     @r_yline
        mov     %FALL_STEP,A
        sta     @r_hlines
        call    @bg_erase_if_visible
        rets
lsd_stop:
        mov     %ST_WALK,A              ; il redevient un simple marcheur
        call    @lem_set_state
        rets

lst_fall:
        ; --- parachutiste en chute libre depuis plus de FLOAT_OPEN lignes :
        ; le parachute s'ouvre, et la distance deja parcourue est annulee
        ; (elle ne compte plus pour une chute mortelle).
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_FALL,A
        jne     @lstf_open_done
        lda     @lem_float(B)
        and     %EQUIP_FLOAT,A
        jeq     @lstf_open_done
        lda     @lem_fall(B)
        cmp     %FLOAT_OPEN,A
        jnc     @lstf_open_done         ; jnc : pas encore assez tombe
        mov     %ST_FLOAT,A
        call    @lem_set_state
        lda     @cur_lem
        mov     A,B
        clr     A
        sta     @lem_fall(B)
lstf_open_done:
        ; --- pas de descente : plus court en parachute --------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_FLOAT,A
        jne     @lstf_normal
        mov     %FLOAT_STEP,A
        br      @lstf_step
lstf_normal:
        mov     %FALL_STEP,A
lstf_step:
        sta     @fall_step              ; utilise deux fois plus bas
        ; --- descend, dessine a la nouvelle position,
        ; puis efface seulement la bande decouverte en haut de l'ancienne.
        ; Meme ordre que pour la marche : le sprite n'est jamais absent.
        lda     @cur_lem
        mov     A,B
        lda     @fall_step
        mov     A,TEMP4
        lda     @lem_y(B)
        add     TEMP4,A
        mov     A,TEMP4
        mov     %LEM_MAX_Y,A            ; ne jamais sortir par le bas
        cmp     TEMP4,A
        jnc     @lst_fall_clamp
        mov     TEMP4,A
        br      @lst_fall_set
lst_fall_clamp:
        mov     %LEM_MAX_Y,A
lst_fall_set:
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_y(B)
        lda     @cur_lem                ; cumule la distance parcourue
        mov     A,B
        lda     @fall_step
        mov     A,TEMP4
        lda     @lem_fall(B)
        add     TEMP4,A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_fall(B)
        call    @lem_anim_next          ; et la chute egalement
        call    @lem_draw

        lda     @cur_lem                ; bande decouverte au-dessus
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_y(B)
        sta     @r_yline
        lda     @fall_step              ; la bande decouverte fait exactement
        sta     @r_hlines               ; la hauteur du pas
        call    @bg_erase_if_visible
        rets

lst_grounded:
        lda     @cur_lem                ; sol retrouve
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_FLOAT,A             ; parachutiste : il se pose toujours
        jne     @lst_chkfall            ; en douceur, jamais de mort
        mov     %ST_WALK,A
        call    @lem_set_state
        br      @lst_chkblock
lst_chkfall:
        cmp     %ST_FALL,A
        jne     @lst_chkblock           ; pas en chute : on passe au test du
                                        ; bloqueur, PAS directement a la
                                        ; marche -- un bloqueur contournait
                                        ; ainsi son propre traitement et
                                        ; repartait a pied
        lda     @cur_lem                ; la chute etait-elle trop haute ?
        mov     A,B
        lda     @lem_fall(B)
        cmp     %MAX_FALL,A
        jnc     @lst_land_ok            ; jnc : distance < seuil -> il survit
        mov     %ST_DEAD,A
        call    @lem_set_state
        lda     @cur_lem                ; lem_fall sert desormais de compte
        mov     A,B                     ; a rebours avant disparition
        mov     %DEATH_STEPS,A
        sta     @lem_fall(B)
        call    @lem_draw
        rets
lst_land_ok:
        mov     %ST_WALK,A
        call    @lem_set_state

lst_chkblock:
        ; --- bloqueur : il ne se deplace pas, il s'anime seulement.
        ; Ce test vient APRES la verification du sol : si le terrain sous
        ; ses pieds disparait, il tombe comme les autres et cesse donc de
        ; bloquer -- comportement du jeu d'origine.
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_BLOCK,A
        jne     @lst_chkwait
        call    @lem_anim_next
        call    @lem_draw
        rets
lst_chkwait:
        ; --- en attente (plus de briques) : meme immobilite qu'un bloqueur,
        ; mais SANS son effet sur les autres lemmings -- il ne doit faire
        ; faire demi-tour a personne, juste attendre d'etre reselectionne.
        ; Pause TEMPORAIRE (WAIT_STEPS pas) : lem_build, qui ne sert plus a
        ; rien, sert ici de compte a rebours. S'il n'est pas reselectionne
        ; avant qu'il n'atteigne 0, il repart marcher tout seul plutot que
        ; de rester bloque indefiniment.
        cmp     %ST_WAIT,A
        jne     @lst_chkbash
        lda     @cur_lem
        mov     A,B
        lda     @lem_build(B)
        dec     A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_build(B)
        jne     @lst_wait_anim
        mov     %ST_WALK,A              ; pause ecoulee : reprend sa marche
        call    @lem_set_state
        call    @lem_draw
        rets
lst_wait_anim:
        call    @lem_anim_next
        call    @lem_draw
        rets
lst_chkbash:
        ; Frappeur et constructeur sont aiguilles ICI, et non avant le test
        ; du sol : si le terrain sous leurs pieds disparait, ils doivent
        ; tomber comme les autres.
        cmp     %ST_BASH,A
        jne     @lst_chkbuild
        br      @lst_bash
lst_chkbuild:
        cmp     %ST_BUILD,A
        jne     @lst_chkmine
        br      @lst_build
lst_chkmine:
        cmp     %ST_MINE,A
        jne     @lst_walk
        br      @lst_mine

lst_walk:
        ; --- Y a-t-il un mur devant ? Sans ce test, le lemming traversait
        ; la terre a l'horizontale comme si elle n'existait pas -- tres
        ; visible une fois tombe au fond d'un puits. On regarde la tuile
        ; situee devant lui, a hauteur de ses pieds.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen             ; sa carte a lui, pas celle affichee
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A             ; derniere ligne du sprite
        sta     @r_yline

        lda     @cur_lem                ; sens de marche : 0 = droite
        mov     A,B
        lda     @lem_dir(B)
        jeq     @lw_right
        br      @lw_left

lw_right:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        inc     A
        cmp     %LEM_COLS,A
        jnc     @lw_r_inside
        br      @lw_next_screen         ; bord droit : ecran suivant
lw_r_inside:
        sta     @r_xseg
        br      @lw_probe
; --- Chemin unique : on sonde le RELIEF de la colonne visee, puis on
; verifie qu'aucun bloqueur ne s'y trouve.
; La version par tuiles testait "solide / pas solide" et ne savait franchir
; qu'une tuile entiere. Ici le lemming epouse le terrain : il monte une
; pente, s'enfonce dans les pixels noirs du haut d'une tuile, et ne fait
; demi-tour que devant un denivele reellement infranchissable.
lw_probe:
        ; --- la sortie juste devant lui ? Verifiee ICI, AVANT de sonder le
        ; relief normalement -- comme un mur, pas comme une marche du sol.
        ; Une premiere version le laissait marcher NORMALEMENT jusqu'a se
        ; retrouver debout SUR la tuile (une tuile pleine se traverse
        ; comme n'importe quel sol), ce qui pouvait donner l'impression
        ; de "grimper dessus" avant de disparaitre. Ici, il est intercepte
        ; des qu'il l'aborde, sans jamais avoir besoin d'y marcher dessus.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        call    @pix_solid
        lda     @tid
        cmp     %TILE_SORTIE,A
        jne     @lw_p_go
        call    @lst_saved              ; call, pas br : lst_saved est loin
                                        ; dans le fichier, un saut relatif
                                        ; depasserait sa portee
        rets                            ; remonte directement jusqu'au bout
                                        ; de lem_step : plus rien d'autre a
                                        ; faire pour ce lemming ce tour-ci
lw_p_go:
        call    @surface_find
        cmp     %1,A
        jeq     @lw_p_ok
        cmp     %2,A
        jeq     @lw_p_fall
        br      @lw_wall                ; mur : grimper, ou demi-tour
lw_p_fall:
        ; ERREUR DE CONCEPTION CORRIGEE : cette branche faisait faire
        ; demi-tour, empechant TOUTE descente de plus de MAX_STEP_DOWN (6
        ; px) -- soit toute marche pleine (10 px) ou tout rebord un peu haut.
        ; Un lemming se retrouvait prisonnier entre ce faux mur et le
        ; suivant, incapable de descendre OU d'avancer : c'est ce qui
        ; isolait completement un escalier des deux cotes.
        ; Il doit au contraire AVANCER : lem_supported, verifie au debut du
        ; PROCHAIN pas, detectera l'absence de sol et declenchera la chute
        ; normalement -- exactement comme marcher au bord d'une falaise.
        br      @lw_p_move
lw_p_ok:
        lda     @r_xseg                 ; un bloqueur barre-t-il le passage ?
        sta     @blk_col
        call    @blocker_at
        jne     @lw_p_blocked
        br      @lw_p_move
lw_p_blocked:
        br      @lw_turn

lw_p_move:
        ; --- il avance d'un segment ET se replace a la hauteur du sol ----
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @lem_old_y(B)
        lda     @r_xseg
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_xseg(B)
        lda     @sf_y
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_y(B)
        call    @lem_anim_next
        call    @lem_draw

        ; L'ancienne position peut differer en X ET en Y : on efface donc
        ; le rectangle complet qu'il occupait, pas seulement une colonne.
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible
        ; --- le redessiner SEULEMENT si l'ancien rectangle chevauche le
        ; nouveau (ecart horizontal < LEM_WSEG). En marchant il avance d'un
        ; segment entier : pas de chevauchement, et ce second lem_draw
        ; (~12 000 cycles, 30 % du pas) etait fait pour rien a chaque pas.
        ; Il reste utile quand seule la hauteur change (meme colonne).
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_xseg(B)
        mov     A,TEMP4
        lda     @lem_xseg(B)
        sub     TEMP4,A                 ; ecart = nouveau - ancien
        jc      @lwm_pos                ; jc : pas d'emprunt, ecart >= 0
        inv     A                       ; ecart negatif : valeur absolue
        inc     A
lwm_pos:
        cmp     %LEM_WSEG,A
        jnc     @lwm_redraw             ; jnc : ecart < LEM_WSEG, chevauchement
        rets
lwm_redraw:
        call    @lem_draw               ; la zone effacee mordait sur lui :
        rets                            ; on le remet

lw_left:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        jne     @lw_l_inside
        br      @lw_prev_screen         ; bord gauche : ecran precedent s'il
                                        ; en existe un, sinon demi-tour
lw_l_inside:
        dec     A
        sta     @r_xseg
        br      @lw_probe               ; meme sondage du relief qu'a droite

; --- la case d'arrivee sur l'ecran voisin est-elle praticable ?
; Entree : new_scr = ecran vise, new_col = colonne d'arrivee.
; Sortie : A != 0 si elle est solide (donc infranchissable).
; Sans ce test, un marcheur passait sur l'ecran voisin meme quand le sol y
; est plus haut : il se retrouvait A L'INTERIEUR de la terre, y restait un
; pas -- invisible -- puis revenait. D'ou le clignotement observe au bord.
; (entry_blocked a disparu : lw_next_screen/lw_prev_screen utilisent
;  desormais surface_find, qui sait aussi grimper en traversant.)

lw_prev_screen:
        ; Symetrique de lw_next_screen : le marcheur ne rebroussait chemin
        ; qu'a droite, et restait donc prisonnier du dernier ecran atteint.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        jne     @lw_ps_go
        br      @lw_turn                ; premier ecran : demi-tour
lw_ps_go:
        dec     A
        sta     @new_scr
        mov     %LEM_LAST_XSEG,A
        sta     @new_col

        ; --- meme correction que lw_next_screen : surface_find (grimpe
        ; possible) au lieu du simple mur a hauteur du corps.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @tmp_d
        lda     @cur_lem
        mov     A,B
        lda     @new_scr
        sta     @lem_screen(B)
        lda     @new_col
        sta     @r_xseg
        call    @surface_find
        sta     @tmp_g

        lda     @tmp_g
        cmp     %1,A
        jne     @lw_ps_noblk
        lda     @r_xseg
        sta     @blk_col
        call    @blocker_at
        jeq     @lw_ps_noblk
        clr     A
        sta     @tmp_g
lw_ps_noblk:
        lda     @cur_lem
        mov     A,B
        lda     @tmp_d
        sta     @lem_screen(B)

        lda     @tmp_g
        jne     @lw_ps_free
        br      @lw_turn                ; mur (ou bloqueur) : demi-tour
lw_ps_free:
        call    @lsb_erase_here         ; efface AVANT de changer d'ecran
        lda     @cur_lem
        mov     A,B
        lda     @sf_y
        sta     @lem_y(B)               ; hauteur trouvee par surface_find
        lda     @cur_lem
        mov     A,B
        lda     @new_scr
        sta     @lem_screen(B)
        lda     @cur_lem
        mov     A,B
        mov     %LEM_LAST_XSEG,A        ; reapparait au bord droit
        sta     @lem_xseg(B)
        br      @lst_anim

; --- Un obstacle d'UNE SEULE tuile se franchit au lieu de provoquer un
; demi-tour. Sans cela, l'escalier du constructeur serait infranchissable,
; y compris pour les autres lemmings : la competence n'aurait servi a rien.
; r_xseg contient deja la colonne visee.
; --- vrai mur rencontre dans l'ecran : un grimpeur s'y accroche, les autres
; font demi-tour. (Bloqueur, bord du niveau et murs vus a travers un
; changement d'ecran restent des demi-tours : l'escalade ne sonde pas au
; dela du bord de l'ecran.)
lw_wall:
        lda     @cur_lem
        mov     A,B
        lda     @lem_float(B)
        and     %EQUIP_CLIMB,A
        jne     @lw_climb
        br      @lw_turn
lw_climb:
        mov     %ST_CLIMB,A
        call    @lem_set_state
        br      @lst_anim               ; il n'a pas bouge : juste redessine

lw_turn:
        ; Demi-tour : il change de sens et ne bouge pas ce pas-ci. Au fond
        ; d'un puits d'une tuile, il fera donc l'aller-retour indefiniment
        ; -- c'est bien le comportement du jeu d'origine, un lemming piege
        ; attend qu'on lui donne une competence.
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        xor     %1,A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_dir(B)
        br      @lst_anim               ; anime quand meme : il piétine

; (lw_move a disparu : le deplacement se fait desormais dans lw_p_move,
;  qui ajuste aussi la hauteur selon le relief sonde.)

lw_next_screen:
        ; Bord droit. S'il reste un ecran a droite, le lemming y passe ;
        ; sinon il fait DEMI-TOUR -- le niveau a une fin, il ne boucle pas.
        ; Une premiere version revenait au premier ecran, ce qui donnait
        ; l'impression que le lemming se teleportait a l'autre bout.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        inc     A
        cmpa    @cur_nscr               ; ecrans de CE niveau
        jnc     @lw_ns_go
        br      @lw_turn                ; dernier ecran : demi-tour
lw_ns_go:
        sta     @new_scr                ; ecran vise (deja dans A)
        clr     A
        sta     @new_col                ; il arriverait au bord gauche

        ; --- ERREUR DE CONCEPTION CORRIGEE : entry_blocked ne testait
        ; qu'un mur a hauteur du corps, jamais la possibilite de GRIMPER en
        ; traversant -- un escalier qui deborde sur l'ecran suivant (voir
        ; le constructeur, qui lui traverse correctement) bloquait donc a
        ; tort tout AUTRE lemming l'abordant par la marche normale. On
        ; utilise desormais surface_find, EXACTEMENT le meme sondage qu'un
        ; pas normal sur le meme ecran. surface_find lit map_screen depuis
        ; lem_screen(cur_lem) : on le bascule donc TEMPORAIREMENT sur
        ; l'ecran vise, le temps du sondage uniquement.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @tmp_d                  ; ecran ACTUEL, a restaurer ensuite
        lda     @cur_lem
        mov     A,B
        lda     @new_scr
        sta     @lem_screen(B)
        lda     @new_col
        sta     @r_xseg
        call    @surface_find
        sta     @tmp_g                  ; resultat : 0 mur / 1 grimpe / 2 tombe

        ; --- bloqueur sur l'ecran vise ? Sonde AVANT de restaurer l'ecran
        ; ACTUEL : blocker_at lit lui aussi lem_screen(cur_lem), et doit
        ; donc encore le trouver bascule sur l'ecran vise a cet instant.
        lda     @tmp_g
        cmp     %1,A
        jne     @lw_ns_noblk
        lda     @r_xseg
        sta     @blk_col
        call    @blocker_at
        jeq     @lw_ns_noblk
        clr     A
        sta     @tmp_g                  ; bloqueur : traite comme un mur
lw_ns_noblk:
        lda     @cur_lem                ; restaure l'ecran ACTUEL -- le
        mov     A,B                     ; test d'effacement plus bas doit
        lda     @tmp_d                  ; encore comparer l'ANCIEN ecran
        sta     @lem_screen(B)

        lda     @tmp_g
        jne     @lw_ns_free
        br      @lw_turn                ; mur (ou bloqueur) : demi-tour
lw_ns_free:
        ; L'effacement de l'ancienne position doit avoir lieu AVANT de
        ; changer lem_screen, sinon la garde de bg_erase_if_visible compare
        ; le NOUVEL ecran et n'efface rien.
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible

        lda     @cur_lem
        mov     A,B
        clr     A
        sta     @lem_xseg(B)
        lda     @cur_lem
        mov     A,B
        lda     @sf_y                   ; hauteur trouvee par surface_find :
        sta     @lem_y(B)               ; PAS forcement inchangee, il peut
                                        ; grimper ou descendre en traversant
        lda     @cur_lem                ; l'existence de l'ecran suivant a
        mov     A,B                     ; deja ete verifiee plus haut
        lda     @new_scr
        sta     @lem_screen(B)
lst_anim:
        call    @lem_anim_next
        call    @lem_draw               ; NOUVELLE position d'abord

        lda     @cur_lem                ; puis la colonne laissee derriere
        mov     A,B
        lda     @lem_xseg(B)
        cmpa    @lem_old_xseg(B)
        jne     @lst_erase
        rets                            ; il n'a pas bouge : rien a effacer
lst_erase:
        lda     @cur_lem
        mov     A,B
        lda     @lem_old_xseg(B)
        sta     @r_xseg
        mov     %1,A                    ; un seul segment expose
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        sta     @r_yline
        mov     %LEM_HLINES,A
        sta     @r_hlines
        call    @bg_erase_if_visible
        rets

; ============================================================================
; SELECTION PAR LE VISEUR
;
; sel_find -- cherche un lemming sous le viseur. Sortie : sel_lem = son
; indice, ou $FF si aucun. On prend le PREMIER trouve ; deux lemmings
; superposes ne sont pas departages.
; ============================================================================
sel_find:
        mov     %$FF,A
        sta     @sel_lem
        clr     A
        sta     @cur_lem
sf_loop:
        call    @sf_one
        lda     @sel_lem                ; trouve : on s'arrete la
        cmp     %$FF,A
        jne     @sf_done
        lda     @cur_lem
        inc     A
        sta     @cur_lem
        cmp     %NUM_LEM,A
        jne     @sf_loop
sf_done:
        rets

; le lemming cur_lem est-il sous le viseur ? Meme test de recouvrement de
; rectangles que cur_erase, plus la condition d'ecran.
sf_one:
        lda     @cur_lem
        mov     A,B
        lda     @lem_alive(B)
        jne     @sfo_alive
        rets
sfo_alive:
        lda     @cur_lem                ; ni un mort ni une explosion en
        mov     A,B                     ; cours ne se designent
        lda     @lem_state(B)
        cmp     %ST_DEAD,A
        jne     @sfo_chkboom
        rets
sfo_chkboom:
        cmp     %ST_BOOM,A
        jne     @sfo_notdead
        rets
sfo_notdead:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        cmpa    @cur_screen
        jeq     @sfo_scr
        rets
sfo_scr:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        add     %LEM_WSEG,A
        mov     A,TEMP4
        lda     @cur_xseg
        cmp     TEMP4,A
        jnc     @sfo_x2
        rets
sfo_x2:
        lda     @cur_xseg
        add     %CUR_W_SEG,A
        mov     A,TEMP4
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        cmp     TEMP4,A
        jnc     @sfo_y1
        rets
sfo_y1:
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        mov     A,TEMP4
        lda     @cur_y
        cmp     TEMP4,A
        jnc     @sfo_y2
        rets
sfo_y2:
        lda     @cur_y
        add     %CUR_H_LINES,A
        mov     A,TEMP4
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        cmp     TEMP4,A
        jnc     @sfo_hit
        rets
sfo_hit:
        lda     @cur_lem
        sta     @sel_lem
        rets

; --- donne le parachute : attribut durable, accepte aussi en pleine chute.
; Si le lemming tombe deja en chute libre, il bascule immediatement en
; parachute et sa distance de chute repart de zero -- sans cela il mourrait
; a l'atterrissage a cause des lignes deja parcourues avant l'ouverture.
; --- G : grimpeur. Competence PERMANENTE (bit EQUIP_CLIMB de lem_float),
; attribuable quel que soit l'etat, comme le parachute ; seul un lemming
; qui l'a deja ne la consomme pas une seconde fois.
give_climb:
        call    @sel_find
        lda     @sel_lem
        cmp     %$FF,A
        jne     @gc_go
        rets
gc_go:
        mov     A,B
        lda     @lem_float(B)
        and     %EQUIP_CLIMB,A
        jeq     @gc_new
        rets                            ; deja grimpeur
gc_new:
        lda     @lem_float(B)
        or      %EQUIP_CLIMB,A
        sta     @lem_float(B)
        clr     A                       ; son sprite de marche change : on
        sta     @lem_frame(B)           ; repart de la premiere vignette
        mov     %1,A
        sta     @give_ok
        rets

; --- un pas d'escalade. Le lemming reste dans son segment, face a la paroi
; (qui occupe le segment d'en face) :
;   1. plafond sur les CLIMB_STEP lignes au-dessus de sa tete (ou haut de
;      l'ecran) : il lache prise et retombe EN ARRIERE (demi-tour, puis la
;      chute normale : parachute s'il l'a, sinon il peut s'ecraser) ;
;   2. sinon il monte de CLIMB_STEP lignes ;
;   3. puis MEME sondage que la marche (surface_find) sur la colonne d'en
;      face, a hauteur de ses pieds : des que le haut de la paroi est a
;      portee d'un pas normal, il passe dessus avec le deplacement de la
;      marche et se remet a marcher.
lst_climb:
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        cmp     %CLIMB_STEP,A
        jc      @lcl_room               ; jc : lem_y >= CLIMB_STEP
        br      @lcl_fall               ; haut de l'ecran : il lache prise
lcl_room:
        dec     A                       ; 1re ligne au-dessus de la tete
        sta     @r_yline
        call    @pix_solid
        jeq     @lcl_c2
        br      @lcl_fall               ; plafond
lcl_c2:
        lda     @r_yline                ; 2e ligne (CLIMB_STEP = 2)
        dec     A
        sta     @r_yline
        call    @pix_solid
        jeq     @lcl_up
        br      @lcl_fall
lcl_up:
        lda     @cur_lem                ; monte : nouvelle position dessinee
        mov     A,B                     ; d'abord...
        lda     @lem_y(B)
        sub     %CLIMB_STEP,A
        sta     @lem_y(B)
        call    @lem_anim_next
        call    @lem_draw
        lda     @cur_lem                ; ...puis les lignes liberees SOUS
        mov     A,B                     ; le sprite (aucun recouvrement)
        lda     @lem_xseg(B)
        sta     @r_xseg
        mov     %LEM_WSEG,A
        sta     @r_wseg
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        sta     @r_yline
        mov     %CLIMB_STEP,A
        sta     @r_hlines
        call    @bg_erase_if_visible

        lda     @cur_lem                ; --- sommet atteint ? colonne d'en
        mov     A,B                     ; face, a hauteur des pieds
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        lda     @cur_lem
        mov     A,B
        lda     @lem_dir(B)
        jne     @lcl_left
        lda     @lem_xseg(B)
        inc     A
        cmp     %LEM_COLS,A
        jnc     @lcl_probe              ; jnc : encore dans l'ecran
        rets                            ; (bord : ne peut arriver, voir lw_wall)
lcl_left:
        lda     @lem_xseg(B)
        jne     @lcl_l2
        rets
lcl_l2:
        dec     A
lcl_probe:
        sta     @r_xseg
        call    @surface_find
        cmp     %0,A
        jne     @lcl_top                ; 1 ou 2 : il peut passer par-dessus
        rets                            ; encore la paroi : au prochain pas
lcl_top:
        mov     %ST_WALK,A
        call    @lem_set_state
        br      @lw_p_ok                ; deplacement de la marche (bloqueur
                                        ; verifie, sf_y, effacement)
lcl_fall:
        lda     @cur_lem                ; lache prise : demi-tour, puis chute
        mov     A,B
        lda     @lem_dir(B)
        xor     %1,A
        sta     @lem_dir(B)
        br      @lst_newfall

; --- M : mineur. Creuse en DIAGONALE vers le bas, dans son sens de marche,
; par tuiles entieres (couche des cases creusees, comme le creuseur). A
; chaque coup de pioche il enleve les DEUX tuiles devant lui -- a hauteur
; du corps et juste en dessous -- puis avance d'une colonne et descend d'une
; tuile. Le tunnel fait donc 2 tuiles de haut, en marches de 10 px, soit
; exactement MAX_STEP_UP : les autres lemmings le SUIVENT en descente et le
; remontent a pied. (En n'enlevant que la tuile en diagonale, comme sur
; Game Boy, il restait un bloc a hauteur du corps devant chaque marche : un
; lemming arrivant d'en haut passait par-dessus le tunnel au lieu d'y
; entrer.)
; Un coup a chaque passage sur la DERNIERE vignette de son animation (4
; vignettes : ~0,6 s par marche). Au bord de l'ecran il continue dans
; l'ecran voisin s'il y en a un. Arret -- il se remet a marcher -- sur
; l'acier (ou la sortie), au bord du niveau, en bas du niveau. S'il
; debouche dans le vide, il tombe : cet etat est aiguille APRES le test de
; sol, comme le frappeur.
lst_mine:
        call    @lem_anim_next
        lda     @cur_lem                ; derniere vignette atteinte ?
        mov     A,B
        lda     @lem_state(B)
        mov     A,B
        lda     @lem_nframes(B)
        dec     A
        mov     A,TEMP4
        lda     @cur_lem
        mov     A,B
        lda     @lem_frame(B)
        cmp     TEMP4,A
        jeq     @lmn_strike
        call    @lem_draw               ; entre deux coups : il s'anime
        rets
lmn_strike:
        lda     @cur_lem                ; ecran vise : le sien par defaut
        mov     A,B
        lda     @lem_screen(B)
        sta     @new_scr
        lda     @cur_lem                ; --- colonne visee
        mov     A,B
        lda     @lem_dir(B)
        jne     @lmn_left
        lda     @lem_xseg(B)
        inc     A
        cmp     %LEM_COLS,A
        jnc     @lmn_col                ; jnc : encore dans l'ecran
        lda     @new_scr                ; bord droit : ecran suivant, colonne 0
        inc     A
        cmpa    @cur_nscr
        jnc     @lmn_nxt
        br      @lmn_stop               ; dernier ecran du niveau
lmn_nxt:
        sta     @new_scr
        clr     A
        br      @lmn_col
lmn_left:
        lda     @lem_xseg(B)
        jne     @lmn_l2
        lda     @new_scr                ; bord gauche : ecran precedent,
        jne     @lmn_prv                ; derniere colonne
        br      @lmn_stop               ; premier ecran du niveau
lmn_prv:
        dec     A
        sta     @new_scr
        mov     %LEM_LAST_XSEG,A
        br      @lmn_col
lmn_l2:
        dec     A
lmn_col:
        sta     @tmp_d
        lda     @new_scr                ; sonde et creuse dans la carte de
        sta     @map_screen             ; l'ecran vise
        lda     @cur_lem                ; --- rangee du sol (ligne sous les
        mov     A,B                     ; pieds / 10)
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        cmp     %GRAPH_LINES,A
        jnc     @lmn_in
        br      @lmn_stop               ; bas du niveau
lmn_in:
        sta     @r_yline
        call    @rect_rowline
        lda     @q_row
        sta     @tmp_g                  ; f = rangee du sol

        ; --- d'abord VERIFIER les deux cases : de l'acier dans l'une ou
        ; l'autre, et il s'arrete sans rien creuser
        lda     @tmp_g
        jeq     @lmn_chkf               ; f = 0 : pas de case au-dessus
        dec     A
        call    @mine_probe             ; case devant, hauteur du corps
        cmp     %1,A
        jne     @lmn_chkf
        br      @lmn_stop
lmn_chkf:
        lda     @tmp_g
        call    @mine_probe             ; case devant, en dessous
        cmp     %1,A
        jne     @lmn_dig
        br      @lmn_stop

lmn_dig:
        lda     @tmp_g                  ; --- puis creuser ce qui est plein
        jeq     @lmn_dig2
        dec     A
        call    @mine_probe
        cmp     %2,A
        jne     @lmn_dig2
        lda     @tmp_g
        dec     A
        call    @mine_dig
lmn_dig2:
        lda     @tmp_g
        call    @mine_probe
        cmp     %2,A
        jne     @lmn_move
        lda     @tmp_g
        call    @mine_dig
lmn_move:
        lda     @cur_lem                ; --- changement d'ecran ?
        mov     A,B
        lda     @lem_screen(B)
        cmpa    @new_scr
        jne     @lmn_cross
        lda     @tmp_g                  ; --- meme ecran : avance et descend,
        mpy     %TILE_H_LINES,A         ; corps dans la rangee f, pieds sur
        mov     B,A                     ; f+1
        sta     @sf_y
        lda     @tmp_d
        sta     @r_xseg
        br      @lw_p_move              ; meme deplacement que la marche
lmn_cross:
        ; --- vers l'ecran voisin. Pas lw_p_move : il efface l'ancienne
        ; position APRES le deplacement, donc en consultant deja le nouvel
        ; ecran. Ici : effacer d'abord (ancien ecran), puis changer.
        call    @lsb_erase_here
        lda     @cur_lem
        mov     A,B
        lda     @new_scr
        sta     @lem_screen(B)
        lda     @cur_lem
        mov     A,B
        lda     @tmp_d
        sta     @lem_xseg(B)
        sta     @lem_old_xseg(B)
        lda     @tmp_g
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_y(B)
        call    @lem_anim_next
        call    @lem_draw
        rets
lmn_stop:
        mov     %ST_WALK,A              ; il redevient un simple marcheur
        call    @lem_set_state
        rets

; --- A = rangee ; case (tmp_d, rangee) de l'ecran map_screen :
; 0 = vide, 1 = pleine et indestructible (acier, sortie), 2 = a creuser
mine_probe:
        mov     A,TEMP4                 ; (rangee)
        lda     @new_scr                ; carte de l'ecran VISE, fixee ici : le
        sta     @map_screen             ; redessin d'une case (bg_draw_rect)
        mov     TEMP4,A                 ; la remet sur l'ecran affiche
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        lda     @tmp_d
        sta     @r_xseg
        call    @tile_flags_at
        mov     A,TEMP4
        and     %TILE_SOLID,A
        jne     @mp_solid
        rets                            ; A = 0
mp_solid:
        mov     TEMP4,A
        and     %TILE_DIG,A
        jne     @mp_dig
        mov     %1,A
        rets
mp_dig:
        mov     %2,A
        rets

; --- A = rangee : creuse la case (tmp_d, rangee) et la redessine (vide)
mine_dig:
        mov     A,TEMP4                 ; (rangee)
        lda     @new_scr                ; carte de l'ecran vise (voir
        sta     @map_screen             ; mine_probe)
        mov     TEMP4,A
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        lda     @tmp_d
        sta     @r_xseg
        sta     @d_col
        call    @rect_rowline           ; q_row pour dig_set
        call    @dig_set
        lda     @tmp_d                  ; puis la tuile entiere redessinee
        sta     @r_xseg
        mov     %1,A
        sta     @r_wseg
        mov     %TILE_H_LINES,A
        sta     @r_hlines
        lda     @q_row
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        ; bg_erase_if_visible juge la visibilite sur l'ecran DU LEMMING : le
        ; temps de ce redessin, on lui donne l'ecran de la case creusee (qui
        ; peut etre l'ecran voisin), puis on remet le sien.
        lda     @cur_lem
        mov     A,B
        lda     @lem_screen(B)
        push    A
        lda     @new_scr
        sta     @lem_screen(B)
        call    @bg_erase_if_visible
        pop     A
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_screen(B)
        rets

give_float:
        call    @sel_find
        lda     @sel_lem
        cmp     %$FF,A
        jne     @gf_go
        rets
gf_go:
        sta     @cur_lem
        mov     A,B
        lda     @lem_float(B)           ; deja equipe : on ne consomme pas
        and     %EQUIP_FLOAT,A          ; un second parachute
        jeq     @gf_new
        rets
gf_new:
        lda     @lem_float(B)           ; ajoute le parachute sans toucher
        or      %EQUIP_FLOAT,A          ; au bit du grimpeur
        sta     @lem_float(B)
        clr     A                       ; son sprite de marche change : on
        sta     @lem_frame(B)           ; repart de la premiere vignette
        mov     %1,A
        sta     @give_ok
        rets                            ; en pleine chute, lst_fall l'ouvre des
                                        ; qu'elle depasse FLOAT_OPEN lignes

; --- donne une competence au lemming designe par le viseur -----------------
; Entree : A = etat a appliquer (ST_DIG, ST_BLOCK...). Sans effet si aucun
; lemming n'est vise, ou si celui-ci n'est pas simplement en train de
; marcher : on ne detourne ni une chute, ni une competence deja en cours.
give_skill:
        sta     @tmp_c                  ; etat demande
        call    @sel_find
        lda     @sel_lem
        cmp     %$FF,A
        jne     @gs_go
        rets                            ; personne sous le viseur
gs_go:
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_WALK,A
        jeq     @gs_set
        cmp     %ST_WAIT,A              ; en attente (plus de briques) :
        jeq     @gs_set                 ; tout aussi selectionnable qu'en
        rets                            ; marche normale, c'est son but
gs_set:
        lda     @sel_lem                ; lem_set_state travaille sur cur_lem
        sta     @cur_lem
        mov     %1,A                    ; attribution reussie : le pouvoir
        sta     @give_ok                ; sera decompte (skill_use)
        lda     @tmp_c
        call    @lem_set_state
        rets

; ============================================================================
; lem_explode -- le lemming cur_lem explose : il detruit les tuiles
; destructibles d'un carre de (2*EXPLODE_R+1) tuiles de cote centre sur lui,
; puis meurt. L'acier resiste.
; Les bornes sont ECRETEES aux limites de l'ecran : sans cela, un kamikaze
; pres d'un bord marquerait des cases appartenant a la rangee voisine, le
; calcul d'index etant lineaire.
; ============================================================================
lem_explode:
        lda     @cur_lem                ; sa carte a lui
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @cur_lem                ; rangee de ses pieds
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_FOOT,A
        sta     @r_yline
        call    @rect_rowline           ; -> q_row

        ; --- bornes en colonnes -------------------------------------------
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        cmp     %EXPLODE_R,A
        jc      @lx_ok                  ; jc : xseg >= rayon
        clr     A                       ; trop a gauche : on ecrete a 0
        sta     @bx0
        br      @lx_right
lx_ok:
        sub     %EXPLODE_R,A
        sta     @bx0
lx_right:
        lda     @cur_lem
        mov     A,B
        lda     @lem_xseg(B)
        add     %EXPLODE_R,A
        cmp     %LEM_LAST_XSEG,A
        jnc     @lx_r_ok                ; jnc : reste dans l'ecran
        mov     %LEM_LAST_XSEG,A
lx_r_ok:
        sta     @bx1

        ; --- bornes en rangees --------------------------------------------
        lda     @q_row
        cmp     %EXPLODE_R,A
        jc      @ly_ok
        clr     A
        sta     @by0
        br      @ly_bottom
ly_ok:
        sub     %EXPLODE_R,A
        sta     @by0
ly_bottom:
        lda     @q_row
        add     %EXPLODE_R,A
        cmp     %LV_MAP_H,A
        jnc     @ly_b_ok                ; jnc : rangee < LV_MAP_H
        mov     %LV_MAP_H,A
        dec     A
ly_b_ok:
        sta     @by1

        ; --- largeur et hauteur de la zone, en tuiles ---------------------
        ; On travaille en COMPTEURS et non en bornes : la version initiale
        ; comparait a bx1/by1 et devait traiter a part la derniere colonne
        ; et la derniere rangee, avec du code duplique et fragile.
        lda     @bx1
        mov     A,TEMP4
        lda     @bx0
        mov     A,B
        mov     TEMP4,A
        sub     B,A
        inc     A
        sta     @bw                     ; bx1 - bx0 + 1
        lda     @by1
        mov     A,TEMP4
        lda     @by0
        mov     A,B
        mov     TEMP4,A
        sub     B,A
        inc     A
        sta     @bh

        ; --- marque toutes les cases destructibles de la zone -------------
        lda     @by0
        sta     @brow
        lda     @bh
        sta     @brow_n
lex_row:
        lda     @bx0
        sta     @bcol
        lda     @bw
        sta     @bcol_n
lex_col:
        lda     @brow                   ; tile_flags_at relit q_row depuis
        mpy     %TILE_H_LINES,A         ; r_yline : on lui donne la ligne du
        mov     B,A                     ; haut de la rangee
        sta     @r_yline
        lda     @bcol
        sta     @r_xseg
        call    @tile_flags_at
        and     %TILE_DIG,A
        jeq     @lex_next               ; acier ou deja vide : on passe
        lda     @brow                   ; dig_set travaille sur q_row/d_col
        sta     @q_row
        lda     @bcol
        sta     @d_col
        call    @dig_set
lex_next:
        lda     @bcol
        inc     A
        sta     @bcol
        lda     @bcol_n
        dec     A
        sta     @bcol_n
        jne     @lex_col

        lda     @brow
        inc     A
        sta     @brow
        lda     @brow_n
        dec     A
        sta     @brow_n
        jne     @lex_row

        ; --- redessine la zone --------------------------------------------
        lda     @bx0
        sta     @r_xseg
        lda     @bw
        sta     @r_wseg
        lda     @by0
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        lda     @bh
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_hlines
        call    @bg_erase_if_visible

        ; --- et il disparait dans une gerbe de pixels ---------------------
        mov     %ST_BOOM,A
        call    @lem_set_state
        lda     @cur_lem
        mov     A,B
        lda     @lem_nframes+ST_BOOM    ; autant de pas que de vignettes dans
        sta     @lem_fall(B)            ; EXELLEM : toutes sont jouees, la
                                        ; derniere reste un pas de plus
        clr     A
        sta     @lem_bomb(B)
        call    @lem_draw
        rets

; --- donne la competence de construction, avec son quota de marches -------
give_build:
        ; --- assez de place au-dessus AVANT d'accepter ? ---------------
        ; Sans ce controle EN AMONT, un escalier pouvait demarrer puis
        ; s'arreter en pleine construction contre le sommet de la carte --
        ; ou, avant le garde-fou ajoute au tour precedent, deborder
        ; purement et simplement du cadre. Ici, on refuse d'emblee plutot
        ; que de laisser une construction s'interrompre a mi-chemin.
        call    @sel_find
        lda     @sel_lem
        cmp     %$FF,A
        jne     @gbd_clear
        rets                            ; personne sous le viseur
gbd_clear:
        lda     @sel_lem
        mov     A,B
        lda     @lem_screen(B)
        sta     @map_screen
        lda     @sel_lem
        mov     A,B
        lda     @lem_xseg(B)
        sta     @r_xseg
        lda     @sel_lem
        mov     A,B
        lda     @lem_y(B)
        add     %LEM_HLINES,A
        sta     @r_yline
        call    @rect_rowline           ; -> q_row : sa rangee d'appui
        lda     @q_row
        cmp     %BUILD_CLEARANCE,A
        jc      @gbd_rowcheck           ; jc : q_row >= BUILD_CLEARANCE,
                                        ; assez de marge jusqu'au sommet
        rets                            ; trop pres du sommet : refuse
gbd_rowcheck:
        ; --- meme colonne, chaque rangee au-dessus jusqu'a la marge :
        ; aucune ne doit deja etre solide (element de decor).
        mov     %BUILD_CLEARANCE,A
        sta     @tmp_g                  ; compteur de rangees restantes
gbd_rloop:
        lda     @q_row
        dec     A
        sta     @q_row
        lda     @q_row
        mpy     %TILE_H_LINES,A
        mov     B,A
        sta     @r_yline
        call    @pix_solid
        jeq     @gbd_rnext              ; vide : cette rangee est libre
        rets                            ; deja solide : element de decor,
                                        ; refuse
gbd_rnext:
        lda     @tmp_g
        dec     A
        sta     @tmp_g
        jne     @gbd_rloop

        ; --- assez de place, rien en travers : accepte la competence ------
        mov     %ST_BUILD,A
        call    @give_skill
        lda     @sel_lem
        cmp     %$FF,A
        jne     @gbd_go
        rets
gbd_go:
        mov     A,B
        lda     @lem_state(B)
        cmp     %ST_BUILD,A             ; give_skill a-t-il accepte ?
        jeq     @gbd_set
        rets
gbd_set:
        lda     @sel_lem
        mov     A,B
        mov     %BUILD_STEPS,A
        sta     @lem_build(B)
        rets

; --- amorce le compte a rebours du lemming designe -------------------------
give_bomb:
        call    @sel_find
        lda     @sel_lem
        cmp     %$FF,A
        jne     @gb_go
        rets
gb_go:
        sta     @cur_lem
        mov     A,B
        lda     @lem_bomb(B)            ; deja amorce : on ne relance pas
        jeq     @gb_set
        rets
gb_set:
        lda     @sel_lem
        mov     A,B
        mov     %EXPLODE_STEPS,A
        sta     @lem_bomb(B)
        mov     %1,A
        sta     @give_ok
        rets

; --- avance d'une vignette, sur le nombre REEL de vignettes du type courant
; (lem_nframes). Apres la derniere : retour a la premiere si le type BOUCLE,
; sinon on RESTE sur la derniere -- reglage "boucle / une seule fois"
; d'EXELLEM, jusqu'ici ignore (la gerbe d'explosion repassait par sa
; vignette 0 juste avant de disparaitre, et la mort se jouait deux fois).
; Ce reglage est le 3e octet de chaque definition lem_defN, emises a la
; suite l'une de l'autre par EXELLEM (nb vignettes, vitesse, boucle) :
; celle du type T commence donc a lem_def0 + 3*T.
lem_anim_next:
        call    @lem_sprite_type        ; le type DESSINE (variante comprise)
        mov     A,B
        lda     @lem_nframes(B)
        mov     A,TEMP4                 ; nb de vignettes de ce type
        mov     B,A                     ; 3 * type : sa definition
        add     B,A
        add     B,A
        mov     A,B
        lda     @lem_def0+2(B)          ; 1 = boucle, 0 = une seule fois
        jne     @lan_loop
        lda     @cur_lem                ; une seule fois : avance tant qu'il
        mov     A,B                     ; reste des vignettes...
        lda     @lem_frame(B)
        inc     A
        cmp     TEMP4,A
        jnc     @lan_ok                 ; jnc : encore dans la plage
        rets                            ; ...puis reste sur la derniere
lan_loop:
        lda     @cur_lem
        mov     A,B
        lda     @lem_frame(B)
        inc     A
        cmp     TEMP4,A
        jnc     @lan_ok                 ; jnc : encore dans la plage
        clr     A
lan_ok:
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_frame(B)
        rets

; --- change l'etat du lemming cur_lem (A = nouvel etat) et remet son
; animation au debut : les vignettes d'un type ne correspondent pas a
; celles d'un autre.
; --- type de sprite a dessiner pour cur_lem : son etat, sauf en MARCHE, ou
; ses competences permanentes choisissent la variante du marcheur : sac de
; parachute dans le dos, crochet de grimpeur, ou les deux (athlete). Ce sont
; les types 12 a 14 d'EXELLEM. Rend A = type ; utilise B.
lem_sprite_type:
        lda     @cur_lem
        mov     A,B
        lda     @lem_state(B)
        jne     @lspt_done              ; ST_WALK = 0 : seul etat a variantes
        lda     @lem_float(B)
        and     %EQUIP_FLOAT|EQUIP_CLIMB,A
        jeq     @lspt_done              ; aucune : marcheur ordinaire (A = 0)
        add     %LT_WALK_F-1,A          ; 1 -> 12, 2 -> 13, 3 -> 14
lspt_done:
        rets

lem_set_state:
        sta     @tmp_c
        lda     @cur_lem
        mov     A,B
        lda     @tmp_c
        sta     @lem_state(B)
        clr     A
        sta     @lem_frame(B)
        rets

; --- fait avancer TOUS les lemmings, puis remet le viseur au-dessus -------
lem_step_all:
        clr     A
        sta     @cur_lem
        sta     @any_stepped            ; personne n'a encore bouge ce tour
lsa_loop:
        lda     @cur_lem
        mov     A,B
        lda     @lem_pending(B)
        jeq     @lsa_next               ; pas encore son tour
        clr     A
        sta     @lem_pending(B)
        mov     %1,A
        sta     @any_stepped            ; au moins un pas : le viseur devra
                                        ; etre redessine par-dessus
        call    @lem_step
lsa_next:
        lda     @cur_lem
        inc     A
        sta     @cur_lem
        cmp     %NUM_LEM,A
        jne     @lsa_loop
        ; Le viseur n'est PLUS redessine ici : ml_next s'en charge, une
        ; seule fois, apres avoir applique un eventuel deplacement (souris
        ; ou fleche). any_stepped lui indique si des lemmings ont pu passer
        ; par-dessus.
        ; --- PASSE DE RATTRAPAGE, DESACTIVEE -------------------------------
        ; Chaque lemming efface la colonne qu'il vient de quitter en
        ; regenerant le decor, ce qui efface aussi tout autre lemming
        ; occupant cette colonne -- c'est la limite du "mode RAW" : aucune
        ; gestion des recouvrements entre sprites.
        ; Redessiner tout le monde apres la boucle corrige ce defaut, mais
        ; coute cher. Desactive tant qu'aucun artefact genant n'est
        ; constate ; il suffit de retirer le point-virgule.
;       call    @lem_draw_all
lsa_done:
        rets

; --- dessine tous les lemmings (apres un redessin complet du decor) -------
lem_draw_all:
        clr     A
        sta     @cur_lem
lda_loop:
        call    @lem_draw
        lda     @cur_lem
        inc     A
        sta     @cur_lem
        cmp     %NUM_LEM,A
        jne     @lda_loop
        rets

; --- fait apparaitre le lemming suivant, s'il en reste ---------------------
lem_spawn:
        ; --- Autant de lemmings que le niveau le demande (LV_LEM_COUNT,
        ; EXELTILE), mais au plus NUM_LEM a l'ecran en meme temps : les
        ; tableaux lem_* n'ont que NUM_LEM places et la SRAM ne permet pas
        ; de les agrandir. On reprend donc l'emplacement d'un lemming sauve
        ; ou mort (lem_alive = 0). Si tous sont occupes, cette naissance est
        ; simplement reportee a l'echeance suivante (SPAWN_TICKS).
        lda     @spawn_count
        cmpa    @cur_lem_count
        jnc     @lsp_find               ; jnc : il en reste a faire sortir
        rets
lsp_find:
        mov     %NUM_LEM,B
lsp_look:
        lda     @lem_alive-1(B)
        jeq     @lsp_free
        djnz    B,@lsp_look
        rets                            ; aucune place libre : plus tard
lsp_free:
        dec     B                       ; emplacement 0..NUM_LEM-1
        mov     B,A
        sta     @spawn_next             ; les lignes suivantes l'utilisent
lsp_go:
        mov     A,B
        mov     %1,A
        sta     @lem_alive(B)
        clr     A
        sta     @lem_frame(B)
        sta     @lem_old_xseg(B)
        sta     @lem_state(B)           ; ST_WALK = 0 ; sans cette remise a
                                        ; zero, un lemming pourrait naitre
                                        ; dans un etat residuel
        sta     @lem_dir(B)             ; part vers la droite
        sta     @lem_fall(B)            ; aucune chute en cours
        sta     @lem_float(B)           ; sans parachute
        sta     @lem_bomb(B)            ; aucun compte a rebours
        sta     @lem_build(B)           ; aucune brique en reserve

        ; --- ecran de naissance : celui choisi dans EXELTILE (point de
        ; depart), plus le hasard "tous a screen 0" d'avant -- un niveau
        ; peut tres bien commencer sur un autre ecran que le premier.
        lda     @cur_spawn_scr
        sta     @lem_screen(B)

        ; --- decalage de depart, explicite plutot que subi -----------------
        ; Jusqu'ici, lem_tick/lem_pending du nouveau lemming n'etaient JAMAIS
        ; remis a zero : leur compteur continuait simplement de tourner
        ; depuis le demarrage du jeu (initialise par init_ticks). Comme les
        ; NUM_LEM compteurs partent tous de 0 EN MEME TEMPS au lancement, et
        ; que SPAWN_TICKS(200) mod LEM_STEP_DELAY(16) = 8 -- exactement la
        ; moitie de 16 -- les naissances ne produisaient que DEUX groupes de
        ; phase, pas dix : cinq lemmings devenaient "dus" au meme tick, et
        ; leur redessin retardait tout le reste de cette passe de boucle, y
        ; compris la lecture des touches -- meme loin du viseur.
        ; Un decalage EXPLICITE, choisi dans une table plutot que subi,
        ; garantit qu'au plus UN lemming devient du par tick.
        lda     @spawn_next
        mov     A,B
        lda     @lem_tick_init(B)
        sta     @lem_tick(B)
        clr     A
        sta     @lem_pending(B)
        ; --- position de naissance : point de depart choisi dans EXELTILE
        ; (LV_SPAWN_COL/LV_SPAWN_Y), plus le "colonne 2, ligne 60" fixe
        ; d'avant -- chaque niveau a son propre point de chute, ce n'est
        ; ni une tuile speciale ni un attribut de tuile.
        lda     @cur_spawn_col
        sta     @lem_xseg(B)
        lda     @cur_spawn_y            ; deja en pixels (ligne*10),
        sta     @lem_y(B)               ; calcule par EXELTILE a l'export
        sta     @lem_old_y(B)           ; emplacement reutilise : rien de
                                        ; l'ancien occupant ne doit rester
        lda     @spawn_next
        mov     A,TEMP4
        lda     @cur_lem                ; on preserve l'indice en cours de
        mov     A,TEMP5                 ; traitement, par prudence
        mov     TEMP4,A
        sta     @cur_lem
        call    @lem_draw
        mov     TEMP5,A
        sta     @cur_lem
        lda     @spawn_count            ; un de plus dehors
        inc     A
        sta     @spawn_count
        mov     %TXT_SORTIS_POS&$FF,B
        call    @put_2dig
        rets

; ============================================================================
; POUVOIRS -- selection, attribution, panneau des 3 lignes du bas
;
; Ordre du panneau (index 0..5) : C constructeur, D creuseur, H frappeur,
; B bloqueur, F parachutiste, E kamikaze. Chaque case fait 4 colonnes sur 3
; lignes : icone 2x2 centree, puis "C 12" (touche, nombre restant). Le
; pouvoir selectionne a un fond bleu : on ne reecrit que les ATTRIBUTS de
; sa case (fond = bits 2-0 en alphamosaique), aucun glyphe supplementaire.
; ============================================================================

; --- attribue le pouvoir selectionne au lemming sous le viseur, s'il en
; reste. Ne decompte que si l'attribution a reellement eu lieu (give_ok,
; pose par give_skill / give_float / give_bomb a leurs points de succes) :
; personne sous le viseur, mauvais etat, deja equipe... ne coutent rien.
skill_use:
        lda     @skill_sel
        mov     A,B
        lda     @skill_cnt(B)
        jne     @su_have
        rets                            ; plus aucun : rien ne se passe
su_have:
        clr     A
        sta     @give_ok
        lda     @skill_sel
        jne     @su_n0
        call    @give_build             ; 0 : C constructeur
        br      @su_done
su_n0:
        cmp     %1,A
        jne     @su_n1
        mov     %ST_DIG,A               ; 1 : D creuseur
        call    @give_skill
        br      @su_done
su_n1:
        cmp     %2,A
        jne     @su_n2
        mov     %ST_BASH,A              ; 2 : H frappeur
        call    @give_skill
        br      @su_done
su_n2:
        cmp     %3,A
        jne     @su_n3
        mov     %ST_BLOCK,A             ; 3 : B bloqueur
        call    @give_skill
        br      @su_done
su_n3:
        cmp     %4,A
        jne     @su_n4
        call    @give_float             ; 4 : F parachutiste
        br      @su_done
su_n4:
        cmp     %5,A
        jne     @su_n5
        call    @give_bomb              ; 5 : E kamikaze
        br      @su_done
su_n5:
        cmp     %6,A
        jne     @su_n6
        call    @give_climb             ; 6 : G grimpeur
        br      @su_done
su_n6:
        mov     %ST_MINE,A              ; 7 : M mineur
        call    @give_skill
su_done:
        lda     @give_ok
        jne     @su_dec
        rets
su_dec:
        lda     @skill_sel
        mov     A,B
        lda     @skill_cnt(B)
        dec     A
        sta     @skill_cnt(B)
        lda     @skill_sel
        call    @panel_draw_slot        ; nombre mis a jour tout de suite
        rets

; --- selectionne le pouvoir A (0..5) : deplace la surbrillance
skill_select:
        cmpa    @skill_sel
        jne     @ss_go
        rets                            ; deja lui : rien a redessiner
ss_go:
        mov     A,TEMP1                 ; nouveau (panel_draw_slot ne touche
        lda     @skill_sel              ; pas TEMP1)
        mov     A,B                     ; ancien
        mov     TEMP1,A
        sta     @skill_sel
        mov     B,A
        call    @panel_draw_slot        ; l'ancien perd sa surbrillance
        mov     TEMP1,A
        call    @panel_draw_slot        ; le nouveau la recoit
        rets

; --- pouvoir suivant (TAB, bouton 2 de la souris), en boucle
skill_next:
        lda     @skill_sel
        inc     A
        cmp     %NUM_SKILLS,A
        jne     @sn_ok
        clr     A
sn_ok:
        call    @skill_select
        rets

; --- boutons de la souris memorises par check_mouse (fronts seulement)
mouse_actions:
        lda     @mouse_act
        and     %MOUSE_BTN1,A
        jeq     @ma_b2
        lda     @level_over             ; niveau fini : le bouton 1 fait
        jeq     @ma_use                 ; comme Espace (level_start
        br      @level_next             ; repositionne la pile)
ma_use:
        call    @skill_use              ; bouton 1 : attribuer
ma_b2:
        lda     @mouse_act
        and     %MOUSE_BTN2,A
        jeq     @ma_done
        call    @skill_next             ; bouton 2 : pouvoir suivant
ma_done:
        clr     A
        sta     @mouse_act
        rets

; --- pointeur d'ecriture VDP sur la cellule (ligne A = 0..2 du panneau,
; colonne B = 0..39). Utilise TEMP6-TEMP8.
panel_setpos:
        mov     B,TEMP6                 ; colonne
        mov     A,B
        lda     @pnl_lo(B)
        mov     A,TEMP7                 ; debut de ligne, poids faible
        lda     @pnl_hi(B)
        mov     A,TEMP8                 ; poids fort
        mov     TEMP6,A
        add     TEMP6,A                 ; 2 octets par cellule (max 78)
        add     TEMP7,A
        jnc     @psp_nc
        inc     TEMP8
psp_nc:
        mov     A,B
        mov     TEMP8,A
        call    @setAcmpxy              ; A = poids fort, B = poids faible
        rets

; --- une cellule vide, au fond courant (TEMP4)
pds_blank:
        mov     TEMP4,A
        or      %TEXT_ATTR,A
        movp    A,P46
        movp    %CH_BLANK,P46
        rets

; --- une cellule d'icone : A = n (0..3) dans l'icone du pouvoir TEMP2.
; Glyphe = TEMP5 (premier glyphe de l'icone, icon_base) + n ; couleur
; d'avant-plan = icon_fg[4*k + n] ; fond courant (TEMP4). Utilise TEMP6
; (libre ici : panel_setpos a deja servi pour cette ligne).
pds_icon:
        mov     A,TEMP6                 ; n
        mov     TEMP2,A                 ; 4k + n
        add     TEMP2,A
        mov     A,B
        add     B,A
        add     TEMP6,A
        mov     A,B
        lda     @icon_fg(B)
        or      %$18,A                  ; banc BAGC3
        or      TEMP4,A
        movp    A,P46
        mov     TEMP5,A
        add     TEMP6,A
        movp    A,P46
        rets

; --- dessine la case du pouvoir A (0..5). Utilise TEMP2-TEMP8, pas TEMP1.
panel_draw_slot:
        mov     A,TEMP2                 ; k
        mov     A,B
        lda     @pnl_x(B)
        mov     A,TEMP3                 ; premiere colonne de la case
        clr     A
        mov     A,TEMP4                 ; fond noir...
        mov     TEMP2,A
        cmpa    @skill_sel
        jne     @pds_bg
        mov     %PNL_SEL_BG,A           ; ...ou bleu s'il est selectionne
        mov     A,TEMP4
pds_bg:
        mov     TEMP2,A                 ; premier glyphe de son icone
        mov     A,B
        lda     @icon_base(B)
        mov     A,TEMP5

        clr     A                       ; ligne 1 : vide, HG, HD, vide
        mov     TEMP3,B
        call    @panel_setpos
        call    @pds_blank
        clr     A                       ; cellule 0 (haut-gauche)
        call    @pds_icon
        mov     %1,A                    ; cellule 1 (haut-droite)
        call    @pds_icon
        call    @pds_blank

        mov     %1,A                    ; ligne 2 : vide, BG, BD, vide
        mov     TEMP3,B
        call    @panel_setpos
        call    @pds_blank
        mov     %2,A                    ; cellule 2 (bas-gauche)
        call    @pds_icon
        mov     %3,A                    ; cellule 3 (bas-droite)
        call    @pds_icon
        call    @pds_blank

        mov     %2,A                    ; ligne 3 : touche, vide, nombre
        mov     TEMP3,B
        call    @panel_setpos
        mov     TEMP2,A
        mov     A,B
        lda     @skill_cnt(B)
        mov     A,TEMP5                 ; nombre restant
        jne     @pds_lw
        mov     %PNL_FG_ZERO|$18,A      ; epuise : libelle rouge
        br      @pds_la
pds_lw:
        mov     %FWHITE|$18,A
pds_la:
        or      TEMP4,A
        mov     A,TEMP7                 ; attribut du libelle
        movp    A,P46
        mov     TEMP2,A
        mov     A,B
        lda     @skill_key_uc(B)        ; la touche directe du pouvoir
        movp    A,P46
        mov     TEMP7,A
        movp    A,P46
        movp    %CH_BLANK,P46
        mov     TEMP5,A                 ; dizaines / unites (max 99)
        clr     B
pds_div:
        cmp     %10,A
        jnc     @pds_div_ok             ; jnc : A < 10
        sub     %10,A
        inc     B
        br      @pds_div
pds_div_ok:
        mov     A,TEMP8                 ; unites
        mov     TEMP7,A
        movp    A,P46
        mov     B,A
        jne     @pds_tens
        mov     %CH_BLANK,A             ; pas de zero en tete
        br      @pds_tw
pds_tens:
        add     %$30,A
pds_tw:
        movp    A,P46
        mov     TEMP7,A
        movp    A,P46
        mov     TEMP8,A
        add     %$30,A
        movp    A,P46
        rets

; --- tout le panneau : 3 lignes vides, puis les six cases
panel_draw_all:
        clr     A
        mov     A,TEMP1
pda_line:
        mov     TEMP1,A
        clr     B
        call    @panel_setpos
        mov     %40,B
pda_cell:
        movp    %TEXT_ATTR,P46
        movp    %CH_BLANK,P46
        djnz    B,@pda_cell
        inc     TEMP1
        mov     TEMP1,A
        cmp     %3,A
        jne     @pda_line
        clr     A
        mov     A,TEMP1
pda_slot:
        mov     TEMP1,A
        call    @panel_draw_slot
        inc     TEMP1
        mov     TEMP1,A
        cmp     %NUM_SKILLS,A
        jne     @pda_slot
        rets

; ============================================================================
; draw_text_line -- ecrit une chaine sur une ligne TEXTE de notre page
; mixte. put_char (mixt_api) ne peut pas servir : il ecrit dans la page de
; mixt_api, pas dans la notre. On ecrit donc directement les deux octets
; par caractere (attribut, code), 40 par ligne.
; Entrees : A:B = adresse VRAM du debut de ligne, TEMP3-1:TEMP3 = chaine
; terminee par $00.
; ============================================================================
draw_text_line:
        call    @setAcmpxy
        mov     %40,TEMP5               ; la ligne fait toujours 40 cellules
dtl_char:
        lda     *TEMP3
        jeq     @dtl_pad                ; fin de chaine : complete d'espaces
        cmp     %$20,A                  ; espace -> glyphe vide dedie (le
        jne     @dtl_notsp              ; code $20 peut s'afficher comme un
        mov     %CH_BLANK,A             ; pave sur machine reelle)
dtl_notsp:
        sta     @tmp_a
        movp    %TEXT_ATTR,P46
        lda     @tmp_a
        movp    A,P46
        inc     TEMP3
        jne     @dtl_next
        inc     TEMP3-1
dtl_next:
        djnz    TEMP5,@dtl_char
        rets
dtl_pad:
        movp    %TEXT_ATTR,P46
        movp    %CH_BLANK,P46           ; espace (glyphe vide dedie)
        djnz    TEMP5,@dtl_pad
        rets

; --- decalages de depart des rythmes de marche.
; ERREUR CORRIGEE : une premiere table (i*16/10 arrondis) ignorait que le
; moment de NAISSANCE lui-meme (tous les SPAWN_TICKS=200 ticks) apporte
; DEJA une phase -- 200 mod 16 = 8, donc les lemmings pairs et impairs
; partent avec 8 ticks d'ecart avant meme d'ajouter cette table. Combinee
; a l'ancienne table, la phase REELLE en regime permanent ne prenait que
; CINQ valeurs distinctes (partagees par deux lemmings chacune), pas dix.
; Cette table est choisie pour ANNULER la phase de naissance et repartir
; les dix lemmings sur les dix phases 0..9, une par tick.
lem_tick_init:
        .byte   0,7,14,5,12,3,10,1,8,15

; --- ecrit le compte de lemmings sauves, en 2 chiffres, DIRECTEMENT a
; l'adresse VRAM voulue -- pas via draw_text_line (qui ne sait lire qu'une
; chaine en ROM/RAM, jamais convertir un nombre). saved_count vaut au plus
; NUM_LEM(10), donc au plus 2 chiffres ; le calcul dizaine/unite reste
; volontairement simple (une seule comparaison) plutot qu'une division
; generale, qui serait inutile ici.
; Position : juste apres "SAUVES:" dans txt_top2 -- chaque case ecran
; occupe 2 octets (attribut, caractere), d'ou le decalage de 36*2=72.
TXT_SAUVES_POS  .equ    $069A           ; TXT_TOP2 + 36 caracteres*2 octets
TXT_TOP_HI      .equ    $06             ; poids fort commun aux deux lignes
                                        ; du haut ($0600..$06A3)
TXT_SORTIS_POS  .equ    $060E           ; ligne 1 (SCREEN_BASE $0600), col 7
TXT_TOTAL_POS   .equ    $0614           ; col 10
TXT_ASAUVER_POS .equ    $062E           ; col 23
TXT_FIN_POS     .equ    $0634           ; col 26 : GAGNE! / PERDU!
TXT_NIV_POS     .equ    $0660           ; ligne 2 (TXT_TOP2 $0652), col 7
; --- charge le niveau cur_level : son theme (adresses des tuiles et de leurs
; proprietes) et ses parametres, depuis les tables de leveldata.asm (une
; entree par niveau ou par theme, generees par EXELTILE).
level_load:
        lda     @cur_level
        mov     A,B
        lda     @lv_lvl_nscr(B)
        sta     @cur_nscr
        lda     @lv_lvl_lem_count(B)
        sta     @cur_lem_count
        lda     @lv_lvl_to_save(B)
        sta     @cur_to_save
        lda     @lv_lvl_spawn_scr(B)
        sta     @cur_spawn_scr
        lda     @lv_lvl_spawn_col(B)
        sta     @cur_spawn_col
        lda     @lv_lvl_spawn_y(B)
        sta     @cur_spawn_y
        mov     B,A                     ; premier ecran dans lv_map_hi/lo :
        add     B,A                     ; 3 par niveau
        add     B,A
        sta     @cur_map_base
        lda     @lv_lvl_theme(B)        ; son jeu de tuiles
        mov     A,B
        lda     @lv_thm_tiles_lo(B)
        sta     @tiles_lo
        lda     @lv_thm_tiles_hi(B)
        sta     @tiles_hi
        lda     @lv_thm_flags_lo(B)
        sta     @flags_lo
        lda     @lv_thm_flags_hi(B)
        sta     @flags_hi
        rets

; --- fin de niveau, Espace ou bouton 1 : niveau suivant si GAGNE (retour au
; premier apres le dernier), le meme si PERDU. On y arrive par BR depuis
; une routine appelee : level_start repositionne la pile.
level_next:
        lda     @level_won
        jeq     @lnx_go
        lda     @cur_level
        inc     A
        cmp     %LV_NLEVELS,A
        jnc     @lnx_set                ; jnc : il reste des niveaux
        clr     A                       ; apres le dernier : le premier
lnx_set:
        sta     @cur_level
lnx_go:
        br      @level_start

draw_saved_count:
        lda     @saved_count
        mov     %TXT_SAUVES_POS&$FF,B
        call    @put_2dig               ; jusqu'a 99 (avant : 19 au plus)
        rets

; --- ecrit A (0..99) en deux chiffres dans la ligne texte du HAUT, a
; l'adresse $06:B (les deux lignes du haut sont toutes en $06xx : voir
; TXT_TOP2 et les positions TXT_*_POS). Utilise TEMP6.
put_2dig:
        mov     A,TEMP6
        mov     %TXT_TOP_HI,A
        call    @setAcmpxy              ; A = poids fort, B = poids faible
        mov     TEMP6,A
        clr     B
p2d_div:
        cmp     %10,A
        jnc     @p2d_ok                 ; jnc : A < 10
        sub     %10,A
        inc     B
        br      @p2d_div
p2d_ok:
        mov     A,TEMP6                 ; unites
        movp    %TEXT_ATTR,P46
        mov     B,A
        add     %$30,A
        movp    A,P46
        movp    %TEXT_ATTR,P46
        mov     TEMP6,A
        add     %$30,A
        movp    A,P46
        rets

; --- ligne 1 : "SORTIS:nn/tt  A SAUVER:ss" (texte fixe dans txt_top1,
; chiffres ecrits ici)
draw_level_info:
        lda     @spawn_count
        mov     %TXT_SORTIS_POS&$FF,B
        call    @put_2dig
        lda     @cur_lem_count
        mov     %TXT_TOTAL_POS&$FF,B
        call    @put_2dig
        lda     @cur_to_save
        mov     %TXT_ASAUVER_POS&$FF,B
        call    @put_2dig
        lda     @cur_level              ; numero de niveau, a partir de 1
        inc     A
        mov     %TXT_NIV_POS&$FF,B
        call    @put_2dig
        rets

; --- fin de niveau : quand tous les lemmings sont sortis et qu'aucun n'est
; plus en jeu (sauves ou morts), compare les sauves au nombre demande et
; l'affiche, une seule fois. Un bloqueur reste en jeu indefiniment : il
; faut le faire exploser (E) pour terminer, comme dans l'original.
level_check:
        lda     @level_over
        jeq     @lc_go
        rets                            ; deja termine
lc_go:
        lda     @spawn_count
        cmpa    @cur_lem_count
        jeq     @lc_all
        rets                            ; il en reste a faire sortir
lc_all:
        mov     %NUM_LEM,B
lc_look:
        lda     @lem_alive-1(B)
        jeq     @lc_next
        rets                            ; encore un lemming en jeu
lc_next:
        djnz    B,@lc_look
        mov     %1,A
        sta     @level_over
        lda     @saved_count
        cmpa    @cur_to_save
        jnc     @lc_lost                ; jnc : sauves < a sauver
        mov     %1,A
        sta     @level_won              ; Espace : niveau suivant
        movd    %txt_win,TEMP3
        br      @lc_msg
lc_lost:
        movd    %txt_lose,TEMP3
lc_msg:
        mov     %TXT_TOP_HI,A
        mov     %TXT_FIN_POS&$FF,B
        call    @draw_text_part
        rets

; --- ecrit une chaine (terminee par 0) a partir de A:B, SANS completer la
; ligne (contrairement a draw_text_line). Espace -> glyphe vide CH_BLANK.
draw_text_part:
        call    @setAcmpxy
dtp_char:
        lda     *TEMP3
        jeq     @dtp_end
        cmp     %$20,A
        jne     @dtp_ns
        mov     %CH_BLANK,A
dtp_ns:
        movp    %TEXT_ATTR,P46
        movp    A,P46
        inc     TEMP3
        jne     @dtp_char
        inc     TEMP3-1
        br      @dtp_char
dtp_end:
        rets

draw_texts:
        ; ORDRE CORRIGE : movd ecrase A et B (il charge une paire de
        ; registres et remet la retenue a zero). Charger la chaine APRES
        ; avoir pose A:B pour setAcmpxy detruisait donc l'adresse de la
        ; ligne -- le texte partait n'importe ou, d'ou les artefacts vus
        ; a l'ecran. On charge desormais la chaine D'ABORD.
        movd    %txt_top1,TEMP3
        mov     %SCREEN_BASE>>8,A
        mov     %SCREEN_BASE&$FF,B
        call    @draw_text_line

        movd    %txt_top2,TEMP3
        mov     %TXT_TOP2>>8,A
        mov     %TXT_TOP2&$FF,B
        call    @draw_text_line

        call    @panel_draw_all         ; panneau des pouvoirs (3 lignes)
        call    @draw_saved_count       ; "00" au demarrage
        call    @draw_level_info        ; SORTIS / total / A SAUVER
        rets

; Adresses des lignes texte, precalculees en dur (convention du projet :
; jamais d'expression a plus d'un operateur dans le source) :
;   haut 0 = SCREEN_BASE            = $0600
;   haut 1 = SCREEN_BASE + 82       = $0652
;   bas 0  = GRAPH_BASE + 200*122   = $06A4 + 24400 = $65F4
;   bas 1  = ... + 82               = $6646
;   bas 2  = ... + 164              = $6698
; (une premiere version donnait $6654/$66A6/$66F8 : 96 octets trop loin,
;  les trois lignes du bas seraient tombees hors de la page.)
TXT_TOP2        .equ    $0652
TXT_BOT1        .equ    $65F4
TXT_BOT2        .equ    $6646
TXT_BOT3        .equ    $6698

; --- police 5x7 chargee dans BAGC3 par trap 19 (voir l'initialisation) ----
; Generee dans la meme convention que celle d'Exeltris (les glyphes '0' et
; '1' sont octet pour octet identiques aux siens) : 10 octets par glyphe,
; premier octet = ligne du BAS (ligne 9), glyphe sur les lignes 1 a 7, 5
; pixels cadres a gauche (bits 7-3). Codes $20..$5F + CH_BLANK en $60.
font_chr:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; $20 espace (vide)
        .byte   $00,$00,$20,$00,$00,$20,$20,$20,$20,$00  ; $21 !
        .byte   $00,$00,$00,$00,$00,$00,$50,$50,$50,$00  ; $22 "
        .byte   $00,$00,$50,$50,$F8,$50,$F8,$50,$50,$00  ; $23 #
        .byte   $00,$00,$20,$F0,$28,$70,$A0,$78,$20,$00  ; $24 $
        .byte   $00,$00,$18,$98,$40,$20,$10,$C8,$C0,$00  ; $25 %
        .byte   $00,$00,$68,$90,$A8,$40,$A0,$90,$60,$00  ; $26 &
        .byte   $00,$00,$00,$00,$00,$00,$40,$20,$60,$00  ; $27 '
        .byte   $00,$00,$10,$20,$40,$40,$40,$20,$10,$00  ; $28 (
        .byte   $00,$00,$40,$20,$10,$10,$10,$20,$40,$00  ; $29 )
        .byte   $00,$00,$00,$20,$A8,$70,$A8,$20,$00,$00  ; $2A *
        .byte   $00,$00,$00,$20,$20,$F8,$20,$20,$00,$00  ; $2B +
        .byte   $00,$00,$40,$20,$60,$00,$00,$00,$00,$00  ; $2C ,
        .byte   $00,$00,$00,$00,$00,$F8,$00,$00,$00,$00  ; $2D -
        .byte   $00,$00,$60,$60,$00,$00,$00,$00,$00,$00  ; $2E .
        .byte   $00,$00,$00,$80,$40,$20,$10,$08,$00,$00  ; $2F /
        .byte   $00,$00,$70,$88,$C8,$A8,$98,$88,$70,$00  ; $30 0
        .byte   $00,$00,$70,$20,$20,$20,$20,$60,$20,$00  ; $31 1
        .byte   $00,$00,$F8,$40,$20,$10,$08,$88,$70,$00  ; $32 2
        .byte   $00,$00,$70,$88,$08,$10,$20,$10,$F8,$00  ; $33 3
        .byte   $00,$00,$10,$10,$F8,$90,$50,$30,$10,$00  ; $34 4
        .byte   $00,$00,$70,$88,$08,$08,$F0,$80,$F8,$00  ; $35 5
        .byte   $00,$00,$70,$88,$88,$F0,$80,$40,$30,$00  ; $36 6
        .byte   $00,$00,$40,$40,$40,$20,$10,$08,$F8,$00  ; $37 7
        .byte   $00,$00,$70,$88,$88,$70,$88,$88,$70,$00  ; $38 8
        .byte   $00,$00,$60,$10,$08,$78,$88,$88,$70,$00  ; $39 9
        .byte   $00,$00,$00,$30,$30,$00,$30,$30,$00,$00  ; $3A :
        .byte   $00,$00,$40,$20,$60,$00,$60,$60,$00,$00  ; $3B ;
        .byte   $00,$00,$10,$20,$40,$80,$40,$20,$10,$00  ; $3C <
        .byte   $00,$00,$00,$00,$F8,$00,$F8,$00,$00,$00  ; $3D =
        .byte   $00,$00,$40,$20,$10,$08,$10,$20,$40,$00  ; $3E >
        .byte   $00,$00,$20,$00,$20,$10,$08,$88,$70,$00  ; $3F ?
        .byte   $00,$00,$70,$A8,$A8,$68,$08,$88,$70,$00  ; $40 @
        .byte   $00,$00,$88,$88,$F8,$88,$88,$88,$70,$00  ; $41 A
        .byte   $00,$00,$F0,$88,$88,$F0,$88,$88,$F0,$00  ; $42 B
        .byte   $00,$00,$70,$88,$80,$80,$80,$88,$70,$00  ; $43 C
        .byte   $00,$00,$E0,$90,$88,$88,$88,$90,$E0,$00  ; $44 D
        .byte   $00,$00,$F8,$80,$80,$F0,$80,$80,$F8,$00  ; $45 E
        .byte   $00,$00,$80,$80,$80,$F0,$80,$80,$F8,$00  ; $46 F
        .byte   $00,$00,$78,$88,$88,$B8,$80,$88,$70,$00  ; $47 G
        .byte   $00,$00,$88,$88,$88,$F8,$88,$88,$88,$00  ; $48 H
        .byte   $00,$00,$70,$20,$20,$20,$20,$20,$70,$00  ; $49 I
        .byte   $00,$00,$60,$90,$10,$10,$10,$10,$38,$00  ; $4A J
        .byte   $00,$00,$88,$90,$A0,$C0,$A0,$90,$88,$00  ; $4B K
        .byte   $00,$00,$F8,$80,$80,$80,$80,$80,$80,$00  ; $4C L
        .byte   $00,$00,$88,$88,$88,$A8,$A8,$D8,$88,$00  ; $4D M
        .byte   $00,$00,$88,$88,$98,$A8,$C8,$88,$88,$00  ; $4E N
        .byte   $00,$00,$70,$88,$88,$88,$88,$88,$70,$00  ; $4F O
        .byte   $00,$00,$80,$80,$80,$F0,$88,$88,$F0,$00  ; $50 P
        .byte   $00,$00,$68,$90,$A8,$88,$88,$88,$70,$00  ; $51 Q
        .byte   $00,$00,$88,$90,$A0,$F0,$88,$88,$F0,$00  ; $52 R
        .byte   $00,$00,$F0,$08,$08,$70,$80,$80,$78,$00  ; $53 S
        .byte   $00,$00,$20,$20,$20,$20,$20,$20,$F8,$00  ; $54 T
        .byte   $00,$00,$70,$88,$88,$88,$88,$88,$88,$00  ; $55 U
        .byte   $00,$00,$20,$50,$88,$88,$88,$88,$88,$00  ; $56 V
        .byte   $00,$00,$50,$A8,$A8,$A8,$88,$88,$88,$00  ; $57 W
        .byte   $00,$00,$88,$88,$50,$20,$50,$88,$88,$00  ; $58 X
        .byte   $00,$00,$20,$20,$20,$50,$88,$88,$88,$00  ; $59 Y
        .byte   $00,$00,$F8,$80,$40,$20,$10,$08,$F8,$00  ; $5A Z
        .byte   $00,$00,$70,$40,$40,$40,$40,$40,$70,$00  ; $5B [
        .byte   $00,$00,$00,$08,$10,$20,$40,$80,$00,$00  ; $5C \
        .byte   $00,$00,$70,$10,$10,$10,$10,$10,$70,$00  ; $5D ]
        .byte   $00,$00,$00,$00,$00,$00,$88,$50,$20,$00  ; $5E ^
        .byte   $00,$00,$F8,$00,$00,$00,$00,$00,$00,$00  ; $5F _
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; $60 CH_BLANK (vide)

txt_top1:
        .byte   "SORTIS:00/00  A SAUVER:00",0       ; chiffres : draw_level_info
txt_win:
        .byte   "GAGNE! ESPACE",0                   ; Espace / bouton 1 :
txt_lose:                                           ; recommencer le niveau
        .byte   "PERDU! ESPACE",0
txt_top2:
        .byte   "NIVEAU:00  R:ECRAN SUIVANT   SAUVES:",0   ; chiffres : col 7 et col 36
;  (les 3 lignes du bas accueillent desormais le panneau des pouvoirs)

; --- panneau des pouvoirs : donnees ------------------------------------------
; touches, dans l'ordre du panneau : C D H B F E G M
skill_key_uc:
        .byte   $43,$44,$48,$42,$46,$45,$47,$4D
skill_key_lc:
        .byte   $63,$64,$68,$62,$66,$65,$67,$6D
; premiere colonne de chaque case (4 de large, 1 d'ecart : 8 cases occupent
; les colonnes 0..38)
pnl_x:
        .byte   0,5,10,15,20,25,30,35
; premier code de glyphe de l'icone de chaque pouvoir (4 glyphes consecutifs)
icon_base:
        .byte   $61,$65,$69,$6D,$71,$75,$79,ICON_FIRST_M
; debut en VRAM des 3 lignes texte du bas
pnl_lo:
        .byte   TXT_BOT1&$FF,TXT_BOT2&$FF,TXT_BOT3&$FF
pnl_hi:
        .byte   TXT_BOT1>>8,TXT_BOT2>>8,TXT_BOT3>>8
; couleur d'avant-plan de chaque glyphe d'icone (bits 7-5 = B G R) : une
; valeur par cellule, pour pouvoir reprendre plus tard des icones dessinees
; avec une couleur differente par cellule. Le FOND vient de la selection.
icon_fg:
        .byte   $60,$60,$60,$60         ; C jaune
        .byte   $C0,$C0,$C0,$C0         ; D cyan
        .byte   $A0,$A0,$A0,$A0         ; H magenta
        .byte   $40,$40,$40,$40         ; B vert
        .byte   $E0,$E0,$E0,$E0         ; F blanc
        .byte   $20,$20,$20,$20         ; E rouge
        .byte   $C0,$E0,$C0,$E0         ; G : silhouette cyan, paroi blanche
        .byte   $60,$60,$20,$20         ; M : pioche jaune, terre rouge
; icones PROVISOIRES 16x20 (2x2 cellules), meme format que la police :
; 10 octets par glyphe, premier = ligne du BAS. A remplacer par les icones
; de l'outil semi-graphique (memes codes $61..$78, ordre HG HD BG BD).
icon_chr:
        .byte   $0F,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; $61 C haut-gauche
        .byte   $FF,$81,$FF,$FF,$09,$0F,$0F,$00,$00,$00  ; $62 C haut-droit
        .byte   $00,$00,$00,$FF,$80,$80,$FF,$FF,$08,$0F  ; $63 C bas-gauche
        .byte   $00,$00,$00,$FF,$01,$01,$FF,$FF,$01,$FF  ; $64 C bas-droit
        .byte   $0F,$1F,$3F,$03,$03,$03,$03,$03,$03,$00  ; $65 D haut-gauche
        .byte   $F0,$F8,$FC,$C0,$C0,$C0,$C0,$C0,$C0,$00  ; $66 D haut-droit
        .byte   $00,$FF,$55,$AA,$55,$AA,$FF,$01,$03,$07  ; $67 D bas-gauche
        .byte   $00,$FF,$55,$AA,$55,$AA,$FF,$80,$C0,$E0  ; $68 D bas-droit
        .byte   $FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00  ; $69 H haut-gauche
        .byte   $E7,$F7,$E5,$C7,$1F,$2B,$2F,$0B,$0F,$00  ; $6A H haut-droit
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$FF  ; $6B H bas-gauche
        .byte   $00,$00,$0F,$0B,$0F,$0B,$2F,$2B,$1F,$C5  ; $6C H bas-droit
        .byte   $03,$03,$03,$FF,$FF,$01,$03,$03,$01,$00  ; $6D B haut-gauche
        .byte   $C0,$C0,$C0,$FF,$FF,$80,$C0,$C0,$80,$00  ; $6E B haut-droit
        .byte   $00,$FF,$00,$1C,$0C,$0C,$06,$06,$03,$03  ; $6F B bas-gauche
        .byte   $00,$FF,$00,$38,$30,$30,$60,$60,$C0,$C0  ; $70 B bas-droit
        .byte   $18,$28,$48,$88,$FF,$7F,$3F,$1F,$07,$00  ; $71 F haut-gauche
        .byte   $98,$94,$8A,$89,$FF,$FE,$FC,$F8,$E0,$00  ; $72 F haut-droit
        .byte   $00,$02,$01,$03,$03,$01,$01,$02,$04,$08  ; $73 F bas-gauche
        .byte   $00,$40,$80,$C0,$C0,$80,$80,$C0,$A0,$90  ; $74 F bas-droit
        .byte   $3F,$1F,$0F,$03,$00,$00,$00,$00,$00,$00  ; $75 E haut-gauche
        .byte   $FC,$F8,$F0,$C0,$40,$20,$14,$08,$14,$00  ; $76 E haut-droit
        .byte   $00,$00,$03,$0F,$1F,$3F,$3F,$2F,$2F,$37  ; $77 E bas-gauche
        .byte   $00,$00,$C0,$F0,$F8,$FC,$FC,$FC,$FC,$FC  ; $78 E bas-droit
        .byte   $01,$01,$01,$03,$03,$07,$07,$03,$00,$00  ; $79 G haut-gauche
        .byte   $9F,$9F,$DF,$DF,$7F,$BF,$BF,$3F,$3F,$1F  ; $7A G haut-droit
        .byte   $00,$00,$00,$00,$08,$04,$02,$01,$01,$01  ; $7B G bas-gauche
        .byte   $3F,$1F,$3F,$1F,$3F,$3F,$3F,$7F,$DF,$9F  ; $7C G bas-droit
        .byte   $FF,$00,$0C,$0C,$0C,$0C,$8C,$7F,$3E,$00  ; $01 M haut-gauche
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; $02 M haut-droit
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FC,$F8,$F0  ; $03 M bas-gauche
        .byte   $FF,$F0,$E1,$C3,$87,$0F,$1F,$3F,$7F,$FF  ; $04 M bas-droit

; ============================================================================
; tick_isr -- appelee 50 fois par seconde par le moniteur, via BRTIME.
; A et B sont deja sauvegardes par le moniteur ; cette routine n'utilise
; qu'eux, donc rien d'autre a preserver. Elle doit finir par RETS (et non
; RETI) : c'est le moniteur qui termine l'interruption.
; Volontairement minuscule -- tout le travail se fait dans la boucle
; principale, qui consomme les ticks accumules.
; ============================================================================
tick_isr:
        lda     @tick_cnt
        inc     A
        sta     @tick_cnt
        rets

; ============================================================================
; DONNEES GENEREES PAR LES EDITEURS
;
; Placees ICI, tout a la fin de la zone de donnees : un #include insere le
; contenu a l'endroit exact ou il apparait, et ce sont des .byte -- au
; milieu du code, le processeur tenterait d'executer des pixels.
;
; Ces deux fichiers sont produits par les outils et peuvent etre remplaces
; a volonte sans toucher a ce programme :
;   leveldata.asm  <- EXELTILE  (tuiles 8x10 + proprietes + cartes)
;   lemdata.asm    <- EXELLEM   (sprites de lemmings + animations)
;
; Symboles exportes, prefixes pour eviter toute collision avec ce fichier :
;   LV_NTILES, LV_NSCREENS, LV_MAP_W, LV_MAP_H, LV_TILE_BYTES
;   lv_flags, lv_tiles, lv_map0..2, lv_map_hi, lv_map_lo
;   LEM_NTYPES, LEM_WSEG, LEM_HLINES, LEM_FRAME_BYTES
;   lem_tN_fM, lem_defN, lem_framesN_hi/lo, lem_def_hi/lo
;
; Ces donnees sont REELLEMENT utilisees : draw_all_tiles parcourt la carte
; de l'ecran courant, bg_draw_rect/bg_fill_buf la relisent pour regenerer
; le decor sous les sprites, et lem_draw va chercher les vignettes du
; lemming dans lem_frames0_hi/lo.
; ============================================================================
#include "leveldata.asm"
#include "lemdata.asm"

#include "mixt_api.asm"

        .end
