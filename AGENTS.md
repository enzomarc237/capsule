# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Non-Obvious Project Specifics

### Template System
- Server template at `lib/templates/server_template.dart` uses placeholder injection: `{{ASSETS}}`, `{{DEFAULT_PORT}}`
- Template loading has fallback: tries `Platform.script` path first, then `Directory.current` (line 51-58 in bin/capsule.dart)
- CRITICAL: `{{DEFAULT_PORT}}` appears TWICE in template replacement (line 67-68) - intentional for two locations in template

### Asset Processing
- ALL files compressed with gzip, even images/fonts (no selective compression yet - see IMPROVEMENT_ROADMAP.md)
- Assets stored as base64-encoded gzip in generated executable
- Server detects browser gzip support and serves compressed OR decompressed (dual-mode serving)

### Build Process
- Generates temporary Dart file in system temp directory with prefix 'capsule_'
- Compiles temp file to executable, then deletes temp directory
- Template path resolution differs when running from source vs compiled executable

### Running Commands
```bash
# Run from source (development)
dart run bin/capsule.dart -i <input_dir> -o <output>

# Compile Capsule itself
dart compile exe bin/capsule.dart -o capsule

# Test generated server
./output_name  # Runs on port 8080 or PORT env var
```

### Server Behavior (Non-Standard)
- Unknown routes fallback to 'index.html' (SPA support) - NOT 404
- Empty path ('/' or '') automatically resolves to 'index.html'
- Only returns 404 if 'index.html' itself is missing from assets

### Package Name Mismatch
- Package name is `web_bundler` but project/executable called "Capsule" (pubspec.yaml line 1)