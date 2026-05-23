# Capsule 2.0 - Desktop Application Bundler

Transform your web applications into native desktop executables for Windows, macOS, and Linux with zero coding required.

## Features

- **Drag & Drop Interface**: Simply drop your web app folder and get a desktop executable
- **Auto-Detection**: Automatically detects React, Vue, Angular, Svelte, Next.js, Nuxt, and static sites
- **Live Preview**: See your app in action before building
- **Cross-Platform**: Build for Windows, macOS, and Linux from any platform
- **Zero Dependencies**: Final executables are completely self-contained
- **Small Bundle Size**: Optimized builds averaging <30MB

## Quick Start

### Prerequisites

- Flutter 3.16+ or Dart 3.2+
- For building Windows apps: Windows 10/11 with Visual Studio
- For building macOS apps: macOS with Xcode
- For building Linux apps: Linux with GCC and GTK development libraries

### Installation

```bash
git clone https://github.com/your-org/capsule_v2.git
cd capsule_v2
flutter pub get
flutter run
```

### Usage

1. **Launch Capsule 2.0**
2. **Drag & Drop** your built web application folder (containing index.html, JS, CSS files)
3. **Configure** your app name, icon, and target platform
4. **Preview** your app in the live preview pane
5. **Build** and get your standalone executable!

## Supported Web Frameworks

- ✅ React / Next.js
- ✅ Vue / Nuxt
- ✅ Angular
- ✅ Svelte
- ✅ Static HTML/CSS/JS
- ✅ Any framework that builds to static files

## Project Structure

```
capsule_v2/
├── lib/
│   ├── main.dart              # App entry point
│   ├── ui/                    # UI screens
│   │   ├── theme/             # App theming
│   │   └── screens/           # All screen widgets
│   ├── models/                # Data models
│   ├── services/              # Business logic
│   │   ├── project_detector.dart  # Project type detection
│   │   └── build_service.dart     # Build pipeline
│   ├── widgets/               # Reusable widgets
│   └── state/                 # State management (Riverpod)
├── assets/                    # App assets
└── pubspec.yaml               # Dependencies
```

## Architecture

Capsule 2.0 uses a 3-layer architecture:

1. **UI Layer**: Flutter widgets and screens
2. **Business Logic Layer**: Services for project detection, building, and packaging
3. **Platform Abstraction Layer**: Cross-platform build tools

### Build Pipeline

1. **Validation**: Verify project structure and requirements
2. **Preparation**: Set up output directories
3. **Asset Copy**: Copy web assets to build directory
4. **Code Generation**: Generate Flutter wrapper with WebView
5. **Compilation**: Compile Flutter app for target platform
6. **Packaging**: Create final executable/installer

## Configuration Options

- **App Name**: Display name of your desktop application
- **Version**: Application version number
- **Description**: App description for metadata
- **Primary Color**: Theme color for the app
- **Target Platform**: Windows, macOS, or Linux
- **Build Directory**: Optional override for built web files location

## Development Roadmap

### Phase 1: MVP (Months 3-6)
- [x] Basic project structure
- [x] Project detection and validation
- [x] Build pipeline implementation
- [x] Live preview functionality
- [ ] Drag & drop interface
- [ ] Code signing integration

### Phase 2: Enhancement (Months 7-12)
- [ ] API integration support
- [ ] Permissions management
- [ ] App templates
- [ ] Auto-update mechanism
- [ ] Advanced customization

### Phase 3: Scale (Months 13-18)
- [ ] Collaboration features
- [ ] Analytics dashboard
- [ ] Plugin system
- [ ] Enterprise features

## Troubleshooting

### "No index.html found"
Ensure your web project has been built and contains an index.html file in the root or build/dist folder.

### "Flutter build failed"
Make sure you have Flutter installed and configured for your target platform. Run `flutter doctor` to check your setup.

### Large bundle size
Try optimizing your web assets before bundling. Remove unused files and minify JavaScript/CSS.

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## License

MIT License - see LICENSE file for details

## Support

For issues and feature requests, please open a GitHub issue.

---

**Built with ❤️ using Flutter & Dart**
