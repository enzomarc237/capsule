import 'note.dart';

class NotesState {
  const NotesState({
    this.notes = const <Note>[],
    this.editingNote,
    this.isLoading = false,
  });

  final List<Note> notes;
  final Note? editingNote;
  final bool isLoading;

  NotesState copyWith({
    List<Note>? notes,
    Note? editingNote,
    bool clearEditingNote = false,
    bool? isLoading,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      editingNote: clearEditingNote ? null : (editingNote ?? this.editingNote),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
