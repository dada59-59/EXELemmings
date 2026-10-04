; ============================================================================
; Genere par EXELTILE -- ne pas editer a la main.
;
; 1 niveau(x), 1 theme(s) (jeux de tuiles). Chaque niveau
; designe son theme ; l'ordre des niveaux est l'ordre du jeu.
; Tuiles 8x10, mode bitmap TMS3556 : chaque ligne de tuile occupe
; 3 octets consecutifs -- plan Bleu, plan Vert, plan Rouge (manuel TMS3556,
; figure 3.18). bit 7 = pixel de gauche. Une tuile = 30 octets.
; ============================================================================

LV_NLEVELS     .equ    1
LV_NTHEMES     .equ    1
LV_MAP_W       .equ    40
LV_MAP_H       .equ    20
LV_TILE_BYTES  .equ    30

; --- constantes nommees (premier theme) ------------------------------------
TILE_VIDE        .equ    0               ; = tuile "vide"
TILE_TERRE       .equ    1               ; = tuile "terre"
TILE_MARCHEA     .equ    2               ; = tuile "marcheA" (meme indice dans tous les themes)
TILE_MARCHEAG    .equ    3               ; = tuile "marcheAG" (meme indice dans tous les themes)
TILE_MARCHEB     .equ    4               ; = tuile "marcheB" (meme indice dans tous les themes)
TILE_MARCHEBG    .equ    5               ; = tuile "marcheBG" (meme indice dans tous les themes)
TILE_MARCHEC     .equ    6               ; = tuile "marcheC" (meme indice dans tous les themes)
TILE_MARCHECG    .equ    7               ; = tuile "marcheCG" (meme indice dans tous les themes)
TILE_SORTIE      .equ    8               ; = tuile "sortie" (meme indice dans tous les themes)
TILE_IMP11       .equ    9               ; = tuile "imp11"
TILE_IMP12       .equ    10               ; = tuile "imp12"
TILE_IMP13       .equ    11               ; = tuile "imp13"
TILE_IMP14       .equ    12               ; = tuile "imp14"
TILE_IMP15       .equ    13               ; = tuile "imp15"
TILE_IMP16       .equ    14               ; = tuile "imp16"
TILE_IMP17       .equ    15               ; = tuile "imp17"
TILE_IMP18       .equ    16               ; = tuile "imp18"
TILE_IMP19       .equ    17               ; = tuile "imp19"
TILE_IMP20       .equ    18               ; = tuile "imp20"
TILE_IMP21       .equ    19               ; = tuile "imp21"
TILE_IMP22       .equ    20               ; = tuile "imp22"
TILE_IMP23       .equ    21               ; = tuile "imp23"
TILE_IMP24       .equ    22               ; = tuile "imp24"
TILE_IMP25       .equ    23               ; = tuile "imp25"
TILE_IMP26       .equ    24               ; = tuile "imp26"
TILE_IMP27       .equ    25               ; = tuile "imp27"
TILE_IMP28       .equ    26               ; = tuile "imp28"
TILE_IMP29       .equ    27               ; = tuile "imp29"
TILE_IMP30       .equ    28               ; = tuile "imp30"
TILE_IMP31       .equ    29               ; = tuile "imp31"
TILE_IMP32       .equ    30               ; = tuile "imp32"
TILE_IMP33       .equ    31               ; = tuile "imp33"
TILE_IMP34       .equ    32               ; = tuile "imp34"
TILE_IMP35       .equ    33               ; = tuile "imp35"
TILE_IMP36       .equ    34               ; = tuile "imp36"
TILE_IMP37       .equ    35               ; = tuile "imp37"
TILE_IMP38       .equ    36               ; = tuile "imp38"
TILE_IMP39       .equ    37               ; = tuile "imp39"
TILE_IMP40       .equ    38               ; = tuile "imp40"
TILE_IMP41       .equ    39               ; = tuile "imp41"
TILE_IMP42       .equ    40               ; = tuile "imp42"
TILE_IMP43       .equ    41               ; = tuile "imp43"
TILE_IMP44       .equ    42               ; = tuile "imp44"
TILE_IMP45       .equ    43               ; = tuile "imp45"
TILE_IMP46       .equ    44               ; = tuile "imp46"
TILE_IMP47       .equ    45               ; = tuile "imp47"
TILE_IMP48       .equ    46               ; = tuile "imp48"
TILE_IMP49       .equ    47               ; = tuile "imp49"
TILE_IMP50       .equ    48               ; = tuile "imp50"
TILE_IMP51       .equ    49               ; = tuile "imp51"
TILE_IMP52       .equ    50               ; = tuile "imp52"
TILE_IMP53       .equ    51               ; = tuile "imp53"
TILE_IMP54       .equ    52               ; = tuile "imp54"
TILE_IMP55       .equ    53               ; = tuile "imp55"
TILE_IMP56       .equ    54               ; = tuile "imp56"
TILE_IMP57       .equ    55               ; = tuile "imp57"
TILE_IMP58       .equ    56               ; = tuile "imp58"
TILE_IMP59       .equ    57               ; = tuile "imp59"
TILE_IMP60       .equ    58               ; = tuile "imp60"
TILE_IMP61       .equ    59               ; = tuile "imp61"
TILE_IMP62       .equ    60               ; = tuile "imp62"
TILE_IMP63       .equ    61               ; = tuile "imp63"
TILE_IMP64       .equ    62               ; = tuile "imp64"
TILE_IMP65       .equ    63               ; = tuile "imp65"
TILE_IMP66       .equ    64               ; = tuile "imp66"
TILE_IMP67       .equ    65               ; = tuile "imp67"
TILE_IMP68       .equ    66               ; = tuile "imp68"
TILE_IMP69       .equ    67               ; = tuile "imp69"
TILE_IMP70       .equ    68               ; = tuile "imp70"
TILE_IMP71       .equ    69               ; = tuile "imp71"
TILE_IMP72       .equ    70               ; = tuile "imp72"
TILE_IMP73       .equ    71               ; = tuile "imp73"
TILE_IMP74       .equ    72               ; = tuile "imp74"
TILE_IMP75       .equ    73               ; = tuile "imp75"
TILE_IMP76       .equ    74               ; = tuile "imp76"
TILE_IMP77       .equ    75               ; = tuile "imp77"
TILE_IMP78       .equ    76               ; = tuile "imp78"
TILE_IMP79       .equ    77               ; = tuile "imp79"
TILE_IMP80       .equ    78               ; = tuile "imp80"
TILE_IMP81       .equ    79               ; = tuile "imp81"
TILE_IMP82       .equ    80               ; = tuile "imp82"
TILE_IMP83       .equ    81               ; = tuile "imp83"
TILE_IMP84       .equ    82               ; = tuile "imp84"
TILE_IMP85       .equ    83               ; = tuile "imp85"
TILE_IMP86       .equ    84               ; = tuile "imp86"
TILE_IMP87       .equ    85               ; = tuile "imp87"
TILE_IMP88       .equ    86               ; = tuile "imp88"
TILE_IMP89       .equ    87               ; = tuile "imp89"
TILE_IMP90       .equ    88               ; = tuile "imp90"
TILE_IMP91       .equ    89               ; = tuile "imp91"
TILE_IMP92       .equ    90               ; = tuile "imp92"
TILE_IMP93       .equ    91               ; = tuile "imp93"
TILE_IMP94       .equ    92               ; = tuile "imp94"
TILE_IMP95       .equ    93               ; = tuile "imp95"
TILE_IMP96       .equ    94               ; = tuile "imp96"
TILE_IMP97       .equ    95               ; = tuile "imp97"
TILE_IMP98       .equ    96               ; = tuile "imp98"
TILE_IMP99       .equ    97               ; = tuile "imp99"
TILE_IMP100      .equ    98               ; = tuile "imp100"
TILE_IMP101      .equ    99               ; = tuile "imp101"
TILE_IMP102      .equ    100               ; = tuile "imp102"
TILE_IMP103      .equ    101               ; = tuile "imp103"
TILE_IMP104      .equ    102               ; = tuile "imp104"
TILE_IMP105      .equ    103               ; = tuile "imp105"
TILE_IMP106      .equ    104               ; = tuile "imp106"
TILE_IMP107      .equ    105               ; = tuile "imp107"
TILE_IMP108      .equ    106               ; = tuile "imp108"
TILE_IMP109      .equ    107               ; = tuile "imp109"
TILE_IMP110      .equ    108               ; = tuile "imp110"
TILE_IMP111      .equ    109               ; = tuile "imp111"
TILE_IMP112      .equ    110               ; = tuile "imp112"
TILE_IMP113      .equ    111               ; = tuile "imp113"
TILE_IMP114      .equ    112               ; = tuile "imp114"
TILE_IMP115      .equ    113               ; = tuile "imp115"
TILE_IMP116      .equ    114               ; = tuile "imp116"
TILE_IMP117      .equ    115               ; = tuile "imp117"
TILE_IMP118      .equ    116               ; = tuile "imp118"
TILE_IMP119      .equ    117               ; = tuile "imp119"
TILE_IMP120      .equ    118               ; = tuile "imp120"
TILE_IMP121      .equ    119               ; = tuile "imp121"
TILE_IMP122      .equ    120               ; = tuile "imp122"
TILE_IMP123      .equ    121               ; = tuile "imp123"
TILE_IMP124      .equ    122               ; = tuile "imp124"
TILE_IMP125      .equ    123               ; = tuile "imp125"
TILE_IMP126      .equ    124               ; = tuile "imp126"
TILE_IMP127      .equ    125               ; = tuile "imp127"
TILE_IMP128      .equ    126               ; = tuile "imp128"
TILE_IMP129      .equ    127               ; = tuile "imp129"
TILE_IMP130      .equ    128               ; = tuile "imp130"
TILE_IMP131      .equ    129               ; = tuile "imp131"
TILE_IMP132      .equ    130               ; = tuile "imp132"
TILE_IMP133      .equ    131               ; = tuile "imp133"
TILE_IMP134      .equ    132               ; = tuile "imp134"
TILE_IMP135      .equ    133               ; = tuile "imp135"
TILE_IMP136      .equ    134               ; = tuile "imp136"
TILE_IMP137      .equ    135               ; = tuile "imp137"
TILE_IMP138      .equ    136               ; = tuile "imp138"
TILE_IMP139      .equ    137               ; = tuile "imp139"
TILE_IMP140      .equ    138               ; = tuile "imp140"
TILE_IMP141      .equ    139               ; = tuile "imp141"
TILE_IMP142      .equ    140               ; = tuile "imp142"
TILE_IMP143      .equ    141               ; = tuile "imp143"
TILE_IMP144      .equ    142               ; = tuile "imp144"
TILE_IMP145      .equ    143               ; = tuile "imp145"
TILE_IMP146      .equ    144               ; = tuile "imp146"
TILE_IMP147      .equ    145               ; = tuile "imp147"
TILE_IMP148      .equ    146               ; = tuile "imp148"
TILE_IMP149      .equ    147               ; = tuile "imp149"
TILE_IMP150      .equ    148               ; = tuile "imp150"
TILE_IMP151      .equ    149               ; = tuile "imp151"
TILE_IMP152      .equ    150               ; = tuile "imp152"
TILE_IMP153      .equ    151               ; = tuile "imp153"
TILE_IMP154      .equ    152               ; = tuile "imp154"
TILE_IMP155      .equ    153               ; = tuile "imp155"
TILE_IMP156      .equ    154               ; = tuile "imp156"
TILE_IMP157      .equ    155               ; = tuile "imp157"
TILE_IMP158      .equ    156               ; = tuile "imp158"
TILE_IMP159      .equ    157               ; = tuile "imp159"
TILE_IMP160      .equ    158               ; = tuile "imp160"
TILE_IMP161      .equ    159               ; = tuile "imp161"
TILE_IMP162      .equ    160               ; = tuile "imp162"
TILE_IMP163      .equ    161               ; = tuile "imp163"
TILE_IMP164      .equ    162               ; = tuile "imp164"
TILE_IMP165      .equ    163               ; = tuile "imp165"
TILE_IMP166      .equ    164               ; = tuile "imp166"
TILE_IMP167      .equ    165               ; = tuile "imp167"
TILE_IMP168      .equ    166               ; = tuile "imp168"
TILE_IMP169      .equ    167               ; = tuile "imp169"
TILE_IMP170      .equ    168               ; = tuile "imp170"
TILE_IMP171      .equ    169               ; = tuile "imp171"
TILE_IMP172      .equ    170               ; = tuile "imp172"
TILE_IMP173      .equ    171               ; = tuile "imp173"
TILE_IMP174      .equ    172               ; = tuile "imp174"
TILE_IMP175      .equ    173               ; = tuile "imp175"
TILE_IMP176      .equ    174               ; = tuile "imp176"
TILE_IMP177      .equ    175               ; = tuile "imp177"
TILE_IMP178      .equ    176               ; = tuile "imp178"
TILE_IMP179      .equ    177               ; = tuile "imp179"
TILE_IMP180      .equ    178               ; = tuile "imp180"
TILE_IMP181      .equ    179               ; = tuile "imp181"
TILE_IMP182      .equ    180               ; = tuile "imp182"
TILE_IMP183      .equ    181               ; = tuile "imp183"
TILE_IMP184      .equ    182               ; = tuile "imp184"
TILE_IMP185      .equ    183               ; = tuile "imp185"
TILE_IMP186      .equ    184               ; = tuile "imp186"
TILE_IMP187      .equ    185               ; = tuile "imp187"
TILE_IMP188      .equ    186               ; = tuile "imp188"
TILE_IMP189      .equ    187               ; = tuile "imp189"
TILE_IMP190      .equ    188               ; = tuile "imp190"
TILE_IMP191      .equ    189               ; = tuile "imp191"
TILE_IMP192      .equ    190               ; = tuile "imp192"
TILE_IMP193      .equ    191               ; = tuile "imp193"
TILE_IMP195      .equ    192               ; = tuile "imp195"
TILE_IMP196      .equ    193               ; = tuile "imp196"
TILE_IMP197      .equ    194               ; = tuile "imp197"
TILE_IMP198      .equ    195               ; = tuile "imp198"
TILE_IMP199      .equ    196               ; = tuile "imp199"
TILE_IMP200      .equ    197               ; = tuile "imp200"
TILE_IMP201      .equ    198               ; = tuile "imp201"
TILE_IMP202      .equ    199               ; = tuile "imp202"
TILE_IMP203      .equ    200               ; = tuile "imp203"
TILE_IMP204      .equ    201               ; = tuile "imp204"
TILE_IMP205      .equ    202               ; = tuile "imp205"
TILE_IMP206      .equ    203               ; = tuile "imp206"
TILE_IMP207      .equ    204               ; = tuile "imp207"
TILE_IMP209      .equ    205               ; = tuile "imp209"
TILE_IMP210      .equ    206               ; = tuile "imp210"
TILE_IMP211      .equ    207               ; = tuile "imp211"
TILE_IMP212      .equ    208               ; = tuile "imp212"
TILE_IMP213      .equ    209               ; = tuile "imp213"
TILE_IMP214      .equ    210               ; = tuile "imp214"
TILE_IMP215      .equ    211               ; = tuile "imp215"
TILE_IMP216      .equ    212               ; = tuile "imp216"
TILE_IMP217      .equ    213               ; = tuile "imp217"
TILE_IMP218      .equ    214               ; = tuile "imp218"
TILE_IMP219      .equ    215               ; = tuile "imp219"
TILE_IMP220      .equ    216               ; = tuile "imp220"
TILE_IMP221      .equ    217               ; = tuile "imp221"
TILE_IMP222      .equ    218               ; = tuile "imp222"
TILE_IMP223      .equ    219               ; = tuile "imp223"
TILE_IMP224      .equ    220               ; = tuile "imp224"
TILE_IMP225      .equ    221               ; = tuile "imp225"
TILE_IMP226      .equ    222               ; = tuile "imp226"
TILE_IMP227      .equ    223               ; = tuile "imp227"
TILE_IMP228      .equ    224               ; = tuile "imp228"
TILE_IMP231      .equ    225               ; = tuile "imp231"
TILE_IMP232      .equ    226               ; = tuile "imp232"
TILE_IMP235      .equ    227               ; = tuile "imp235"
TILE_IMP236      .equ    228               ; = tuile "imp236"
TILE_IMP237      .equ    229               ; = tuile "imp237"
TILE_IMP238      .equ    230               ; = tuile "imp238"
TILE_IMP239      .equ    231               ; = tuile "imp239"
TILE_IMP240      .equ    232               ; = tuile "imp240"
TILE_IMP241      .equ    233               ; = tuile "imp241"
TILE_IMP242      .equ    234               ; = tuile "imp242"
TILE_IMP243      .equ    235               ; = tuile "imp243"
TILE_IMP244      .equ    236               ; = tuile "imp244"
TILE_IMP245      .equ    237               ; = tuile "imp245"
TILE_IMP246      .equ    238               ; = tuile "imp246"
TILE_IMP247      .equ    239               ; = tuile "imp247"
TILE_IMP248      .equ    240               ; = tuile "imp248"
TILE_IMP252      .equ    241               ; = tuile "imp252"
TILE_IMP253      .equ    242               ; = tuile "imp253"
TILE_IMP254      .equ    243               ; = tuile "imp254"
TILE_IMP255      .equ    244               ; = tuile "imp255"

; --- niveaux : une entree par niveau ---------------------------------------
;   1 : niveau 1 (theme "base")
lv_lvl_theme:
        .byte   0   ; theme (jeu de tuiles)
lv_lvl_nscr:
        .byte   1   ; nombre d'ecrans (1..3)
lv_lvl_spawn_scr:
        .byte   0   ; depart : ecran
lv_lvl_spawn_col:
        .byte   4   ; depart : colonne (segments)
lv_lvl_spawn_y:
        .byte   20   ; depart : ligne de balayage (rangee*10)
lv_lvl_lem_count:
        .byte   10   ; lemmings a faire sortir
lv_lvl_to_save:
        .byte   5   ; lemmings a sauver
; pouvoirs, 8 par niveau : C constructeur, D creuseur, H frappeur, B bloqueur, F parachutiste, E kamikaze, G grimpeur, M mineur
lv_lvl_skills:
        .byte   10,10,10,10,10,10,10,10   ; niveau 1

; --- theme 0 : "base", 245 tuiles -----------------------------
; proprietes : bit 0 = solide (porte un lemming) ; bit 1 = destructible
lv_t0_flags:
        .byte   $00,$03,$03,$03,$03,$03,$03,$03   ; 0:vide 1:terre 2:marcheA 3:marcheAG 4:marcheB 5:marcheBG 6:marcheC 7:marcheCG
        .byte   $01,$00,$03,$03,$03,$03,$03,$03   ; 8:sortie 9:imp11 10:imp12 11:imp13 12:imp14 13:imp15 14:imp16 15:imp17
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 16:imp18 17:imp19 18:imp20 19:imp21 20:imp22 21:imp23 22:imp24 23:imp25
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 24:imp26 25:imp27 26:imp28 27:imp29 28:imp30 29:imp31 30:imp32 31:imp33
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 32:imp34 33:imp35 34:imp36 35:imp37 36:imp38 37:imp39 38:imp40 39:imp41
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 40:imp42 41:imp43 42:imp44 43:imp45 44:imp46 45:imp47 46:imp48 47:imp49
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 48:imp50 49:imp51 50:imp52 51:imp53 52:imp54 53:imp55 54:imp56 55:imp57
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 56:imp58 57:imp59 58:imp60 59:imp61 60:imp62 61:imp63 62:imp64 63:imp65
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 64:imp66 65:imp67 66:imp68 67:imp69 68:imp70 69:imp71 70:imp72 71:imp73
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 72:imp74 73:imp75 74:imp76 75:imp77 76:imp78 77:imp79 78:imp80 79:imp81
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 80:imp82 81:imp83 82:imp84 83:imp85 84:imp86 85:imp87 86:imp88 87:imp89
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 88:imp90 89:imp91 90:imp92 91:imp93 92:imp94 93:imp95 94:imp96 95:imp97
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 96:imp98 97:imp99 98:imp100 99:imp101 100:imp102 101:imp103 102:imp104 103:imp105
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 104:imp106 105:imp107 106:imp108 107:imp109 108:imp110 109:imp111 110:imp112 111:imp113
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 112:imp114 113:imp115 114:imp116 115:imp117 116:imp118 117:imp119 118:imp120 119:imp121
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 120:imp122 121:imp123 122:imp124 123:imp125 124:imp126 125:imp127 126:imp128 127:imp129
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 128:imp130 129:imp131 130:imp132 131:imp133 132:imp134 133:imp135 134:imp136 135:imp137
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 136:imp138 137:imp139 138:imp140 139:imp141 140:imp142 141:imp143 142:imp144 143:imp145
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 144:imp146 145:imp147 146:imp148 147:imp149 148:imp150 149:imp151 150:imp152 151:imp153
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 152:imp154 153:imp155 154:imp156 155:imp157 156:imp158 157:imp159 158:imp160 159:imp161
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 160:imp162 161:imp163 162:imp164 163:imp165 164:imp166 165:imp167 166:imp168 167:imp169
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 168:imp170 169:imp171 170:imp172 171:imp173 172:imp174 173:imp175 174:imp176 175:imp177
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 176:imp178 177:imp179 178:imp180 179:imp181 180:imp182 181:imp183 182:imp184 183:imp185
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 184:imp186 185:imp187 186:imp188 187:imp189 188:imp190 189:imp191 190:imp192 191:imp193
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 192:imp195 193:imp196 194:imp197 195:imp198 196:imp199 197:imp200 198:imp201 199:imp202
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 200:imp203 201:imp204 202:imp205 203:imp206 204:imp207 205:imp209 206:imp210 207:imp211
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 208:imp212 209:imp213 210:imp214 211:imp215 212:imp216 213:imp217 214:imp218 215:imp219
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 216:imp220 217:imp221 218:imp222 219:imp223 220:imp224 221:imp225 222:imp226 223:imp227
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 224:imp228 225:imp231 226:imp232 227:imp235 228:imp236 229:imp237 230:imp238 231:imp239
        .byte   $03,$03,$03,$03,$03,$03,$03,$03   ; 232:imp240 233:imp241 234:imp242 235:imp243 236:imp244 237:imp245 238:imp246 239:imp247
        .byte   $03,$03,$03,$03,$03   ; 240:imp248 241:imp252 242:imp253 243:imp254 244:imp255
lv_t0_tiles:
; tuile 0 : vide
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 1 : terre [solide] [destructible]
        .byte   $00,$AA,$FF        ; ligne 0  B,G,R
        .byte   $00,$55,$FF        ; ligne 1  B,G,R
        .byte   $00,$AA,$FF        ; ligne 2  B,G,R
        .byte   $00,$55,$FF        ; ligne 3  B,G,R
        .byte   $00,$AA,$FF        ; ligne 4  B,G,R
        .byte   $00,$55,$FF        ; ligne 5  B,G,R
        .byte   $00,$AA,$FF        ; ligne 6  B,G,R
        .byte   $00,$55,$FF        ; ligne 7  B,G,R
        .byte   $00,$AA,$FF        ; ligne 8  B,G,R
        .byte   $00,$55,$FF        ; ligne 9  B,G,R
; tuile 2 : marcheA [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$18,$18        ; ligne 5  B,G,R
        .byte   $00,$28,$3C        ; ligne 6  B,G,R
        .byte   $00,$14,$3C        ; ligne 7  B,G,R
        .byte   $00,$2A,$7E        ; ligne 8  B,G,R
        .byte   $00,$55,$FF        ; ligne 9  B,G,R
; tuile 3 : marcheAG [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$18,$18        ; ligne 5  B,G,R
        .byte   $00,$14,$3C        ; ligne 6  B,G,R
        .byte   $00,$28,$3C        ; ligne 7  B,G,R
        .byte   $00,$54,$7E        ; ligne 8  B,G,R
        .byte   $00,$AA,$FF        ; ligne 9  B,G,R
; tuile 4 : marcheB [solide] [destructible]
        .byte   $00,$18,$18        ; ligne 0  B,G,R
        .byte   $00,$14,$3C        ; ligne 1  B,G,R
        .byte   $00,$28,$3C        ; ligne 2  B,G,R
        .byte   $00,$54,$7E        ; ligne 3  B,G,R
        .byte   $00,$AA,$FF        ; ligne 4  B,G,R
        .byte   $00,$55,$FF        ; ligne 5  B,G,R
        .byte   $00,$AA,$FF        ; ligne 6  B,G,R
        .byte   $00,$55,$FF        ; ligne 7  B,G,R
        .byte   $00,$AA,$FF        ; ligne 8  B,G,R
        .byte   $00,$55,$FF        ; ligne 9  B,G,R
; tuile 5 : marcheBG [solide] [destructible]
        .byte   $00,$18,$18        ; ligne 0  B,G,R
        .byte   $00,$28,$3C        ; ligne 1  B,G,R
        .byte   $00,$14,$3C        ; ligne 2  B,G,R
        .byte   $00,$2A,$7E        ; ligne 3  B,G,R
        .byte   $00,$55,$FF        ; ligne 4  B,G,R
        .byte   $00,$AA,$FF        ; ligne 5  B,G,R
        .byte   $00,$55,$FF        ; ligne 6  B,G,R
        .byte   $00,$AA,$FF        ; ligne 7  B,G,R
        .byte   $00,$55,$FF        ; ligne 8  B,G,R
        .byte   $00,$AA,$FF        ; ligne 9  B,G,R
; tuile 6 : marcheC [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$18,$18        ; ligne 5  B,G,R
        .byte   $00,$28,$3C        ; ligne 6  B,G,R
        .byte   $00,$14,$3C        ; ligne 7  B,G,R
        .byte   $00,$2A,$7E        ; ligne 8  B,G,R
        .byte   $00,$55,$FF        ; ligne 9  B,G,R
; tuile 7 : marcheCG [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$18,$18        ; ligne 5  B,G,R
        .byte   $00,$14,$3C        ; ligne 6  B,G,R
        .byte   $00,$28,$3C        ; ligne 7  B,G,R
        .byte   $00,$54,$7E        ; ligne 8  B,G,R
        .byte   $00,$AA,$FF        ; ligne 9  B,G,R
; tuile 8 : sortie [solide]
        .byte   $FF,$00,$FF        ; ligne 0  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 1  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 2  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 3  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 4  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 5  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 6  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 7  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 8  B,G,R
        .byte   $FF,$7E,$FF        ; ligne 9  B,G,R
; tuile 9 : imp11
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 10 : imp12 [solide] [destructible]
        .byte   $00,$80,$E7        ; ligne 0  B,G,R
        .byte   $00,$80,$E7        ; ligne 1  B,G,R
        .byte   $00,$80,$E7        ; ligne 2  B,G,R
        .byte   $00,$80,$E7        ; ligne 3  B,G,R
        .byte   $00,$80,$E7        ; ligne 4  B,G,R
        .byte   $00,$80,$E7        ; ligne 5  B,G,R
        .byte   $00,$80,$E7        ; ligne 6  B,G,R
        .byte   $00,$80,$E7        ; ligne 7  B,G,R
        .byte   $00,$80,$E7        ; ligne 8  B,G,R
        .byte   $00,$80,$E7        ; ligne 9  B,G,R
; tuile 11 : imp13 [solide] [destructible]
        .byte   $00,$03,$03        ; ligne 0  B,G,R
        .byte   $00,$03,$03        ; ligne 1  B,G,R
        .byte   $00,$03,$03        ; ligne 2  B,G,R
        .byte   $00,$03,$03        ; ligne 3  B,G,R
        .byte   $00,$03,$03        ; ligne 4  B,G,R
        .byte   $00,$03,$03        ; ligne 5  B,G,R
        .byte   $00,$03,$03        ; ligne 6  B,G,R
        .byte   $00,$03,$03        ; ligne 7  B,G,R
        .byte   $00,$03,$03        ; ligne 8  B,G,R
        .byte   $00,$03,$03        ; ligne 9  B,G,R
; tuile 12 : imp14 [solide] [destructible]
        .byte   $00,$67,$FF        ; ligne 0  B,G,R
        .byte   $00,$67,$FF        ; ligne 1  B,G,R
        .byte   $00,$67,$FF        ; ligne 2  B,G,R
        .byte   $00,$67,$FF        ; ligne 3  B,G,R
        .byte   $00,$67,$FF        ; ligne 4  B,G,R
        .byte   $00,$67,$FF        ; ligne 5  B,G,R
        .byte   $00,$67,$FF        ; ligne 6  B,G,R
        .byte   $00,$67,$FF        ; ligne 7  B,G,R
        .byte   $00,$67,$FF        ; ligne 8  B,G,R
        .byte   $00,$67,$FF        ; ligne 9  B,G,R
; tuile 13 : imp15 [solide] [destructible]
        .byte   $00,$E3,$F7        ; ligne 0  B,G,R
        .byte   $00,$E3,$F7        ; ligne 1  B,G,R
        .byte   $00,$E3,$F7        ; ligne 2  B,G,R
        .byte   $00,$E3,$F7        ; ligne 3  B,G,R
        .byte   $00,$E3,$F7        ; ligne 4  B,G,R
        .byte   $00,$E3,$F7        ; ligne 5  B,G,R
        .byte   $00,$E3,$F7        ; ligne 6  B,G,R
        .byte   $00,$E3,$F7        ; ligne 7  B,G,R
        .byte   $00,$E3,$F7        ; ligne 8  B,G,R
        .byte   $00,$E3,$F7        ; ligne 9  B,G,R
; tuile 14 : imp16 [solide] [destructible]
        .byte   $00,$E0,$F3        ; ligne 0  B,G,R
        .byte   $00,$E0,$FB        ; ligne 1  B,G,R
        .byte   $00,$E0,$FB        ; ligne 2  B,G,R
        .byte   $00,$E0,$FB        ; ligne 3  B,G,R
        .byte   $00,$E0,$FB        ; ligne 4  B,G,R
        .byte   $00,$E0,$FB        ; ligne 5  B,G,R
        .byte   $00,$E0,$FB        ; ligne 6  B,G,R
        .byte   $00,$E0,$FB        ; ligne 7  B,G,R
        .byte   $00,$E0,$FB        ; ligne 8  B,G,R
        .byte   $00,$E0,$FB        ; ligne 9  B,G,R
; tuile 15 : imp17 [solide] [destructible]
        .byte   $00,$00,$E8        ; ligne 0  B,G,R
        .byte   $00,$00,$E8        ; ligne 1  B,G,R
        .byte   $00,$00,$E8        ; ligne 2  B,G,R
        .byte   $00,$00,$E8        ; ligne 3  B,G,R
        .byte   $00,$00,$E8        ; ligne 4  B,G,R
        .byte   $00,$00,$E8        ; ligne 5  B,G,R
        .byte   $00,$00,$E8        ; ligne 6  B,G,R
        .byte   $00,$00,$E8        ; ligne 7  B,G,R
        .byte   $00,$00,$E8        ; ligne 8  B,G,R
        .byte   $00,$00,$E8        ; ligne 9  B,G,R
; tuile 16 : imp18 [solide] [destructible]
        .byte   $00,$07,$0F        ; ligne 0  B,G,R
        .byte   $00,$07,$0F        ; ligne 1  B,G,R
        .byte   $00,$07,$0F        ; ligne 2  B,G,R
        .byte   $00,$07,$0F        ; ligne 3  B,G,R
        .byte   $00,$07,$0F        ; ligne 4  B,G,R
        .byte   $00,$07,$0F        ; ligne 5  B,G,R
        .byte   $00,$07,$0F        ; ligne 6  B,G,R
        .byte   $00,$07,$0F        ; ligne 7  B,G,R
        .byte   $00,$07,$0F        ; ligne 8  B,G,R
        .byte   $00,$07,$0F        ; ligne 9  B,G,R
; tuile 17 : imp19 [solide] [destructible]
        .byte   $00,$DF,$FF        ; ligne 0  B,G,R
        .byte   $00,$DF,$FF        ; ligne 1  B,G,R
        .byte   $00,$DF,$FF        ; ligne 2  B,G,R
        .byte   $00,$DF,$FF        ; ligne 3  B,G,R
        .byte   $00,$DF,$FF        ; ligne 4  B,G,R
        .byte   $00,$DF,$FF        ; ligne 5  B,G,R
        .byte   $00,$DF,$FF        ; ligne 6  B,G,R
        .byte   $00,$DF,$FF        ; ligne 7  B,G,R
        .byte   $00,$DF,$FF        ; ligne 8  B,G,R
        .byte   $00,$DF,$FF        ; ligne 9  B,G,R
; tuile 18 : imp20 [solide] [destructible]
        .byte   $00,$8F,$DF        ; ligne 0  B,G,R
        .byte   $00,$8F,$DF        ; ligne 1  B,G,R
        .byte   $00,$8F,$DF        ; ligne 2  B,G,R
        .byte   $00,$8F,$DF        ; ligne 3  B,G,R
        .byte   $00,$8F,$DF        ; ligne 4  B,G,R
        .byte   $00,$8F,$DF        ; ligne 5  B,G,R
        .byte   $00,$8F,$DF        ; ligne 6  B,G,R
        .byte   $00,$8F,$DF        ; ligne 7  B,G,R
        .byte   $00,$8F,$DF        ; ligne 8  B,G,R
        .byte   $00,$8F,$DF        ; ligne 9  B,G,R
; tuile 19 : imp21 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$08,$FF        ; ligne 9  B,G,R
; tuile 20 : imp22 [solide] [destructible]
        .byte   $00,$00,$90        ; ligne 0  B,G,R
        .byte   $00,$00,$90        ; ligne 1  B,G,R
        .byte   $00,$00,$90        ; ligne 2  B,G,R
        .byte   $00,$00,$90        ; ligne 3  B,G,R
        .byte   $00,$00,$90        ; ligne 4  B,G,R
        .byte   $00,$00,$90        ; ligne 5  B,G,R
        .byte   $00,$00,$90        ; ligne 6  B,G,R
        .byte   $00,$00,$90        ; ligne 7  B,G,R
        .byte   $00,$00,$90        ; ligne 8  B,G,R
        .byte   $00,$00,$90        ; ligne 9  B,G,R
; tuile 21 : imp23 [solide] [destructible]
        .byte   $00,$1F,$1F        ; ligne 0  B,G,R
        .byte   $00,$1F,$1F        ; ligne 1  B,G,R
        .byte   $00,$1F,$1F        ; ligne 2  B,G,R
        .byte   $00,$1F,$1F        ; ligne 3  B,G,R
        .byte   $00,$1F,$1F        ; ligne 4  B,G,R
        .byte   $00,$1F,$1F        ; ligne 5  B,G,R
        .byte   $00,$1F,$1F        ; ligne 6  B,G,R
        .byte   $00,$1F,$1F        ; ligne 7  B,G,R
        .byte   $00,$1F,$1F        ; ligne 8  B,G,R
        .byte   $00,$1F,$1F        ; ligne 9  B,G,R
; tuile 22 : imp24 [solide] [destructible]
        .byte   $00,$7E,$FF        ; ligne 0  B,G,R
        .byte   $00,$7E,$FF        ; ligne 1  B,G,R
        .byte   $00,$7E,$FF        ; ligne 2  B,G,R
        .byte   $00,$7E,$FF        ; ligne 3  B,G,R
        .byte   $00,$7E,$FF        ; ligne 4  B,G,R
        .byte   $00,$7E,$FF        ; ligne 5  B,G,R
        .byte   $00,$7E,$FF        ; ligne 6  B,G,R
        .byte   $00,$7E,$FF        ; ligne 7  B,G,R
        .byte   $00,$7E,$FF        ; ligne 8  B,G,R
        .byte   $00,$7E,$FF        ; ligne 9  B,G,R
; tuile 23 : imp25 [solide] [destructible]
        .byte   $00,$1E,$7F        ; ligne 0  B,G,R
        .byte   $00,$1E,$7F        ; ligne 1  B,G,R
        .byte   $00,$1E,$7F        ; ligne 2  B,G,R
        .byte   $00,$1E,$7F        ; ligne 3  B,G,R
        .byte   $00,$1E,$7F        ; ligne 4  B,G,R
        .byte   $00,$1E,$7F        ; ligne 5  B,G,R
        .byte   $00,$1E,$7F        ; ligne 6  B,G,R
        .byte   $00,$1E,$7F        ; ligne 7  B,G,R
        .byte   $00,$1E,$7F        ; ligne 8  B,G,R
        .byte   $00,$1E,$7F        ; ligne 9  B,G,R
; tuile 24 : imp26 [solide] [destructible]
        .byte   $00,$00,$9C        ; ligne 0  B,G,R
        .byte   $00,$00,$9C        ; ligne 1  B,G,R
        .byte   $00,$00,$9C        ; ligne 2  B,G,R
        .byte   $00,$00,$9E        ; ligne 3  B,G,R
        .byte   $00,$00,$9E        ; ligne 4  B,G,R
        .byte   $00,$00,$9E        ; ligne 5  B,G,R
        .byte   $00,$00,$9E        ; ligne 6  B,G,R
        .byte   $00,$00,$9E        ; ligne 7  B,G,R
        .byte   $00,$00,$9E        ; ligne 8  B,G,R
        .byte   $00,$00,$9E        ; ligne 9  B,G,R
; tuile 25 : imp27 [solide] [destructible]
        .byte   $00,$00,$40        ; ligne 0  B,G,R
        .byte   $00,$00,$40        ; ligne 1  B,G,R
        .byte   $00,$00,$40        ; ligne 2  B,G,R
        .byte   $00,$00,$40        ; ligne 3  B,G,R
        .byte   $00,$00,$40        ; ligne 4  B,G,R
        .byte   $00,$00,$40        ; ligne 5  B,G,R
        .byte   $00,$00,$40        ; ligne 6  B,G,R
        .byte   $00,$00,$40        ; ligne 7  B,G,R
        .byte   $00,$00,$40        ; ligne 8  B,G,R
        .byte   $00,$00,$40        ; ligne 9  B,G,R
; tuile 26 : imp28 [solide] [destructible]
        .byte   $00,$CF,$FF        ; ligne 0  B,G,R
        .byte   $00,$CF,$FF        ; ligne 1  B,G,R
        .byte   $00,$CF,$FF        ; ligne 2  B,G,R
        .byte   $00,$CF,$FF        ; ligne 3  B,G,R
        .byte   $00,$CF,$FF        ; ligne 4  B,G,R
        .byte   $00,$CF,$FF        ; ligne 5  B,G,R
        .byte   $00,$CF,$FF        ; ligne 6  B,G,R
        .byte   $00,$CF,$FF        ; ligne 7  B,G,R
        .byte   $00,$CF,$FF        ; ligne 8  B,G,R
        .byte   $00,$CF,$FF        ; ligne 9  B,G,R
; tuile 27 : imp29 [solide] [destructible]
        .byte   $00,$87,$EF        ; ligne 0  B,G,R
        .byte   $00,$87,$EF        ; ligne 1  B,G,R
        .byte   $00,$87,$EF        ; ligne 2  B,G,R
        .byte   $00,$87,$EF        ; ligne 3  B,G,R
        .byte   $00,$87,$EF        ; ligne 4  B,G,R
        .byte   $00,$87,$EF        ; ligne 5  B,G,R
        .byte   $00,$87,$EF        ; ligne 6  B,G,R
        .byte   $00,$87,$EF        ; ligne 7  B,G,R
        .byte   $00,$87,$EF        ; ligne 8  B,G,R
        .byte   $00,$87,$EF        ; ligne 9  B,G,R
; tuile 28 : imp30 [solide] [destructible]
        .byte   $00,$1F,$BF        ; ligne 0  B,G,R
        .byte   $00,$1F,$BF        ; ligne 1  B,G,R
        .byte   $00,$1F,$BF        ; ligne 2  B,G,R
        .byte   $00,$1F,$BF        ; ligne 3  B,G,R
        .byte   $00,$1F,$BF        ; ligne 4  B,G,R
        .byte   $00,$1F,$BF        ; ligne 5  B,G,R
        .byte   $00,$1F,$BF        ; ligne 6  B,G,R
        .byte   $00,$1F,$BF        ; ligne 7  B,G,R
        .byte   $00,$1F,$BF        ; ligne 8  B,G,R
        .byte   $00,$1F,$BF        ; ligne 9  B,G,R
; tuile 29 : imp31 [solide] [destructible]
        .byte   $00,$00,$CF        ; ligne 0  B,G,R
        .byte   $00,$00,$CF        ; ligne 1  B,G,R
        .byte   $00,$00,$CF        ; ligne 2  B,G,R
        .byte   $00,$00,$CF        ; ligne 3  B,G,R
        .byte   $00,$00,$CF        ; ligne 4  B,G,R
        .byte   $00,$00,$CF        ; ligne 5  B,G,R
        .byte   $00,$00,$CF        ; ligne 6  B,G,R
        .byte   $00,$00,$CF        ; ligne 7  B,G,R
        .byte   $00,$00,$CF        ; ligne 8  B,G,R
        .byte   $00,$00,$CF        ; ligne 9  B,G,R
; tuile 30 : imp32 [solide] [destructible]
        .byte   $00,$00,$07        ; ligne 0  B,G,R
        .byte   $00,$00,$03        ; ligne 1  B,G,R
        .byte   $00,$00,$01        ; ligne 2  B,G,R
        .byte   $00,$00,$01        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 31 : imp33 [solide] [destructible]
        .byte   $00,$BF,$FF        ; ligne 0  B,G,R
        .byte   $00,$BF,$FF        ; ligne 1  B,G,R
        .byte   $00,$BF,$FF        ; ligne 2  B,G,R
        .byte   $00,$BF,$FF        ; ligne 3  B,G,R
        .byte   $00,$BF,$FF        ; ligne 4  B,G,R
        .byte   $00,$BF,$FF        ; ligne 5  B,G,R
        .byte   $00,$BF,$FF        ; ligne 6  B,G,R
        .byte   $00,$BF,$FF        ; ligne 7  B,G,R
        .byte   $00,$BF,$FF        ; ligne 8  B,G,R
        .byte   $00,$BF,$FF        ; ligne 9  B,G,R
; tuile 32 : imp34 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $FF,$00,$00        ; ligne 9  B,G,R
; tuile 33 : imp35 [solide] [destructible]
        .byte   $00,$01,$93        ; ligne 0  B,G,R
        .byte   $00,$01,$93        ; ligne 1  B,G,R
        .byte   $00,$01,$93        ; ligne 2  B,G,R
        .byte   $00,$01,$93        ; ligne 3  B,G,R
        .byte   $00,$01,$93        ; ligne 4  B,G,R
        .byte   $00,$01,$93        ; ligne 5  B,G,R
        .byte   $00,$01,$93        ; ligne 6  B,G,R
        .byte   $00,$01,$93        ; ligne 7  B,G,R
        .byte   $00,$01,$93        ; ligne 8  B,G,R
        .byte   $00,$00,$93        ; ligne 9  B,G,R
; tuile 34 : imp36 [solide] [destructible]
        .byte   $00,$B3,$FB        ; ligne 0  B,G,R
        .byte   $00,$FB,$FF        ; ligne 1  B,G,R
        .byte   $00,$FB,$FF        ; ligne 2  B,G,R
        .byte   $00,$FB,$FF        ; ligne 3  B,G,R
        .byte   $00,$FB,$FF        ; ligne 4  B,G,R
        .byte   $00,$FB,$FF        ; ligne 5  B,G,R
        .byte   $00,$FB,$FF        ; ligne 6  B,G,R
        .byte   $00,$FB,$FF        ; ligne 7  B,G,R
        .byte   $00,$FB,$FF        ; ligne 8  B,G,R
        .byte   $00,$FB,$FF        ; ligne 9  B,G,R
; tuile 35 : imp37 [solide] [destructible]
        .byte   $00,$F1,$FB        ; ligne 0  B,G,R
        .byte   $00,$F1,$FB        ; ligne 1  B,G,R
        .byte   $00,$F1,$FB        ; ligne 2  B,G,R
        .byte   $00,$F1,$FB        ; ligne 3  B,G,R
        .byte   $00,$F1,$FB        ; ligne 4  B,G,R
        .byte   $00,$F1,$FB        ; ligne 5  B,G,R
        .byte   $00,$F1,$FB        ; ligne 6  B,G,R
        .byte   $00,$F1,$FB        ; ligne 7  B,G,R
        .byte   $00,$F1,$FB        ; ligne 8  B,G,R
        .byte   $00,$F1,$FB        ; ligne 9  B,G,R
; tuile 36 : imp38 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$78,$FE        ; ligne 9  B,G,R
; tuile 37 : imp39 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$03,$0F        ; ligne 9  B,G,R
; tuile 38 : imp40 [solide] [destructible]
        .byte   $00,$C4,$FF        ; ligne 0  B,G,R
        .byte   $00,$3F,$FF        ; ligne 1  B,G,R
        .byte   $00,$F8,$FF        ; ligne 2  B,G,R
        .byte   $00,$FC,$FF        ; ligne 3  B,G,R
        .byte   $00,$FD,$FF        ; ligne 4  B,G,R
        .byte   $00,$F6,$FF        ; ligne 5  B,G,R
        .byte   $00,$FE,$FF        ; ligne 6  B,G,R
        .byte   $00,$E6,$FF        ; ligne 7  B,G,R
        .byte   $00,$C6,$FF        ; ligne 8  B,G,R
        .byte   $00,$E0,$FF        ; ligne 9  B,G,R
; tuile 39 : imp41 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$60        ; ligne 5  B,G,R
        .byte   $00,$00,$FC        ; ligne 6  B,G,R
        .byte   $00,$00,$FF        ; ligne 7  B,G,R
        .byte   $00,$00,$FF        ; ligne 8  B,G,R
        .byte   $20,$3F,$E0        ; ligne 9  B,G,R
; tuile 40 : imp42 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$C0        ; ligne 7  B,G,R
        .byte   $00,$00,$FC        ; ligne 8  B,G,R
        .byte   $FF,$00,$00        ; ligne 9  B,G,R
; tuile 41 : imp43 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $FF,$FF,$FF        ; ligne 9  B,G,R
; tuile 42 : imp44 [solide] [destructible]
        .byte   $00,$F0,$FF        ; ligne 0  B,G,R
        .byte   $00,$F0,$FF        ; ligne 1  B,G,R
        .byte   $00,$B1,$FF        ; ligne 2  B,G,R
        .byte   $00,$33,$FF        ; ligne 3  B,G,R
        .byte   $00,$70,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$7F        ; ligne 5  B,G,R
        .byte   $00,$20,$7F        ; ligne 6  B,G,R
        .byte   $00,$20,$3F        ; ligne 7  B,G,R
        .byte   $00,$00,$3F        ; ligne 8  B,G,R
        .byte   $00,$00,$0F        ; ligne 9  B,G,R
; tuile 43 : imp45 [solide] [destructible]
        .byte   $00,$38,$7F        ; ligne 0  B,G,R
        .byte   $00,$2C,$FF        ; ligne 1  B,G,R
        .byte   $00,$34,$FF        ; ligne 2  B,G,R
        .byte   $00,$34,$7F        ; ligne 3  B,G,R
        .byte   $00,$3C,$7F        ; ligne 4  B,G,R
        .byte   $00,$38,$7F        ; ligne 5  B,G,R
        .byte   $00,$38,$7F        ; ligne 6  B,G,R
        .byte   $00,$32,$FF        ; ligne 7  B,G,R
        .byte   $00,$17,$FF        ; ligne 8  B,G,R
        .byte   $00,$17,$FF        ; ligne 9  B,G,R
; tuile 44 : imp46 [solide] [destructible]
        .byte   $00,$07,$FF        ; ligne 0  B,G,R
        .byte   $00,$20,$FF        ; ligne 1  B,G,R
        .byte   $00,$20,$FF        ; ligne 2  B,G,R
        .byte   $00,$31,$FF        ; ligne 3  B,G,R
        .byte   $00,$9F,$FF        ; ligne 4  B,G,R
        .byte   $00,$7F,$FF        ; ligne 5  B,G,R
        .byte   $00,$77,$FF        ; ligne 6  B,G,R
        .byte   $00,$67,$FF        ; ligne 7  B,G,R
        .byte   $00,$CF,$FF        ; ligne 8  B,G,R
        .byte   $00,$FF,$FF        ; ligne 9  B,G,R
; tuile 45 : imp47 [solide] [destructible]
        .byte   $00,$FF,$FF        ; ligne 0  B,G,R
        .byte   $00,$7F,$FF        ; ligne 1  B,G,R
        .byte   $00,$0F,$FF        ; ligne 2  B,G,R
        .byte   $00,$06,$FF        ; ligne 3  B,G,R
        .byte   $00,$C0,$FE        ; ligne 4  B,G,R
        .byte   $00,$E0,$FC        ; ligne 5  B,G,R
        .byte   $00,$E0,$FE        ; ligne 6  B,G,R
        .byte   $00,$80,$FF        ; ligne 7  B,G,R
        .byte   $00,$04,$FF        ; ligne 8  B,G,R
        .byte   $00,$9E,$FF        ; ligne 9  B,G,R
; tuile 46 : imp48 [solide] [destructible]
        .byte   $00,$C3,$FF        ; ligne 0  B,G,R
        .byte   $00,$83,$FF        ; ligne 1  B,G,R
        .byte   $00,$17,$FF        ; ligne 2  B,G,R
        .byte   $00,$02,$FF        ; ligne 3  B,G,R
        .byte   $00,$01,$7F        ; ligne 4  B,G,R
        .byte   $00,$60,$FF        ; ligne 5  B,G,R
        .byte   $00,$78,$FF        ; ligne 6  B,G,R
        .byte   $00,$78,$FF        ; ligne 7  B,G,R
        .byte   $00,$78,$FF        ; ligne 8  B,G,R
        .byte   $00,$C0,$FC        ; ligne 9  B,G,R
; tuile 47 : imp49 [solide] [destructible]
        .byte   $00,$36,$FF        ; ligne 0  B,G,R
        .byte   $00,$FE,$FF        ; ligne 1  B,G,R
        .byte   $00,$7F,$FF        ; ligne 2  B,G,R
        .byte   $00,$3F,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$31,$FF        ; ligne 5  B,G,R
        .byte   $00,$30,$FF        ; ligne 6  B,G,R
        .byte   $00,$F8,$FF        ; ligne 7  B,G,R
        .byte   $00,$E6,$FF        ; ligne 8  B,G,R
        .byte   $00,$E0,$FF        ; ligne 9  B,G,R
; tuile 48 : imp50 [solide] [destructible]
        .byte   $00,$6F,$FF        ; ligne 0  B,G,R
        .byte   $00,$0F,$FF        ; ligne 1  B,G,R
        .byte   $00,$0F,$FF        ; ligne 2  B,G,R
        .byte   $00,$0D,$FF        ; ligne 3  B,G,R
        .byte   $00,$05,$CF        ; ligne 4  B,G,R
        .byte   $00,$0F,$DF        ; ligne 5  B,G,R
        .byte   $00,$0F,$DF        ; ligne 6  B,G,R
        .byte   $00,$0E,$FF        ; ligne 7  B,G,R
        .byte   $00,$0E,$FF        ; ligne 8  B,G,R
        .byte   $00,$87,$FF        ; ligne 9  B,G,R
; tuile 49 : imp51 [solide] [destructible]
        .byte   $00,$8F,$C3        ; ligne 0  B,G,R
        .byte   $00,$07,$E3        ; ligne 1  B,G,R
        .byte   $00,$07,$E3        ; ligne 2  B,G,R
        .byte   $00,$9F,$E7        ; ligne 3  B,G,R
        .byte   $00,$07,$FF        ; ligne 4  B,G,R
        .byte   $00,$17,$FF        ; ligne 5  B,G,R
        .byte   $00,$17,$FF        ; ligne 6  B,G,R
        .byte   $00,$17,$FF        ; ligne 7  B,G,R
        .byte   $00,$D7,$FF        ; ligne 8  B,G,R
        .byte   $00,$FF,$FF        ; ligne 9  B,G,R
; tuile 50 : imp52 [solide] [destructible]
        .byte   $00,$BF,$FF        ; ligne 0  B,G,R
        .byte   $00,$EF,$FF        ; ligne 1  B,G,R
        .byte   $00,$EE,$FF        ; ligne 2  B,G,R
        .byte   $00,$6F,$FF        ; ligne 3  B,G,R
        .byte   $00,$23,$FF        ; ligne 4  B,G,R
        .byte   $00,$E1,$FF        ; ligne 5  B,G,R
        .byte   $00,$C0,$FF        ; ligne 6  B,G,R
        .byte   $00,$D0,$FF        ; ligne 7  B,G,R
        .byte   $00,$94,$FF        ; ligne 8  B,G,R
        .byte   $00,$BE,$FF        ; ligne 9  B,G,R
; tuile 51 : imp53 [solide] [destructible]
        .byte   $00,$E0,$FF        ; ligne 0  B,G,R
        .byte   $00,$31,$FF        ; ligne 1  B,G,R
        .byte   $00,$21,$FF        ; ligne 2  B,G,R
        .byte   $00,$03,$FF        ; ligne 3  B,G,R
        .byte   $00,$C2,$FF        ; ligne 4  B,G,R
        .byte   $00,$E0,$FB        ; ligne 5  B,G,R
        .byte   $00,$40,$F7        ; ligne 6  B,G,R
        .byte   $00,$01,$E7        ; ligne 7  B,G,R
        .byte   $00,$05,$EF        ; ligne 8  B,G,R
        .byte   $00,$60,$FF        ; ligne 9  B,G,R
; tuile 52 : imp54 [solide] [destructible]
        .byte   $00,$B9,$FF        ; ligne 0  B,G,R
        .byte   $00,$7F,$FF        ; ligne 1  B,G,R
        .byte   $00,$EC,$FF        ; ligne 2  B,G,R
        .byte   $00,$E0,$FF        ; ligne 3  B,G,R
        .byte   $00,$42,$FF        ; ligne 4  B,G,R
        .byte   $00,$3C,$FF        ; ligne 5  B,G,R
        .byte   $00,$1C,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$FF        ; ligne 7  B,G,R
        .byte   $00,$00,$FF        ; ligne 8  B,G,R
        .byte   $00,$3E,$FF        ; ligne 9  B,G,R
; tuile 53 : imp55 [solide] [destructible]
        .byte   $00,$81,$FF        ; ligne 0  B,G,R
        .byte   $00,$01,$FF        ; ligne 1  B,G,R
        .byte   $00,$13,$FF        ; ligne 2  B,G,R
        .byte   $00,$33,$FF        ; ligne 3  B,G,R
        .byte   $00,$33,$FF        ; ligne 4  B,G,R
        .byte   $00,$18,$FF        ; ligne 5  B,G,R
        .byte   $00,$81,$FF        ; ligne 6  B,G,R
        .byte   $00,$C1,$FF        ; ligne 7  B,G,R
        .byte   $00,$CD,$FF        ; ligne 8  B,G,R
        .byte   $00,$F6,$FF        ; ligne 9  B,G,R
; tuile 54 : imp56 [solide] [destructible]
        .byte   $00,$DF,$FF        ; ligne 0  B,G,R
        .byte   $00,$A1,$FF        ; ligne 1  B,G,R
        .byte   $00,$E1,$FF        ; ligne 2  B,G,R
        .byte   $00,$F3,$FF        ; ligne 3  B,G,R
        .byte   $00,$FB,$FF        ; ligne 4  B,G,R
        .byte   $00,$11,$FF        ; ligne 5  B,G,R
        .byte   $00,$01,$FF        ; ligne 6  B,G,R
        .byte   $00,$93,$FF        ; ligne 7  B,G,R
        .byte   $00,$83,$FF        ; ligne 8  B,G,R
        .byte   $00,$61,$FF        ; ligne 9  B,G,R
; tuile 55 : imp57 [solide] [destructible]
        .byte   $00,$2F,$FF        ; ligne 0  B,G,R
        .byte   $00,$BF,$FF        ; ligne 1  B,G,R
        .byte   $00,$FF,$FF        ; ligne 2  B,G,R
        .byte   $00,$EE,$FF        ; ligne 3  B,G,R
        .byte   $00,$6F,$FF        ; ligne 4  B,G,R
        .byte   $00,$A3,$FF        ; ligne 5  B,G,R
        .byte   $00,$E3,$FF        ; ligne 6  B,G,R
        .byte   $00,$83,$FF        ; ligne 7  B,G,R
        .byte   $00,$03,$BF        ; ligne 8  B,G,R
        .byte   $00,$33,$FB        ; ligne 9  B,G,R
; tuile 56 : imp58 [solide] [destructible]
        .byte   $00,$B0,$FF        ; ligne 0  B,G,R
        .byte   $00,$F0,$FF        ; ligne 1  B,G,R
        .byte   $00,$30,$FF        ; ligne 2  B,G,R
        .byte   $00,$31,$FF        ; ligne 3  B,G,R
        .byte   $00,$03,$FF        ; ligne 4  B,G,R
        .byte   $00,$C2,$FF        ; ligne 5  B,G,R
        .byte   $00,$C0,$FF        ; ligne 6  B,G,R
        .byte   $00,$C0,$FB        ; ligne 7  B,G,R
        .byte   $00,$C1,$F7        ; ligne 8  B,G,R
        .byte   $00,$C5,$F7        ; ligne 9  B,G,R
; tuile 57 : imp59 [solide] [destructible]
        .byte   $00,$19,$FF        ; ligne 0  B,G,R
        .byte   $00,$99,$FF        ; ligne 1  B,G,R
        .byte   $00,$BD,$FF        ; ligne 2  B,G,R
        .byte   $00,$7F,$FF        ; ligne 3  B,G,R
        .byte   $00,$E0,$FF        ; ligne 4  B,G,R
        .byte   $00,$42,$FF        ; ligne 5  B,G,R
        .byte   $00,$0E,$FF        ; ligne 6  B,G,R
        .byte   $00,$1C,$FF        ; ligne 7  B,G,R
        .byte   $00,$98,$FF        ; ligne 8  B,G,R
        .byte   $00,$18,$FF        ; ligne 9  B,G,R
; tuile 58 : imp60 [solide] [destructible]
        .byte   $00,$05,$CF        ; ligne 0  B,G,R
        .byte   $00,$81,$FF        ; ligne 1  B,G,R
        .byte   $00,$81,$FF        ; ligne 2  B,G,R
        .byte   $00,$11,$FF        ; ligne 3  B,G,R
        .byte   $00,$3B,$FF        ; ligne 4  B,G,R
        .byte   $00,$33,$FF        ; ligne 5  B,G,R
        .byte   $00,$11,$FF        ; ligne 6  B,G,R
        .byte   $00,$01,$FF        ; ligne 7  B,G,R
        .byte   $00,$E1,$FF        ; ligne 8  B,G,R
        .byte   $00,$CD,$FF        ; ligne 9  B,G,R
; tuile 59 : imp61 [solide] [destructible]
        .byte   $00,$0F,$FF        ; ligne 0  B,G,R
        .byte   $00,$8F,$FF        ; ligne 1  B,G,R
        .byte   $00,$8F,$FF        ; ligne 2  B,G,R
        .byte   $00,$AF,$FF        ; ligne 3  B,G,R
        .byte   $00,$EF,$FF        ; ligne 4  B,G,R
        .byte   $00,$EF,$FF        ; ligne 5  B,G,R
        .byte   $00,$CF,$FF        ; ligne 6  B,G,R
        .byte   $00,$0F,$FF        ; ligne 7  B,G,R
        .byte   $00,$8F,$FF        ; ligne 8  B,G,R
        .byte   $00,$8F,$FF        ; ligne 9  B,G,R
; tuile 60 : imp62 [solide] [destructible]
        .byte   $00,$03,$27        ; ligne 0  B,G,R
        .byte   $00,$03,$27        ; ligne 1  B,G,R
        .byte   $00,$07,$27        ; ligne 2  B,G,R
        .byte   $00,$06,$27        ; ligne 3  B,G,R
        .byte   $00,$00,$27        ; ligne 4  B,G,R
        .byte   $00,$00,$27        ; ligne 5  B,G,R
        .byte   $00,$07,$27        ; ligne 6  B,G,R
        .byte   $00,$07,$27        ; ligne 7  B,G,R
        .byte   $00,$03,$27        ; ligne 8  B,G,R
        .byte   $00,$01,$27        ; ligne 9  B,G,R
; tuile 61 : imp63 [solide] [destructible]
        .byte   $00,$9F,$FF        ; ligne 0  B,G,R
        .byte   $00,$D0,$FF        ; ligne 1  B,G,R
        .byte   $00,$C2,$FF        ; ligne 2  B,G,R
        .byte   $00,$C2,$FF        ; ligne 3  B,G,R
        .byte   $00,$E5,$FF        ; ligne 4  B,G,R
        .byte   $00,$0F,$FF        ; ligne 5  B,G,R
        .byte   $00,$0D,$FF        ; ligne 6  B,G,R
        .byte   $00,$80,$FF        ; ligne 7  B,G,R
        .byte   $00,$C0,$EF        ; ligne 8  B,G,R
        .byte   $00,$07,$DF        ; ligne 9  B,G,R
; tuile 62 : imp64 [solide] [destructible]
        .byte   $10,$3F,$70        ; ligne 0  B,G,R
        .byte   $18,$1F,$38        ; ligne 1  B,G,R
        .byte   $18,$1F,$38        ; ligne 2  B,G,R
        .byte   $0C,$0F,$3C        ; ligne 3  B,G,R
        .byte   $06,$07,$3E        ; ligne 4  B,G,R
        .byte   $03,$03,$3F        ; ligne 5  B,G,R
        .byte   $03,$03,$3F        ; ligne 6  B,G,R
        .byte   $01,$01,$3F        ; ligne 7  B,G,R
        .byte   $00,$00,$3F        ; ligne 8  B,G,R
        .byte   $00,$00,$3F        ; ligne 9  B,G,R
; tuile 63 : imp65 [solide] [destructible]
        .byte   $FF,$00,$00        ; ligne 0  B,G,R
        .byte   $3F,$C0,$01        ; ligne 1  B,G,R
        .byte   $37,$C9,$01        ; ligne 2  B,G,R
        .byte   $26,$DF,$06        ; ligne 3  B,G,R
        .byte   $02,$FF,$02        ; ligne 4  B,G,R
        .byte   $00,$FF,$00        ; ligne 5  B,G,R
        .byte   $00,$FF,$00        ; ligne 6  B,G,R
        .byte   $80,$FF,$80        ; ligne 7  B,G,R
        .byte   $C0,$FF,$C0        ; ligne 8  B,G,R
        .byte   $60,$40,$C0        ; ligne 9  B,G,R
; tuile 64 : imp66 [solide] [destructible]
        .byte   $FF,$00,$00        ; ligne 0  B,G,R
        .byte   $FF,$00,$80        ; ligne 1  B,G,R
        .byte   $FF,$C0,$C0        ; ligne 2  B,G,R
        .byte   $FF,$F8,$F8        ; ligne 3  B,G,R
        .byte   $FF,$FC,$FC        ; ligne 4  B,G,R
        .byte   $FF,$FD,$FD        ; ligne 5  B,G,R
        .byte   $7F,$FF,$7F        ; ligne 6  B,G,R
        .byte   $2F,$FF,$2F        ; ligne 7  B,G,R
        .byte   $2F,$FF,$2F        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 65 : imp67 [solide] [destructible]
        .byte   $FF,$7F,$FF        ; ligne 0  B,G,R
        .byte   $FF,$3F,$3F        ; ligne 1  B,G,R
        .byte   $FF,$1C,$3C        ; ligne 2  B,G,R
        .byte   $FF,$38,$38        ; ligne 3  B,G,R
        .byte   $FF,$E3,$F3        ; ligne 4  B,G,R
        .byte   $FF,$FF,$FF        ; ligne 5  B,G,R
        .byte   $FF,$FF,$FF        ; ligne 6  B,G,R
        .byte   $FF,$FF,$FF        ; ligne 7  B,G,R
        .byte   $FE,$FE,$FE        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 66 : imp68 [solide] [destructible]
        .byte   $F8,$00,$80        ; ligne 0  B,G,R
        .byte   $F8,$00,$00        ; ligne 1  B,G,R
        .byte   $F0,$00,$00        ; ligne 2  B,G,R
        .byte   $E0,$60,$60        ; ligne 3  B,G,R
        .byte   $C0,$C0,$C0        ; ligne 4  B,G,R
        .byte   $C0,$80,$80        ; ligne 5  B,G,R
        .byte   $80,$80,$80        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 67 : imp69 [solide] [destructible]
        .byte   $00,$3F,$FF        ; ligne 0  B,G,R
        .byte   $00,$3D,$FF        ; ligne 1  B,G,R
        .byte   $00,$B9,$FF        ; ligne 2  B,G,R
        .byte   $00,$03,$BF        ; ligne 3  B,G,R
        .byte   $00,$00,$1F        ; ligne 4  B,G,R
        .byte   $00,$00,$0B        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 68 : imp70 [solide] [destructible]
        .byte   $00,$F1,$FF        ; ligne 0  B,G,R
        .byte   $00,$80,$FF        ; ligne 1  B,G,R
        .byte   $00,$80,$FF        ; ligne 2  B,G,R
        .byte   $00,$94,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$9E        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 69 : imp71 [solide] [destructible]
        .byte   $00,$B2,$FF        ; ligne 0  B,G,R
        .byte   $00,$22,$FF        ; ligne 1  B,G,R
        .byte   $00,$06,$FF        ; ligne 2  B,G,R
        .byte   $00,$0F,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$E0        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$06,$0F        ; ligne 7  B,G,R
        .byte   $00,$0C,$0F        ; ligne 8  B,G,R
        .byte   $00,$0C,$0F        ; ligne 9  B,G,R
; tuile 70 : imp72 [solide] [destructible]
        .byte   $00,$00,$FC        ; ligne 0  B,G,R
        .byte   $00,$00,$FD        ; ligne 1  B,G,R
        .byte   $00,$20,$F9        ; ligne 2  B,G,R
        .byte   $00,$80,$F3        ; ligne 3  B,G,R
        .byte   $00,$00,$F1        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$08,$FF        ; ligne 7  B,G,R
        .byte   $00,$66,$FF        ; ligne 8  B,G,R
        .byte   $00,$66,$FF        ; ligne 9  B,G,R
; tuile 71 : imp73 [solide] [destructible]
        .byte   $00,$E0,$FF        ; ligne 0  B,G,R
        .byte   $00,$E3,$FF        ; ligne 1  B,G,R
        .byte   $00,$F3,$FF        ; ligne 2  B,G,R
        .byte   $00,$EF,$FF        ; ligne 3  B,G,R
        .byte   $00,$09,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$A0        ; ligne 6  B,G,R
        .byte   $00,$00,$10        ; ligne 7  B,G,R
        .byte   $00,$00,$B9        ; ligne 8  B,G,R
        .byte   $00,$00,$BF        ; ligne 9  B,G,R
; tuile 72 : imp74 [solide] [destructible]
        .byte   $00,$07,$FF        ; ligne 0  B,G,R
        .byte   $00,$07,$FF        ; ligne 1  B,G,R
        .byte   $00,$8F,$FF        ; ligne 2  B,G,R
        .byte   $00,$47,$EF        ; ligne 3  B,G,R
        .byte   $00,$00,$CF        ; ligne 4  B,G,R
        .byte   $00,$00,$87        ; ligne 5  B,G,R
        .byte   $00,$00,$07        ; ligne 6  B,G,R
        .byte   $00,$00,$30        ; ligne 7  B,G,R
        .byte   $00,$C4,$FF        ; ligne 8  B,G,R
        .byte   $00,$E0,$FF        ; ligne 9  B,G,R
; tuile 73 : imp75 [solide] [destructible]
        .byte   $00,$F7,$FF        ; ligne 0  B,G,R
        .byte   $00,$F7,$FF        ; ligne 1  B,G,R
        .byte   $00,$37,$FF        ; ligne 2  B,G,R
        .byte   $00,$67,$FF        ; ligne 3  B,G,R
        .byte   $00,$E7,$FF        ; ligne 4  B,G,R
        .byte   $00,$07,$FF        ; ligne 5  B,G,R
        .byte   $00,$07,$EF        ; ligne 6  B,G,R
        .byte   $00,$07,$4F        ; ligne 7  B,G,R
        .byte   $00,$07,$FF        ; ligne 8  B,G,R
        .byte   $00,$F7,$FF        ; ligne 9  B,G,R
; tuile 74 : imp76 [solide] [destructible]
        .byte   $00,$01,$93        ; ligne 0  B,G,R
        .byte   $00,$01,$93        ; ligne 1  B,G,R
        .byte   $00,$01,$93        ; ligne 2  B,G,R
        .byte   $00,$01,$93        ; ligne 3  B,G,R
        .byte   $00,$00,$93        ; ligne 4  B,G,R
        .byte   $00,$00,$93        ; ligne 5  B,G,R
        .byte   $00,$00,$93        ; ligne 6  B,G,R
        .byte   $00,$00,$90        ; ligne 7  B,G,R
        .byte   $00,$00,$93        ; ligne 8  B,G,R
        .byte   $00,$00,$93        ; ligne 9  B,G,R
; tuile 75 : imp77 [solide] [destructible]
        .byte   $00,$BE,$FF        ; ligne 0  B,G,R
        .byte   $00,$FE,$FF        ; ligne 1  B,G,R
        .byte   $00,$CF,$FF        ; ligne 2  B,G,R
        .byte   $00,$D8,$FF        ; ligne 3  B,G,R
        .byte   $00,$18,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$FC        ; ligne 6  B,G,R
        .byte   $00,$00,$10        ; ligne 7  B,G,R
        .byte   $00,$00,$FF        ; ligne 8  B,G,R
        .byte   $00,$F9,$FF        ; ligne 9  B,G,R
; tuile 76 : imp78 [solide] [destructible]
        .byte   $00,$00,$EF        ; ligne 0  B,G,R
        .byte   $00,$00,$CF        ; ligne 1  B,G,R
        .byte   $00,$03,$9F        ; ligne 2  B,G,R
        .byte   $00,$00,$9F        ; ligne 3  B,G,R
        .byte   $00,$00,$3F        ; ligne 4  B,G,R
        .byte   $00,$00,$3F        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$FC        ; ligne 8  B,G,R
        .byte   $00,$9C,$FE        ; ligne 9  B,G,R
; tuile 77 : imp79 [solide] [destructible]
        .byte   $00,$2E,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FF        ; ligne 1  B,G,R
        .byte   $00,$39,$FF        ; ligne 2  B,G,R
        .byte   $00,$23,$FF        ; ligne 3  B,G,R
        .byte   $00,$F8,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$E0        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$01,$FF        ; ligne 8  B,G,R
        .byte   $00,$09,$7F        ; ligne 9  B,G,R
; tuile 78 : imp80 [solide] [destructible]
        .byte   $00,$17,$FF        ; ligne 0  B,G,R
        .byte   $00,$06,$FF        ; ligne 1  B,G,R
        .byte   $00,$82,$FF        ; ligne 2  B,G,R
        .byte   $00,$C1,$FF        ; ligne 3  B,G,R
        .byte   $00,$3E,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$7F        ; ligne 6  B,G,R
        .byte   $00,$00,$3F        ; ligne 7  B,G,R
        .byte   $00,$00,$FC        ; ligne 8  B,G,R
        .byte   $00,$C0,$FC        ; ligne 9  B,G,R
; tuile 79 : imp81 [solide] [destructible]
        .byte   $00,$44,$FF        ; ligne 0  B,G,R
        .byte   $00,$C0,$FF        ; ligne 1  B,G,R
        .byte   $00,$10,$FF        ; ligne 2  B,G,R
        .byte   $00,$38,$FF        ; ligne 3  B,G,R
        .byte   $00,$30,$FF        ; ligne 4  B,G,R
        .byte   $00,$D0,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$FD        ; ligne 6  B,G,R
        .byte   $00,$00,$89        ; ligne 7  B,G,R
        .byte   $00,$00,$3D        ; ligne 8  B,G,R
        .byte   $00,$0C,$FF        ; ligne 9  B,G,R
; tuile 80 : imp82 [solide] [destructible]
        .byte   $00,$E0,$FF        ; ligne 0  B,G,R
        .byte   $00,$E0,$FF        ; ligne 1  B,G,R
        .byte   $00,$E5,$F7        ; ligne 2  B,G,R
        .byte   $00,$F3,$FF        ; ligne 3  B,G,R
        .byte   $00,$F1,$FB        ; ligne 4  B,G,R
        .byte   $00,$F0,$F9        ; ligne 5  B,G,R
        .byte   $00,$F0,$F9        ; ligne 6  B,G,R
        .byte   $00,$F0,$F9        ; ligne 7  B,G,R
        .byte   $00,$F0,$FB        ; ligne 8  B,G,R
        .byte   $00,$F1,$FB        ; ligne 9  B,G,R
; tuile 81 : imp83 [solide] [destructible]
        .byte   $00,$3C,$FF        ; ligne 0  B,G,R
        .byte   $00,$7E,$FF        ; ligne 1  B,G,R
        .byte   $00,$F7,$FF        ; ligne 2  B,G,R
        .byte   $00,$CF,$FF        ; ligne 3  B,G,R
        .byte   $00,$1F,$FF        ; ligne 4  B,G,R
        .byte   $00,$1F,$FF        ; ligne 5  B,G,R
        .byte   $00,$3E,$FF        ; ligne 6  B,G,R
        .byte   $00,$3E,$FF        ; ligne 7  B,G,R
        .byte   $00,$FC,$FF        ; ligne 8  B,G,R
        .byte   $00,$F0,$FF        ; ligne 9  B,G,R
; tuile 82 : imp84 [solide] [destructible]
        .byte   $00,$CD,$FF        ; ligne 0  B,G,R
        .byte   $00,$47,$FF        ; ligne 1  B,G,R
        .byte   $00,$07,$FF        ; ligne 2  B,G,R
        .byte   $00,$C2,$FB        ; ligne 3  B,G,R
        .byte   $00,$81,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$FD        ; ligne 6  B,G,R
        .byte   $00,$00,$BF        ; ligne 7  B,G,R
        .byte   $00,$00,$7F        ; ligne 8  B,G,R
        .byte   $00,$00,$7F        ; ligne 9  B,G,R
; tuile 83 : imp85 [solide] [destructible]
        .byte   $00,$0F,$FF        ; ligne 0  B,G,R
        .byte   $00,$2F,$FF        ; ligne 1  B,G,R
        .byte   $00,$CF,$FF        ; ligne 2  B,G,R
        .byte   $00,$4F,$FF        ; ligne 3  B,G,R
        .byte   $00,$0F,$FF        ; ligne 4  B,G,R
        .byte   $00,$0F,$FF        ; ligne 5  B,G,R
        .byte   $00,$4F,$FF        ; ligne 6  B,G,R
        .byte   $00,$4F,$FF        ; ligne 7  B,G,R
        .byte   $00,$0F,$9F        ; ligne 8  B,G,R
        .byte   $00,$0F,$1F        ; ligne 9  B,G,R
; tuile 84 : imp86 [solide] [destructible]
        .byte   $00,$00,$27        ; ligne 0  B,G,R
        .byte   $00,$00,$27        ; ligne 1  B,G,R
        .byte   $00,$00,$27        ; ligne 2  B,G,R
        .byte   $00,$00,$27        ; ligne 3  B,G,R
        .byte   $00,$00,$27        ; ligne 4  B,G,R
        .byte   $00,$00,$26        ; ligne 5  B,G,R
        .byte   $00,$00,$26        ; ligne 6  B,G,R
        .byte   $00,$00,$26        ; ligne 7  B,G,R
        .byte   $00,$00,$24        ; ligne 8  B,G,R
        .byte   $00,$00,$20        ; ligne 9  B,G,R
; tuile 85 : imp87 [solide] [destructible]
        .byte   $00,$04,$DF        ; ligne 0  B,G,R
        .byte   $00,$00,$DF        ; ligne 1  B,G,R
        .byte   $00,$80,$FF        ; ligne 2  B,G,R
        .byte   $00,$12,$BF        ; ligne 3  B,G,R
        .byte   $00,$04,$3F        ; ligne 4  B,G,R
        .byte   $00,$00,$7F        ; ligne 5  B,G,R
        .byte   $00,$00,$7F        ; ligne 6  B,G,R
        .byte   $00,$01,$7F        ; ligne 7  B,G,R
        .byte   $00,$00,$4F        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 86 : imp88 [solide] [destructible]
        .byte   $00,$00,$3F        ; ligne 0  B,G,R
        .byte   $00,$00,$3E        ; ligne 1  B,G,R
        .byte   $00,$00,$3C        ; ligne 2  B,G,R
        .byte   $00,$00,$3C        ; ligne 3  B,G,R
        .byte   $00,$00,$30        ; ligne 4  B,G,R
        .byte   $00,$00,$20        ; ligne 5  B,G,R
        .byte   $00,$00,$20        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 87 : imp89 [solide] [destructible]
        .byte   $00,$02,$07        ; ligne 0  B,G,R
        .byte   $00,$03,$03        ; ligne 1  B,G,R
        .byte   $00,$01,$03        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 88 : imp90 [solide] [destructible]
        .byte   $00,$48,$FF        ; ligne 0  B,G,R
        .byte   $00,$D0,$FF        ; ligne 1  B,G,R
        .byte   $00,$C1,$FF        ; ligne 2  B,G,R
        .byte   $00,$F1,$FF        ; ligne 3  B,G,R
        .byte   $00,$3D,$FF        ; ligne 4  B,G,R
        .byte   $00,$0F,$7F        ; ligne 5  B,G,R
        .byte   $00,$0F,$3F        ; ligne 6  B,G,R
        .byte   $00,$0B,$1F        ; ligne 7  B,G,R
        .byte   $00,$03,$0F        ; ligne 8  B,G,R
        .byte   $00,$03,$0F        ; ligne 9  B,G,R
; tuile 89 : imp91 [solide] [destructible]
        .byte   $00,$01,$FF        ; ligne 0  B,G,R
        .byte   $00,$03,$FF        ; ligne 1  B,G,R
        .byte   $00,$83,$FF        ; ligne 2  B,G,R
        .byte   $00,$83,$FF        ; ligne 3  B,G,R
        .byte   $00,$83,$FF        ; ligne 4  B,G,R
        .byte   $00,$03,$FF        ; ligne 5  B,G,R
        .byte   $00,$13,$FF        ; ligne 6  B,G,R
        .byte   $00,$13,$FF        ; ligne 7  B,G,R
        .byte   $00,$03,$FB        ; ligne 8  B,G,R
        .byte   $00,$03,$F3        ; ligne 9  B,G,R
; tuile 90 : imp92 [solide] [destructible]
        .byte   $00,$61,$FF        ; ligne 0  B,G,R
        .byte   $00,$FF,$FF        ; ligne 1  B,G,R
        .byte   $00,$FF,$FF        ; ligne 2  B,G,R
        .byte   $00,$2F,$FF        ; ligne 3  B,G,R
        .byte   $00,$6F,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$EE,$FF        ; ligne 6  B,G,R
        .byte   $00,$6E,$FF        ; ligne 7  B,G,R
        .byte   $00,$47,$FF        ; ligne 8  B,G,R
        .byte   $00,$43,$FF        ; ligne 9  B,G,R
; tuile 91 : imp93 [solide] [destructible]
        .byte   $00,$D7,$FF        ; ligne 0  B,G,R
        .byte   $00,$C7,$FF        ; ligne 1  B,G,R
        .byte   $00,$E7,$FF        ; ligne 2  B,G,R
        .byte   $00,$F7,$FF        ; ligne 3  B,G,R
        .byte   $00,$E7,$FF        ; ligne 4  B,G,R
        .byte   $00,$67,$FF        ; ligne 5  B,G,R
        .byte   $00,$37,$FF        ; ligne 6  B,G,R
        .byte   $00,$07,$FF        ; ligne 7  B,G,R
        .byte   $00,$87,$FF        ; ligne 8  B,G,R
        .byte   $00,$C7,$FF        ; ligne 9  B,G,R
; tuile 92 : imp94 [solide] [destructible]
        .byte   $00,$EB,$FF        ; ligne 0  B,G,R
        .byte   $00,$C3,$FF        ; ligne 1  B,G,R
        .byte   $00,$EF,$FF        ; ligne 2  B,G,R
        .byte   $00,$F4,$FF        ; ligne 3  B,G,R
        .byte   $00,$F0,$FF        ; ligne 4  B,G,R
        .byte   $00,$70,$FF        ; ligne 5  B,G,R
        .byte   $00,$31,$FF        ; ligne 6  B,G,R
        .byte   $00,$23,$FF        ; ligne 7  B,G,R
        .byte   $00,$82,$FF        ; ligne 8  B,G,R
        .byte   $00,$C0,$FF        ; ligne 9  B,G,R
; tuile 93 : imp95 [solide] [destructible]
        .byte   $00,$84,$FE        ; ligne 0  B,G,R
        .byte   $00,$C0,$FE        ; ligne 1  B,G,R
        .byte   $00,$F4,$FF        ; ligne 2  B,G,R
        .byte   $00,$98,$FF        ; ligne 3  B,G,R
        .byte   $00,$19,$FF        ; ligne 4  B,G,R
        .byte   $00,$BD,$FF        ; ligne 5  B,G,R
        .byte   $00,$7F,$FF        ; ligne 6  B,G,R
        .byte   $00,$E4,$FF        ; ligne 7  B,G,R
        .byte   $00,$42,$FF        ; ligne 8  B,G,R
        .byte   $00,$46,$FF        ; ligne 9  B,G,R
; tuile 94 : imp96 [solide] [destructible]
        .byte   $00,$09,$7F        ; ligne 0  B,G,R
        .byte   $00,$00,$7F        ; ligne 1  B,G,R
        .byte   $00,$00,$3F        ; ligne 2  B,G,R
        .byte   $00,$05,$DF        ; ligne 3  B,G,R
        .byte   $00,$01,$DF        ; ligne 4  B,G,R
        .byte   $00,$81,$FF        ; ligne 5  B,G,R
        .byte   $00,$11,$FF        ; ligne 6  B,G,R
        .byte   $00,$33,$FF        ; ligne 7  B,G,R
        .byte   $00,$33,$FF        ; ligne 8  B,G,R
        .byte   $00,$31,$FF        ; ligne 9  B,G,R
; tuile 95 : imp97 [solide] [destructible]
        .byte   $00,$40,$FD        ; ligne 0  B,G,R
        .byte   $00,$60,$FF        ; ligne 1  B,G,R
        .byte   $00,$01,$FF        ; ligne 2  B,G,R
        .byte   $00,$1F,$FF        ; ligne 3  B,G,R
        .byte   $00,$1F,$FF        ; ligne 4  B,G,R
        .byte   $00,$8F,$FF        ; ligne 5  B,G,R
        .byte   $00,$A1,$FF        ; ligne 6  B,G,R
        .byte   $00,$E1,$FF        ; ligne 7  B,G,R
        .byte   $00,$F3,$FF        ; ligne 8  B,G,R
        .byte   $00,$F1,$FF        ; ligne 9  B,G,R
; tuile 96 : imp98 [solide] [destructible]
        .byte   $00,$E1,$FF        ; ligne 0  B,G,R
        .byte   $00,$20,$FF        ; ligne 1  B,G,R
        .byte   $00,$FC,$FF        ; ligne 2  B,G,R
        .byte   $00,$DE,$FF        ; ligne 3  B,G,R
        .byte   $00,$F7,$FF        ; ligne 4  B,G,R
        .byte   $00,$AF,$FF        ; ligne 5  B,G,R
        .byte   $00,$BF,$FF        ; ligne 6  B,G,R
        .byte   $00,$EF,$FF        ; ligne 7  B,G,R
        .byte   $00,$6F,$FF        ; ligne 8  B,G,R
        .byte   $00,$67,$FF        ; ligne 9  B,G,R
; tuile 97 : imp99 [solide] [destructible]
        .byte   $00,$F0,$FE        ; ligne 0  B,G,R
        .byte   $00,$F0,$FC        ; ligne 1  B,G,R
        .byte   $00,$F0,$FC        ; ligne 2  B,G,R
        .byte   $00,$F0,$FC        ; ligne 3  B,G,R
        .byte   $00,$F0,$FC        ; ligne 4  B,G,R
        .byte   $00,$F0,$FC        ; ligne 5  B,G,R
        .byte   $00,$F0,$FD        ; ligne 6  B,G,R
        .byte   $00,$F0,$FD        ; ligne 7  B,G,R
        .byte   $00,$F0,$FD        ; ligne 8  B,G,R
        .byte   $00,$F0,$FD        ; ligne 9  B,G,R
; tuile 98 : imp100 [solide] [destructible]
        .byte   $00,$00,$7E        ; ligne 0  B,G,R
        .byte   $00,$00,$FC        ; ligne 1  B,G,R
        .byte   $00,$00,$FC        ; ligne 2  B,G,R
        .byte   $00,$00,$FC        ; ligne 3  B,G,R
        .byte   $00,$00,$F4        ; ligne 4  B,G,R
        .byte   $00,$00,$F0        ; ligne 5  B,G,R
        .byte   $00,$00,$F0        ; ligne 6  B,G,R
        .byte   $00,$00,$F2        ; ligne 7  B,G,R
        .byte   $00,$00,$F2        ; ligne 8  B,G,R
        .byte   $00,$00,$F2        ; ligne 9  B,G,R
; tuile 99 : imp101 [solide] [destructible]
        .byte   $00,$0F,$3F        ; ligne 0  B,G,R
        .byte   $00,$2F,$FF        ; ligne 1  B,G,R
        .byte   $00,$6F,$7F        ; ligne 2  B,G,R
        .byte   $00,$6F,$7F        ; ligne 3  B,G,R
        .byte   $00,$6F,$7F        ; ligne 4  B,G,R
        .byte   $00,$2F,$7F        ; ligne 5  B,G,R
        .byte   $00,$0F,$FF        ; ligne 6  B,G,R
        .byte   $00,$2F,$FF        ; ligne 7  B,G,R
        .byte   $00,$2F,$FF        ; ligne 8  B,G,R
        .byte   $00,$4F,$FF        ; ligne 9  B,G,R
; tuile 100 : imp102 [solide] [destructible]
        .byte   $00,$00,$24        ; ligne 0  B,G,R
        .byte   $00,$00,$27        ; ligne 1  B,G,R
        .byte   $00,$00,$27        ; ligne 2  B,G,R
        .byte   $00,$00,$27        ; ligne 3  B,G,R
        .byte   $00,$00,$27        ; ligne 4  B,G,R
        .byte   $00,$02,$27        ; ligne 5  B,G,R
        .byte   $00,$07,$27        ; ligne 6  B,G,R
        .byte   $00,$01,$27        ; ligne 7  B,G,R
        .byte   $00,$01,$27        ; ligne 8  B,G,R
        .byte   $00,$03,$27        ; ligne 9  B,G,R
; tuile 101 : imp103 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$E7        ; ligne 1  B,G,R
        .byte   $00,$80,$E7        ; ligne 2  B,G,R
        .byte   $00,$40,$F7        ; ligne 3  B,G,R
        .byte   $00,$00,$F7        ; ligne 4  B,G,R
        .byte   $00,$00,$F3        ; ligne 5  B,G,R
        .byte   $00,$40,$FB        ; ligne 6  B,G,R
        .byte   $00,$90,$FC        ; ligne 7  B,G,R
        .byte   $00,$D8,$FF        ; ligne 8  B,G,R
        .byte   $00,$D8,$FF        ; ligne 9  B,G,R
; tuile 102 : imp104 [solide] [destructible]
        .byte   $00,$03,$F7        ; ligne 0  B,G,R
        .byte   $00,$03,$FF        ; ligne 1  B,G,R
        .byte   $00,$03,$FF        ; ligne 2  B,G,R
        .byte   $00,$03,$FF        ; ligne 3  B,G,R
        .byte   $00,$01,$FF        ; ligne 4  B,G,R
        .byte   $00,$01,$7F        ; ligne 5  B,G,R
        .byte   $00,$0B,$3F        ; ligne 6  B,G,R
        .byte   $00,$0B,$3F        ; ligne 7  B,G,R
        .byte   $00,$01,$1F        ; ligne 8  B,G,R
        .byte   $00,$00,$03        ; ligne 9  B,G,R
; tuile 103 : imp105 [solide] [destructible]
        .byte   $00,$C1,$FF        ; ligne 0  B,G,R
        .byte   $00,$C8,$FF        ; ligne 1  B,G,R
        .byte   $00,$90,$FF        ; ligne 2  B,G,R
        .byte   $00,$B4,$FF        ; ligne 3  B,G,R
        .byte   $00,$FE,$FF        ; ligne 4  B,G,R
        .byte   $00,$FE,$FF        ; ligne 5  B,G,R
        .byte   $00,$FE,$FF        ; ligne 6  B,G,R
        .byte   $00,$CC,$FF        ; ligne 7  B,G,R
        .byte   $00,$D8,$FF        ; ligne 8  B,G,R
        .byte   $00,$18,$FF        ; ligne 9  B,G,R
; tuile 104 : imp106 [solide] [destructible]
        .byte   $00,$C7,$FF        ; ligne 0  B,G,R
        .byte   $00,$C7,$EF        ; ligne 1  B,G,R
        .byte   $00,$07,$E7        ; ligne 2  B,G,R
        .byte   $00,$07,$EF        ; ligne 3  B,G,R
        .byte   $00,$47,$FF        ; ligne 4  B,G,R
        .byte   $00,$07,$DF        ; ligne 5  B,G,R
        .byte   $00,$07,$DF        ; ligne 6  B,G,R
        .byte   $00,$07,$9F        ; ligne 7  B,G,R
        .byte   $00,$07,$3F        ; ligne 8  B,G,R
        .byte   $00,$07,$3F        ; ligne 9  B,G,R
; tuile 105 : imp107 [solide] [destructible]
        .byte   $00,$01,$93        ; ligne 0  B,G,R
        .byte   $00,$00,$93        ; ligne 1  B,G,R
        .byte   $00,$00,$93        ; ligne 2  B,G,R
        .byte   $00,$00,$93        ; ligne 3  B,G,R
        .byte   $00,$00,$93        ; ligne 4  B,G,R
        .byte   $00,$00,$93        ; ligne 5  B,G,R
        .byte   $00,$00,$93        ; ligne 6  B,G,R
        .byte   $00,$00,$93        ; ligne 7  B,G,R
        .byte   $00,$00,$93        ; ligne 8  B,G,R
        .byte   $00,$00,$93        ; ligne 9  B,G,R
; tuile 106 : imp108 [solide] [destructible]
        .byte   $00,$C0,$F3        ; ligne 0  B,G,R
        .byte   $00,$40,$F7        ; ligne 1  B,G,R
        .byte   $00,$01,$E7        ; ligne 2  B,G,R
        .byte   $00,$00,$EF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$EF        ; ligne 5  B,G,R
        .byte   $00,$03,$DF        ; ligne 6  B,G,R
        .byte   $00,$00,$9F        ; ligne 7  B,G,R
        .byte   $00,$00,$1F        ; ligne 8  B,G,R
        .byte   $00,$00,$3F        ; ligne 9  B,G,R
; tuile 107 : imp109 [solide] [destructible]
        .byte   $00,$1C,$FF        ; ligne 0  B,G,R
        .byte   $00,$18,$FF        ; ligne 1  B,G,R
        .byte   $00,$00,$FF        ; ligne 2  B,G,R
        .byte   $00,$38,$FF        ; ligne 3  B,G,R
        .byte   $00,$3E,$FF        ; ligne 4  B,G,R
        .byte   $00,$06,$FF        ; ligne 5  B,G,R
        .byte   $00,$18,$FF        ; ligne 6  B,G,R
        .byte   $00,$39,$FF        ; ligne 7  B,G,R
        .byte   $00,$71,$FF        ; ligne 8  B,G,R
        .byte   $00,$60,$FF        ; ligne 9  B,G,R
; tuile 108 : imp110 [solide] [destructible]
        .byte   $00,$11,$FF        ; ligne 0  B,G,R
        .byte   $00,$C3,$FF        ; ligne 1  B,G,R
        .byte   $00,$C9,$FF        ; ligne 2  B,G,R
        .byte   $00,$ED,$FF        ; ligne 3  B,G,R
        .byte   $00,$F6,$FF        ; ligne 4  B,G,R
        .byte   $00,$07,$FF        ; ligne 5  B,G,R
        .byte   $00,$06,$FF        ; ligne 6  B,G,R
        .byte   $00,$C3,$FF        ; ligne 7  B,G,R
        .byte   $00,$03,$FF        ; ligne 8  B,G,R
        .byte   $00,$1E,$FF        ; ligne 9  B,G,R
; tuile 109 : imp111 [solide] [destructible]
        .byte   $00,$11,$FF        ; ligne 0  B,G,R
        .byte   $00,$13,$FF        ; ligne 1  B,G,R
        .byte   $00,$83,$FF        ; ligne 2  B,G,R
        .byte   $00,$03,$FF        ; ligne 3  B,G,R
        .byte   $00,$45,$FF        ; ligne 4  B,G,R
        .byte   $00,$CD,$FF        ; ligne 5  B,G,R
        .byte   $00,$81,$FF        ; ligne 6  B,G,R
        .byte   $00,$19,$FF        ; ligne 7  B,G,R
        .byte   $00,$39,$FF        ; ligne 8  B,G,R
        .byte   $00,$31,$FF        ; ligne 9  B,G,R
; tuile 110 : imp112 [solide] [destructible]
        .byte   $00,$A3,$FF        ; ligne 0  B,G,R
        .byte   $00,$E0,$FF        ; ligne 1  B,G,R
        .byte   $00,$C0,$FF        ; ligne 2  B,G,R
        .byte   $00,$D0,$FF        ; ligne 3  B,G,R
        .byte   $00,$94,$FF        ; ligne 4  B,G,R
        .byte   $00,$BF,$FF        ; ligne 5  B,G,R
        .byte   $00,$BF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FE,$FF        ; ligne 7  B,G,R
        .byte   $00,$CC,$FF        ; ligne 8  B,G,R
        .byte   $00,$CC,$FF        ; ligne 9  B,G,R
; tuile 111 : imp113 [solide] [destructible]
        .byte   $00,$FB,$FF        ; ligne 0  B,G,R
        .byte   $00,$FB,$FF        ; ligne 1  B,G,R
        .byte   $00,$FB,$FF        ; ligne 2  B,G,R
        .byte   $00,$FB,$FF        ; ligne 3  B,G,R
        .byte   $00,$FB,$FF        ; ligne 4  B,G,R
        .byte   $00,$F3,$FB        ; ligne 5  B,G,R
        .byte   $00,$F3,$FB        ; ligne 6  B,G,R
        .byte   $00,$F3,$FB        ; ligne 7  B,G,R
        .byte   $00,$F3,$FB        ; ligne 8  B,G,R
        .byte   $00,$F3,$FB        ; ligne 9  B,G,R
; tuile 112 : imp114 [solide] [destructible]
        .byte   $00,$F0,$FD        ; ligne 0  B,G,R
        .byte   $00,$F0,$FD        ; ligne 1  B,G,R
        .byte   $00,$F0,$FD        ; ligne 2  B,G,R
        .byte   $00,$F0,$FD        ; ligne 3  B,G,R
        .byte   $00,$F0,$FD        ; ligne 4  B,G,R
        .byte   $00,$F0,$FD        ; ligne 5  B,G,R
        .byte   $00,$F0,$FC        ; ligne 6  B,G,R
        .byte   $00,$F0,$FC        ; ligne 7  B,G,R
        .byte   $00,$F0,$FD        ; ligne 8  B,G,R
        .byte   $00,$F0,$FF        ; ligne 9  B,G,R
; tuile 113 : imp115 [solide] [destructible]
        .byte   $00,$00,$F2        ; ligne 0  B,G,R
        .byte   $00,$00,$F2        ; ligne 1  B,G,R
        .byte   $00,$00,$F2        ; ligne 2  B,G,R
        .byte   $00,$00,$F6        ; ligne 3  B,G,R
        .byte   $00,$00,$F6        ; ligne 4  B,G,R
        .byte   $00,$00,$F7        ; ligne 5  B,G,R
        .byte   $00,$00,$FB        ; ligne 6  B,G,R
        .byte   $00,$00,$FF        ; ligne 7  B,G,R
        .byte   $00,$0F,$FF        ; ligne 8  B,G,R
        .byte   $00,$0F,$FF        ; ligne 9  B,G,R
; tuile 114 : imp116 [solide] [destructible]
        .byte   $00,$0F,$FF        ; ligne 0  B,G,R
        .byte   $00,$0F,$FF        ; ligne 1  B,G,R
        .byte   $00,$0F,$7F        ; ligne 2  B,G,R
        .byte   $00,$0F,$7F        ; ligne 3  B,G,R
        .byte   $00,$1F,$FF        ; ligne 4  B,G,R
        .byte   $00,$FB,$FF        ; ligne 5  B,G,R
        .byte   $00,$F7,$FF        ; ligne 6  B,G,R
        .byte   $00,$FF,$FF        ; ligne 7  B,G,R
        .byte   $00,$FF,$FF        ; ligne 8  B,G,R
        .byte   $00,$FE,$FF        ; ligne 9  B,G,R
; tuile 115 : imp117 [solide] [destructible]
        .byte   $00,$BF,$FF        ; ligne 0  B,G,R
        .byte   $00,$BF,$FF        ; ligne 1  B,G,R
        .byte   $00,$BF,$FF        ; ligne 2  B,G,R
        .byte   $00,$BF,$FF        ; ligne 3  B,G,R
        .byte   $00,$BF,$FF        ; ligne 4  B,G,R
        .byte   $00,$BF,$FF        ; ligne 5  B,G,R
        .byte   $00,$BF,$FF        ; ligne 6  B,G,R
        .byte   $00,$3F,$FF        ; ligne 7  B,G,R
        .byte   $00,$7F,$FF        ; ligne 8  B,G,R
        .byte   $00,$7E,$FF        ; ligne 9  B,G,R
; tuile 116 : imp118 [solide] [destructible]
        .byte   $00,$07,$27        ; ligne 0  B,G,R
        .byte   $00,$02,$27        ; ligne 1  B,G,R
        .byte   $00,$06,$27        ; ligne 2  B,G,R
        .byte   $00,$00,$27        ; ligne 3  B,G,R
        .byte   $00,$00,$27        ; ligne 4  B,G,R
        .byte   $00,$00,$27        ; ligne 5  B,G,R
        .byte   $00,$00,$27        ; ligne 6  B,G,R
        .byte   $00,$01,$27        ; ligne 7  B,G,R
        .byte   $00,$03,$27        ; ligne 8  B,G,R
        .byte   $00,$00,$27        ; ligne 9  B,G,R
; tuile 117 : imp119 [solide] [destructible]
        .byte   $00,$F1,$FF        ; ligne 0  B,G,R
        .byte   $00,$43,$FF        ; ligne 1  B,G,R
        .byte   $00,$33,$FF        ; ligne 2  B,G,R
        .byte   $00,$61,$FF        ; ligne 3  B,G,R
        .byte   $00,$C0,$FF        ; ligne 4  B,G,R
        .byte   $00,$85,$FF        ; ligne 5  B,G,R
        .byte   $00,$0E,$FF        ; ligne 6  B,G,R
        .byte   $00,$8E,$FF        ; ligne 7  B,G,R
        .byte   $00,$E7,$FF        ; ligne 8  B,G,R
        .byte   $00,$21,$FF        ; ligne 9  B,G,R
; tuile 118 : imp120 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$B8        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 119 : imp121 [solide] [destructible]
        .byte   $00,$07,$3F        ; ligne 0  B,G,R
        .byte   $00,$07,$07        ; ligne 1  B,G,R
        .byte   $00,$07,$07        ; ligne 2  B,G,R
        .byte   $00,$07,$07        ; ligne 3  B,G,R
        .byte   $00,$07,$07        ; ligne 4  B,G,R
        .byte   $00,$07,$07        ; ligne 5  B,G,R
        .byte   $00,$07,$07        ; ligne 6  B,G,R
        .byte   $00,$07,$07        ; ligne 7  B,G,R
        .byte   $00,$07,$07        ; ligne 8  B,G,R
        .byte   $00,$07,$07        ; ligne 9  B,G,R
; tuile 120 : imp122 [solide] [destructible]
        .byte   $00,$87,$EF        ; ligne 0  B,G,R
        .byte   $00,$87,$EF        ; ligne 1  B,G,R
        .byte   $00,$87,$EF        ; ligne 2  B,G,R
        .byte   $00,$87,$EF        ; ligne 3  B,G,R
        .byte   $00,$86,$CF        ; ligne 4  B,G,R
        .byte   $00,$8C,$CF        ; ligne 5  B,G,R
        .byte   $00,$8E,$DF        ; ligne 6  B,G,R
        .byte   $00,$0E,$9F        ; ligne 7  B,G,R
        .byte   $00,$0F,$0F        ; ligne 8  B,G,R
        .byte   $00,$0F,$0F        ; ligne 9  B,G,R
; tuile 121 : imp123 [solide] [destructible]
        .byte   $00,$80,$E3        ; ligne 0  B,G,R
        .byte   $00,$80,$F3        ; ligne 1  B,G,R
        .byte   $00,$00,$F3        ; ligne 2  B,G,R
        .byte   $00,$00,$F3        ; ligne 3  B,G,R
        .byte   $00,$00,$F3        ; ligne 4  B,G,R
        .byte   $00,$00,$E7        ; ligne 5  B,G,R
        .byte   $00,$00,$CE        ; ligne 6  B,G,R
        .byte   $00,$00,$CC        ; ligne 7  B,G,R
        .byte   $00,$00,$FC        ; ligne 8  B,G,R
        .byte   $00,$00,$EC        ; ligne 9  B,G,R
; tuile 122 : imp124 [solide] [destructible]
        .byte   $00,$00,$93        ; ligne 0  B,G,R
        .byte   $00,$00,$90        ; ligne 1  B,G,R
        .byte   $00,$00,$90        ; ligne 2  B,G,R
        .byte   $00,$00,$80        ; ligne 3  B,G,R
        .byte   $00,$00,$80        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 123 : imp125 [solide] [destructible]
        .byte   $00,$00,$37        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$01,$01        ; ligne 4  B,G,R
        .byte   $00,$00,$01        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 124 : imp126 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$41        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$84,$FF        ; ligne 4  B,G,R
        .byte   $00,$8C,$FF        ; ligne 5  B,G,R
        .byte   $00,$4D,$FF        ; ligne 6  B,G,R
        .byte   $00,$39,$7F        ; ligne 7  B,G,R
        .byte   $00,$38,$3F        ; ligne 8  B,G,R
        .byte   $00,$1F,$1F        ; ligne 9  B,G,R
; tuile 125 : imp127 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$3F        ; ligne 1  B,G,R
        .byte   $00,$00,$37        ; ligne 2  B,G,R
        .byte   $00,$00,$F3        ; ligne 3  B,G,R
        .byte   $00,$C0,$F3        ; ligne 4  B,G,R
        .byte   $00,$40,$F7        ; ligne 5  B,G,R
        .byte   $00,$00,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$FF        ; ligne 7  B,G,R
        .byte   $00,$10,$FF        ; ligne 8  B,G,R
        .byte   $00,$18,$FF        ; ligne 9  B,G,R
; tuile 126 : imp128 [solide] [destructible]
        .byte   $00,$90,$FD        ; ligne 0  B,G,R
        .byte   $00,$00,$F9        ; ligne 1  B,G,R
        .byte   $00,$00,$80        ; ligne 2  B,G,R
        .byte   $00,$00,$04        ; ligne 3  B,G,R
        .byte   $00,$00,$3F        ; ligne 4  B,G,R
        .byte   $00,$1C,$FF        ; ligne 5  B,G,R
        .byte   $00,$06,$FF        ; ligne 6  B,G,R
        .byte   $00,$3F,$FF        ; ligne 7  B,G,R
        .byte   $00,$7B,$FF        ; ligne 8  B,G,R
        .byte   $00,$74,$FF        ; ligne 9  B,G,R
; tuile 127 : imp129 [solide] [destructible]
        .byte   $00,$98,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FF        ; ligne 1  B,G,R
        .byte   $00,$00,$FD        ; ligne 2  B,G,R
        .byte   $00,$00,$58        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$1F,$FF        ; ligne 5  B,G,R
        .byte   $00,$3D,$FF        ; ligne 6  B,G,R
        .byte   $00,$FC,$FF        ; ligne 7  B,G,R
        .byte   $00,$FC,$FF        ; ligne 8  B,G,R
        .byte   $00,$FE,$FF        ; ligne 9  B,G,R
; tuile 128 : imp130 [solide] [destructible]
        .byte   $00,$F3,$FB        ; ligne 0  B,G,R
        .byte   $00,$FB,$FF        ; ligne 1  B,G,R
        .byte   $00,$79,$FF        ; ligne 2  B,G,R
        .byte   $00,$7D,$FF        ; ligne 3  B,G,R
        .byte   $00,$7D,$FF        ; ligne 4  B,G,R
        .byte   $00,$F8,$FD        ; ligne 5  B,G,R
        .byte   $00,$7C,$FF        ; ligne 6  B,G,R
        .byte   $00,$7C,$FF        ; ligne 7  B,G,R
        .byte   $00,$3C,$FF        ; ligne 8  B,G,R
        .byte   $00,$3E,$FF        ; ligne 9  B,G,R
; tuile 129 : imp131 [solide] [destructible]
        .byte   $00,$F0,$FB        ; ligne 0  B,G,R
        .byte   $00,$F0,$F9        ; ligne 1  B,G,R
        .byte   $00,$F0,$FD        ; ligne 2  B,G,R
        .byte   $00,$F0,$FD        ; ligne 3  B,G,R
        .byte   $00,$F0,$FF        ; ligne 4  B,G,R
        .byte   $00,$F8,$FF        ; ligne 5  B,G,R
        .byte   $00,$F8,$FF        ; ligne 6  B,G,R
        .byte   $00,$F8,$FF        ; ligne 7  B,G,R
        .byte   $00,$F8,$FF        ; ligne 8  B,G,R
        .byte   $00,$7C,$FF        ; ligne 9  B,G,R
; tuile 130 : imp132 [solide] [destructible]
        .byte   $00,$F1,$FF        ; ligne 0  B,G,R
        .byte   $00,$FB,$FF        ; ligne 1  B,G,R
        .byte   $00,$FB,$FF        ; ligne 2  B,G,R
        .byte   $00,$FB,$FF        ; ligne 3  B,G,R
        .byte   $00,$7F,$FF        ; ligne 4  B,G,R
        .byte   $00,$3F,$FF        ; ligne 5  B,G,R
        .byte   $00,$BE,$FF        ; ligne 6  B,G,R
        .byte   $00,$FE,$FF        ; ligne 7  B,G,R
        .byte   $00,$FE,$FF        ; ligne 8  B,G,R
        .byte   $00,$F8,$FF        ; ligne 9  B,G,R
; tuile 131 : imp133 [solide] [destructible]
        .byte   $00,$07,$FF        ; ligne 0  B,G,R
        .byte   $00,$E0,$FF        ; ligne 1  B,G,R
        .byte   $00,$F8,$FF        ; ligne 2  B,G,R
        .byte   $00,$FF,$FF        ; ligne 3  B,G,R
        .byte   $00,$FF,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$7F,$FF        ; ligne 7  B,G,R
        .byte   $00,$7F,$FF        ; ligne 8  B,G,R
        .byte   $00,$0F,$FF        ; ligne 9  B,G,R
; tuile 132 : imp134 [solide] [destructible]
        .byte   $00,$FC,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FF        ; ligne 1  B,G,R
        .byte   $00,$03,$FF        ; ligne 2  B,G,R
        .byte   $00,$FF,$FF        ; ligne 3  B,G,R
        .byte   $00,$FF,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FF,$FF        ; ligne 7  B,G,R
        .byte   $00,$FF,$FF        ; ligne 8  B,G,R
        .byte   $00,$FE,$FF        ; ligne 9  B,G,R
; tuile 133 : imp135 [solide] [destructible]
        .byte   $00,$FE,$FF        ; ligne 0  B,G,R
        .byte   $00,$FE,$FF        ; ligne 1  B,G,R
        .byte   $00,$FC,$FF        ; ligne 2  B,G,R
        .byte   $00,$FC,$FF        ; ligne 3  B,G,R
        .byte   $00,$F8,$FE        ; ligne 4  B,G,R
        .byte   $00,$F0,$FD        ; ligne 5  B,G,R
        .byte   $00,$E0,$F9        ; ligne 6  B,G,R
        .byte   $00,$E0,$FB        ; ligne 7  B,G,R
        .byte   $00,$C0,$F7        ; ligne 8  B,G,R
        .byte   $00,$01,$EF        ; ligne 9  B,G,R
; tuile 134 : imp136 [solide] [destructible]
        .byte   $00,$1E,$7F        ; ligne 0  B,G,R
        .byte   $00,$3E,$7F        ; ligne 1  B,G,R
        .byte   $00,$3E,$FF        ; ligne 2  B,G,R
        .byte   $00,$3E,$FF        ; ligne 3  B,G,R
        .byte   $00,$3C,$FF        ; ligne 4  B,G,R
        .byte   $00,$7C,$FF        ; ligne 5  B,G,R
        .byte   $00,$78,$FF        ; ligne 6  B,G,R
        .byte   $00,$F8,$FF        ; ligne 7  B,G,R
        .byte   $00,$F8,$FE        ; ligne 8  B,G,R
        .byte   $00,$F0,$FE        ; ligne 9  B,G,R
; tuile 135 : imp137 [solide] [destructible]
        .byte   $00,$00,$8F        ; ligne 0  B,G,R
        .byte   $00,$00,$9E        ; ligne 1  B,G,R
        .byte   $00,$00,$9E        ; ligne 2  B,G,R
        .byte   $00,$00,$9E        ; ligne 3  B,G,R
        .byte   $00,$00,$9E        ; ligne 4  B,G,R
        .byte   $00,$00,$3E        ; ligne 5  B,G,R
        .byte   $00,$00,$3E        ; ligne 6  B,G,R
        .byte   $00,$00,$3C        ; ligne 7  B,G,R
        .byte   $00,$00,$7C        ; ligne 8  B,G,R
        .byte   $00,$00,$78        ; ligne 9  B,G,R
; tuile 136 : imp138 [solide] [destructible]
        .byte   $00,$00,$27        ; ligne 0  B,G,R
        .byte   $00,$03,$07        ; ligne 1  B,G,R
        .byte   $00,$03,$4F        ; ligne 2  B,G,R
        .byte   $00,$06,$4F        ; ligne 3  B,G,R
        .byte   $00,$00,$4F        ; ligne 4  B,G,R
        .byte   $00,$00,$40        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$87        ; ligne 7  B,G,R
        .byte   $00,$01,$87        ; ligne 8  B,G,R
        .byte   $00,$01,$9F        ; ligne 9  B,G,R
; tuile 137 : imp139 [solide] [destructible]
        .byte   $00,$80,$FF        ; ligne 0  B,G,R
        .byte   $00,$9C,$FF        ; ligne 1  B,G,R
        .byte   $00,$1A,$FF        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$03        ; ligne 5  B,G,R
        .byte   $00,$00,$C3        ; ligne 6  B,G,R
        .byte   $00,$41,$F3        ; ligne 7  B,G,R
        .byte   $00,$00,$F7        ; ligne 8  B,G,R
        .byte   $00,$80,$FF        ; ligne 9  B,G,R
; tuile 138 : imp140 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$03        ; ligne 5  B,G,R
        .byte   $00,$01,$07        ; ligne 6  B,G,R
        .byte   $00,$01,$07        ; ligne 7  B,G,R
        .byte   $00,$03,$07        ; ligne 8  B,G,R
        .byte   $00,$07,$0F        ; ligne 9  B,G,R
; tuile 139 : imp141 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$02,$FF        ; ligne 4  B,G,R
        .byte   $00,$DB,$FF        ; ligne 5  B,G,R
        .byte   $00,$83,$FF        ; ligne 6  B,G,R
        .byte   $00,$83,$FF        ; ligne 7  B,G,R
        .byte   $00,$00,$FF        ; ligne 8  B,G,R
        .byte   $00,$60,$FB        ; ligne 9  B,G,R
; tuile 140 : imp142 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$16,$FF        ; ligne 4  B,G,R
        .byte   $00,$B7,$FF        ; ligne 5  B,G,R
        .byte   $00,$B1,$FF        ; ligne 6  B,G,R
        .byte   $00,$28,$FF        ; ligne 7  B,G,R
        .byte   $00,$4F,$FF        ; ligne 8  B,G,R
        .byte   $00,$4F,$FF        ; ligne 9  B,G,R
; tuile 141 : imp143 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$10        ; ligne 3  B,G,R
        .byte   $00,$3E,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$EB,$FF        ; ligne 6  B,G,R
        .byte   $00,$EB,$FF        ; ligne 7  B,G,R
        .byte   $00,$B1,$FF        ; ligne 8  B,G,R
        .byte   $00,$A0,$FF        ; ligne 9  B,G,R
; tuile 142 : imp144 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$01,$87        ; ligne 4  B,G,R
        .byte   $00,$87,$FF        ; ligne 5  B,G,R
        .byte   $00,$E3,$FF        ; ligne 6  B,G,R
        .byte   $00,$E3,$FF        ; ligne 7  B,G,R
        .byte   $00,$A0,$FF        ; ligne 8  B,G,R
        .byte   $00,$58,$FF        ; ligne 9  B,G,R
; tuile 143 : imp145 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$F8        ; ligne 3  B,G,R
        .byte   $00,$FC,$FF        ; ligne 4  B,G,R
        .byte   $00,$3E,$FF        ; ligne 5  B,G,R
        .byte   $00,$9F,$FF        ; ligne 6  B,G,R
        .byte   $00,$9F,$FF        ; ligne 7  B,G,R
        .byte   $00,$BF,$FF        ; ligne 8  B,G,R
        .byte   $00,$9E,$FF        ; ligne 9  B,G,R
; tuile 144 : imp146 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$FC        ; ligne 4  B,G,R
        .byte   $00,$F0,$FF        ; ligne 5  B,G,R
        .byte   $00,$C0,$FF        ; ligne 6  B,G,R
        .byte   $00,$A0,$FF        ; ligne 7  B,G,R
        .byte   $00,$E0,$FF        ; ligne 8  B,G,R
        .byte   $00,$E2,$FF        ; ligne 9  B,G,R
; tuile 145 : imp147 [solide] [destructible]
        .byte   $00,$07,$07        ; ligne 0  B,G,R
        .byte   $00,$07,$07        ; ligne 1  B,G,R
        .byte   $00,$06,$07        ; ligne 2  B,G,R
        .byte   $00,$06,$07        ; ligne 3  B,G,R
        .byte   $00,$06,$07        ; ligne 4  B,G,R
        .byte   $00,$00,$07        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 146 : imp148 [solide] [destructible]
        .byte   $00,$CC,$FE        ; ligne 0  B,G,R
        .byte   $00,$CC,$FC        ; ligne 1  B,G,R
        .byte   $00,$C4,$E4        ; ligne 2  B,G,R
        .byte   $00,$C0,$C0        ; ligne 3  B,G,R
        .byte   $00,$C0,$C0        ; ligne 4  B,G,R
        .byte   $00,$00,$80        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 147 : imp149 [solide] [destructible]
        .byte   $00,$0F,$0F        ; ligne 0  B,G,R
        .byte   $00,$0F,$0F        ; ligne 1  B,G,R
        .byte   $00,$07,$0F        ; ligne 2  B,G,R
        .byte   $00,$07,$07        ; ligne 3  B,G,R
        .byte   $00,$07,$07        ; ligne 4  B,G,R
        .byte   $00,$03,$07        ; ligne 5  B,G,R
        .byte   $00,$03,$03        ; ligne 6  B,G,R
        .byte   $00,$01,$03        ; ligne 7  B,G,R
        .byte   $00,$00,$01        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 148 : imp150 [solide] [destructible]
        .byte   $00,$00,$E2        ; ligne 0  B,G,R
        .byte   $00,$00,$F6        ; ligne 1  B,G,R
        .byte   $00,$00,$F0        ; ligne 2  B,G,R
        .byte   $00,$00,$F8        ; ligne 3  B,G,R
        .byte   $00,$00,$F8        ; ligne 4  B,G,R
        .byte   $00,$40,$F8        ; ligne 5  B,G,R
        .byte   $00,$E0,$F8        ; ligne 6  B,G,R
        .byte   $00,$C0,$F0        ; ligne 7  B,G,R
        .byte   $00,$80,$E0        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 149 : imp151 [solide] [destructible]
        .byte   $00,$07,$0F        ; ligne 0  B,G,R
        .byte   $00,$01,$07        ; ligne 1  B,G,R
        .byte   $00,$00,$03        ; ligne 2  B,G,R
        .byte   $00,$01,$03        ; ligne 3  B,G,R
        .byte   $00,$00,$01        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 150 : imp152 [solide] [destructible]
        .byte   $00,$B0,$FF        ; ligne 0  B,G,R
        .byte   $00,$F0,$FF        ; ligne 1  B,G,R
        .byte   $00,$F0,$FF        ; ligne 2  B,G,R
        .byte   $00,$72,$FF        ; ligne 3  B,G,R
        .byte   $00,$70,$FF        ; ligne 4  B,G,R
        .byte   $00,$30,$FF        ; ligne 5  B,G,R
        .byte   $00,$20,$FF        ; ligne 6  B,G,R
        .byte   $00,$60,$7F        ; ligne 7  B,G,R
        .byte   $00,$20,$7F        ; ligne 8  B,G,R
        .byte   $00,$00,$1F        ; ligne 9  B,G,R
; tuile 151 : imp153 [solide] [destructible]
        .byte   $00,$35,$FF        ; ligne 0  B,G,R
        .byte   $00,$3F,$7F        ; ligne 1  B,G,R
        .byte   $00,$3D,$7F        ; ligne 2  B,G,R
        .byte   $00,$6D,$7F        ; ligne 3  B,G,R
        .byte   $00,$2C,$7F        ; ligne 4  B,G,R
        .byte   $00,$34,$7F        ; ligne 5  B,G,R
        .byte   $00,$7C,$7F        ; ligne 6  B,G,R
        .byte   $00,$78,$FF        ; ligne 7  B,G,R
        .byte   $00,$32,$FF        ; ligne 8  B,G,R
        .byte   $00,$36,$FF        ; ligne 9  B,G,R
; tuile 152 : imp154 [solide] [destructible]
        .byte   $00,$FE,$FF        ; ligne 0  B,G,R
        .byte   $00,$EE,$FF        ; ligne 1  B,G,R
        .byte   $00,$E6,$FF        ; ligne 2  B,G,R
        .byte   $00,$E4,$FF        ; ligne 3  B,G,R
        .byte   $00,$F8,$FF        ; ligne 4  B,G,R
        .byte   $00,$78,$FF        ; ligne 5  B,G,R
        .byte   $00,$18,$FF        ; ligne 6  B,G,R
        .byte   $00,$08,$FE        ; ligne 7  B,G,R
        .byte   $00,$80,$FC        ; ligne 8  B,G,R
        .byte   $00,$C0,$FE        ; ligne 9  B,G,R
; tuile 153 : imp155 [solide] [destructible]
        .byte   $00,$3E,$FF        ; ligne 0  B,G,R
        .byte   $00,$1F,$FF        ; ligne 1  B,G,R
        .byte   $00,$1F,$FF        ; ligne 2  B,G,R
        .byte   $00,$1F,$FF        ; ligne 3  B,G,R
        .byte   $00,$4B,$FF        ; ligne 4  B,G,R
        .byte   $00,$0B,$FF        ; ligne 5  B,G,R
        .byte   $00,$05,$7F        ; ligne 6  B,G,R
        .byte   $00,$04,$FF        ; ligne 7  B,G,R
        .byte   $00,$22,$FF        ; ligne 8  B,G,R
        .byte   $00,$00,$FF        ; ligne 9  B,G,R
; tuile 154 : imp156 [solide] [destructible]
        .byte   $00,$7C,$FF        ; ligne 0  B,G,R
        .byte   $00,$3C,$FF        ; ligne 1  B,G,R
        .byte   $00,$3C,$FF        ; ligne 2  B,G,R
        .byte   $00,$1C,$FF        ; ligne 3  B,G,R
        .byte   $00,$80,$FE        ; ligne 4  B,G,R
        .byte   $00,$80,$FE        ; ligne 5  B,G,R
        .byte   $00,$C0,$FE        ; ligne 6  B,G,R
        .byte   $00,$C0,$FE        ; ligne 7  B,G,R
        .byte   $00,$E0,$FF        ; ligne 8  B,G,R
        .byte   $00,$40,$FF        ; ligne 9  B,G,R
; tuile 155 : imp157 [solide] [destructible]
        .byte   $00,$78,$FF        ; ligne 0  B,G,R
        .byte   $00,$7E,$FF        ; ligne 1  B,G,R
        .byte   $00,$3F,$FF        ; ligne 2  B,G,R
        .byte   $00,$3F,$FF        ; ligne 3  B,G,R
        .byte   $00,$1F,$FF        ; ligne 4  B,G,R
        .byte   $00,$0F,$7F        ; ligne 5  B,G,R
        .byte   $00,$0F,$7F        ; ligne 6  B,G,R
        .byte   $00,$03,$3F        ; ligne 7  B,G,R
        .byte   $00,$00,$1F        ; ligne 8  B,G,R
        .byte   $00,$00,$87        ; ligne 9  B,G,R
; tuile 156 : imp158 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$87        ; ligne 1  B,G,R
        .byte   $00,$00,$F0        ; ligne 2  B,G,R
        .byte   $00,$80,$FF        ; ligne 3  B,G,R
        .byte   $00,$E0,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FF,$FF        ; ligne 7  B,G,R
        .byte   $00,$FF,$FF        ; ligne 8  B,G,R
        .byte   $00,$1F,$FF        ; ligne 9  B,G,R
; tuile 157 : imp159 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FE        ; ligne 1  B,G,R
        .byte   $00,$00,$01        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FF,$FF        ; ligne 7  B,G,R
        .byte   $00,$FF,$FF        ; ligne 8  B,G,R
        .byte   $00,$FF,$FF        ; ligne 9  B,G,R
; tuile 158 : imp160 [solide] [destructible]
        .byte   $00,$03,$FF        ; ligne 0  B,G,R
        .byte   $00,$07,$3F        ; ligne 1  B,G,R
        .byte   $00,$1F,$FF        ; ligne 2  B,G,R
        .byte   $00,$3F,$FF        ; ligne 3  B,G,R
        .byte   $00,$FF,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$FE,$FF        ; ligne 6  B,G,R
        .byte   $00,$F8,$FF        ; ligne 7  B,G,R
        .byte   $00,$E0,$FF        ; ligne 8  B,G,R
        .byte   $00,$80,$FC        ; ligne 9  B,G,R
; tuile 159 : imp161 [solide] [destructible]
        .byte   $00,$E0,$FC        ; ligne 0  B,G,R
        .byte   $00,$E0,$FC        ; ligne 1  B,G,R
        .byte   $00,$C0,$FC        ; ligne 2  B,G,R
        .byte   $00,$80,$F9        ; ligne 3  B,G,R
        .byte   $00,$00,$F3        ; ligne 4  B,G,R
        .byte   $00,$00,$E7        ; ligne 5  B,G,R
        .byte   $00,$00,$C7        ; ligne 6  B,G,R
        .byte   $00,$00,$8F        ; ligne 7  B,G,R
        .byte   $00,$00,$1F        ; ligne 8  B,G,R
        .byte   $00,$00,$3F        ; ligne 9  B,G,R
; tuile 160 : imp162 [solide] [destructible]
        .byte   $00,$00,$78        ; ligne 0  B,G,R
        .byte   $00,$00,$F9        ; ligne 1  B,G,R
        .byte   $00,$00,$F1        ; ligne 2  B,G,R
        .byte   $00,$00,$F2        ; ligne 3  B,G,R
        .byte   $00,$00,$E6        ; ligne 4  B,G,R
        .byte   $00,$00,$E4        ; ligne 5  B,G,R
        .byte   $00,$00,$E4        ; ligne 6  B,G,R
        .byte   $00,$00,$CC        ; ligne 7  B,G,R
        .byte   $00,$00,$89        ; ligne 8  B,G,R
        .byte   $00,$00,$91        ; ligne 9  B,G,R
; tuile 161 : imp163 [solide] [destructible]
        .byte   $00,$00,$3F        ; ligne 0  B,G,R
        .byte   $00,$18,$3F        ; ligne 1  B,G,R
        .byte   $00,$1C,$3F        ; ligne 2  B,G,R
        .byte   $00,$1C,$7F        ; ligne 3  B,G,R
        .byte   $00,$3E,$7F        ; ligne 4  B,G,R
        .byte   $00,$27,$7F        ; ligne 5  B,G,R
        .byte   $00,$27,$7F        ; ligne 6  B,G,R
        .byte   $00,$27,$FF        ; ligne 7  B,G,R
        .byte   $00,$07,$FF        ; ligne 8  B,G,R
        .byte   $00,$06,$FF        ; ligne 9  B,G,R
; tuile 162 : imp164 [solide] [destructible]
        .byte   $00,$41,$FF        ; ligne 0  B,G,R
        .byte   $00,$4E,$FF        ; ligne 1  B,G,R
        .byte   $00,$4C,$FE        ; ligne 2  B,G,R
        .byte   $00,$68,$FC        ; ligne 3  B,G,R
        .byte   $00,$F0,$F8        ; ligne 4  B,G,R
        .byte   $00,$C0,$F0        ; ligne 5  B,G,R
        .byte   $00,$C0,$F0        ; ligne 6  B,G,R
        .byte   $00,$40,$E0        ; ligne 7  B,G,R
        .byte   $00,$00,$C0        ; ligne 8  B,G,R
        .byte   $00,$00,$80        ; ligne 9  B,G,R
; tuile 163 : imp165 [solide] [destructible]
        .byte   $00,$07,$0F        ; ligne 0  B,G,R
        .byte   $00,$06,$0F        ; ligne 1  B,G,R
        .byte   $00,$06,$0F        ; ligne 2  B,G,R
        .byte   $00,$06,$0F        ; ligne 3  B,G,R
        .byte   $00,$07,$07        ; ligne 4  B,G,R
        .byte   $00,$03,$07        ; ligne 5  B,G,R
        .byte   $00,$03,$07        ; ligne 6  B,G,R
        .byte   $00,$00,$03        ; ligne 7  B,G,R
        .byte   $00,$00,$01        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 164 : imp166 [solide] [destructible]
        .byte   $00,$60,$F9        ; ligne 0  B,G,R
        .byte   $00,$E0,$F9        ; ligne 1  B,G,R
        .byte   $00,$C0,$F9        ; ligne 2  B,G,R
        .byte   $00,$61,$FF        ; ligne 3  B,G,R
        .byte   $00,$20,$FF        ; ligne 4  B,G,R
        .byte   $00,$6C,$FF        ; ligne 5  B,G,R
        .byte   $00,$EC,$FF        ; ligne 6  B,G,R
        .byte   $00,$E0,$FF        ; ligne 7  B,G,R
        .byte   $00,$20,$FB        ; ligne 8  B,G,R
        .byte   $00,$03,$43        ; ligne 9  B,G,R
; tuile 165 : imp167 [solide] [destructible]
        .byte   $00,$10,$FF        ; ligne 0  B,G,R
        .byte   $00,$0C,$FF        ; ligne 1  B,G,R
        .byte   $00,$8F,$FF        ; ligne 2  B,G,R
        .byte   $00,$87,$FF        ; ligne 3  B,G,R
        .byte   $00,$04,$E7        ; ligne 4  B,G,R
        .byte   $00,$07,$E7        ; ligne 5  B,G,R
        .byte   $00,$07,$E7        ; ligne 6  B,G,R
        .byte   $00,$67,$FF        ; ligne 7  B,G,R
        .byte   $00,$67,$FF        ; ligne 8  B,G,R
        .byte   $00,$67,$FF        ; ligne 9  B,G,R
; tuile 166 : imp168 [solide] [destructible]
        .byte   $00,$A1,$FF        ; ligne 0  B,G,R
        .byte   $00,$E1,$FF        ; ligne 1  B,G,R
        .byte   $00,$40,$FF        ; ligne 2  B,G,R
        .byte   $00,$06,$EF        ; ligne 3  B,G,R
        .byte   $00,$03,$C7        ; ligne 4  B,G,R
        .byte   $00,$03,$C7        ; ligne 5  B,G,R
        .byte   $00,$83,$E7        ; ligne 6  B,G,R
        .byte   $00,$C3,$F7        ; ligne 7  B,G,R
        .byte   $00,$C3,$F7        ; ligne 8  B,G,R
        .byte   $00,$E3,$F7        ; ligne 9  B,G,R
; tuile 167 : imp169 [solide] [destructible]
        .byte   $00,$9F,$FF        ; ligne 0  B,G,R
        .byte   $00,$9B,$FF        ; ligne 1  B,G,R
        .byte   $00,$0F,$FF        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$F8        ; ligne 4  B,G,R
        .byte   $00,$80,$E0        ; ligne 5  B,G,R
        .byte   $00,$80,$E0        ; ligne 6  B,G,R
        .byte   $00,$C0,$F0        ; ligne 7  B,G,R
        .byte   $00,$C0,$F3        ; ligne 8  B,G,R
        .byte   $00,$C0,$F3        ; ligne 9  B,G,R
; tuile 168 : imp170 [solide] [destructible]
        .byte   $00,$8F,$FF        ; ligne 0  B,G,R
        .byte   $00,$0F,$FF        ; ligne 1  B,G,R
        .byte   $00,$8F,$FF        ; ligne 2  B,G,R
        .byte   $00,$2F,$FF        ; ligne 3  B,G,R
        .byte   $00,$03,$7F        ; ligne 4  B,G,R
        .byte   $00,$01,$37        ; ligne 5  B,G,R
        .byte   $00,$00,$03        ; ligne 6  B,G,R
        .byte   $00,$00,$01        ; ligne 7  B,G,R
        .byte   $00,$00,$80        ; ligne 8  B,G,R
        .byte   $00,$00,$80        ; ligne 9  B,G,R
; tuile 169 : imp171 [solide] [destructible]
        .byte   $00,$E3,$FF        ; ligne 0  B,G,R
        .byte   $00,$E3,$FF        ; ligne 1  B,G,R
        .byte   $00,$F2,$FF        ; ligne 2  B,G,R
        .byte   $00,$F3,$FF        ; ligne 3  B,G,R
        .byte   $00,$F7,$FF        ; ligne 4  B,G,R
        .byte   $00,$F6,$FF        ; ligne 5  B,G,R
        .byte   $00,$F0,$FF        ; ligne 6  B,G,R
        .byte   $00,$F0,$FE        ; ligne 7  B,G,R
        .byte   $00,$40,$FF        ; ligne 8  B,G,R
        .byte   $00,$00,$3F        ; ligne 9  B,G,R
; tuile 170 : imp172 [solide] [destructible]
        .byte   $00,$00,$80        ; ligne 0  B,G,R
        .byte   $00,$00,$80        ; ligne 1  B,G,R
        .byte   $00,$00,$80        ; ligne 2  B,G,R
        .byte   $00,$00,$80        ; ligne 3  B,G,R
        .byte   $00,$00,$80        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$FF        ; ligne 9  B,G,R
; tuile 171 : imp173 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$E0,$FF        ; ligne 9  B,G,R
; tuile 172 : imp174 [solide] [destructible]
        .byte   $00,$00,$0F        ; ligne 0  B,G,R
        .byte   $00,$00,$0F        ; ligne 1  B,G,R
        .byte   $00,$00,$07        ; ligne 2  B,G,R
        .byte   $00,$00,$03        ; ligne 3  B,G,R
        .byte   $00,$00,$03        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 173 : imp175 [solide] [destructible]
        .byte   $00,$17,$FF        ; ligne 0  B,G,R
        .byte   $00,$37,$FF        ; ligne 1  B,G,R
        .byte   $00,$3F,$FF        ; ligne 2  B,G,R
        .byte   $00,$39,$FF        ; ligne 3  B,G,R
        .byte   $00,$3B,$FF        ; ligne 4  B,G,R
        .byte   $00,$03,$3F        ; ligne 5  B,G,R
        .byte   $00,$00,$3F        ; ligne 6  B,G,R
        .byte   $00,$00,$1B        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 174 : imp176 [solide] [destructible]
        .byte   $00,$C0,$FF        ; ligne 0  B,G,R
        .byte   $00,$C0,$FD        ; ligne 1  B,G,R
        .byte   $00,$E0,$F9        ; ligne 2  B,G,R
        .byte   $00,$80,$F3        ; ligne 3  B,G,R
        .byte   $00,$00,$F3        ; ligne 4  B,G,R
        .byte   $00,$00,$E7        ; ligne 5  B,G,R
        .byte   $00,$00,$E6        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 175 : imp177 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FB        ; ligne 1  B,G,R
        .byte   $00,$20,$FD        ; ligne 2  B,G,R
        .byte   $00,$20,$FE        ; ligne 3  B,G,R
        .byte   $00,$0C,$FE        ; ligne 4  B,G,R
        .byte   $00,$0C,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$08        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 176 : imp178 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$EF        ; ligne 1  B,G,R
        .byte   $00,$00,$E7        ; ligne 2  B,G,R
        .byte   $00,$00,$B3        ; ligne 3  B,G,R
        .byte   $00,$00,$19        ; ligne 4  B,G,R
        .byte   $00,$00,$88        ; ligne 5  B,G,R
        .byte   $00,$00,$8C        ; ligne 6  B,G,R
        .byte   $00,$00,$07        ; ligne 7  B,G,R
        .byte   $00,$00,$01        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 177 : imp179 [solide] [destructible]
        .byte   $00,$00,$C3        ; ligne 0  B,G,R
        .byte   $00,$00,$E0        ; ligne 1  B,G,R
        .byte   $00,$00,$F8        ; ligne 2  B,G,R
        .byte   $00,$00,$FE        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$00,$3F        ; ligne 6  B,G,R
        .byte   $00,$00,$0F        ; ligne 7  B,G,R
        .byte   $00,$00,$87        ; ligne 8  B,G,R
        .byte   $00,$00,$C1        ; ligne 9  B,G,R
; tuile 178 : imp180 [solide] [destructible]
        .byte   $00,$0F,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FF        ; ligne 1  B,G,R
        .byte   $00,$00,$1F        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$C0        ; ligne 4  B,G,R
        .byte   $00,$00,$E0        ; ligne 5  B,G,R
        .byte   $00,$00,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$FF        ; ligne 7  B,G,R
        .byte   $00,$00,$FF        ; ligne 8  B,G,R
        .byte   $00,$00,$FF        ; ligne 9  B,G,R
; tuile 179 : imp181 [solide] [destructible]
        .byte   $00,$FE,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$FF        ; ligne 1  B,G,R
        .byte   $00,$00,$FF        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$FF        ; ligne 7  B,G,R
        .byte   $00,$00,$FF        ; ligne 8  B,G,R
        .byte   $00,$00,$FF        ; ligne 9  B,G,R
; tuile 180 : imp182 [solide] [destructible]
        .byte   $00,$00,$F8        ; ligne 0  B,G,R
        .byte   $00,$00,$F0        ; ligne 1  B,G,R
        .byte   $00,$00,$03        ; ligne 2  B,G,R
        .byte   $00,$00,$0F        ; ligne 3  B,G,R
        .byte   $00,$00,$7F        ; ligne 4  B,G,R
        .byte   $00,$00,$7F        ; ligne 5  B,G,R
        .byte   $00,$00,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$FE        ; ligne 7  B,G,R
        .byte   $00,$00,$FC        ; ligne 8  B,G,R
        .byte   $00,$00,$F0        ; ligne 9  B,G,R
; tuile 181 : imp183 [solide] [destructible]
        .byte   $00,$00,$7F        ; ligne 0  B,G,R
        .byte   $00,$00,$FE        ; ligne 1  B,G,R
        .byte   $00,$00,$FC        ; ligne 2  B,G,R
        .byte   $00,$00,$F9        ; ligne 3  B,G,R
        .byte   $00,$00,$F1        ; ligne 4  B,G,R
        .byte   $00,$00,$E3        ; ligne 5  B,G,R
        .byte   $00,$00,$86        ; ligne 6  B,G,R
        .byte   $00,$00,$1C        ; ligne 7  B,G,R
        .byte   $00,$00,$10        ; ligne 8  B,G,R
        .byte   $00,$00,$40        ; ligne 9  B,G,R
; tuile 182 : imp184 [solide] [destructible]
        .byte   $00,$00,$21        ; ligne 0  B,G,R
        .byte   $00,$00,$67        ; ligne 1  B,G,R
        .byte   $00,$02,$C7        ; ligne 2  B,G,R
        .byte   $00,$06,$8F        ; ligne 3  B,G,R
        .byte   $00,$0C,$1F        ; ligne 4  B,G,R
        .byte   $00,$04,$1F        ; ligne 5  B,G,R
        .byte   $00,$1C,$3E        ; ligne 6  B,G,R
        .byte   $00,$08,$3E        ; ligne 7  B,G,R
        .byte   $00,$00,$1C        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 183 : imp185 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$08,$7E        ; ligne 1  B,G,R
        .byte   $00,$08,$7C        ; ligne 2  B,G,R
        .byte   $00,$10,$7C        ; ligne 3  B,G,R
        .byte   $00,$20,$78        ; ligne 4  B,G,R
        .byte   $00,$00,$F8        ; ligne 5  B,G,R
        .byte   $00,$00,$F0        ; ligne 6  B,G,R
        .byte   $00,$00,$E0        ; ligne 7  B,G,R
        .byte   $00,$00,$E0        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 184 : imp186 [solide] [destructible]
        .byte   $00,$00,$80        ; ligne 0  B,G,R
        .byte   $00,$00,$C0        ; ligne 1  B,G,R
        .byte   $00,$00,$C0        ; ligne 2  B,G,R
        .byte   $00,$00,$C0        ; ligne 3  B,G,R
        .byte   $00,$00,$E0        ; ligne 4  B,G,R
        .byte   $00,$00,$E0        ; ligne 5  B,G,R
        .byte   $00,$00,$E0        ; ligne 6  B,G,R
        .byte   $00,$00,$E0        ; ligne 7  B,G,R
        .byte   $00,$00,$E0        ; ligne 8  B,G,R
        .byte   $00,$00,$E8        ; ligne 9  B,G,R
; tuile 185 : imp187 [solide] [destructible]
        .byte   $00,$01,$0F        ; ligne 0  B,G,R
        .byte   $00,$07,$0F        ; ligne 1  B,G,R
        .byte   $00,$06,$0F        ; ligne 2  B,G,R
        .byte   $00,$06,$1F        ; ligne 3  B,G,R
        .byte   $00,$0D,$1F        ; ligne 4  B,G,R
        .byte   $00,$1D,$3F        ; ligne 5  B,G,R
        .byte   $00,$1D,$3F        ; ligne 6  B,G,R
        .byte   $00,$1B,$3F        ; ligne 7  B,G,R
        .byte   $00,$19,$3F        ; ligne 8  B,G,R
        .byte   $00,$18,$3F        ; ligne 9  B,G,R
; tuile 186 : imp188 [solide] [destructible]
        .byte   $00,$0F,$FF        ; ligne 0  B,G,R
        .byte   $00,$6F,$FF        ; ligne 1  B,G,R
        .byte   $00,$06,$FF        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$81,$EF        ; ligne 4  B,G,R
        .byte   $00,$80,$E7        ; ligne 5  B,G,R
        .byte   $00,$80,$F7        ; ligne 6  B,G,R
        .byte   $00,$80,$F7        ; ligne 7  B,G,R
        .byte   $00,$42,$F7        ; ligne 8  B,G,R
        .byte   $00,$80,$FF        ; ligne 9  B,G,R
; tuile 187 : imp189 [solide] [destructible]
        .byte   $00,$5E,$FF        ; ligne 0  B,G,R
        .byte   $00,$DF,$FF        ; ligne 1  B,G,R
        .byte   $00,$E3,$FF        ; ligne 2  B,G,R
        .byte   $00,$32,$FF        ; ligne 3  B,G,R
        .byte   $00,$BE,$FF        ; ligne 4  B,G,R
        .byte   $00,$3E,$FF        ; ligne 5  B,G,R
        .byte   $00,$02,$FF        ; ligne 6  B,G,R
        .byte   $00,$31,$FF        ; ligne 7  B,G,R
        .byte   $00,$1C,$FF        ; ligne 8  B,G,R
        .byte   $00,$18,$FF        ; ligne 9  B,G,R
; tuile 188 : imp190 [solide] [destructible]
        .byte   $00,$FC,$FF        ; ligne 0  B,G,R
        .byte   $00,$FF,$FF        ; ligne 1  B,G,R
        .byte   $00,$AF,$FF        ; ligne 2  B,G,R
        .byte   $00,$CE,$FF        ; ligne 3  B,G,R
        .byte   $00,$C4,$FF        ; ligne 4  B,G,R
        .byte   $00,$81,$FF        ; ligne 5  B,G,R
        .byte   $00,$87,$FF        ; ligne 6  B,G,R
        .byte   $00,$C3,$FF        ; ligne 7  B,G,R
        .byte   $00,$18,$FF        ; ligne 8  B,G,R
        .byte   $00,$08,$3F        ; ligne 9  B,G,R
; tuile 189 : imp191 [solide] [destructible]
        .byte   $00,$0E,$9F        ; ligne 0  B,G,R
        .byte   $00,$0E,$FF        ; ligne 1  B,G,R
        .byte   $00,$C6,$FF        ; ligne 2  B,G,R
        .byte   $00,$8B,$FF        ; ligne 3  B,G,R
        .byte   $00,$C2,$FF        ; ligne 4  B,G,R
        .byte   $00,$62,$FF        ; ligne 5  B,G,R
        .byte   $00,$7E,$FF        ; ligne 6  B,G,R
        .byte   $00,$24,$FF        ; ligne 7  B,G,R
        .byte   $00,$17,$FF        ; ligne 8  B,G,R
        .byte   $00,$00,$FF        ; ligne 9  B,G,R
; tuile 190 : imp192 [solide] [destructible]
        .byte   $00,$F9,$FF        ; ligne 0  B,G,R
        .byte   $00,$7F,$FF        ; ligne 1  B,G,R
        .byte   $00,$7F,$FF        ; ligne 2  B,G,R
        .byte   $00,$BF,$FF        ; ligne 3  B,G,R
        .byte   $00,$3F,$FF        ; ligne 4  B,G,R
        .byte   $00,$3F,$FF        ; ligne 5  B,G,R
        .byte   $00,$3F,$FF        ; ligne 6  B,G,R
        .byte   $00,$1F,$FF        ; ligne 7  B,G,R
        .byte   $00,$BF,$FF        ; ligne 8  B,G,R
        .byte   $00,$0F,$FF        ; ligne 9  B,G,R
; tuile 191 : imp193 [solide] [destructible]
        .byte   $00,$80,$F8        ; ligne 0  B,G,R
        .byte   $00,$C0,$FC        ; ligne 1  B,G,R
        .byte   $00,$00,$FE        ; ligne 2  B,G,R
        .byte   $00,$80,$FE        ; ligne 3  B,G,R
        .byte   $00,$80,$FE        ; ligne 4  B,G,R
        .byte   $00,$84,$FE        ; ligne 5  B,G,R
        .byte   $00,$84,$FE        ; ligne 6  B,G,R
        .byte   $00,$84,$FE        ; ligne 7  B,G,R
        .byte   $00,$CC,$FE        ; ligne 8  B,G,R
        .byte   $00,$CC,$FE        ; ligne 9  B,G,R
; tuile 192 : imp195 [solide] [destructible]
        .byte   $00,$00,$20        ; ligne 0  B,G,R
        .byte   $00,$00,$1C        ; ligne 1  B,G,R
        .byte   $00,$00,$03        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 193 : imp196 [solide] [destructible]
        .byte   $00,$00,$3F        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$C0        ; ligne 2  B,G,R
        .byte   $00,$00,$7F        ; ligne 3  B,G,R
        .byte   $00,$00,$1F        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 194 : imp197 [solide] [destructible]
        .byte   $00,$00,$FF        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$00,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 195 : imp198 [solide] [destructible]
        .byte   $00,$00,$80        ; ligne 0  B,G,R
        .byte   $00,$00,$07        ; ligne 1  B,G,R
        .byte   $00,$00,$78        ; ligne 2  B,G,R
        .byte   $00,$00,$C0        ; ligne 3  B,G,R
        .byte   $00,$00,$80        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 196 : imp199 [solide] [destructible]
        .byte   $00,$0C,$1F        ; ligne 0  B,G,R
        .byte   $00,$0D,$1F        ; ligne 1  B,G,R
        .byte   $00,$07,$0F        ; ligne 2  B,G,R
        .byte   $00,$01,$07        ; ligne 3  B,G,R
        .byte   $00,$00,$03        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 197 : imp200 [solide] [destructible]
        .byte   $00,$80,$FF        ; ligne 0  B,G,R
        .byte   $00,$B8,$FF        ; ligne 1  B,G,R
        .byte   $00,$F1,$FF        ; ligne 2  B,G,R
        .byte   $00,$81,$FF        ; ligne 3  B,G,R
        .byte   $00,$01,$EF        ; ligne 4  B,G,R
        .byte   $00,$07,$0F        ; ligne 5  B,G,R
        .byte   $00,$07,$0F        ; ligne 6  B,G,R
        .byte   $00,$07,$0F        ; ligne 7  B,G,R
        .byte   $00,$07,$0F        ; ligne 8  B,G,R
        .byte   $00,$07,$0F        ; ligne 9  B,G,R
; tuile 198 : imp201 [solide] [destructible]
        .byte   $00,$0C,$9F        ; ligne 0  B,G,R
        .byte   $00,$0E,$9F        ; ligne 1  B,G,R
        .byte   $00,$1F,$DF        ; ligne 2  B,G,R
        .byte   $00,$9F,$FF        ; ligne 3  B,G,R
        .byte   $00,$9F,$FF        ; ligne 4  B,G,R
        .byte   $00,$9F,$FF        ; ligne 5  B,G,R
        .byte   $00,$DF,$FF        ; ligne 6  B,G,R
        .byte   $00,$DF,$FF        ; ligne 7  B,G,R
        .byte   $00,$DF,$FF        ; ligne 8  B,G,R
        .byte   $00,$DF,$FF        ; ligne 9  B,G,R
; tuile 199 : imp202 [solide] [destructible]
        .byte   $00,$04,$1F        ; ligne 0  B,G,R
        .byte   $00,$0E,$9F        ; ligne 1  B,G,R
        .byte   $00,$0F,$DF        ; ligne 2  B,G,R
        .byte   $00,$0F,$DF        ; ligne 3  B,G,R
        .byte   $00,$8F,$DF        ; ligne 4  B,G,R
        .byte   $00,$8F,$DF        ; ligne 5  B,G,R
        .byte   $00,$8F,$DF        ; ligne 6  B,G,R
        .byte   $00,$8F,$DF        ; ligne 7  B,G,R
        .byte   $00,$8F,$DF        ; ligne 8  B,G,R
        .byte   $00,$8F,$DF        ; ligne 9  B,G,R
; tuile 200 : imp203 [solide] [destructible]
        .byte   $00,$00,$C0        ; ligne 0  B,G,R
        .byte   $00,$00,$80        ; ligne 1  B,G,R
        .byte   $00,$00,$C0        ; ligne 2  B,G,R
        .byte   $00,$00,$C4        ; ligne 3  B,G,R
        .byte   $00,$00,$C6        ; ligne 4  B,G,R
        .byte   $00,$80,$E7        ; ligne 5  B,G,R
        .byte   $00,$80,$E7        ; ligne 6  B,G,R
        .byte   $00,$80,$E7        ; ligne 7  B,G,R
        .byte   $00,$80,$E7        ; ligne 8  B,G,R
        .byte   $00,$80,$E7        ; ligne 9  B,G,R
; tuile 201 : imp204 [solide] [destructible]
        .byte   $00,$07,$FF        ; ligne 0  B,G,R
        .byte   $00,$07,$0F        ; ligne 1  B,G,R
        .byte   $00,$03,$07        ; ligne 2  B,G,R
        .byte   $00,$01,$07        ; ligne 3  B,G,R
        .byte   $00,$00,$01        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$80        ; ligne 7  B,G,R
        .byte   $00,$00,$80        ; ligne 8  B,G,R
        .byte   $00,$00,$80        ; ligne 9  B,G,R
; tuile 202 : imp205 [solide] [destructible]
        .byte   $00,$DC,$FE        ; ligne 0  B,G,R
        .byte   $00,$58,$FC        ; ligne 1  B,G,R
        .byte   $00,$C0,$FC        ; ligne 2  B,G,R
        .byte   $00,$C0,$FC        ; ligne 3  B,G,R
        .byte   $00,$00,$FC        ; ligne 4  B,G,R
        .byte   $00,$00,$7F        ; ligne 5  B,G,R
        .byte   $00,$0C,$1F        ; ligne 6  B,G,R
        .byte   $00,$19,$3F        ; ligne 7  B,G,R
        .byte   $00,$18,$3F        ; ligne 8  B,G,R
        .byte   $00,$18,$7F        ; ligne 9  B,G,R
; tuile 203 : imp206 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$BD,$FF        ; ligne 6  B,G,R
        .byte   $00,$9B,$FF        ; ligne 7  B,G,R
        .byte   $00,$13,$FF        ; ligne 8  B,G,R
        .byte   $00,$02,$FF        ; ligne 9  B,G,R
; tuile 204 : imp207 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$21,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$8E,$FF        ; ligne 7  B,G,R
        .byte   $00,$8E,$FF        ; ligne 8  B,G,R
        .byte   $00,$EB,$FF        ; ligne 9  B,G,R
; tuile 205 : imp209 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$0F,$3F        ; ligne 5  B,G,R
        .byte   $00,$3B,$FF        ; ligne 6  B,G,R
        .byte   $00,$19,$FF        ; ligne 7  B,G,R
        .byte   $00,$1C,$FF        ; ligne 8  B,G,R
        .byte   $00,$0C,$FF        ; ligne 9  B,G,R
; tuile 206 : imp210 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$C0,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FC,$FF        ; ligne 7  B,G,R
        .byte   $00,$FE,$FF        ; ligne 8  B,G,R
        .byte   $00,$FE,$FF        ; ligne 9  B,G,R
; tuile 207 : imp211 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$C0        ; ligne 5  B,G,R
        .byte   $00,$00,$F0        ; ligne 6  B,G,R
        .byte   $00,$00,$F8        ; ligne 7  B,G,R
        .byte   $00,$00,$F8        ; ligne 8  B,G,R
        .byte   $00,$00,$FC        ; ligne 9  B,G,R
; tuile 208 : imp212 [solide] [destructible]
        .byte   $00,$00,$80        ; ligne 0  B,G,R
        .byte   $00,$00,$80        ; ligne 1  B,G,R
        .byte   $00,$00,$80        ; ligne 2  B,G,R
        .byte   $00,$00,$80        ; ligne 3  B,G,R
        .byte   $00,$00,$90        ; ligne 4  B,G,R
        .byte   $00,$00,$90        ; ligne 5  B,G,R
        .byte   $00,$00,$90        ; ligne 6  B,G,R
        .byte   $00,$00,$90        ; ligne 7  B,G,R
        .byte   $00,$00,$90        ; ligne 8  B,G,R
        .byte   $00,$00,$90        ; ligne 9  B,G,R
; tuile 209 : imp213 [solide] [destructible]
        .byte   $00,$32,$7F        ; ligne 0  B,G,R
        .byte   $00,$77,$7F        ; ligne 1  B,G,R
        .byte   $00,$66,$7F        ; ligne 2  B,G,R
        .byte   $00,$66,$7F        ; ligne 3  B,G,R
        .byte   $00,$65,$7F        ; ligne 4  B,G,R
        .byte   $00,$32,$7F        ; ligne 5  B,G,R
        .byte   $00,$32,$7F        ; ligne 6  B,G,R
        .byte   $00,$1E,$3F        ; ligne 7  B,G,R
        .byte   $00,$0F,$3F        ; ligne 8  B,G,R
        .byte   $00,$02,$1F        ; ligne 9  B,G,R
; tuile 210 : imp214 [solide] [destructible]
        .byte   $00,$06,$9F        ; ligne 0  B,G,R
        .byte   $00,$01,$DF        ; ligne 1  B,G,R
        .byte   $00,$00,$CF        ; ligne 2  B,G,R
        .byte   $00,$08,$DF        ; ligne 3  B,G,R
        .byte   $00,$0C,$DF        ; ligne 4  B,G,R
        .byte   $00,$00,$FF        ; ligne 5  B,G,R
        .byte   $00,$E0,$FE        ; ligne 6  B,G,R
        .byte   $00,$E0,$FF        ; ligne 7  B,G,R
        .byte   $00,$46,$FF        ; ligne 8  B,G,R
        .byte   $00,$07,$FF        ; ligne 9  B,G,R
; tuile 211 : imp215 [solide] [destructible]
        .byte   $00,$FB,$FF        ; ligne 0  B,G,R
        .byte   $00,$0A,$FF        ; ligne 1  B,G,R
        .byte   $00,$C7,$FF        ; ligne 2  B,G,R
        .byte   $00,$72,$FF        ; ligne 3  B,G,R
        .byte   $00,$30,$FF        ; ligne 4  B,G,R
        .byte   $00,$00,$7C        ; ligne 5  B,G,R
        .byte   $00,$38,$7E        ; ligne 6  B,G,R
        .byte   $00,$3C,$7F        ; ligne 7  B,G,R
        .byte   $00,$7C,$7F        ; ligne 8  B,G,R
        .byte   $00,$7E,$FF        ; ligne 9  B,G,R
; tuile 212 : imp216 [solide] [destructible]
        .byte   $00,$03,$FF        ; ligne 0  B,G,R
        .byte   $00,$4C,$FF        ; ligne 1  B,G,R
        .byte   $00,$0C,$FF        ; ligne 2  B,G,R
        .byte   $00,$00,$FF        ; ligne 3  B,G,R
        .byte   $00,$20,$FF        ; ligne 4  B,G,R
        .byte   $00,$12,$7F        ; ligne 5  B,G,R
        .byte   $00,$18,$7E        ; ligne 6  B,G,R
        .byte   $00,$1C,$7F        ; ligne 7  B,G,R
        .byte   $00,$1C,$7F        ; ligne 8  B,G,R
        .byte   $00,$1C,$7F        ; ligne 9  B,G,R
; tuile 213 : imp217 [solide] [destructible]
        .byte   $00,$89,$FF        ; ligne 0  B,G,R
        .byte   $00,$F8,$FF        ; ligne 1  B,G,R
        .byte   $00,$D8,$FF        ; ligne 2  B,G,R
        .byte   $00,$D8,$FF        ; ligne 3  B,G,R
        .byte   $00,$4F,$FF        ; ligne 4  B,G,R
        .byte   $00,$01,$E3        ; ligne 5  B,G,R
        .byte   $00,$00,$01        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$18        ; ligne 9  B,G,R
; tuile 214 : imp218 [solide] [destructible]
        .byte   $00,$FF,$FF        ; ligne 0  B,G,R
        .byte   $00,$FE,$FF        ; ligne 1  B,G,R
        .byte   $00,$7E,$FF        ; ligne 2  B,G,R
        .byte   $00,$7F,$FF        ; ligne 3  B,G,R
        .byte   $00,$FF,$FF        ; ligne 4  B,G,R
        .byte   $00,$3F,$FF        ; ligne 5  B,G,R
        .byte   $00,$1D,$3F        ; ligne 6  B,G,R
        .byte   $00,$0F,$3F        ; ligne 7  B,G,R
        .byte   $00,$07,$1F        ; ligne 8  B,G,R
        .byte   $00,$07,$0F        ; ligne 9  B,G,R
; tuile 215 : imp219 [solide] [destructible]
        .byte   $00,$00,$FC        ; ligne 0  B,G,R
        .byte   $00,$10,$FC        ; ligne 1  B,G,R
        .byte   $00,$10,$FC        ; ligne 2  B,G,R
        .byte   $00,$10,$F8        ; ligne 3  B,G,R
        .byte   $00,$10,$F8        ; ligne 4  B,G,R
        .byte   $00,$30,$F8        ; ligne 5  B,G,R
        .byte   $00,$60,$F8        ; ligne 6  B,G,R
        .byte   $00,$00,$F0        ; ligne 7  B,G,R
        .byte   $00,$00,$F0        ; ligne 8  B,G,R
        .byte   $00,$00,$F0        ; ligne 9  B,G,R
; tuile 216 : imp220 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$80        ; ligne 1  B,G,R
        .byte   $00,$00,$80        ; ligne 2  B,G,R
        .byte   $00,$00,$C0        ; ligne 3  B,G,R
        .byte   $00,$00,$C0        ; ligne 4  B,G,R
        .byte   $00,$80,$C0        ; ligne 5  B,G,R
        .byte   $00,$80,$C0        ; ligne 6  B,G,R
        .byte   $00,$00,$C0        ; ligne 7  B,G,R
        .byte   $00,$00,$C0        ; ligne 8  B,G,R
        .byte   $00,$80,$C0        ; ligne 9  B,G,R
; tuile 217 : imp221 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$01,$03        ; ligne 4  B,G,R
        .byte   $00,$01,$03        ; ligne 5  B,G,R
        .byte   $00,$03,$03        ; ligne 6  B,G,R
        .byte   $00,$03,$07        ; ligne 7  B,G,R
        .byte   $00,$01,$03        ; ligne 8  B,G,R
        .byte   $00,$01,$03        ; ligne 9  B,G,R
; tuile 218 : imp222 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$6E,$FF        ; ligne 3  B,G,R
        .byte   $00,$F5,$FF        ; ligne 4  B,G,R
        .byte   $00,$FF,$FF        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FE,$FF        ; ligne 7  B,G,R
        .byte   $00,$FF,$FF        ; ligne 8  B,G,R
        .byte   $00,$F5,$FF        ; ligne 9  B,G,R
; tuile 219 : imp223 [solide] [destructible]
        .byte   $00,$80,$C0        ; ligne 0  B,G,R
        .byte   $00,$80,$C0        ; ligne 1  B,G,R
        .byte   $00,$80,$C0        ; ligne 2  B,G,R
        .byte   $00,$00,$C0        ; ligne 3  B,G,R
        .byte   $00,$00,$C0        ; ligne 4  B,G,R
        .byte   $00,$80,$C0        ; ligne 5  B,G,R
        .byte   $00,$80,$C0        ; ligne 6  B,G,R
        .byte   $00,$80,$C0        ; ligne 7  B,G,R
        .byte   $00,$80,$C0        ; ligne 8  B,G,R
        .byte   $00,$80,$C0        ; ligne 9  B,G,R
; tuile 220 : imp224 [solide] [destructible]
        .byte   $00,$00,$03        ; ligne 0  B,G,R
        .byte   $00,$00,$03        ; ligne 1  B,G,R
        .byte   $00,$00,$03        ; ligne 2  B,G,R
        .byte   $00,$00,$01        ; ligne 3  B,G,R
        .byte   $00,$00,$01        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$03        ; ligne 7  B,G,R
        .byte   $00,$01,$07        ; ligne 8  B,G,R
        .byte   $00,$03,$07        ; ligne 9  B,G,R
; tuile 221 : imp225 [solide] [destructible]
        .byte   $00,$C1,$FF        ; ligne 0  B,G,R
        .byte   $00,$C1,$FF        ; ligne 1  B,G,R
        .byte   $00,$DC,$FF        ; ligne 2  B,G,R
        .byte   $00,$DE,$FF        ; ligne 3  B,G,R
        .byte   $00,$B6,$FF        ; ligne 4  B,G,R
        .byte   $00,$F4,$FF        ; ligne 5  B,G,R
        .byte   $00,$FC,$FF        ; ligne 6  B,G,R
        .byte   $00,$68,$FE        ; ligne 7  B,G,R
        .byte   $00,$E8,$FF        ; ligne 8  B,G,R
        .byte   $00,$F0,$FF        ; ligne 9  B,G,R
; tuile 222 : imp226 [solide] [destructible]
        .byte   $00,$80,$C0        ; ligne 0  B,G,R
        .byte   $00,$80,$C0        ; ligne 1  B,G,R
        .byte   $00,$00,$C0        ; ligne 2  B,G,R
        .byte   $00,$00,$80        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 223 : imp227 [solide] [destructible]
        .byte   $00,$03,$07        ; ligne 0  B,G,R
        .byte   $00,$00,$03        ; ligne 1  B,G,R
        .byte   $00,$03,$03        ; ligne 2  B,G,R
        .byte   $00,$03,$03        ; ligne 3  B,G,R
        .byte   $00,$01,$03        ; ligne 4  B,G,R
        .byte   $00,$00,$03        ; ligne 5  B,G,R
        .byte   $00,$00,$01        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$01        ; ligne 9  B,G,R
; tuile 224 : imp228 [solide] [destructible]
        .byte   $00,$B1,$FF        ; ligne 0  B,G,R
        .byte   $00,$47,$FF        ; ligne 1  B,G,R
        .byte   $00,$7D,$FF        ; ligne 2  B,G,R
        .byte   $00,$DD,$FF        ; ligne 3  B,G,R
        .byte   $00,$66,$FF        ; ligne 4  B,G,R
        .byte   $00,$67,$FF        ; ligne 5  B,G,R
        .byte   $00,$37,$FF        ; ligne 6  B,G,R
        .byte   $00,$00,$7F        ; ligne 7  B,G,R
        .byte   $00,$00,$7F        ; ligne 8  B,G,R
        .byte   $00,$20,$F2        ; ligne 9  B,G,R
; tuile 225 : imp231 [solide] [destructible]
        .byte   $00,$00,$0F        ; ligne 0  B,G,R
        .byte   $00,$0E,$1F        ; ligne 1  B,G,R
        .byte   $00,$0B,$1F        ; ligne 2  B,G,R
        .byte   $00,$1F,$1F        ; ligne 3  B,G,R
        .byte   $00,$1D,$3F        ; ligne 4  B,G,R
        .byte   $00,$1B,$3F        ; ligne 5  B,G,R
        .byte   $00,$1B,$3F        ; ligne 6  B,G,R
        .byte   $00,$1F,$1F        ; ligne 7  B,G,R
        .byte   $00,$1E,$3F        ; ligne 8  B,G,R
        .byte   $00,$16,$3F        ; ligne 9  B,G,R
; tuile 226 : imp232 [solide] [destructible]
        .byte   $00,$60,$FF        ; ligne 0  B,G,R
        .byte   $00,$0F,$FF        ; ligne 1  B,G,R
        .byte   $00,$0E,$FF        ; ligne 2  B,G,R
        .byte   $00,$FE,$FF        ; ligne 3  B,G,R
        .byte   $00,$FE,$FF        ; ligne 4  B,G,R
        .byte   $00,$7F,$FF        ; ligne 5  B,G,R
        .byte   $00,$7B,$FF        ; ligne 6  B,G,R
        .byte   $00,$FB,$FF        ; ligne 7  B,G,R
        .byte   $00,$73,$FF        ; ligne 8  B,G,R
        .byte   $00,$72,$FF        ; ligne 9  B,G,R
; tuile 227 : imp235 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$01,$81        ; ligne 6  B,G,R
        .byte   $00,$01,$C1        ; ligne 7  B,G,R
        .byte   $00,$03,$C3        ; ligne 8  B,G,R
        .byte   $00,$83,$C3        ; ligne 9  B,G,R
; tuile 228 : imp236 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$FF,$FF        ; ligne 6  B,G,R
        .byte   $00,$FF,$FF        ; ligne 7  B,G,R
        .byte   $00,$FF,$FF        ; ligne 8  B,G,R
        .byte   $00,$FF,$FF        ; ligne 9  B,G,R
; tuile 229 : imp237 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$FC,$FE        ; ligne 6  B,G,R
        .byte   $00,$FC,$FE        ; ligne 7  B,G,R
        .byte   $00,$FE,$FF        ; ligne 8  B,G,R
        .byte   $00,$FE,$FF        ; ligne 9  B,G,R
; tuile 230 : imp238 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$00        ; ligne 2  B,G,R
        .byte   $00,$00,$00        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$28        ; ligne 6  B,G,R
        .byte   $00,$00,$38        ; ligne 7  B,G,R
        .byte   $00,$00,$38        ; ligne 8  B,G,R
        .byte   $00,$10,$38        ; ligne 9  B,G,R
; tuile 231 : imp239 [solide] [destructible]
        .byte   $00,$1A,$1F        ; ligne 0  B,G,R
        .byte   $00,$1A,$1F        ; ligne 1  B,G,R
        .byte   $00,$1E,$1F        ; ligne 2  B,G,R
        .byte   $00,$1E,$3F        ; ligne 3  B,G,R
        .byte   $00,$1D,$1F        ; ligne 4  B,G,R
        .byte   $00,$19,$1F        ; ligne 5  B,G,R
        .byte   $00,$0B,$1F        ; ligne 6  B,G,R
        .byte   $00,$0B,$1F        ; ligne 7  B,G,R
        .byte   $00,$1F,$1F        ; ligne 8  B,G,R
        .byte   $00,$1E,$1F        ; ligne 9  B,G,R
; tuile 232 : imp240 [solide] [destructible]
        .byte   $00,$7C,$FF        ; ligne 0  B,G,R
        .byte   $00,$3C,$FF        ; ligne 1  B,G,R
        .byte   $00,$0E,$FF        ; ligne 2  B,G,R
        .byte   $00,$04,$FF        ; ligne 3  B,G,R
        .byte   $00,$40,$FF        ; ligne 4  B,G,R
        .byte   $00,$20,$FF        ; ligne 5  B,G,R
        .byte   $00,$E2,$FF        ; ligne 6  B,G,R
        .byte   $00,$F0,$FE        ; ligne 7  B,G,R
        .byte   $00,$F0,$FC        ; ligne 8  B,G,R
        .byte   $00,$40,$FD        ; ligne 9  B,G,R
; tuile 233 : imp241 [solide] [destructible]
        .byte   $00,$00,$00        ; ligne 0  B,G,R
        .byte   $00,$00,$00        ; ligne 1  B,G,R
        .byte   $00,$00,$E0        ; ligne 2  B,G,R
        .byte   $00,$00,$F8        ; ligne 3  B,G,R
        .byte   $00,$E0,$F8        ; ligne 4  B,G,R
        .byte   $00,$E0,$F8        ; ligne 5  B,G,R
        .byte   $00,$B0,$F8        ; ligne 6  B,G,R
        .byte   $00,$20,$F8        ; ligne 7  B,G,R
        .byte   $00,$60,$F8        ; ligne 8  B,G,R
        .byte   $00,$F0,$F8        ; ligne 9  B,G,R
; tuile 234 : imp242 [solide] [destructible]
        .byte   $00,$C3,$E7        ; ligne 0  B,G,R
        .byte   $00,$47,$E7        ; ligne 1  B,G,R
        .byte   $00,$47,$E7        ; ligne 2  B,G,R
        .byte   $40,$4F,$4F        ; ligne 3  B,G,R
        .byte   $00,$0F,$0F        ; ligne 4  B,G,R
        .byte   $00,$0F,$1F        ; ligne 5  B,G,R
        .byte   $00,$1F,$1F        ; ligne 6  B,G,R
        .byte   $00,$1F,$3F        ; ligne 7  B,G,R
        .byte   $00,$1F,$3F        ; ligne 8  B,G,R
        .byte   $00,$3F,$3F        ; ligne 9  B,G,R
; tuile 235 : imp243 [solide] [destructible]
        .byte   $00,$FF,$FF        ; ligne 0  B,G,R
        .byte   $00,$FF,$FF        ; ligne 1  B,G,R
        .byte   $00,$FF,$FF        ; ligne 2  B,G,R
        .byte   $00,$F1,$FF        ; ligne 3  B,G,R
        .byte   $00,$E0,$FF        ; ligne 4  B,G,R
        .byte   $00,$E0,$FF        ; ligne 5  B,G,R
        .byte   $00,$C0,$F0        ; ligne 6  B,G,R
        .byte   $00,$80,$E0        ; ligne 7  B,G,R
        .byte   $00,$80,$E0        ; ligne 8  B,G,R
        .byte   $0F,$00,$C0        ; ligne 9  B,G,R
; tuile 236 : imp244 [solide] [destructible]
        .byte   $00,$FE,$FF        ; ligne 0  B,G,R
        .byte   $00,$FF,$FF        ; ligne 1  B,G,R
        .byte   $00,$FF,$FF        ; ligne 2  B,G,R
        .byte   $00,$FF,$FF        ; ligne 3  B,G,R
        .byte   $00,$3F,$FF        ; ligne 4  B,G,R
        .byte   $00,$1F,$FF        ; ligne 5  B,G,R
        .byte   $00,$1F,$3F        ; ligne 6  B,G,R
        .byte   $00,$1F,$3F        ; ligne 7  B,G,R
        .byte   $00,$1F,$1F        ; ligne 8  B,G,R
        .byte   $E0,$0F,$1F        ; ligne 9  B,G,R
; tuile 237 : imp245 [solide] [destructible]
        .byte   $00,$08,$9C        ; ligne 0  B,G,R
        .byte   $00,$18,$98        ; ligne 1  B,G,R
        .byte   $00,$18,$98        ; ligne 2  B,G,R
        .byte   $08,$08,$C8        ; ligne 3  B,G,R
        .byte   $00,$80,$C0        ; ligne 4  B,G,R
        .byte   $00,$80,$C0        ; ligne 5  B,G,R
        .byte   $00,$80,$E0        ; ligne 6  B,G,R
        .byte   $00,$80,$F0        ; ligne 7  B,G,R
        .byte   $00,$C0,$F0        ; ligne 8  B,G,R
        .byte   $00,$E0,$F0        ; ligne 9  B,G,R
; tuile 238 : imp246 [solide] [destructible]
        .byte   $00,$0C,$1F        ; ligne 0  B,G,R
        .byte   $00,$00,$1F        ; ligne 1  B,G,R
        .byte   $00,$00,$0F        ; ligne 2  B,G,R
        .byte   $00,$00,$0D        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$00        ; ligne 5  B,G,R
        .byte   $00,$00,$00        ; ligne 6  B,G,R
        .byte   $00,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$00        ; ligne 8  B,G,R
        .byte   $00,$00,$00        ; ligne 9  B,G,R
; tuile 239 : imp247 [solide] [destructible]
        .byte   $00,$C0,$F9        ; ligne 0  B,G,R
        .byte   $00,$80,$F9        ; ligne 1  B,G,R
        .byte   $00,$00,$F1        ; ligne 2  B,G,R
        .byte   $00,$00,$C0        ; ligne 3  B,G,R
        .byte   $00,$00,$00        ; ligne 4  B,G,R
        .byte   $00,$00,$03        ; ligne 5  B,G,R
        .byte   $00,$01,$07        ; ligne 6  B,G,R
        .byte   $00,$03,$0F        ; ligne 7  B,G,R
        .byte   $00,$0F,$0F        ; ligne 8  B,G,R
        .byte   $00,$05,$0F        ; ligne 9  B,G,R
; tuile 240 : imp248 [solide] [destructible]
        .byte   $00,$E0,$F8        ; ligne 0  B,G,R
        .byte   $00,$00,$F8        ; ligne 1  B,G,R
        .byte   $00,$00,$F0        ; ligne 2  B,G,R
        .byte   $00,$20,$F8        ; ligne 3  B,G,R
        .byte   $00,$00,$70        ; ligne 4  B,G,R
        .byte   $00,$00,$80        ; ligne 5  B,G,R
        .byte   $00,$80,$C0        ; ligne 6  B,G,R
        .byte   $00,$80,$D0        ; ligne 7  B,G,R
        .byte   $00,$00,$F0        ; ligne 8  B,G,R
        .byte   $00,$40,$F0        ; ligne 9  B,G,R
; tuile 241 : imp252 [solide] [destructible]
        .byte   $00,$3F,$3F        ; ligne 0  B,G,R
        .byte   $00,$3F,$7F        ; ligne 1  B,G,R
        .byte   $00,$7F,$7F        ; ligne 2  B,G,R
        .byte   $00,$7E,$FF        ; ligne 3  B,G,R
        .byte   $00,$FE,$FF        ; ligne 4  B,G,R
        .byte   $00,$FC,$FF        ; ligne 5  B,G,R
        .byte   $00,$FC,$FE        ; ligne 6  B,G,R
        .byte   $00,$F8,$FE        ; ligne 7  B,G,R
        .byte   $00,$F8,$FC        ; ligne 8  B,G,R
        .byte   $00,$F8,$FC        ; ligne 9  B,G,R
; tuile 242 : imp253 [solide] [destructible]
        .byte   $1F,$00,$C0        ; ligne 0  B,G,R
        .byte   $1F,$00,$80        ; ligne 1  B,G,R
        .byte   $1F,$00,$80        ; ligne 2  B,G,R
        .byte   $1F,$00,$00        ; ligne 3  B,G,R
        .byte   $1F,$00,$00        ; ligne 4  B,G,R
        .byte   $1F,$00,$00        ; ligne 5  B,G,R
        .byte   $1F,$00,$00        ; ligne 6  B,G,R
        .byte   $1F,$00,$00        ; ligne 7  B,G,R
        .byte   $00,$00,$1E        ; ligne 8  B,G,R
        .byte   $00,$00,$1E        ; ligne 9  B,G,R
; tuile 243 : imp254 [solide] [destructible]
        .byte   $E0,$0F,$0F        ; ligne 0  B,G,R
        .byte   $E0,$0F,$0F        ; ligne 1  B,G,R
        .byte   $E0,$07,$0F        ; ligne 2  B,G,R
        .byte   $E0,$07,$07        ; ligne 3  B,G,R
        .byte   $E0,$07,$07        ; ligne 4  B,G,R
        .byte   $E0,$03,$07        ; ligne 5  B,G,R
        .byte   $E0,$03,$03        ; ligne 6  B,G,R
        .byte   $E0,$01,$01        ; ligne 7  B,G,R
        .byte   $00,$01,$01        ; ligne 8  B,G,R
        .byte   $00,$00,$01        ; ligne 9  B,G,R
; tuile 244 : imp255 [solide] [destructible]
        .byte   $00,$E0,$F0        ; ligne 0  B,G,R
        .byte   $00,$E0,$F8        ; ligne 1  B,G,R
        .byte   $00,$E0,$F8        ; ligne 2  B,G,R
        .byte   $00,$F0,$FC        ; ligne 3  B,G,R
        .byte   $00,$F0,$FC        ; ligne 4  B,G,R
        .byte   $00,$F8,$FC        ; ligne 5  B,G,R
        .byte   $00,$F8,$FE        ; ligne 6  B,G,R
        .byte   $00,$FC,$FE        ; ligne 7  B,G,R
        .byte   $00,$FC,$FF        ; ligne 8  B,G,R
        .byte   $00,$FC,$FF        ; ligne 9  B,G,R

; --- cartes, un octet par case (index de tuile dans le theme du niveau) ----
; 40 octets par rangee, 20 rangees par ecran.
lv_l0_map0:   ; niveau 1, ecran 1
        .byte   $09,$09,$27,$28,$20,$29,$20,$09,$09,$09,$09,$09,$1E,$2A,$2B,$2C,$2D,$2E,$2F,$30   ; rangee 0
        .byte   $31,$1A,$1B,$0A,$21,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$1F,$1C,$1D,$3C,$3D
        .byte   $09,$09,$3E,$3F,$40,$41,$42,$09,$09,$09,$09,$09,$09,$1E,$43,$44,$45,$46,$47,$48   ; rangee 1
        .byte   $49,$1A,$1B,$0A,$4A,$4B,$4C,$4D,$4E,$4F,$22,$50,$51,$52,$53,$1F,$1C,$1D,$54,$55
        .byte   $09,$09,$56,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$57,$58,$59,$5A   ; rangee 2
        .byte   $5B,$1A,$1B,$0A,$21,$5C,$5D,$5E,$5F,$60,$22,$23,$61,$62,$63,$1F,$1C,$1D,$64,$65
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$1E,$66,$67   ; rangee 3
        .byte   $68,$1A,$1B,$0A,$69,$6A,$6B,$6C,$6D,$6E,$6F,$23,$70,$71,$72,$73,$1C,$1D,$74,$75
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$76   ; rangee 4
        .byte   $77,$1A,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89
        .byte   $09,$8A,$8B,$8C,$8D,$8E,$8F,$90,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09   ; rangee 5
        .byte   $91,$92,$93,$94,$09,$09,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9F,$A0,$A1,$A2
        .byte   $09,$A3,$A4,$A5,$A6,$A7,$A8,$A9,$AA,$13,$24,$25,$AB,$09,$09,$09,$09,$09,$09,$09   ; rangee 6
        .byte   $09,$09,$09,$09,$09,$09,$09,$AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$09
        .byte   $09,$09,$0B,$0C,$0D,$0E,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,$09,$09,$00,$09,$09,$09   ; rangee 7
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$C0,$C1,$C2,$C3,$09,$09,$09,$09
        .byte   $09,$09,$0B,$0C,$0D,$0E,$0F,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$00,$CD,$CE,$CF   ; rangee 8
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
        .byte   $09,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7   ; rangee 9
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
        .byte   $09,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$09,$09   ; rangee 10
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
        .byte   $D8,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$09   ; rangee 11
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$D9,$DA
        .byte   $DB,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$09   ; rangee 12
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$DC,$DD
        .byte   $DE,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$09   ; rangee 13
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$DF,$E0
        .byte   $09,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$00   ; rangee 14
        .byte   $00,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$E1,$E2
        .byte   $09,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$00   ; rangee 15
        .byte   $00,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$E3,$E4,$E5,$E6,$09,$E7,$E8
        .byte   $E9,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$09   ; rangee 16
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$EA,$EB,$EC,$ED,$09,$EE,$EF
        .byte   $F0,$09,$0B,$0C,$0D,$0E,$0F,$09,$10,$11,$12,$0A,$14,$09,$15,$16,$17,$18,$19,$09   ; rangee 17
        .byte   $09,$09,$09,$09,$09,$00,$09,$09,$09,$09,$09,$00,$00,$F1,$F2,$F3,$F4,$09,$09,$00
        .byte   $01,$00,$00,$02,$03,$00,$00,$13,$00,$00,$00,$0A,$14,$13,$15,$16,$17,$18,$19,$13   ; rangee 18
        .byte   $09,$13,$24,$13,$25,$AB,$13,$13,$24,$25,$AB,$00,$00,$00,$08,$E9,$D6,$D8,$13,$10
        .byte   $26,$53,$5F,$30,$99,$83,$38,$7F,$3B,$1F,$1A,$2E,$30,$5B,$34,$1A,$26,$30,$3A,$61   ; rangee 19
        .byte   $5B,$6E,$7F,$38,$16,$26,$60,$D2,$7F,$84,$26,$73,$D2,$D4,$16,$26,$83,$2B,$7F,$6D

; --- adresses : tuiles et proprietes de chaque theme -----------------------
lv_thm_tiles_lo:
        .byte   lv_t0_tiles&$FF
lv_thm_tiles_hi:
        .byte   lv_t0_tiles>>8
lv_thm_flags_lo:
        .byte   lv_t0_flags&$FF
lv_thm_flags_hi:
        .byte   lv_t0_flags>>8
; --- cartes : 3 entrees par niveau (index niveau*3 + ecran) ; un ecran
; inutilise pointe sur le premier, jamais consulte par le jeu.
lv_map_hi:
        .byte   lv_l0_map0>>8,lv_l0_map0>>8,lv_l0_map0>>8   ; niveau 1
lv_map_lo:
        .byte   lv_l0_map0&$FF,lv_l0_map0&$FF,lv_l0_map0&$FF   ; niveau 1
