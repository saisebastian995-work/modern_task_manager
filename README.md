# Modern Task Manager

A clean and modern task management application built with Flutter. It features a sleek glassmorphic UI, support for both light and dark themes, and local data persistence.

## Features

- **Task Management**: Easily add, complete, and manage your daily tasks.
- **Modern UI**: High-quality design using Material 3, glassmorphism effects, and smooth transitions.
- **Theming**: Support for Light and Dark modes with persistent settings.
- **Local Persistence**: Uses [Hive](https://pub.dev/packages/hive) for fast, offline-first data storage.
- **Progress Tracking**: Real-time progress bar to track your task completion.

## Getting Started

### Prerequisites

- Flutter SDK: `^3.9.2`
- Dart SDK: `^3.0.0`

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/saisebastian995-work/modern_task_manager.git
   cd modern_task_manager
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters:**
   The project uses code generation for Hive models. Run the following command to generate the necessary adapters:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/models/`: Contains the `Task` data model and generated Hive adapters.
- `lib/services/`: Handles local storage via `TaskStore` and application settings like theme preference.
- `lib/ui/`: Main screens and UI logic.
- `lib/ui/widgets/`: Custom reusable widgets including glassmorphic cards and task tiles.

## Dependencies

- `hive` & `hive_flutter`: Local NoSQL database.
- `intl`: For date formatting.
- `build_runner` & `hive_generator`: Development tools for code generation.
