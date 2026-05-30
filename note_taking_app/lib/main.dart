import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(const _NotesApp());
}

class _NotesApp extends StatelessWidget {
  const _NotesApp();

  @override
  Widget build(BuildContext context) {
    return const MacosApp(
      debugShowCheckedModeBanner: false,
      home: MacosWindow(
        child: SizedBox.expand(),
      ),
    );
  }
}
