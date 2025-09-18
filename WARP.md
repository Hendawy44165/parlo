# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Parlo is a Flutter-based API Key Manager application with authentication and settings functionality. The project uses Riverpod for state management, GetIt for dependency injection, and targets Android and iOS platforms exclusively.

## Development Commands

### Build & Run
```bash
# Get dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Clean build artifacts
flutter clean
```

### Code Quality
```bash
# Analyze code for linting issues
flutter analyze

# Format code according to Dart standards
flutter format .

# Check for unused dependencies
flutter pub deps
```

### Testing
```bash
# Run all tests (when test files are created)
flutter test

# Run tests with coverage
flutter test --coverage

# Run a single test file
flutter test test/path/to/test_file.dart
```

## Architecture & Code Structure

### Core Architecture Pattern
- **Clean Architecture**: Features are organized into `logic/` (services, entities) and `presentation/` (screens, providers, widgets) layers
- **State Management**: Uses Riverpod with `StateNotifier` pattern for managing UI state
- **Dependency Injection**: GetIt service locator pattern in `core/dependency_injection.dart`
- **Routing**: Custom routing system in `core/routing/` with route definitions and navigation handling

### Feature Structure
Each feature follows this structure:
```
features/feature_name/
├── logic/
│   ├── entities/       # Data models
│   └── services/       # Business logic and API calls
└── presentation/
    ├── providers/      # Riverpod state providers
    ├── screens/        # Full screen widgets
    └── widgets/        # Reusable UI components
```

### Authentication Flow
- App uses `StreamBuilder` in `app.dart` to listen to authentication state
- Routes automatically to `/settings` if authenticated, `/login` if not
- Authentication service provides `uidStream` for reactive auth state management

### Theming System
- Centralized color palette in `core/themes/color.dart`
- Text styles defined in `core/themes/text.dart`
- Uses Ubuntu font family throughout the app
- Dark theme with primary color `#636AE8`

## Database & Backend

- **Database**: Supabase (PostgreSQL-based)
- **Authentication**: Custom email/password + Google OAuth integration
- **State Persistence**: Handled through Riverpod providers

## Development Guidelines

### Code Style
- Follow existing patterns for provider creation using factory functions (e.g., `getLoginProvider()`)
- Use `AsyncValue` for async state management in providers
- Maintain consistent error handling with `AsyncError` states
- Keep UI components modular and reusable

### Platform-Specific Considerations
- Target platforms: Android and iOS only
- Uses `flutter_native_splash` for splash screen configuration
- Custom system UI overlay styling for Android status bar

### Validation
- Email validation: Uses regex pattern for standard email format
- Password validation: Requires 8+ characters with uppercase, lowercase, and numbers
- Username validation: 3-20 characters length requirement

### Asset Management
- SVG icons stored in `assets/icons/`
- Custom fonts in `assets/fonts/` (Ubuntu family)
- Logo assets in `assets/logos/`

## Key Dependencies

- `flutter_riverpod`: State management
- `get_it`: Dependency injection
- `flutter_svg`: SVG asset support
- `flutter_native_splash`: Splash screen configuration
- `flutter_easylogger`: Logging utility
- `mocktail`: Testing mocks (for future test implementation)

## Important Notes

- Authentication services are currently stub implementations
- Settings screen includes voice character selection and stability configuration
- The app is designed for voice chat functionality (evident from route names like `voiceRooms`)
- No test files currently exist, but test dependencies are configured
- Development should follow strict adherence to provided UI designs and avoid modifications without explicit instruction