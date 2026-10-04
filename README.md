# Lemmings pour Exelvision EXL100 / EXELTEL

Clone de *Lemmings* écrit en assembleur **TMS7020** pour les ordinateurs
Exelvision EXL100 et EXELTEL. Le jeu tourne en mode mixte texte + bitmap
320×200 du VDP TMS3556, et s'accompagne de deux éditeurs web :
**EXELTILE** pour les niveaux, **EXELLEM** pour les sprites.

![game screen](https://raw.githubusercontent.com/dada59-59/EXELemmings/refs/heads/main/EXLemmings.png)

## Fonctionnalités

- 8 pouvoirs : constructeur, creuseur, frappeur, bloqueur, parachutiste,
  kamikaze, grimpeur, mineur. Le parachute et le grimpeur sont permanents
  (variantes de sprite « parachute », « grimpeur », « athlète »).
- Plusieurs niveaux de 1 à 3 écrans, chacun rattaché à un thème (jeu de
  tuiles). Enchaînement : niveau suivant si gagné, rejoué si perdu.
- Lemmings à sortir et à sauver, nombre de chaque pouvoir définis par niveau.
- Décor destructible, collisions au pixel.
- Panneau d'icônes en bas de l'écran, police maison.
- Clavier, et souris ExelMouse en option.

## Commandes

| Touche | Action |
|---|---|
| Flèches | déplacer le viseur |
| C D H B F E G M | choisir le pouvoir et l'attribuer au lemming visé |
| TAB | pouvoir suivant |
| Espace | attribuer le pouvoir sélectionné (fin de niveau : continuer) |
| R | écran suivant |
| S | activer ou couper la souris (bouton 1 : attribuer, bouton 2 : pouvoir suivant) |

## Fichiers

| Fichier | Rôle |
|---|---|
| `mixpix.asm` | le jeu |
| `leveldata.asm` | niveaux et tuiles, **généré par EXELTILE** |
| `lemdata.asm` | sprites des lemmings, **généré par EXELLEM** |
| `exeltile.html` | éditeur de tuiles et de niveaux (import d'image, thèmes, copier-coller, annulation) |
| `exellem.html` | éditeur de sprites et d'animations, avec masque de transparence |

Les deux éditeurs s'ouvrent directement dans un navigateur, sans
installation. Leurs projets s'enregistrent en `.json`.

## Compilation

Assembleur **TASM** avec la table `tasmEXL.TAB` (cible TMS7000/7020).
Le programme est placé en `$1000`, au format cartouche.

Fichiers inclus par `mixpix.asm` : `7020.equ`, `3556.equ`, `mixt_api.asm`,
`leveldata.asm`, `lemdata.asm`.

Testé sur l'émulateur **DCEXEL** et sur un EXELTEL réel.

## Créer un niveau

1. Dans **EXELLEM**, dessiner ou ajuster les sprites, tournés vers la
   droite (le jeu fait le miroir), puis exporter `lemdata.asm`.
2. Dans **EXELTILE**, dessiner ou importer le décor, placer le point de
   départ, régler les lemmings et les pouvoirs, puis exporter
   `leveldata.asm`.
3. Assembler `mixpix.asm`.

La cartouche fait 28 Ko utiles (`$1000`–`$7FFF`). Une tuile coûte 31
octets et un écran de carte 800 octets.
