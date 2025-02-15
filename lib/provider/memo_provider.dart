import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo/models/memo_model.dart';

final memoProvider = StateNotifierProvider<MemoNotifier, List<Memo>>((ref) {
  return MemoNotifier();
});

class MemoNotifier extends StateNotifier<List<Memo>> {
  MemoNotifier() : super([]) {
    _loadMemos();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loadMemos() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final memoSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('memos')
          .orderBy('createdAt', descending: true)
          .get();

      final fetchedMemos = memoSnapshot.docs.map((doc) {
        return Memo.fromMap(doc.data(), doc.id);
      }).toList();

      state = fetchedMemos;
    } catch (e) {
      print("Error loading memos: $e");
    }
  }

  Future<void> addMemo(Memo memo) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final docRef = await _firestore.collection('users').doc(user.uid).collection('memos').add({
        'title': memo.title,
        'body': memo.body,
        'createdAt': memo.createdAt.millisecondsSinceEpoch,
      });

      state = [...state, memo.copyWith(id: docRef.id)];
    } catch (e) {
      print("Error saving memo: $e");
    }
  }

  Future<void> deleteMemo(String memoId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).collection('memos').doc(memoId).delete();
      state = state.where((memo) => memo.id != memoId).toList();
    } catch (e) {
      print("Error deleting memo: $e");
    }
  }

  Future<void> updateMemo (Memo updatedMemo)async{
    final user = _auth.currentUser;
    if(user == null)return;

    try {
      await _firestore
      .collection('users')
      .doc(user.uid)
      .collection('memos')
      .doc(updatedMemo.id)
      .update(updatedMemo.toMap());

      state = state.map((memo)=> memo.id == updatedMemo.id ? updatedMemo: memo).toList();
    } catch (e) {
      print("Error updating memo $e");
    
    }
  }
}
