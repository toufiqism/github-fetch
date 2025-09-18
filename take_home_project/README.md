# GitHub Repository Explorer (Flutter)

A clean-architecture Flutter app that lists public GitHub repositories matching a search term (default: `flutter`) sorted by stars (desc). It supports pagination, offline caching, dark mode toggle, and a detail screen.

## Features
- Search GitHub repos with pagination (20 per page)
- Infinite scroll + pull-to-refresh
- Offline caching via `SharedPreferences` with online/offline fallback
- Debounced search input
- Error handling with retry SnackBar
- Dark/Light mode toggle with persistence
- Clean Architecture with SOLID principles and repository pattern

## Architecture
- `domain/` entities, repository contract, use cases
- `data/` models (DTOs), remote and local data sources, repository implementation
- `presentation/` UI (pages, widgets) and BLoC/Cubit state management
- `core/` shared code (errors, network info, result)
- `di/` dependency injection using `get_it`

## Dependencies
Key packages: `dio`, `flutter_bloc`, `get_it`, `shared_preferences`, `connectivity_plus`, `rxdart`, `equatable`, `cached_network_image`, `shimmer`, `url_launcher`, `json_serializable`, `build_runner`.

All dependencies are compatible with Android and iOS.

## Setup
1. Flutter 3.24+ required.
2. Install packages:
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```
3. Run app:
```bash
flutter run
```

## Usage
- Type in the search bar to filter (debounced).
- Scroll to load more. Pull down to refresh.
- Tap a card to view details and open in browser.
- Toggle Dark mode from the AppBar switch.

## Assumptions & Notes
- Caching strategy: page-level caching keyed by query+page+pageSize.
- If online fetch fails, app falls back to cached data when available.
- For iOS, ensure URL schemes are permitted (handled by `url_launcher` default setup). If any issues, add LSApplicationQueriesSchemes as needed.

## Screens
- Home list with skeleton loaders and states
- Detail page with avatar, stars, forks and link

## Tests (optional)
- Add unit tests under `test/` for `SearchRepositories` and `GithubRepositoryImpl`.
