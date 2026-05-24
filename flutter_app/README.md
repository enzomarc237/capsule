# Capsule 2.1+ - Flutter GUI Application

Flutter desktop application for Capsule bundler with live preview and advanced features.

## Features

### Phase 2 Implementation (v2.1+)
- ✅ **Flutter GUI Application**: Native desktop interface for Windows, macOS, and Linux
- ✅ **Live Preview Window**: Real-time WebView preview of your web application
- ✅ **Drag & Drop Interface**: Easy project import and configuration
- ✅ **Build Progress Tracking**: 6-stage pipeline with detailed logging
- ✅ **Multi-Platform Builds**: Configure and build for multiple platforms simultaneously
- 🔄 **Template System**: Pre-configured templates for common app types (coming soon)
- 🔄 **Auto-Update Mechanism**: Automatic updates for bundled applications (coming soon)
- 🔄 **Code Signing UI**: Easy certificate management and signing (coming soon)

## Screenshots

[Screenshots will be added after implementation]

## Development

### Prerequisites
- Flutter SDK 3.10.0 or later
- Dart SDK 3.10.1 or later

### Setup

```bash
cd flutter_app
flutter pub get
```

### Run in Development

```bash
# Linux
flutter run -d linux

# macOS
flutter run -d macos

# Windows
flutter run -d windows
```

### Build for Production

```bash
# Linux
flutter build linux --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release
```

## Architecture

The Flutter GUI app follows clean architecture principles:

```
lib/
├── main.dart              # App entry point
├── ui/
│   ├── screens/          # Main screens
│   │   ├── welcome_screen.dart
│   │   ├── project_setup_screen.dart
│   │   ├── workspace_screen.dart
│   │   ├── build_progress_screen.dart
│   │   └── success_screen.dart
│   ├── widgets/          # Reusable widgets
│   │   ├── config_panel.dart
│   │   └── preview_window.dart
│   └── theme/           # Theming
│       └── app_theme.dart
├── providers/           # State management (Riverpod)
├── services/            # Business logic integration
└── models/             # Data models
```

## Integration with v2.0 CLI

The Flutter GUI integrates with the existing Capsule v2.0 build pipeline:

1. GUI collects project configuration
2. Invokes v2.0 build services
3. Displays real-time progress
4. Shows build results

## Roadmap

### v2.1.0 (Current)
- [x] Basic Flutter GUI structure
- [x] Welcome and project setup screens
- [x] Live preview with WebView
- [x] Build progress visualization
- [ ] Integration with v2.0 build engine
- [ ] Template system
- [ ] Settings persistence

### v2.2.0 (Next)
- [ ] Auto-update mechanism
- [ ] Code signing UI
- [ ] Advanced configuration options
- [ ] Plugin system foundation

### v2.3.0 (Future)
- [ ] Template marketplace
- [ ] Cloud sync
- [ ] Team collaboration features
- [ ] Analytics dashboard

## License

Same as main Capsule project
