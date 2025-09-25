# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Parlo is a Flutter mobile app targeting Android and iOS platforms. It's built using:
- **Flutter SDK**: 3.35.2+
- **State Management**: Riverpod 
- **Database**: Supabase
- **Dependency Injection**: get_it
- **Navigation**: Custom routing with MaterialApp
- **UI Assets**: Custom Ubuntu font family, SVG icons

## Architecture

The codebase follows a feature-based Clean Architecture approach:

### Directory Structure
```
lib/
├── app.dart                    # Main app widget with auth stream
├── main.dart                   # Entry point with DI setup
├── core/                       # Shared utilities and configurations
│   ├── dependency_injection.dart
│   ├── routing/                # App navigation
│   ├── themes/                 # Colors and text styles
│   └── models/                 # Shared data models
└── features/                   # Feature modules
    ├── auth/                   # Authentication feature
    │   ├── presentation/       # UI (screens, providers, widgets)
    │   ├── logic/             # Business logic (services, entities)
    │   └── data/              # Data layer (repositories, models, datasources)
    └── settings/              # Settings feature
        ├── presentation/
        ├── logic/
        └── data/
```

### Key Architectural Patterns
- **Feature-based modules**: Each feature contains presentation, logic, and data layers
- **Riverpod providers**: State management using flutter_riverpod
- **Service layer**: Business logic isolated in service classes
- **Stream-based auth**: Authentication state managed via streams in `app.dart`
- **Dependency injection**: Services registered with get_it in `main.dart`

## Common Development Commands

### Running the App
```bash
# Run on connected device/emulator (debug mode)
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

### Building
```bash
# Build APK for Android
flutter build apk

# Build App Bundle for Android
flutter build appbundle

# Build for iOS (requires macOS)
flutter build ios

# Build for Linux desktop
flutter build linux
```

### Development Tools
```bash
# Code analysis and linting
flutter analyze

# Format code
flutter format .

# Install dependencies
flutter pub get

# Clean build cache
flutter clean

# Generate native splash screen
flutter pub run flutter_native_splash:create
```

### Testing
```bash
# Run all tests (note: no test directory exists yet)
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/path/to/test_file.dart
```

## Development Guidelines

### Code Organization
- Follow the existing feature-based structure with presentation/logic/data layers
- Place providers in `presentation/providers/`
- Put business logic in `logic/services/`
- Create entities in `logic/entities/`
- Use the existing `core/` folder for shared utilities

### State Management
- Use Riverpod providers for state management
- Providers should be placed in the `presentation/providers/` directory of each feature
- Services should be registered in `core/dependency_injection.dart`

### UI Development
- The project uses Ubuntu font family (defined in pubspec.yaml)
- Custom color scheme and text styles are in `core/themes/`
- SVG icons are stored in `assets/icons/`
- Native splash screen configuration is in pubspec.yaml

### Platform Considerations
- Target platforms are Android and iOS only
- No web or desktop deployment planned
- Platform-specific code should be organized accordingly

### Database Integration  
- Supabase is used as the backend database
- Authentication is handled through Supabase Auth
- Auth state is managed via streams in the main app widget

## Key Files to Reference

### Core Architecture
- `lib/main.dart` - App initialization and dependency injection setup
- `lib/app.dart` - Main app widget with authentication stream
- `lib/core/dependency_injection.dart` - Service registration
- `lib/core/routing/app_router.dart` - Navigation configuration

### Feature Examples
- `lib/features/auth/` - Reference for feature structure and patterns
- `lib/features/auth/logic/services/auth_service.dart` - Service pattern example
- `lib/features/auth/presentation/providers/` - Riverpod provider examples

### Styling
- `lib/core/themes/color.dart` - Color definitions
- `lib/core/themes/text.dart` - Text style definitions

## Configuration Files

### Development Environment
- `analysis_options.yaml` - Dart analyzer configuration with custom rules
- `pubspec.yaml` - Dependencies and asset declarations
- `.windsurf/rules/parlo-ai-rules.md` - AI assistant development rules
- `.windsurf/templates/` - Code generation templates

### Assets
- Custom Ubuntu font family with regular, bold, and italic variants
- SVG icons for UI components (mail, lock, settings, user, google)
- Native splash screen with custom parrot logo and dark theme

## Environment Setup Requirements

- Flutter SDK 3.7.0+
- Android development environment
- For iOS development: Xcode (macOS required)
- Supabase project configuration (credentials not in repository)