# Detect OS
ifeq ($(OS),Windows_NT)
  SHELL := cmd.exe
  CURL = curl.exe
  MKDIR = -md
  PATHSEP = \\
  RM = -rmdir /S /Q
else
  SHELL := /bin/bash
  CURL = curl
  MKDIR = mkdir -p
  PATHSEP = /
  RM = rm -rf
endif

# Variables
ANDROID_OUTPUT_PATH = android$(PATHSEP)app$(PATHSEP)src$(PATHSEP)main$(PATHSEP)jniLibs
ANDROID_ARM64 = android_arm64_nknu_core
ANDROID_ARM = android_arm_nknu_core
ANDROID_X86_64 = android_x86_64_nknu_core
ANDROID_X86 = android_x86_nknu_core

create-bin-folder:
	$(MKDIR) bin

create-android-lib-folders:
	$(MKDIR) $(ANDROID_OUTPUT_PATH)$(PATHSEP)arm64-v8a
	$(MKDIR) $(ANDROID_OUTPUT_PATH)$(PATHSEP)armeabi-v7a
	$(MKDIR) $(ANDROID_OUTPUT_PATH)$(PATHSEP)x86_64
	$(MKDIR) $(ANDROID_OUTPUT_PATH)$(PATHSEP)x86

download-android-arm64:
	$(CURL) -L -o $(ANDROID_OUTPUT_PATH)$(PATHSEP)arm64-v8a$(PATHSEP)libnknu.so https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_ARM64).so
	$(CURL) -L -o bin$(PATHSEP)libnknu_arm64.h https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_ARM64).h

download-android-arm:
	$(CURL) -L -o $(ANDROID_OUTPUT_PATH)$(PATHSEP)armeabi-v7a$(PATHSEP)libnknu.so https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_ARM).so
	$(CURL) -L -o bin$(PATHSEP)libnknu_arm.h https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_ARM).h

download-android-x86_64:
	$(CURL) -L -o $(ANDROID_OUTPUT_PATH)$(PATHSEP)x86_64$(PATHSEP)libnknu.so https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_X86_64).so
	$(CURL) -L -o bin$(PATHSEP)libnknu_x86_64.h https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_X86_64).h

download-android-x86:
	$(CURL) -L -o $(ANDROID_OUTPUT_PATH)$(PATHSEP)x86$(PATHSEP)libnknu.so https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_X86).so
	$(CURL) -L -o bin$(PATHSEP)libnknu_x86.h https://github.com/GDG-on-Campus-NKNU/NKNU-Core/releases/latest/download/$(ANDROID_X86).h

generate-ffigen-config:
	dart run ffigen_config_gen.dart

generate-android-bindings:
	$(MKDIR) lib$(PATHSEP)ffi$(PATHSEP)bindings
	dart run ffigen --config ./bin/ffigen_x86_64_config.yaml
	dart run ffigen --config ./bin/ffigen_x86_config.yaml
	dart run ffigen --config ./bin/ffigen_arm64_config.yaml
	dart run ffigen --config ./bin/ffigen_arm_config.yaml


download-android-libs: create-bin-folder create-android-lib-folders download-android-arm64 download-android-arm download-android-x86_64 download-android-x86

# Download the file
download-all-libs: clean download-android-libs

# Generate bindings
generate-bindings: generate-ffigen-config generate-android-bindings

# Clean up
clean:
	$(RM) $(ANDROID_OUTPUT_PATH)
	$(RM) bin