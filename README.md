# Capsule 🚀

> Bundle web applications into standalone, self-contained Dart executables with built-in HTTP server

[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.10.1-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎉 Capsule 2.0 is Here!

**Capsule has been completely rewritten with a robust 6-stage build pipeline, modular architecture, and enterprise-grade features!**

👉 **[See Capsule 2.0 Documentation](README_V2.md)** for the latest features and usage.

---

## About Capsule

Capsule transforms your web applications into single executable files that include everything needed to serve them - no external dependencies, no separate web server, no configuration files. Just one file that runs anywhere.

## ✨ Features

- 🎯 **Single Executable**: Bundle entire web apps into one portable file
- 🗜️ **Smart Compression**: Automatic Gzip compression with browser detection
- 🚀 **Zero Dependencies**: Generated executables need nothing else to run
- 🌐 **Built-in Server**: Includes HTTP server with SPA routing support
- 📦 **Cross-Platform**: Works on Linux, macOS, and Windows
- ⚡ **Fast Serving**: Compressed assets served directly to supporting browsers
- 🎨 **Content-Type Detection**: Automatic MIME type handling for common formats

## 📦 Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/enzomarc237/capsule.git
cd capsule

# Install dependencies
dart pub get

# Compile Capsule itself
dart compile exe bin/capsule.dart -o capsule

# Add to PATH (optional)
export PATH="$PATH:$(pwd)"
```

### Using Dart Pub (Coming Soon)

```bash
dart pub global activate capsule
```

## 🚀 Quick Start

### Basic Usage

Bundle a web application:

```bash
capsule -i ./my-web-app -o my_server
```

Run the generated executable:

```bash
./my_server
# Server starts at http://localhost:8080
```

### With Custom Port

```bash
capsule -i ./dist -o app_server -p 3000
./app_server
# Server starts at http://localhost:3000
```

### Runtime Port Override

```bash
PORT=5000 ./app_server
# Server starts at http://localhost:5000
```

## 📖 Usage

### Command Line Options

```
Usage: capsule -i <input_dir> [options]

Options:
  -i, --input     Input directory containing web assets (required)
  -o, --output    Output executable path (default: "capsule_server")
  -p, --port      Default port for the server (default: "8080")
  -h, --help      Show usage information
```

### Examples

#### Bundle a React App

```bash
# Build your React app
npm run build

# Bundle with Capsule
capsule -i ./build -o react_app

# Run
./react_app
```

#### Bundle a Vue.js App

```bash
# Build your Vue app
npm run build

# Bundle with Capsule
capsule -i ./dist -o vue_app -p 8080

# Run
./vue_app
```

#### Bundle Static HTML Site

```bash
capsule -i ./public -o static_site
./static_site
```

## 🏗️ How It Works

1. **Asset Collection**: Capsule recursively scans your input directory for all files
2. **Compression**: Each file is compressed using Gzip for optimal size
3. **Encoding**: Compressed data is Base64-encoded for embedding
4. **Code Generation**: Assets are injected into a Dart server template
5. **Compilation**: The generated code is compiled into a native executable
6. **Smart Serving**: At runtime, the server detects browser capabilities and serves compressed or decompressed content accordingly

### Architecture

```
┌─────────────────┐
│   Web Assets    │
│  (HTML/CSS/JS)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Gzip Compress  │
│  & Base64 Encode│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Inject into     │
│ Server Template │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Dart Compile    │
│   to Native     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Standalone    │
│   Executable    │
└─────────────────┘
```

## 🎯 Use Cases

- **Static Site Deployment**: Deploy Jekyll, Hugo, or hand-coded sites
- **SPA Distribution**: Package React, Vue, or Angular applications
- **Offline Documentation**: Create portable documentation servers
- **Demo Applications**: Share prototypes without hosting setup
- **Embedded Web UIs**: Deploy on IoT devices or kiosks
- **Internal Tools**: Distribute web-based utilities to teams
- **Desktop Apps**: Bundle web UIs into native applications

## 📊 Performance

Capsule uses Gzip compression to significantly reduce executable size:

```
Example React App:
├─ Original assets: 2.5 MB
├─ Compressed data: 850 KB
└─ Final executable: ~12 MB (includes Dart runtime + server)
```

The server intelligently serves:
- **Compressed data** directly to browsers supporting Gzip (most modern browsers)
- **Decompressed data** to legacy browsers that don't support compression

## 🔧 Technical Details

### Supported File Types

Capsule automatically detects and serves the correct MIME types for:

- **HTML/Text**: `.html`, `.css`, `.js`, `.json`, `.xml`, `.txt`
- **Images**: `.png`, `.jpg`, `.jpeg`, `.gif`, `.svg`, `.ico`
- **Fonts**: `.woff`, `.woff2`, `.ttf`, `.otf`, `.eot`
- **Video/Audio**: `.mp4`, `.webm`, `.mp3`, `.wav`, `.ogg`
- **Archives**: `.zip`, `.pdf`

### SPA Routing

Capsule includes built-in support for Single Page Applications:
- Unknown routes automatically fall back to `index.html`
- Enables client-side routing for React Router, Vue Router, etc.

### Environment Variables

- `PORT`: Override the default port at runtime

## 🛠️ Development

### Project Structure

```
capsule/
├── bin/
│   └── capsule.dart          # CLI entry point
├── lib/
│   └── templates/
│       └── server_template.dart  # Runtime server template
├── pubspec.yaml              # Project configuration
└── README.md                 # This file
```

### Building from Source

```bash
# Get dependencies
dart pub get

# Run in development
dart run bin/capsule.dart -i ./example -o test_server

# Compile Capsule
dart compile exe bin/capsule.dart -o capsule

# Run tests (when available)
dart test
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Roadmap

See [IMPROVEMENT_ROADMAP.md](IMPROVEMENT_ROADMAP.md) for planned features and enhancements.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Dart](https://dart.dev)
- Inspired by the need for simple, portable web application deployment

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/enzomarc237/capsule/issues)
- **Discussions**: [GitHub Discussions](https://github.com/enzomarc237/capsule/discussions)

## 🔮 Future Features

Planned enhancements include:
- Development mode with hot reload
- HTTPS support
- Asset optimization (minification)
- Multi-platform cross-compilation
- Configuration file support
- And much more! See [IMPROVEMENT_ROADMAP.md](IMPROVEMENT_ROADMAP.md)

---

**Made with ❤️ by the Capsule team**

*Simplifying web application deployment, one executable at a time.*