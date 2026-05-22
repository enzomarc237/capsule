# Capsule Improvement Roadmap

> Implementation plan for enhancing the Capsule web bundler project
> Organized by implementation complexity and impact (Quick Wins First)

## 📋 Table of Contents

1. [Phase 1: Quick Wins (1-2 days)](#phase-1-quick-wins)
2. [Phase 2: Core Enhancements (1 week)](#phase-2-core-enhancements)
3. [Phase 3: Advanced Features (2-3 weeks)](#phase-3-advanced-features)
4. [Phase 4: Enterprise Features (1 month+)](#phase-4-enterprise-features)

---

## Phase 1: Quick Wins (1-2 days)

### 1.1 Add Version Flag ⭐ Priority: HIGH
**Effort**: 15 minutes | **Impact**: HIGH

Add `--version` flag to display current version.

**Files to Modify**: `bin/capsule.dart`

**Implementation**:
```dart
const String version = '1.0.0';
..addFlag('version', abbr: 'v', negatable: false, help: 'Show version')
if (argResults['version']) {
  print('Capsule v$version');
  return;
}
```

---

### 1.2 Add Quiet Mode ⭐ Priority: MEDIUM
**Effort**: 20 minutes | **Impact**: MEDIUM

Add `--quiet` flag to suppress non-error output.

**Files to Create**: `lib/utils/logger.dart`
**Files to Modify**: `bin/capsule.dart`

---

### 1.3 Add More MIME Types ⭐ Priority: HIGH
**Effort**: 30 minutes | **Impact**: HIGH

Expand content type detection for modern formats (WebP, WOFF2, MP4, etc.).

**Files to Modify**: `lib/templates/server_template.dart`

Add support for:
- Modern images: WebP, AVIF
- Fonts: WOFF, WOFF2, TTF, OTF
- Video/Audio: MP4, WebM, MP3, WAV
- Archives: ZIP, PDF

---

### 1.4 Improve CLI Help ⭐ Priority: HIGH
**Effort**: 30 minutes | **Impact**: HIGH

Enhance help text with examples and better descriptions.

**Files to Modify**: `bin/capsule.dart`

---

### 1.5 Support Custom Index File ⭐ Priority: MEDIUM
**Effort**: 45 minutes | **Impact**: MEDIUM

Add `--index` flag to specify custom index file (not just index.html).

**Files to Modify**: `bin/capsule.dart`, `lib/templates/server_template.dart`

---

### 1.6 Add Compression Ratio Reporting ⭐ Priority: MEDIUM
**Effort**: 1 hour | **Impact**: MEDIUM

Display compression statistics by file type after build.

**Files to Modify**: `bin/capsule.dart`

Create `CompressionStats` class to track and report:
- Original vs compressed sizes per file type
- Compression ratios
- Total savings

---

### 1.7 Add .capsuleignore Support ⭐ Priority: HIGH
**Effort**: 1 hour | **Impact**: HIGH

Support `.capsuleignore` file for excluding files from bundling.

**Files to Create**: `lib/utils/ignore_patterns.dart`
**Files to Modify**: `bin/capsule.dart`

---

### 1.8 Add --open Flag ⭐ Priority: LOW
**Effort**: 30 minutes | **Impact**: LOW

Auto-open browser after successful compilation.

**Files to Modify**: `bin/capsule.dart`

---

## Phase 2: Core Enhancements (1 week)

### 2.1 Selective Compression ⭐ Priority: HIGH
**Effort**: 3-4 hours | **Impact**: HIGH

Don't compress already-compressed files (images, videos, fonts).

**Files to Create**: `lib/utils/compression.dart`
**Files to Modify**: `bin/capsule.dart`, `lib/templates/server_template.dart`

**Features**:
- Skip compression for: JPG, PNG, GIF, WebP, MP4, WOFF2, ZIP
- Add size threshold (don't compress files < 1KB)
- Add `--compression-level` flag (0-9)

---

### 2.2 Better Error Handling ⭐ Priority: HIGH
**Effort**: 4-5 hours | **Impact**: HIGH

Comprehensive error handling with actionable messages.

**Files to Create**: `lib/exceptions/capsule_exceptions.dart`
**Files to Modify**: `bin/capsule.dart`

**Exception Types**:
- `InvalidInputException` - Directory doesn't exist
- `EmptyDirectoryException` - No files to bundle
- `CompilationException` - Dart compilation failed

Add `--verbose` flag for detailed error output.

---

### 2.3 Progress Indicators ⭐ Priority: MEDIUM
**Effort**: 3-4 hours | **Impact**: MEDIUM

Show progress bars during asset processing and compilation.

**Dependencies**: Add `cli_progress` package
**Files to Modify**: `pubspec.yaml`, `bin/capsule.dart`

---

### 2.4 Configuration File Support ⭐ Priority: HIGH
**Effort**: 6-8 hours | **Impact**: HIGH

Support `capsule.yaml` for project-specific settings.

**Dependencies**: Add `yaml` package
**Files to Create**: `lib/models/capsule_config.dart`, `capsule.example.yaml`
**Files to Modify**: `pubspec.yaml`, `bin/capsule.dart`

**Configuration Options**:
```yaml
input: ./dist
output: my_app_server
port: 8080
index: index.html
exclude:
  - "*.map"
  - "*.test.js"
headers:
  Cache-Control: "public, max-age=3600"
routes:
  /old-path: /new-path
compression:
  level: 6
  selective: true
  minSize: 1024
```

---

### 2.5 Enhanced Logging System ⭐ Priority: MEDIUM
**Effort**: 4-5 hours | **Impact**: MEDIUM

Comprehensive logging with levels and file output.

**Files to Modify**: `lib/utils/logger.dart`, `bin/capsule.dart`

**Features**:
- Log levels: DEBUG, INFO, WARNING, ERROR
- Colored console output
- File logging with `--log-file` flag
- Timestamps

---

## Phase 3: Advanced Features (2-3 weeks)

### 3.1 Development Mode with Hot Reload ⭐ Priority: HIGH
**Effort**: 2-3 days | **Impact**: HIGH

Add `--dev` flag for development without compilation.

**Dependencies**: Add `watcher` package
**Files to Create**: `lib/dev_server.dart`
**Files to Modify**: `pubspec.yaml`, `bin/capsule.dart`

**Features**:
- Serve files directly without compilation
- Watch for file changes
- Auto-reload on changes
- Faster iteration during development

---

### 3.2 HTTPS Support ⭐ Priority: MEDIUM
**Effort**: 2-3 days | **Impact**: MEDIUM

Add SSL/TLS support for secure serving.

**Files to Create**: `lib/utils/cert_generator.dart`
**Files to Modify**: `bin/capsule.dart`, `lib/templates/server_template.dart`

**Features**:
- `--cert` and `--key` flags for certificate files
- `--generate-cert` flag for self-signed certificates
- HTTPS server binding

---

### 3.3 Caching & ETag Support ⭐ Priority: MEDIUM
**Effort**: 2 days | **Impact**: MEDIUM

Implement efficient caching with ETags.

**Dependencies**: Add `crypto` package
**Files to Create**: `lib/utils/etag.dart`
**Files to Modify**: `pubspec.yaml`, `bin/capsule.dart`, `lib/templates/server_template.dart`

**Features**:
- Generate ETags for assets
- Handle If-None-Match requests
- Return 304 Not Modified when appropriate
- Configurable Cache-Control headers

---

### 3.4 Multi-Platform Build Support ⭐ Priority: HIGH
**Effort**: 3-4 days | **Impact**: HIGH

Cross-compile for multiple platforms in one command.

**Files to Create**: `lib/models/build_target.dart`
**Files to Modify**: `bin/capsule.dart`

**Supported Targets**:
- Linux (x64, ARM64, ARM32)
- macOS (x64, ARM64)
- Windows (x64)

**Usage**:
```bash
capsule -i ./web --target linux,macos,windows
capsule -i ./web --target all
```

---

### 3.5 Asset Optimization Pipeline ⭐ Priority: MEDIUM
**Effort**: 4-5 days | **Impact**: HIGH

Minify and optimize assets before bundling.

**Dependencies**: Add `html_minifier`, `csslib`, `image` packages
**Files to Create**: 
- `lib/optimizers/html_optimizer.dart`
- `lib/optimizers/css_optimizer.dart`
- `lib/optimizers/js_optimizer.dart`
- `lib/optimizers/image_optimizer.dart`
- `lib/optimizers/optimizer.dart`

**Features**:
- HTML minification (remove comments, whitespace)
- CSS minification
- JavaScript minification
- Image optimization (resize, compress)
- `--optimize` flag with levels: none, basic, aggressive

---

### 3.6 Advanced Routing ⭐ Priority: MEDIUM
**Effort**: 2-3 days | **Impact**: MEDIUM

Custom routing rules and redirects.

**Files to Modify**: `lib/templates/server_template.dart`

**Features**:
- Custom 404 page
- Regex-based route matching
- URL rewrites
- Redirects (301, 302)
- API proxy support

---

### 3.7 Security Headers ⭐ Priority: HIGH
**Effort**: 1-2 days | **Impact**: HIGH

Add security headers to responses.

**Files to Modify**: `lib/templates/server_template.dart`

**Headers**:
- Content-Security-Policy
- X-Frame-Options
- X-Content-Type-Options
- X-XSS-Protection
- Strict-Transport-Security (for HTTPS)

---

## Phase 4: Enterprise Features (1 month+)

### 4.1 Basic Authentication ⭐ Priority: MEDIUM
**Effort**: 2-3 days | **Impact**: MEDIUM

Add password protection with `--auth user:pass`.

**Files to Modify**: `bin/capsule.dart`, `lib/templates/server_template.dart`

---

### 4.2 Request Logging & Analytics ⭐ Priority: MEDIUM
**Effort**: 3-4 days | **Impact**: MEDIUM

Track and log HTTP requests.

**Features**:
- Access logs in Common Log Format
- Request metrics (response times, status codes)
- Export to JSON/CSV
- Real-time statistics

---

### 4.3 Brotli Compression Support ⭐ Priority: LOW
**Effort**: 2-3 days | **Impact**: MEDIUM

Add Brotli compression (better than gzip).

**Dependencies**: Add `brotli` package
**Files to Modify**: `bin/capsule.dart`, `lib/templates/server_template.dart`

---

### 4.4 Plugin System ⭐ Priority: LOW
**Effort**: 1-2 weeks | **Impact**: HIGH

Allow custom middleware and transformers.

**Features**:
- Hook system (pre/post processing)
- Custom content transformers
- Middleware injection
- Plugin API

---

### 4.5 Docker Image Generation ⭐ Priority: LOW
**Effort**: 2-3 days | **Impact**: MEDIUM

Generate Docker images from bundled apps.

**Files to Create**: `lib/docker/dockerfile_generator.dart`

---

### 4.6 Service Worker Generation ⭐ Priority: LOW
**Effort**: 3-4 days | **Impact**: MEDIUM

Auto-generate service workers for PWA support.

**Features**:
- Offline caching
- Background sync
- Push notifications support

---

### 4.7 Internationalization (i18n) ⭐ Priority: LOW
**Effort**: 1 week | **Impact**: MEDIUM

Bundle multiple language versions.

**Features**:
- Multi-language asset bundling
- Runtime language switching
- Locale-based routing

---

### 4.8 Testing Infrastructure ⭐ Priority: HIGH
**Effort**: 1-2 weeks | **Impact**: HIGH

Comprehensive test suite.

**Files to Create**: `test/` directory structure
**Dependencies**: Add `test` package

**Test Coverage**:
- Unit tests for compression logic
- Integration tests for server functionality
- Mock file system tests
- CI/CD pipeline setup

---

## 📊 Implementation Priority Matrix

### Must Have (Phase 1-2)
1. Version flag
2. More MIME types
3. .capsuleignore support
4. Selective compression
5. Better error handling
6. Configuration file support

### Should Have (Phase 3)
1. Development mode
2. Multi-platform builds
3. Asset optimization
4. Security headers
5. Caching/ETags

### Nice to Have (Phase 4)
1. Authentication
2. Request logging
3. Plugin system
4. Testing infrastructure

---

## 🎯 Quick Start Implementation Order

For maximum impact with minimal effort, implement in this order:

1. **Day 1**: Version flag, Quiet mode, More MIME types, Better help
2. **Day 2**: .capsuleignore, Custom index, Compression reporting
3. **Week 1**: Selective compression, Error handling, Progress bars
4. **Week 2**: Configuration file, Enhanced logging, Development mode
5. **Week 3-4**: Multi-platform builds, Asset optimization, Caching

---

## 📝 Notes

- All features should maintain backward compatibility
- Add comprehensive documentation for each feature
- Include examples in help text and README
- Write tests for critical functionality
- Consider performance impact of each feature

---

## 🔗 Related Files

- Main CLI: `bin/capsule.dart`
- Server Template: `lib/templates/server_template.dart`
- Configuration: `pubspec.yaml`
- Documentation: `README.md` (to be created)

---

**Last Updated**: 2026-05-22
**Version**: 1.0.0