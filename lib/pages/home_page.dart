import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo/models/memo_model.dart';
import 'package:memo/pages/create_memo_page.dart';
import 'package:memo/pages/profile_page.dart';
import 'package:memo/provider/memo_provider.dart';
import 'package:memo/widgets/memo_card.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  String _formatDate(DateTime dateTime) {
    final DateFormat dayformatter = DateFormat('EEE');
    final DateFormat dateformatter = DateFormat('MMM d, y');
    return "${dayformatter.format(dateTime)},\n${dateformatter.format(dateTime)}";
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Memo memo) {
    TextEditingController titleController =
        TextEditingController(text: memo.title);
    TextEditingController bodyController =
        TextEditingController(text: memo.body);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Memo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: bodyController,
                  decoration: InputDecoration(labelText: "Your text here"),
                  maxLines: 3,
                )
              ],
            ),
            actions: [TextButton(onPressed: ()=>Navigator.pop(context), 
            child: const Text("Cancel")),
            ElevatedButton(onPressed: (){
              final updatedMemo = memo.copyWith(
                title: titleController.text,
                body: bodyController.text,
                createdAt: DateTime.now()
              );
              ref.read(memoProvider.notifier).updateMemo(updatedMemo);
              Navigator.pop(context);
            }, child: Text("Save"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memos = ref.watch(memoProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            icon: Icon(Icons.person_2_outlined),
          )
        ],
        title: const Text("Memo"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: memos.isEmpty
          ? Center(child: Text("No memos available"))
          : ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                  title: MemoCard(
                    note: memos[index],
                    onNoteDeleted: (String memoId) {
                      ref.read(memoProvider.notifier).deleteMemo(memoId);
                    },
                    onNoteTapped: (){
                      _showEditDialog(context, ref, memos[index]);
                    }
                  ),
                  trailing: Text(
                    _formatDate(memos[index].createdAt),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMemoPage(
                onNewNoteCreated: (memo) {
                  ref.read(memoProvider.notifier).addMemo(memo);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
