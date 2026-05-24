# Capsule 2.0 🚀

> A modern desktop application bundler that transforms web applications into standalone, self-contained executables with a built-in HTTP server and advanced build pipeline.

[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.10.1-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Build Status](https://github.com/enzomarc237/capsule/workflows/Build%20and%20Release%20Capsule%202.0/badge.svg)](https://github.com/enzomarc237/capsule/actions)

Capsule 2.0 is a complete rewrite of the original Capsule, featuring a robust **6-stage build pipeline**, modular architecture, and enterprise-grade features for bundling web applications into native desktop executables.

## ✨ Features

### Core Features
- 🎯 **Single Executable**: Bundle entire web apps into one portable file
- 🏗️ **6-Stage Build Pipeline**: Validation → Preparation → Code Generation → Compilation → Packaging → Verification
- 📊 **Real-time Progress Tracking**: Beautiful CLI with live build progress
- 🗜️ **Smart Compression**: Automatic Gzip compression with browser detection
- 🚀 **Zero Dependencies**: Generated executables need nothing else to run
- 🌐 **Built-in Server**: Includes HTTP server with SPA routing support
- 📦 **Cross-Platform**: Build for Linux, macOS, and Windows
- ⚡ **Fast Serving**: Compressed assets served directly to supporting browsers

### Capsule 2.0 Enhancements
- **Modular Architecture**: Clean separation between UI, business logic, and platform layers
- **Project Management**: Full project lifecycle with configuration persistence
- **Asset Optimization**: Advanced asset processing and optimization
- **Build Configuration**: Flexible build settings per platform
- **Detailed Logging**: Comprehensive build logs with multiple log levels
- **Platform Abstraction**: Ready for future platform-specific optimizations

## 🏗️ Architecture

Capsule 2.0 follows the architecture specified in our [Technical Architecture Document](docs/capsule-2.0/ARCHITECTURE.md):

```
┌─────────────────────────────────────────┐
│        CLI / User Interface             │
├─────────────────────────────────────────┤
│          Services Layer                 │
│  ┌──────────┐  ┌──────────┐  ┌────────┐│
│  │ Project  │  │  Asset   │  │ Build  ││
│  │ Service  │  │Processor │  │ Engine ││
│  └──────────┘  └──────────┘  └────────┘│
├─────────────────────────────────────────┤
│         Build Pipeline (6 Stages)       │
│  Validation → Preparation → CodeGen →  │
│  Compilation → Packaging → Verification │
├─────────────────────────────────────────┤
│        Platform Abstraction Layer       │
└─────────────────────────────────────────┘
```

### 6-Stage Build Pipeline

1. **Validation**: Checks Dart SDK, project structure, and dependencies
2. **Preparation**: Creates temp directory, copies and optimizes assets
3. **Code Generation**: Generates Dart code from templates, injects assets
4. **Compilation**: Compiles to native executable using `dart compile exe`
5. **Packaging**: Handles code signing and installer generation (optional)
6. **Verification**: Tests executable, verifies integrity, reports size

## 📦 Installation

### Quick Install (Linux/macOS)

```bash
# Download the latest release
wget https://github.com/enzomarc237/capsule/releases/latest/download/capsule_linux_x64
chmod +x capsule_linux_x64
sudo mv capsule_linux_x64 /usr/local/bin/capsule

# Or for macOS Intel
wget https://github.com/enzomarc237/capsule/releases/latest/download/capsule_macos_x64
chmod +x capsule_macos_x64
sudo mv capsule_macos_x64 /usr/local/bin/capsule

# Or for macOS Apple Silicon
wget https://github.com/enzomarc237/capsule/releases/latest/download/capsule_macos_arm64
chmod +x capsule_macos_arm64
sudo mv capsule_macos_arm64 /usr/local/bin/capsule
```

### From Source

```bash
# Clone the repository
git clone https://github.com/enzomarc237/capsule.git
cd capsule

# Install dependencies
dart pub get

# Build Capsule
dart compile exe bin/capsule_v2.dart -o capsule

# Add to PATH (optional)
export PATH="$PATH:$(pwd)"
```

### Using Docker

```bash
# Pull the Docker image
docker pull ghcr.io/enzomarc237/capsule:latest

# Run Capsule
docker run --rm -v $(pwd):/workspace capsule -i /workspace/my-app
```

## 🚀 Quick Start

### Basic Usage

Bundle a web application:

```bash
capsule -i ./my-web-app
```

Run the generated executable:

```bash
./build/my-web-app
# Server starts at http://localhost:8080
```

### Advanced Usage

```bash
# Specify output directory and app name
capsule -i ./dist -o ./output -n "MyApp"

# Build for specific platform
capsule -i ./dist --platform macos

# Verbose output with detailed logs
capsule -i ./dist -v

# Custom port
capsule -i ./dist -p 3000
```

## 📖 Command Line Options

```
Options:
  -i, --input       Input directory containing web assets (required)
  -o, --output      Output executable path or directory (default: "build")
  -n, --name        Application name
  -p, --port        Default port for the server (default: "8080")
      --platform    Target platform (windows, macos, linux)
  -v, --verbose     Show detailed build logs
  -h, --help        Show usage information
```

## 📚 Examples

### Bundle a React App

```bash
# Build your React app
npm run build

# Bundle with Capsule
capsule -i ./build -n "My React App"

# Run
./build/my_react_app
```

### Bundle a Vue.js App

```bash
# Build your Vue app
npm run build

# Bundle with Capsule
capsule -i ./dist -o ./release -n "My Vue App" -v

# Run
./release/my_vue_app
```

### Bundle Static HTML Site

```bash
capsule -i ./public -n "Portfolio"
./build/portfolio
```

## 🎯 Use Cases

- **Static Site Deployment**: Deploy Jekyll, Hugo, or hand-coded sites
- **SPA Distribution**: Package React, Vue, or Angular applications
- **Offline Documentation**: Create portable documentation servers
- **Demo Applications**: Share prototypes without hosting setup
- **Embedded Web UIs**: Deploy on IoT devices or kiosks
- **Internal Tools**: Distribute web-based utilities to teams
- **Desktop Apps**: Bundle web UIs into native applications
- **Testing & QA**: Quickly deploy test environments

## 📊 Performance

Capsule uses Gzip compression to significantly reduce executable size:

```
Example React App:
├─ Original assets:      2.5 MB
├─ Compressed data:      850 KB
└─ Final executable:     ~12 MB (includes Dart runtime + server)

Build Time:
├─ Simple app:           < 10 seconds
├─ Average app:          < 30 seconds
└─ Complex app:          < 2 minutes
```

The server intelligently serves:
- **Compressed data** directly to browsers supporting Gzip (most modern browsers)
- **Decompressed data** to legacy browsers that don't support compression

## 🔧 Technical Details

### Supported File Types

Capsule automatically detects and serves the correct MIME types for:

- **HTML/Text**: `.html`, `.css`, `.js`, `.json`, `.xml`, `.txt`
- **Images**: `.png`, `.jpg`, `.jpeg`, `.gif`, `.svg`, `.ico`, `.webp`
- **Fonts**: `.woff`, `.woff2`, `.ttf`, `.otf`, `.eot`
- **Video/Audio**: `.mp4`, `.webm`, `.mp3`, `.wav`, `.ogg`
- **Archives**: `.zip`, `.pdf`

### SPA Routing

Capsule includes built-in support for Single Page Applications:
- Unknown routes automatically fall back to `index.html`
- Enables client-side routing for React Router, Vue Router, etc.
- Preserves URL structure for bookmarking and sharing

### Environment Variables

- `PORT`: Override the default port at runtime

### Build Artifacts

```
build/
├── app_name              # Main executable
├── app_name.sha256      # Checksum (in releases)
└── build.log            # Build logs (with -v flag)
```

## 🛠️ Development

### Project Structure

```
capsule/
├── bin/
│   ├── capsule.dart         # Original CLI (v1)
│   └── capsule_v2.dart      # New CLI (v2)
├── lib/
│   ├── models/              # Data models
│   │   ├── project/
│   │   ├── build/
│   │   └── assets/
│   ├── services/            # Business logic
│   │   ├── project_service.dart
│   │   ├── asset_processor.dart
│   │   └── build_engine.dart
│   ├── build/
│   │   ├── pipeline/        # Build pipeline
│   │   └── platforms/       # Platform-specific builders
│   └── templates/
│       └── server_template.dart
├── docs/
│   └── capsule-2.0/         # Comprehensive documentation
├── .github/
│   └── workflows/           # CI/CD pipelines
├── pubspec.yaml
└── README.md
```

### Building from Source

```bash
# Get dependencies
dart pub get

# Run in development
dart run bin/capsule_v2.dart -i ./example -v

# Run tests
dart test

# Analyze code
dart analyze

# Compile Capsule
dart compile exe bin/capsule_v2.dart -o capsule
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Roadmap

See the [Product Requirements Document](docs/capsule-2.0/PRD.md) and [Development Roadmap](docs/capsule-2.0/ROADMAP.md) for planned features and enhancements.

### Planned Features

- **GUI Application**: Flutter-based visual interface
- **Live Preview**: Real-time preview during configuration
- **Template System**: Pre-built templates for common app types
- **Code Signing**: Automated code signing for all platforms
- **Auto-Update**: Built-in update mechanism for bundled apps
- **Plugin System**: Extensibility through plugins
- **Cloud Builds**: Optional cloud-based build service

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Dart](https://dart.dev)
- Inspired by the need for simple, portable web application deployment
- Based on lessons learned from Electron, Tauri, and other bundlers

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/enzomarc237/capsule/issues)
- **Discussions**: [GitHub Discussions](https://github.com/enzomarc237/capsule/discussions)
- **Documentation**: [docs/capsule-2.0/](docs/capsule-2.0/)

## 🌟 Stargazers

If you find this project useful, please consider giving it a star on GitHub!

## 📈 Project Status

Capsule 2.0 is in **active development**. The core build system is complete and functional. GUI features and advanced functionality are planned for future releases.

### Version History

- **v2.0.0** (Current): Complete rewrite with 6-stage pipeline, modular architecture
- **v1.0.0**: Original CLI-based bundler

---

**Made with ❤️ by the Capsule team**

*Transforming web applications into desktop executables, one build at a time.*
