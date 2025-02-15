import 'package:flutter/material.dart';
import 'package:memo/models/memo_model.dart';

class MemoCard extends StatelessWidget {
  final Memo note;
  final void Function(String memoId) onNoteDeleted;
  final VoidCallback onNoteTapped; 

  const MemoCard({
    Key? key,
    required this.note,
    required this.onNoteDeleted,
    required this.onNoteTapped 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onNoteTapped,
      child: Card(
        child: ListTile(
          title: Text(note.title),
          subtitle: Text(note.body),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => onNoteDeleted(note.id), 
          ),
        ),
      ),
    );
  }
}
