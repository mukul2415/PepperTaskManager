# Pepper Cloud Task Manager

A clean and intuitive task management application built with Flutter, designed to showcase modern app development practices including Clean Architecture, BLoC for state management, and robust local persistence with a mock remote data source.

## 🎥 Demo Video

[![Task Manager Demo](https://drive.google.com/file/d/17n-PP84reuWLRyvyJsLHyxKchkz9MZPE/view?usp=sharing)](https://drive.google.com/file/d/1jDavzMOFAJzjWhiLDsOynvn-RaJRPW0F/view?usp=sharing)

*Click the thumbnail above to watch the full demo video.*



## 📲 Download & Install APK

You can download the compiled Android APK file directly from the link below to install and test the app on a physical device.

<a href="https://drive.google.com/file/d/1sJPVIUwuFUqzD6nWEv934e65NpOgNDCi/view?usp=sharing">
   <img src="https://storage.googleapis.com/flutter-fellows-prod.appspot.com/custom_images/google-play-badge.png" alt="Download APK" width="200">
</a>

**Important Note:** To install the APK, you may need to enable "Install from unknown sources" in your Android device's security settings.

## ✨ Features

- **Full CRUD Functionality**: Create, Read, Update, and Delete tasks seamlessly.
- **Task Status Management**: Mark tasks as completed or pending with a simple tap.
- **Local Persistence**: All tasks are saved locally using **Hive**, ensuring your data is available even after closing the app.
- **Mock API Integration**: The app is architected to work with both local and remote data sources, simulating a real-world client-server environment.
- **Advanced Filtering**: Filter the task list to view "All," "Completed," or "Pending" tasks.
- **Dynamic Sorting**: Sort tasks by Due Date (Ascending/Descending) or Title (A-Z/Z-A).
- **Intuitive UI/UX**: A clean, responsive interface built following Material Design principles.
- **Form Validation**: Ensures that all required fields are filled correctly before a task can be created or updated.

## 🏛️ Architecture

This project is built using **Clean Architecture** with a **Feature-First** approach. This ensures a clear separation of concerns, making the codebase scalable, maintainable, and highly testable.

The architecture is divided into three main layers:

-   **Presentation Layer**:
    -   Contains the UI (Pages and Widgets).
    -   Uses **Flutter BLoC** for state management to handle UI logic and events.
    -   Navigation is managed by **GoRouter** for a declarative and robust routing solution.

-   **Domain Layer**:
    -   The core of the application, containing the business logic.
    -   Includes **Entities** (business objects), **Repositories** (abstract contracts), and **Use Cases** (specific business rules).
    -   This layer is completely independent of the UI and data sources.

-   **Data Layer**:
    -   Responsible for data retrieval and storage.
    -   Includes **Repositories Implementation** that orchestrates data from different sources.
    -   **Data Sources**:
        -   `TaskLocalDataSource`: Manages data persistence using the **Hive** database.
        -   `TaskRemoteDataSource`: A mock implementation simulating a REST API, showcasing how the app would interact with a server.
    -   **Models**: Data Transfer Objects (DTOs) used to parse and handle data from sources.

Dependency Injection is managed by `get_it` to decouple the layers and manage dependencies efficiently.

## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

-   Flutter SDK (version 3.0.0 or higher)
-   An IDE like Android Studio or VS Code with the Flutter plugin.
-   An Android Emulator or a physical Android device.

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/mukul2415/PepperTaskManager.git
    cd PepperTaskManager
    ```

2.  **Get Flutter dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the build_runner to generate necessary files (for Hive):**
    ```sh
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```sh
    flutter run
    ```

## 🛠️ Building the APK

To build a release version of the Android application (`.apk`), run the following command in your terminal:

```sh
    flutter build apk --release
```

The generated APK file will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## 📦 Key Packages Used

-   **State Management**: `flutter_bloc`, `bloc`
-   **Local Persistence**: `hive`, `hive_flutter`
-   **Routing**: `go_router`
-   **Dependency Injection**: `get_it`
-   **Functional Programming**: `dartz` (for `Either` type)
-   **Value Equality**: `equatable`
-   **Date Formatting**: `intl`
-   **Unique ID Generation**: `uuid`

## 📝 Additional Notes

-   The mock remote data source (`TaskRemoteDataSourceImpl`) is designed to simulate a real-world API. It has a built-in delay and uses a static in-memory list that resets on each app launch.
-   The repository layer (`TaskRepositoryImpl`) contains logic to gracefully handle state inconsistencies between the local cache and the remote source. For instance, it allows deleting a locally-created task even after an app restart, when the task no longer "exists" on the mock remote.

---

*This project was developed as part of an assignment for Pepper Cloud.*