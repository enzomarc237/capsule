import 'dart:async';

import 'package:riverpod/riverpod.dart';

import 'note.dart';
import 'note_repository.dart';
import 'notes_state.dart';

class NoteNotifier extends StateNotifier<NotesState> {
  NoteNotifier(this._repository) : super(const NotesState());

  static const Duration autosaveDelay = Duration(milliseconds: 500);

  final NoteRepository _repository;
  Timer? _autosaveTimer;

  Future<void> loadNotes() async {
    state = state.copyWith(isLoading: true);
    final notes = await _repository.listNotes();
    state = state.copyWith(notes: notes, isLoading: false);
  }

  void startEditing({Note? note}) {
    final now = DateTime.now();
    state = state.copyWith(
      editingNote: note ??
          Note(
            title: '',
            content: '',
            createdAt: now,
            updatedAt: now,
          ),
    );
  }

  void updateDraft({
    String? title,
    String? content,
  }) {
    final current = state.editingNote;
    if (current == null) {
      startEditing();
      return updateDraft(title: title, content: content);
    }

    state = state.copyWith(
      editingNote: current.copyWith(
        title: title ?? current.title,
        content: content ?? current.content,
        updatedAt: DateTime.now(),
      ),
    );

    _scheduleAutosave();
  }

  Future<Note?> saveNow() async {
    _autosaveTimer?.cancel();
    return _persistEditingNote();
  }

  Future<void> deleteNote(int noteId) async {
    await _repository.delete(noteId);
    final notes = await _repository.listNotes();
    final clearEdited = state.editingNote?.id == noteId;
    state = state.copyWith(
      notes: notes,
      clearEditingNote: clearEdited,
    );
  }

  void _scheduleAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(autosaveDelay, () async {
      await _persistEditingNote();
    });
  }

  Future<Note?> _persistEditingNote() async {
    final editing = state.editingNote;
    if (editing == null) {
      return null;
    }

    final hasText = editing.title.trim().isNotEmpty || editing.content.trim().isNotEmpty;
    if (!hasText) {
      return null;
    }

    final persisted = await _repository.save(editing);
    final notes = await _repository.listNotes();
    state = state.copyWith(notes: notes, editingNote: persisted);
    return persisted;
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    super.dispose();
  }
}

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  throw UnimplementedError('Override noteRepositoryProvider with an initialized NoteRepository.');
});

final noteNotifierProvider = StateNotifierProvider<NoteNotifier, NotesState>((ref) {
  return NoteNotifier(ref.watch(noteRepositoryProvider));
});
