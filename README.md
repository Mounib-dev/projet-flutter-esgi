
## Documentation Technique – Application Flutter "TV Shows"

Présentation Générale L’application “TV Shows” est une application Flutter multiplateforme 
permettant aux utilisateurs de :

1- Consulter une liste de séries populaires
2- Rechercher des séries par nom
3- Visualiser les détails d’une série

Les données proviennent de l’API publique de episodate.com.

## Architecture Globale
L’application suit une architecture en couches modulaires, inspirée du modèle MVVM (Model-View-ViewModel), 
avec un découpage propre en :

- models : Définit les structures de données (ex : TVShow)
- services : Contient les appels réseau/API (ApiService)
- providers : Gère l’état de l’application avec Provider + ChangeNotifier(ShowProvider, ThemeProvider)
- views : Les interfaces utilisateur (HomeViews, DetailViews)
- widgets : Composants UI réutilisables (ShowCard)

## Détails des Composants

1- Model (lib/models/show.dart)
   Contient la classe TVShow qui reflète la structure JSON de l’API.
   Utilisée pour désérialiser les réponses API.

   Exemple d’attributs :id,name,image_thumbnail_path → image,description

2- Service API (lib/services/api_service.dart)

 - Classe ApiService, qui encapsule les appels réseau :
     fetchPopularShows(page) → séries populaires paginées
     searchShows(query, page) → recherche d’une série
     getShowDetails(id) → détail complet d’une série

 - Utilisation de la bibliothèque http pour les requêtes GET.

3- Provider (lib/providers/show_provider.dart)

 - Classe ShowProvider : gère l’état de l’application via ChangeNotifier.
   
  ## Responsabilités :
  - Conserver la liste des séries (shows)
  - Indiquer si une requête est en cours (isLoading)
  - Gérer la pagination (currentPage)
  - Suivre le mot-clé de recherche (searchQuery)
  - Fournir des méthodes publiques pour charger ou rechercher des séries.
  - Deux scroll infinis pour la pagination :
    loadMorePopularShows()
    loadMoreSearchResults()

- ThemeProvider
  Gère le thème de l’application :
  ThemeMode _themeMode = ThemeMode.dark;
  void toggleTheme(bool isOn) { ... }
  Expose :
  themeMode
  isDarkMode
  toggleTheme(bool)


4- UI – Views

 - HomeView :
   Affiche une barre de recherche
   Liste des séries (via ShowCard)
   Navigation vers les détails (DetailScreen)

 - DetailView :
   Charge et affiche les détails d’une série à partir de son ID
   Affiche image, titre et description

5-  Widgets
   ShowCard (lib/widgets/show_card.dart) : Widget utilisé dans les listes pour représenter une série avec image et titre.
   State Management (Provider)

   L’état est centralisé dans ShowProvider.
   Au démarrage, fetchPopularShows() est appelé automatiquement.
   Lors d’une recherche, searchShows(query) est déclenché.
   Les views écoutent les changements via Provider.of<ShowProvider>(context).

## Navigation

- Utilisation de Navigator.push pour la navigation entre HomeView et DetailView.
- La classe TVShow contient un identifiant utilisé pour récupérer les détails d’une série.

## API utilisée

L’application interagit avec l’API REST suivante :

- Base : https://www.episodate.com/api

- Endpoints :
    GET /most-popular?page= → liste paginée des séries
    GET /search?q= → recherche d’une série
    GET /show-details?q= → détails d’une série

- Les réponses sont au format JSON.

## Dépendances du projet
   pubspec.yaml :
       dependencies: flutter: 
           sdk: flutter http: ^0.13.6 provider: ^6.1.1

- Lancement du projet
- flutter pub get
- flutter run

L’app démarre sur HomeView et récupère les séries populaires dès le début.