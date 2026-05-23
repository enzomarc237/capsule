import 'dart:io';

/// Platform-specific build operations interface
abstract class PlatformBuilder {
  Future<bool> validateEnvironment();
  Future<String?> generateExecutable(String projectPath, BuildConfig config);
  Future<bool> signExecutable(String executablePath, SigningConfig? config);
}

/// Windows platform builder using MSBuild/Visual Studio tools
class WindowsBuilder implements PlatformBuilder {
  @override
  Future<bool> validateEnvironment() async {
    // Check for Visual Studio Build Tools
    final vsWhere = File(r'C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe');
    if (!await vsWhere.exists()) {
      return false;
    }
    
    // Check for MSBuild
    final result = await Process.run('where', ['msbuild']);
    return result.exitCode == 0;
  }

  @override
  Future<String?> generateExecutable(String projectPath, BuildConfig config) async {
    try {
      // Create Windows-specific wrapper
      final wrapperDir = Directory('$projectPath/build/windows_wrapper');
      await wrapperDir.create(recursive: true);
      
      // Generate C++/Win32 wrapper code
      await _generateWin32Wrapper(wrapperDir.path, config);
      
      // Compile with MSBuild or cl.exe
      final compileResult = await _compileWindows(wrapperDir.path);
      
      if (compileResult != null) {
        final outputPath = '$projectPath/dist/${config.outputName}.exe';
        await Directory('$projectPath/dist').create(recursive: true);
        await File(compileResult).copy(outputPath);
        return outputPath;
      }
      
      return null;
    } catch (e) {
      print('Windows build error: $e');
      return null;
    }
  }

  Future<void> _generateWin32Wrapper(String outputDir, BuildConfig config) async {
    // Generate main.cpp with embedded web server and assets
    final cppContent = '''
#include <windows.h>
#include <string>
#include "webview.h"

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // Initialize WebView2
    auto webview = webview_create(false, nullptr);
    
    // Set window properties
    webview_set_title(webview, "${config.appName}");
    webview_set_size(webview, ${config.windowWidth}, ${config.windowHeight}, WEBVIEW_HINT_NONE);
    
    // Load embedded content
    std::string html_path = get_embedded_asset_path("index.html");
    webview_navigate(webview, ("file:///" + html_path).c_str());
    
    // Run event loop
    webview_run(webview);
    webview_destroy(webview);
    
    return 0;
}
''';
    
    await File('$outputDir/main.cpp').writeAsString(cppContent);
    
    // Generate resource file for icon and manifest
    final rcContent = '''
#define IDI_APP_ICON 101
IDI_APP_ICON ICON "app_icon.ico"
''';
    await File('$outputDir/app.rc').writeAsString(rcContent);
  }

  Future<String?> _compileWindows(String sourceDir) async {
    // Try MSBuild first
    final msbuildResult = await Process.run(
      'msbuild',
      ['/p:Configuration=Release', '/p:Platform=x64'],
      workingDirectory: sourceDir,
    );
    
    if (msbuildResult.exitCode == 0) {
      return '$sourceDir/x64/Release/app.exe';
    }
    
    // Fallback to cl.exe
    final clResult = await Process.run(
      'cl',
      ['/EHsc', '/O2', '/Fe:app.exe', 'main.cpp', 'app.rc'],
      workingDirectory: sourceDir,
    );
    
    if (clResult.exitCode == 0) {
      return '$sourceDir/app.exe';
    }
    
    return null;
  }

  @override
  Future<bool> signExecutable(String executablePath, SigningConfig? config) async {
    if (config == null || config.certificatePath == null) {
      return true; // Skip signing if no config
    }
    
    final result = await Process.run(
      'signtool',
      ['sign', '/f', config.certificatePath!, '/tr', 'http://timestamp.digicert.com', executablePath],
    );
    
    return result.exitCode == 0;
  }
}

/// macOS platform builder using Xcode tools
class MacOSBuilder implements PlatformBuilder {
  @override
  Future<bool> validateEnvironment() async {
    final xcodeSelect = await Process.run('xcode-select', ['-p']);
    return xcodeSelect.exitCode == 0;
  }

  @override
  Future<String?> generateExecutable(String projectPath, BuildConfig config) async {
    try {
      final wrapperDir = Directory('$projectPath/build/macos_wrapper');
      await wrapperDir.create(recursive: true);
      
      // Generate Swift/AppKit wrapper
      await _generateMacOSWrapper(wrapperDir.path, config);
      
      // Build with xcodebuild
      final buildResult = await Process.run(
        'xcodebuild',
        ['-configuration', 'Release', '-derivedDataPath', '${wrapperDir.path}/DerivedData'],
        workingDirectory: wrapperDir.path,
      );
      
      if (buildResult.exitCode == 0) {
        final appName = '${config.outputName}.app';
        final outputPath = '$projectPath/dist/$appName';
        await Directory('$projectPath/dist').create(recursive: true);
        
        // Copy .app bundle
        final appBundle = Directory('${wrapperDir.path}/build/Release/${config.appName}.app');
        if (await appBundle.exists()) {
          await _copyDirectory(appBundle, Directory(outputPath));
          return outputPath;
        }
      }
      
      return null;
    } catch (e) {
      print('macOS build error: $e');
      return null;
    }
  }

  Future<void> _generateMacOSWrapper(String outputDir, BuildConfig config) async {
    // Generate Info.plist
    final infoPlist = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>${config.appName}</string>
    <key>CFBundleIdentifier</key>
    <string>${config.bundleId}</string>
    <key>CFBundleVersion</key>
    <string>${config.version}</string>
    <key>CFBundleShortVersionString</key>
    <string>${config.version}</string>
    <key>CFBundleExecutable</key>
    <string>${config.appName}</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
''';
    
    final contentsDir = Directory('$outputDir/${config.appName}.app/Contents');
    await contentsDir.create(recursive: true);
    await File('${contentsDir.path}/Info.plist').writeAsString(infoPlist);
    
    // Generate Swift main file
    final swiftContent = '''
import Cocoa
import WebKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var webView: WKWebView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create window
        let screen = NSScreen.main!
        let windowRect = NSRect(x: 0, y: 0, width: ${config.windowWidth}, height: ${config.windowHeight})
        window = NSWindow(contentRect: windowRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false)
        window.center()
        window.title = "${config.appName}"
        window.makeKeyAndOrderFront(nil)
        
        // Create WebView
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: window.contentView!.bounds, configuration: config)
        webView.autoresizingMask = [.width, .height]
        
        // Load embedded content
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        window.contentView?.addSubview(webView)
    }
}
''';
    
    final sourcesDir = Directory('$outputDir/Sources');
    await sourcesDir.create(recursive: true);
    await File('${sourcesDir.path}/main.swift').writeAsString(swiftContent);
  }

  @override
  Future<bool> signExecutable(String executablePath, SigningConfig? config) async {
    if (config == null || config.developerId == null) {
      return true;
    }
    
    final result = await Process.run(
      'codesign',
      ['--force', '--deep', '-s', config.developerId!, executablePath],
    );
    
    return result.exitCode == 0;
  }
}

/// Linux platform builder
class LinuxBuilder implements PlatformBuilder {
  @override
  Future<bool> validateEnvironment() async {
    // Check for GTK development libraries and compiler
    final gccResult = await Process.run('which', ['gcc']);
    final pkgConfigResult = await Process.run('pkg-config', ['--exists', 'gtk+-3.0']);
    return gccResult.exitCode == 0 && pkgConfigResult.exitCode == 0;
  }

  @override
  Future<String?> generateExecutable(String projectPath, BuildConfig config) async {
    try {
      final wrapperDir = Directory('$projectPath/build/linux_wrapper');
      await wrapperDir.create(recursive: true);
      
      // Generate C/GTK wrapper
      await _generateLinuxWrapper(wrapperDir.path, config);
      
      // Compile with GCC
      final compileResult = await Process.run(
        'gcc',
        [
          '-o', 'app',
          '-Wall', '-O2',
          '`pkg-config --cflags gtk+-3.0 webkit2gtk-4.0`',
          'main.c',
          '`pkg-config --libs gtk+-3.0 webkit2gtk-4.0`',
        ],
        workingDirectory: wrapperDir.path,
      );
      
      if (compileResult.exitCode == 0) {
        final outputPath = '$projectPath/dist/${config.outputName}';
        await Directory('$projectPath/dist').create(recursive: true);
        await File('$wrapperDir.path/app').copy(outputPath);
        await Process.run('chmod', ['+x', outputPath]);
        return outputPath;
      }
      
      return null;
    } catch (e) {
      print('Linux build error: $e');
      return null;
    }
  }

  Future<void> _generateLinuxWrapper(String outputDir, BuildConfig config) async {
    final cContent = '''
#include <gtk/gtk.h>
#include <webkit2/webkit-web-view.h>
#include <stdlib.h>

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "${config.appName}");
    gtk_window_set_default_size(GTK_WINDOW(window), ${config.windowWidth}, ${config.windowHeight});
    
    WebKitWebView *webview = WEBKIT_WEB_VIEW(webkit_web_view_new());
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(webview));
    
    char *path = g_build_filename(g_get_current_dir(), "assets", "index.html", NULL);
    char *uri = g_strdup_printf("file://%s", path);
    webkit_web_view_load_uri(webview, uri);
    
    g_free(path);
    g_free(uri);
    
    gtk_widget_show_all(window);
}

int main(int argc, char **argv) {
    GtkApplication *app = gtk_application_new("${config.bundleId}", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
''';
    
    await File('$outputDir/main.c').writeAsString(cContent);
  }

  @override
  Future<bool> signExecutable(String executablePath, SigningConfig? config) async {
    // Linux typically doesn't require signing for distribution
    return true;
  }
}

/// Factory to get the appropriate platform builder
PlatformBuilder getPlatformBuilder() {
  if (Platform.isWindows) {
    return WindowsBuilder();
  } else if (Platform.isMacOS) {
    return MacOSBuilder();
  } else if (Platform.isLinux) {
    return LinuxBuilder();
  }
  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await for (final entity in source.list(recursive: true)) {
    final relativePath = entity.path.substring(source.path.length + 1);
    final newPath = '${destination.path}/$relativePath';
    
    if (entity is Directory) {
      await Directory(newPath).create(recursive: true);
    } else if (entity is File) {
      await entity.copy(newPath);
    }
  }
}
