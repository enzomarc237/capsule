import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

import 'note.dart';

class NoteRepository {
  NoteRepository._(this._box);

  static const String defaultBoxName = 'notes';
  static const String _nextIdKey = '__meta_next_id__';

  final Box<dynamic> _box;

  static Future<NoteRepository> open({
    String? storagePath,
    String boxName = defaultBoxName,
  }) async {
    final resolvedPath = storagePath ?? p.join(Directory.current.path, '.capsule_notes');
    await Directory(resolvedPath).create(recursive: true);
    Hive.init(resolvedPath);
    final box = await Hive.openBox<dynamic>(boxName);
    return NoteRepository._(box);
  }

  Future<List<Note>> listNotes() async {
    final notes = <Note>[];
    for (final key in _box.keys) {
      if (key is int) {
        final value = _box.get(key);
        if (value is Map) {
          notes.add(Note.fromJson(value));
        }
      }
    }
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  Future<Note> save(Note note) async {
    final now = DateTime.now();
    final noteId = note.id ?? await _nextId();
    final persisted = note.copyWith(
      id: noteId,
      createdAt: note.id == null ? now : note.createdAt,
      updatedAt: now,
    );

    await _box.put(noteId, persisted.toJson());
    return persisted;
  }

  Future<void> delete(int noteId) async {
    await _box.delete(noteId);
  }

  Future<void> close() async {
    await _box.close();
  }

  Future<int> _nextId() async {
    final current = (_box.get(_nextIdKey, defaultValue: 1) as int?) ?? 1;
    await _box.put(_nextIdKey, current + 1);
    return current;
  }
}
