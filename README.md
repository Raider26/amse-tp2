# amse-tp2
Application comportant plusieurs exercices dont le 7 qui est un jeu de taquin.
Réalisée dans le contexte de l'UV AMSE à IMT Nord Europe.
Développée par Guillaume FOISSY et Maxence FIRMIN

## Getting Started
Pour lancer l'application:

```bash
git clone http://www.github.com/Raider26/amse-tp2
cd amse-tp2/tp2
flutter pub get
flutter run
```

## Features
L'exercice 7 permet de jouer au taquin avec une grille allant de 2x2 à 7x7. 

Voici la liste des fonctionnalités supplémentaires:
- l'utilisateur peut revenir en arrière d'un coup (son nombre de coup est décrémenté)
- il est possible d'afficher/de masquer l'image modèle
- il est possible de choisir une image parmi 10 figurants dans les assets de l'application et une chargée au lancement de   l'application à partir de ce lien https://picsum.photos/300
- un bouton paramètre pour accèder à d'autres fonctionnalités:
    - choisir si le mélange est totalement aléatoire ou si l'utilisateur peut rentrer un nombre de mélanges qui correspondent à des coups valides du taquin
    - afficher le numéro des tuiles
    - activer un solveur qui détermine le minimum de coups requis pour résoudre le taquin (uniquement pour le 3x3)