
import 'package:flutter/material.dart';
import 'package:memo/models/memo_model.dart';

class CreateMemoPage extends StatefulWidget {
  const CreateMemoPage({super.key, required this.onNewNoteCreated});

  final Function(Memo) onNewNoteCreated;

  @override
  State<CreateMemoPage> createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(
                fontSize: 28,
              ),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Title"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: bodyController,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Your Story"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          if (titleController.text.isEmpty) {
            return;
          }
          if (bodyController.text.isEmpty) {
            return;
          }
          final note =
              Memo(body: bodyController.text, title: titleController.text,createdAt: DateTime.now(), id: '');
       
          widget.onNewNoteCreated(note);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 140, 177, 207)
              ,content: Text("Note Saved!",)),
          );
          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
