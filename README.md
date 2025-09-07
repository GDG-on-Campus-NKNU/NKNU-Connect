# NKNU-Connect

> 📱 A modern, easy-to-use mobile app to streamline campus life for NKNU students.
>
> **By Students, For Students.**

NKNU-Connect is a modern, cross-platform mobile app built with Flutter, designed to enhance the campus experience for
NKNU students.
It offers a suite of practical tools to streamline academic and social life, empowering students to stay organized,
connected, and informed, making campus life more convenient and engaging.

[![State-of-the-art Shitcode](https://img.shields.io/static/v1?label=State-of-the-art&message=Shitcode&color=7B5804)](https://github.com/trekhleb/state-of-the-art-shitcode)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white)](#)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=fff)](#)
[![Android](https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white)](#)
[![iOS](https://img.shields.io/badge/iOS-000000?&logo=apple&logoColor=white)](#)

## Prerequisites

Before you begin, ensure the following tools are installed:

- Flutter SDK (version 3.29.3)
- Android Development:
    - Android Studio (version 2024.1.2.12)
    - Android SDK (version 35.0.0)
    - Java JDK (version 17.0.11)
- iOS Development:
    - TBD
- GNU Make (version 4.4.1)

> ⚠️ Higher version may work but have not been tested

Run `flutter doctor -v` in your terminal to verify your Flutter setup and ensure all dependencies are correctly
configured.

### Environment Setup

1. Install Flutter SDK (version 3.29.3):
    - Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) to download and
      install Flutter SDK 3.29.3.
    - Add the `flutter` command to your system PATH as described in the guide.
    - Run `flutter doctor -v` to verify the installation and check for additional dependencies.

2. Set up Android Development:
    - Android Studio:
        - Download and install Android Studio 2024.1.2.12
          from [Android Studio website](https://developer.android.com/studio).
        - Configure the Android SDK and Android Emulator during the installation process.
    - Android SDK:
        - Open Android Studio, go to File > Settings > Appearance & Behavior > System Settings > Android SDK, and
          install Android SDK Platform 35.0.0.
        - Ensure the Android Emulator and necessary build tools are installed.
    - Java JDK:
        - Android Studio includes a built-in JDK (expected version 17.0.11). Verify the JDK version by running
          `flutter doctor -v`.

3. Set up iOS Development:
    - TBD.

4. Install GNU Make:
    - Install GNU Make for build automation scripts. Download and install GNU Make 4.4.1
      from [GNU Make website](https://www.gnu.org/software/make/).
    - Verify the installation by running `make --version`.

5. Verify Your Setup:
    - Run `flutter doctor -v` in your terminal to ensure all dependencies are correctly configured.
    - Address any issues reported by `flutter doctor`.

## Project Structure

```
NKNU-Connect/
├── lib/                    # Main Dart source code
│   ├── main.dart           # Application entry point
│   ├── screens/            # UI screens (e.g., course scheduling, campus news)
│   ├── widgets/            # Reusable UI components
│   ├── services/           # Business logic and API integrations
│   ├── ffi/                # Dart bindings and interfaces for core logic compiled from NKNU-Core.
│   └── models/             # Data models
├── android/                # Android-specific configuration
│   └── app/
│       └── build.gradle.kts  # Android build configuration
├── ios/                    # iOS-specific configuration
│   └── Runner.xcodeproj    # Xcode project for iOS builds
├── test/                   # Unit and widget tests
├── analysis_options.yaml   # Dart code analysis rules
├── Makefile                # Build automation scripts
├── pubspec.yaml            # Flutter configuration (dependencies, assets)
├── .gitignore              # Files and directories to exclude from version control
└── README.md           # Project documentation
```

## Building the Project

Follow these steps to run NKNU-Connect on a simulator/emulator or build a release:

1. Install Dependencies
    - Run the following command to fetch Flutter dependencies:
        ```shell
        flutter pub get
        ``` 
    - Download compiled [NKNU-Core libraries](https://github.com/GDG-on-Campus-NKNU/NKNU-Core):
        ```shell
        make download-all-libs
        ```
2. Run the app:
    - List available devices (emulators or connected devices):
      ```shell
      flutter devices
      ```
    - Run the app on a specific device, replacing `<device_id>` with the target device ID:
        ```shell
        flutter run -d <device_id>
        ```
3. Build Releases:
    - Build a release using Makefile:
        ```shell
        make build
        ```
    - The output APK is located at `build/app/outputs/flutter-apk/app-release.apk`.
    - For iOS: Build requirements are TBD.

## Development Guidelines

TBD

## Testing

TBD