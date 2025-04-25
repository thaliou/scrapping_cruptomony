# scrapping_cruptomony

## Description

Ce projet est un ensemble de scripts Ruby permettant de scrapper des données depuis des sites web spécifiques. Il inclut deux fonctionnalités principales :

1. **Scrapping des prix des cryptomonnaies** : Extraction des symboles et des prix des cryptomonnaies depuis le site [CoinMarketCap](https://coinmarketcap.com).
2. **Scrapping des informations des députés français** : Extraction des noms, prénoms et départements des députés depuis le site de l'Assemblée Nationale.

Ces scripts utilisent la gem `nokogiri` pour parser le HTML des pages web et extraire les données pertinentes.

## Fonctionnalités

### 1. Scrapping des cryptomonnaies
- Fichier : [`lib/crypto_scrap.rb`](lib/crypto_scrap.rb)
- Fonction principale : `crypto_scrap`
- Fonctionnalités :
  - Récupère les symboles et les prix des cryptomonnaies.
  - Limite les résultats à 20 lignes pour éviter de surcharger la sortie.
  - Gère les erreurs en cas de données manquantes ou invalides.

### 2. Scrapping des mairies
- Fichier : [`lib/mail_scrapping.rb`](lib/mail_scrapping.rb)
- Fonction principale : `deputy_scrap`
- Fonctionnalités :
  - Récupère les noms, prénoms et départements des députés français.
  - Limite les résultats à 20 lignes.
  - Gère les erreurs en cas de données manquantes ou invalides.

### 3. Scrapping des députés
- Fichier : [`lib/deputy_scrap.rb`](lib/deputy_scrap.rb)
- Fonction principale : `deputy_scrap`
- Fonctionnalités :
  - Récupère les noms, prénoms et départements des députés français.
  - Limite les résultats à 20 lignes.
  - Gère les erreurs en cas de données manquantes ou invalides.

## Prérequis

- Ruby version 3.3.8 (spécifiée dans le fichier [Gemfile](Gemfile)).
- Les gems suivantes doivent être installées :
  - `nokogiri`
  - `pry`
  - `open-uri`
  - `rspec` (pour les tests)
  - `webmock` (pour les tests)

- Installer les gems dans la Gemfile (A exécuter à la racine du dossier) :

``` ruby
bundle install
```
**NB**: Nécessite d'avoir `bundle` installé.

## Installation

1. Clonez ce dépôt :
   ```bash
   git clone <URL_DU_DEPOT>
   cd scrapping_cruptomony
   ```

## Structure du projet

```
.
├── lib/
│   ├──           # Script pour scrapper les cryptomonnaies
│   ├──           # Script pour scrapper les députés
├── spec/
│   ├──      # Tests pour cryptomonnaies 
│   ├──      # Tests pour députés
├── Gemfile                      # Dépendances du projet
├── README.md                   # Documentation du projet
└── .rubocop.yml               # Configuration RuboCop
```
# Auteurs
- [THIAM](https://github.com/thaliou)
- [ASSY](https://github.com/AssyaJalo)
- [SOUARE](https://github.com/bbkouty)
- [FANAR](https://github.com/fanarbandia)
- [MAIGA](https://github.com/Fadelion)

Ce travail est à but éducatif. Pour toute contribution, nous sommes disponible sur notre serveur [Discord](https://discord.com/channels/963075796216446976/996464065645916211).
