# Capsule 2.1+ 🚀

> Transform web applications into standalone desktop executables with a beautiful graphical interface

[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.10.1-blue.svg)](https://dart.dev)
[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.19.0-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Build Status](https://github.com/enzomarc237/capsule/workflows/Build%20and%20Release%20Capsule%202.1+/badge.svg)](https://github.com/enzomarc237/capsule/actions)

Capsule 2.1+ introduces a native Flutter GUI application alongside the powerful v2.0 CLI, making desktop app bundling accessible to everyone - from experienced developers to designers without coding experience.

## ✨ What's New in 2.1+

### 🎨 Flutter GUI Application (NEW!)
- **Beautiful Desktop Interface**: Native cross-platform GUI built with Flutter and Material Design
- **Live Preview Window**: See your web app in real-time with integrated WebView before building
- **Drag & Drop Workflow**: Import projects, upload icons, and configure settings visually
- **Visual Build Progress**: Watch the 6-stage pipeline with detailed logging and stage indicators
- **Multi-Platform Support**: Select and build for Windows, macOS, and Linux simultaneously
- **Zero Code Required**: Complete visual workflow for non-developers

### 🔧 Powerful CLI (v2.0 Foundation)
- **6-Stage Build Pipeline**: Validation → Preparation → Code Generation → Compilation → Packaging → Verification
- **Modular Architecture**: Clean separation between services, models, and build stages
- **Rich Terminal Output**: Beautiful progress tracking with real-time build logs
- **Smart Asset Processing**: Automatic compression with browser gzip detection
- **Platform Abstraction**: Ready for platform-specific optimizations

## 🖼️ Screenshots

[Screenshots coming soon - GUI implementation complete, capture in progress]

## 📦 Installation

### GUI Application (Recommended)

#### macOS
```bash
# Download the latest release
curl -LO https://github.com/enzomarc237/capsule/releases/latest/download/capsule_gui_macos_x64.zip
unzip capsule_gui_macos_x64.zip
open capsule_gui.app
```

#### Linux
```bash
# Download and extract
wget https://github.com/enzomarc237/capsule/releases/latest/download/capsule_gui_linux_x64.tar.gz
tar -xzf capsule_gui_linux_x64.tar.gz
./capsule_gui
```

#### Windows
1. Download `capsule_gui_windows_x64.zip` from [releases](https://github.com/enzomarc237/capsule/releases)
2. Extract the archive
3. Double-click `capsule_gui.exe`

### CLI Tool (For Automation)

```bash
# Linux/macOS
wget https://github.com/enzomarc237/capsule/releases/latest/download/capsule_cli_linux_x64
chmod +x capsule_cli_linux_x64
sudo mv capsule_cli_linux_x64 /usr/local/bin/capsule

# Or build from source
git clone https://github.com/enzomarc237/capsule.git
cd capsule
dart compile exe bin/capsule_v2.dart -o capsule
```

## 🚀 Quick Start

### Using the GUI

1. **Launch Capsule GUI** - Open the application
2. **Create New Project** - Click "Create New Project" or drag your web app folder
3. **Configure Settings**:
   - Set app name, version, and author
   - Upload custom icon (optional)
   - Select target platforms
4. **Preview Your App** - See live preview in the workspace
5. **Build** - Click the build button and watch the progress
6. **Done!** - Your standalone desktop app is ready

### Using the CLI

```bash
# Basic usage
capsule -i ./my-web-app

# With custom settings
capsule -i ./dist -o ./build -n "My Awesome App" -v

# Multi-platform build
capsule -i ./app --platforms linux,macos,windows
```

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│              Capsule 2.1+ Application                     │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  ┌────────────────────┐     ┌──────────────────────┐    │
│  │   Flutter GUI      │     │    CLI Interface     │    │
│  │   (v2.1+)          │     │    (v2.0)            │    │
│  │                    │     │                      │    │
│  │ - Visual workflow  │     │ - Automation         │    │
│  │ - Live preview     │     │ - CI/CD integration  │    │
│  │ - Zero code        │     │ - Scripting          │    │
│  └──────────┬─────────┘     └──────────┬───────────┘    │
│             │                           │                 │
│             └───────────┬───────────────┘                 │
│                         │                                 │
│              ┌──────────▼──────────┐                     │
│              │  Build Engine v2.0   │                     │
│              │                      │                     │
│              │  6-Stage Pipeline:   │                     │
│              │  1. Validation       │                     │
│              │  2. Preparation      │                     │
│              │  3. Code Generation  │                     │
│              │  4. Compilation      │                     │
│              │  5. Packaging        │                     │
│              │  6. Verification     │                     │
│              └──────────────────────┘                     │
└──────────────────────────────────────────────────────────┘
```

## 📖 Documentation

- **[CLI Documentation](README_V2.md)** - Complete CLI guide
- **[GUI Documentation](flutter_app/README.md)** - Flutter app details
- **[Architecture](docs/capsule-2.0/ARCHITECTURE.md)** - Technical architecture
- **[Roadmap](docs/capsule-2.0/ROADMAP.md)** - Development roadmap
- **[Changelog](CHANGELOG.md)** - Version history

## 🎯 Use Cases

### For Web Developers
Convert your React, Vue, Angular, or static sites into native desktop apps without learning new frameworks.

### For Designers
Turn web prototypes into distributable desktop applications without writing code.

### For Teams
Quickly create desktop versions of web dashboards, admin panels, or internal tools.

### For Automation
Use the CLI to integrate desktop app bundling into your CI/CD pipeline.

## 🔧 Development

### GUI Development
```bash
cd flutter_app
flutter pub get
flutter run -d linux  # or macos/windows
```

### CLI Development
```bash
dart pub get
dart run bin/capsule_v2.dart -i ./test-app
```

### Running Tests
```bash
# CLI tests
dart test

# GUI tests (coming soon)
cd flutter_app
flutter test
```

## 🛣️ Roadmap

### ✅ v2.0 (Completed)
- 6-stage build pipeline
- Modular architecture
- CLI with rich output
- Multi-platform builds

### ✅ v2.1 (Current)
- Flutter GUI application
- Live preview window
- Visual build progress
- Automated release drafts

### 🔄 v2.2 (Next)
- Template system
- Auto-update mechanism
- Code signing UI
- Advanced configurations

### 📋 v2.3 (Future)
- Template marketplace
- Cloud sync
- Team collaboration
- Analytics dashboard

See the [complete roadmap](docs/capsule-2.0/ROADMAP.md) for details.

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and linting
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Dart](https://dart.dev) and [Flutter](https://flutter.dev)
- Inspired by [Electron](https://electronjs.org) and [Tauri](https://tauri.app)
- Powered by GitHub Actions for CI/CD

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/enzomarc237/capsule/issues)
- **Discussions**: [GitHub Discussions](https://github.com/enzomarc237/capsule/discussions)
- **Documentation**: [Wiki](https://github.com/enzomarc237/capsule/wiki)

---

**Made with ❤️ by the Capsule team**

**Star ⭐ this repository if you find it useful!**
