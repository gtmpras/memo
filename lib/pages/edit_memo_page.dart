

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:memo/models/memo_model.dart';
// import 'package:memo/provider/memo_provider.dart';

// class EditMemoPage extends ConsumerStatefulWidget{
//   final Memo memo;
//   const EditMemoPage({super.key, required this.memo});

//   @override
//   ConsumerState<EditMemoPage> createState()=> _EditMemoPageState();
// }

// class _EditMemoPageState extends ConsumerState<EditMemoPage> {
//   late TextEditingController _titleController;
//   late TextEditingController _bodyController;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _titleController = TextEditingController(text: widget.memo.title);
//     _bodyController = TextEditingController(text: widget.memo.body);
    
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     _titleController.dispose();
//     _bodyController.dispose();
//     // TODO: implement dispose
//   }
  

//   void _updateMemo(){
//     final userId = _auth.currentUser?.uid;
//     if(userId == null) return;

//     final updatedMemo = widget.memo.copyWith(
//       title: _titleController.text,
//       body: _bodyController.text,
//       createdAt: DateTime.now(),
//     );

//     ref.read(memoProvider.notifier).updateMemo(userId, updatedMemo);
//     Navigator.of(context).pop();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: const Text("Edit Memo"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _updateMemo,
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: "Title"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _bodyController,
//               decoration: const InputDecoration(labelText: "Body"),
//               maxLines: 5,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:memo/models/memo_model.dart';

class EditMemoPage extends StatefulWidget {
  final Memo memo;
  final Function(Memo) onMemoUpdated;

  const EditMemoPage({Key? key, required this.memo, required this.onMemoUpdated})
      : super(key: key);

  @override
  _EditMemoPageState createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memo.title);
    _bodyController = TextEditingController(text: widget.memo.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveMemo() {
    final updatedMemo = widget.memo.copyWith(
      title: _titleController.text,
      body: _bodyController.text,
      createdAt: DateTime.now(), 
    );

    widget.onMemoUpdated(updatedMemo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Memo"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMemo,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: "Body"),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
