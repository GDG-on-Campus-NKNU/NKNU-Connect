# NKNU-Connect

> 📱 A modern, easy-to-use mobile app to streamline campus life for NKNU students.
>
> **By Students, For Students.**

NKNU-Connect is a modern, cross-platform mobile app built with Flutter, designed to enhance the campus experience for NKNU students. 
It offers a suite of practical tools to streamline academic and social life, empowering students to stay organized, connected, and informed, 
making campus life more convenient and engaging.

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

1. Go:
    - Verify installation: `go version`
2. Android NDK:
    - Set the `ANDROID_NDK_HOME` environment variable:
      ```bash
      export ANDROID_NDK_HOME=/path/to/android-ndk
      ```
3. GNU Make:
    - Verify installation: `make --version`

## Project Structure

```
NKNU-Connect/
├── sso/                # NKNU Single Sign-On (SSO) related functionality
├── utils/              # Utility functions and helper tools
├── Makefile            # Build automation script for compiling the library
└── README.md           # Project documentation
```

## Building the Project

The project uses a Makefile to automate the compilation process, generating a shared object (`.so`) file for integration
with Android or other platforms.

To compile the library:

```bash
make compile
```

This command builds the core functionality into a `.so` file, ready for use in dependent projects
like [NKNU-Connect](https://github.com/GDG-on-Campus-NKNU/NKNU-Connect).

## Usage

The compiled `.so` file can be integrated into Android projects or other platforms that support native libraries. Refer
to the documentation of the consuming project (e.g., [NKNU-Connect](https://github.com/GDG-on-Campus-NKNU/NKNU-Connect))
for specific integration instructions.

## Development Guidelines

To maintain modularity and reusability, each independent feature should be implemented in a separate Go package. For
example, if developing a traffic information query feature, create a dedicated `traffic` package. All functions intended
for export to other projects must be placed in a file named `api.go` within the respective package. Additionally, in the
`main` package's `main.go`, use side effect imports (e.g., `import _ "path/to/package"`) to ensure that the package is
included during compilation.

## Testing

To run tests, set the following environment variables for SSO authentication:

- `account`: Your SSO account username
- `password`: Your SSO account password

Example:

```bash
export account=your_sso_username
export password=your_sso_password
```

Then, execute the tests using:

```bash
make test
```