# Bruno Barreto — Software Developer Portfolio

A production-ready, highly optimized Single Page Application (SPA) built with Flutter and Dart 3. This repository serves not only as my personal portfolio but as a live demonstration of scalable frontend architecture, accessibility compliance, and advanced UI engineering.

## 🏗 Architecture & Engineering

This project is built with scalability and modularity in mind, separating the core business logic from the visual identity.

### 1. Decoupled Design System (`design_kit`)
The UI is strictly governed by a standalone, brand-agnostic design system package called `design_kit` (included as a submodule/dependency).
*   **Inversion of Control**: The application injects the active brand theme (e.g., Portfolio, Acme, Biome) into the design kit. The components themselves have no knowledge of the host application.
*   **European Accessibility Act (EAA) & WCAG 2.1 AA**: All components enforce strict accessibility standards. Hit targets are guaranteed to be at least 44x44 logical pixels, and full `Semantics` support is implemented for screen readers.
*   **Responsive & Fluid**: The layout engine dynamically scales typography and component dimensions across Mobile, Tablet, and Desktop breakpoints.

### 2. State & Navigation
*   **Riverpod**: Manages global application state (such as active brand and brightness mode) with zero unnecessary rebuilds. UI-specific ephemeral state is intentionally kept within `setState` to prevent polluting the global scope.
*   **GoRouter**: Handles complex SPA navigation, enabling direct deep-linking to specific sections while maintaining the persistent `AppShell` (the navigation bar).

### 3. Performance & Rendering
*   **60 FPS Animations**: Utilizes `RepaintBoundary` to isolate high-frequency repaints (e.g., the interactive dot-grid and parallax scroll effects) from static layouts.
*   **Optimized Assets**: Heavy use of `ResizeImage` and cached network resources to minimize memory footprint and avoid layout shifts.

### 4. Code Quality & Security
*   **Strict Linting**: The entire codebase strictly adheres to the `very_good_analysis` ruleset. Zero warnings, zero "hacks".
*   **Modern Dart 3**: Leverages the latest language features, including Switch Expressions and exhaustive pattern matching.
*   **Secure Environment**: Integrates `flutter_dotenv` to securely manage API keys (e.g., the Formspree endpoint) without exposing secrets to the version control system.

## ⚙️ Getting Started

### Prerequisites
*   Flutter SDK `^3.24.0` (or latest stable)
*   Dart SDK `^3.5.0`

### Local Development

1.  **Clone the repository** (Ensure the `design_kit` dependency path is accessible, or fetch it via git if configured):
    ```bash
    git clone https://github.com/bbarretoweb/portfolio_app.git
    cd portfolio_app
    ```
2.  **Environment Variables**:
    Create a `.env` file in the root directory and provide your Formspree ID to enable the contact form:
    ```env
    FORMSPREE_ENDPOINT=your_endpoint_id
    ```
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the application**:
    ```bash
    flutter run -d chrome
    ```

## 🚀 CI/CD Pipeline

The project includes a fully automated GitHub Actions workflow (`deploy.yml`). 
Upon pushing to the `main` branch, the pipeline:
1. Provisions an Ubuntu runner with the latest Node.js/Flutter environments.
2. Injects production secrets into the `.env` asset.
3. Compiles the optimized Web release (`flutter build web --release`).
4. Deploys the static bundle directly to GitHub Pages.

---
*Designed and engineered by [Bruno Barreto](https://github.com/bbarretoweb).*
