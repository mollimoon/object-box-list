import 'package:flutter/material.dart';
import 'note.dart';
import 'notes_repository.dart';

///В-третьих, нам нужен сам экран для отображения записей

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    _notesRepo
        .initDB() //initial
        .whenComplete(() =>
            setState(() => _notes = _notesRepo.notes)); //refresh when complete
  }

  late final _notesRepo = NotesRepository();
  late var _notes = <Note>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(
            _notes[i].name,
          ),
          subtitle: Text(
            _notes[i].description,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showDialog(
                    name: _notes[i].name,
                    description: _notes[i].description,
                    actionButtonText: 'Save',
                    onActionButtonPressed:
                        (String name, String description) async {
                      await _notesRepo.updateNote(
                        oldNote: _notes[i],
                        newNote: Note(
                          name: name,
                          description: description,
                        ),
                      );
                      setState(() {
                        _notes = _notesRepo.notes;
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _notesRepo.deleteNote(_notes[i]); //передается чтобы удалиться
                  setState(() {
                    _notes = _notesRepo.notes; // update _notes by updated _notesRepo.notes
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showDialog(
          actionButtonText: 'Add',
          onActionButtonPressed: (String name, String description) async {
            await _notesRepo.addNote(
              Note(
                name: name,
                description: description,
              ),
            );
            setState(() {
              _notes = _notesRepo.notes;
              Navigator.pop(context);
            });
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showDialog({
    String name = '', //начальный текст контроллера
    String description = '', //если нет данных, будет пустая заметка
    required String actionButtonText,
    required void Function(String name, String description)
        onActionButtonPressed, //callback
  }) =>
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController(text: name);
          final descController = TextEditingController(text: description);
          return AlertDialog(
            title: const Text('New note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => onActionButtonPressed(
                  nameController.text,
                  descController.text,
                ),
                child: Text(actionButtonText),
              ),
            ],
          );
        },
      );
}
