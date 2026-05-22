# Advanced Mode Rules (Non-Obvious Only)

## Template Modification Rules
- When modifying `lib/templates/server_template.dart`, remember placeholders are replaced at build time
- `{{ASSETS}}` placeholder expects trailing comma in each line (see line 62 in bin/capsule.dart)
- `{{DEFAULT_PORT}}` must appear exactly twice in template (lines 10-11) - both replacements are intentional

## Asset Processing
- ALL files are gzip compressed regardless of type (images, fonts, etc.) - no selective logic yet
- Compression happens in bin/capsule.dart line 45 using `gzip.encode(bytes)`
- Base64 encoding is mandatory after compression for embedding in Dart source

## Code Generation
- Generated server code goes to system temp directory with 'capsule_' prefix
- Temp directory is deleted after compilation (line 94) - don't rely on it persisting
- Template path resolution uses Platform.script first, then Directory.current as fallback

## Server Implementation
- SPA routing: unknown paths redirect to 'index.html' (line 25-27 in server_template.dart)
- Dual-mode serving: checks Accept-Encoding header to serve compressed or decompressed
- Content-Type detection is extension-based only (no magic number detection)

## Access To
- MCP tools available
- Browser tools available