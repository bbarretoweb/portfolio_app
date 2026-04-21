# Portfolio App - Flutter Design System Practice

A Flutter application built as a practice project for working with **Flutter Design Systems** and **Material 3**.

## Features

- 🎨 **Material 3 Design**: Fully implemented with Material 3 components and theming.
- 🏗️ **Design System**: Built on top of the `design_kit` package for consistent UI components.
- 📱 **Responsive Layout**: Designed to work seamlessly on both mobile and desktop platforms.
- 🌑 **Dark Theme**: Automatic theme switching support and consistent dark mode implementation.
- 🎨 **Theme Preview**: Includes a dedicated `ThemeShowSection` to demonstrate all available Material 3 colors.

## Getting Started

### Prerequisites

- Flutter SDK (version compatible with `design_kit` dependencies)
- Dart SDK

### Installation

1. Clone the repository (or copy the project files).
2. Open the project in your Flutter-compatible IDE (e.g., VS Code, Android Studio).
3. Run `flutter pub get` in the terminal to fetch all dependencies.
4. Run `flutter run` to launch the application.

## Code Structure

- `lib/app.dart`: Main application entry point and theme configuration.
- `lib/features/`: Contains the different sections of the portfolio.
  - `home/`: Home screen widgets and section implementations.
  - `home/sections/`: Reusable UI sections like `HeroSection`, `AboutSection`, `ContactSection`, etc.
- `lib/features/home/sections/theme_show_section.dart`: A comprehensive section to preview all Material 3 colors and typography.
- `lib/features/home/widgets/`: Shared widgets used across the home screen.
- `design_kit/`: (Submodule/Local package) The custom design system library used by the application.

## Technologies Used

- **Flutter**: UI framework.
- **Material 3**: Design system implementation.
- **Riverpod**: State management (used in `ThemeShowSection` via `ChangeNotifierProvider`).
- **design_kit**: Custom Flutter widget library.

## Contributing

This project is primarily used for practicing Flutter and design system development. Feel free to fork, experiment, and modify the code to learn more about Flutter widgets, theming, and responsive UI design.
