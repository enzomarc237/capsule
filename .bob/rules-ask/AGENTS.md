# Ask Mode Rules (Non-Obvious Only)

## Project Structure
- Package name is `web_bundler` but project/executable called "Capsule" (pubspec.yaml line 1)
- Only two source files: `bin/capsule.dart` (CLI) and `lib/templates/server_template.dart` (runtime template)
- No test directory yet - see IMPROVEMENT_ROADMAP.md for planned testing infrastructure

## Documentation Context
- README.md contains user-facing documentation
- IMPROVEMENT_ROADMAP.md contains detailed implementation plans for 30+ enhancements
- AGENTS.md files contain non-obvious technical details for AI assistants

## Template System
- `lib/templates/server_template.dart` is NOT executed during build - it's a template
- Template is read as string, placeholders replaced, then compiled into final executable
- Generated executables are standalone - no runtime dependency on template file

## Build Artifacts
- Compiled Capsule tool itself: `capsule` (or `capsule.exe` on Windows)
- Generated web servers: default name `capsule_server` (configurable with -o flag)
- Temporary build files in system temp with 'capsule_' prefix (auto-deleted)

## Compression Strategy
- Currently compresses ALL files including already-compressed formats (images, fonts)
- This is intentional for v1.0 - selective compression planned in Phase 2 (see IMPROVEMENT_ROADMAP.md)
- Dual-mode serving compensates: browsers get pre-compressed, legacy browsers get decompressed