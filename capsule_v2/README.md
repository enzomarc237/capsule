# Capsule 2.0 - Desktop App Bundler

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-blue.svg)](https://dart.dev)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](#)

**Transform your web applications into native desktop executables with zero coding required.**

## 🚀 Features

### Core Capabilities
- **Drag & Drop Import** - Simply drop your web project folder
- **Auto-Detection** - Automatically detects React, Vue, Angular, Svelte, Next.js, Nuxt, and static sites
- **Cross-Platform Builds** - Build for Windows (.exe), macOS (.app), and Linux (executable)
- **Live Preview** - Real-time preview of your application before building
- **Smart Compression** - Gzip compression for optimized bundle sizes
- **Zero Dependencies** - Final executables run without external dependencies
- **Code Signing** - Optional code signing for Windows and macOS

### User Experience
- **GUI Interface** - Intuitive desktop application (no CLI required)
- **5-Minute Setup** - From import to executable in under 5 minutes
- **Project Templates** - Pre-configured templates for common scenarios
- **Build History** - Track previous builds and configurations
- **Real-time Progress** - Live build progress with detailed logs

## 📦 Installation

### Prerequisites
- **Flutter SDK** 3.16 or higher
- **Dart SDK** 3.2 or higher
- **Platform-specific requirements:**
  - **Windows**: Visual Studio Build Tools 2019+
  - **macOS**: Xcode 14+ with command line tools
  - **Linux**: GCC, GTK 3+, WebKit2GTK

### Setup

```bash
# Clone the repository
git clone https://github.com/your-org/capsule-v2.git
cd capsule-v2

# Install dependencies
flutter pub get

# Run the application
flutter run -d <windows|linux|macos>
```

### Building Capsule Itself

```bash
# Build for current platform
flutter build <windows|linux|macos> --release

# Output locations:
# Windows: build/windows/runner/Release/capsule.exe
# macOS: build/macos/Build/Products/Release/Capsule.app
# Linux: build/linux/x64/release/bundle/capsule
```

## 🎯 Usage Guide

### Step 1: Import Project
1. Launch Capsule
2. Click "Import Project" or drag & drop your web app folder
3. Capsule auto-detects your framework and configuration

### Step 2: Configure Build
1. Set application name and bundle identifier
2. Choose target platforms (Windows, macOS, Linux)
3. Configure window size and application icon
4. (Optional) Add code signing certificates

### Step 3: Preview & Build
1. Use live preview to test your app
2. Click "Build" to start the build process
3. Monitor real-time progress
4. Access your executable when complete

### Supported Frameworks

| Framework | Detection | Build Support | Notes |
|-----------|-----------|---------------|-------|
| React | ✅ | ✅ | Create React App, Vite |
| Vue.js | ✅ | ✅ | Vue CLI, Vite |
| Angular | ✅ | ✅ | Angular CLI |
| Svelte | ✅ | ✅ | SvelteKit, Vite |
| Next.js | ✅ | ✅ | Static export mode |
| Nuxt.js | ✅ | ✅ | Static generation |
| Static Sites | ✅ | ✅ | HTML/CSS/JS |

## 🏗️ Architecture

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── project/             # Project configuration
│   └── build/               # Build configuration
├── services/                # Business logic
│   ├── project_detector.dart
│   ├── build_service.dart
│   └── platform/            # Platform-specific builders
├── ui/                      # UI components
│   ├── theme/               # App theming
│   └── screens/             # Application screens
├── widgets/                 # Reusable widgets
├── state/                   # State management (Riverpod)
│   └── providers/           # Riverpod providers
└── utils/                   # Utilities
    ├── file_utils.dart
    └── build_utils.dart
```

## 🔧 Development

### Project Structure
- **Models**: Define data structures for projects and builds
- **Services**: Core business logic for detection and building
- **UI**: Material Design 3 interface components
- **State**: Riverpod-based reactive state management
- **Utils**: File operations, compression, and helpers

### Adding New Framework Support

1. Update `ProjectDetector` with new detection patterns
2. Add framework-specific build configurations
3. Test with sample projects
4. Update documentation

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📊 Performance Targets

- **Bundle Size**: <30MB average (with compression)
- **Build Time**: <2 minutes for typical apps
- **Memory Usage**: <200MB during build
- **Startup Time**: <1 second for generated executables

## 🛣️ Roadmap

### Phase 1: MVP (Months 3-6) 🔄
- [x] Core Flutter application structure
- [x] Project detection system
- [x] Basic build pipeline
- [x] Live preview functionality
- [x] Cross-platform support foundation
- [ ] WebView integration for preview
- [ ] Production-ready platform builders

### Phase 2: Enhancement (Months 7-12)
- [ ] API integration capabilities
- [ ] Advanced permissions system
- [ ] Application templates library
- [ ] Auto-update mechanism
- [ ] Code signing automation
- [ ] Plugin system

### Phase 3: Scale (Months 13-18)
- [ ] Team collaboration features
- [ ] Build analytics dashboard
- [ ] Enterprise deployment tools
- [ ] Cloud build service
- [ ] Marketplace for extensions

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Ways to Help
- Report bugs and suggest features
- Improve documentation
- Add support for new frameworks
- Optimize build processes
- Create tutorials and examples

## 📄 License

Capsule 2.0 is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev)
- State management by [Riverpod](https://riverpod.dev)
- Inspired by the original [Capsule](https://github.com/origami/capsule) CLI tool

## 📞 Support

- **Documentation**: https://capsule.dev/docs
- **Issues**: https://github.com/your-org/capsule-v2/issues
- **Discussions**: https://github.com/your-org/capsule-v2/discussions
- **Twitter**: @capsule_dev

---

**Made with ❤️ by the Capsule Team**
