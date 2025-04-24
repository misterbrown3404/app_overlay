

# App_Overlay – Flutter App Overlay & Parental Control

**ScreenGuard** is a Flutter-based mobile application designed to help parents or individuals limit screen time by **overlaying a blocking screen over all other apps**. This app utilizes platform-specific capabilities to draw over other applications, providing a screen timeout or restriction mechanism ideal for parental control or focus-enhancing purposes.

## Features

- **App Overlay**: Blocks interaction with other apps using a fullscreen overlay.
- **Custom Timer**: Set screen time limits and enforce them with overlays.
- **Parental Control**: Prevents access to restricted apps or device functions.
- **Permission Handling**: Automatically prompts for "Draw over other apps" permission.
- **Cross-Platform Support**: Primarily supports Android (iOS restrictions limit overlays).


## Installation

Clone the repository:

```bash
git clone https://github.com/misterbrown3404/app_overlay.git
cd app_overlay
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

> **Note**: Make sure to enable the **"Draw over other apps"** permission from system settings.

## Permissions Required

- `SYSTEM_ALERT_WINDOW`: For drawing over other apps.
- Optional: `FOREGROUND_SERVICE`, `INTERNET`, depending on features added.

## How It Works

The app uses platform-specific APIs (via platform channels or plugins) to draw a fullscreen widget over other apps. The overlay remains active for a set duration or until a specific action is performed.

## Technical Stack

- **Flutter**
- **Dart**
- Platform-specific code in **Kotlin (Android)**
- Plugin: `flutter_overlay_window` (or custom plugin if used)

## Limitations

- **Android only**: Due to platform limitations, iOS does not support screen overlays in this manner.
- May require manual permission grant on some devices or OS versions.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Would you like me to customize this with your GitHub username or project name if you're planning to upload it there?
