# Plan Mode Rules (Non-Obvious Only)

## Architecture Constraints
- Template-based code generation: changes to server behavior require modifying `lib/templates/server_template.dart`
- No runtime configuration: all settings baked into executable at compile time (except PORT env var)
- Single-threaded server: no concurrent request handling (Dart's async/await handles I/O)

## Design Decisions
- Compression is all-or-nothing: no per-file decisions (intentional for v1.0 simplicity)
- SPA routing is hardcoded: unknown paths → index.html (no custom routing yet)
- Content-Type detection is extension-based: no file content inspection (performance trade-off)

## Build Process Coupling
- Template path resolution has two modes: compiled vs source (lines 51-58 in bin/capsule.dart)
- Temp directory cleanup is mandatory: prevents disk space leaks (line 94)
- Placeholder replacement order matters: `{{DEFAULT_PORT}}` replaced twice intentionally

## Planned Enhancements
- See IMPROVEMENT_ROADMAP.md for 4-phase enhancement plan
- Phase 1 (Quick Wins): 8 features, 1-2 days each
- Phase 2 (Core): Selective compression, config files, error handling
- Phase 3 (Advanced): Dev mode, HTTPS, multi-platform builds
- Phase 4 (Enterprise): Auth, analytics, plugin system

## Current Limitations
- No selective compression (compresses everything)
- No configuration file support (CLI args only)
- No development mode (must recompile for changes)
- No HTTPS support
- No custom routing rules
- No asset optimization (minification)