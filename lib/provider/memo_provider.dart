import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo/models/memo_model.dart';

final memoProvider = StateNotifierProvider<MemoNotifier, AsyncValue<List<Memo>>>((ref) {
  return MemoNotifier(ref);
});

class MemoNotifier extends StateNotifier<AsyncValue<List<Memo>>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  MemoNotifier(Ref ref) : super(const AsyncValue.loading()) {
    // Listen to authentication state changes
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _loadMemos(user.uid); // Load memos for the new user
      } else {
        state = const AsyncValue.data([]); // Clear memos when logged out
      }
    });
  }

  // Load memos for the logged-in user
  Future<void> _loadMemos(String userId) async {
    try {
      final memoSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('memos')
          .orderBy('createdAt', descending: true)
          .get();

      final fetchedMemos = memoSnapshot.docs.map((doc) {
        return Memo.fromMap(doc.data(), doc.id);
      }).toList();

      state = AsyncValue.data(fetchedMemos); // Update state with fetched memos
    } catch (e) {
      state = AsyncValue.error('Failed to load memos',StackTrace.current);
      print("Error loading memos: $e");
    }
  }

  // Add a new memo
  Future<void> addMemo(Memo memo) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final docRef = await _firestore.collection('users').doc(user.uid).collection('memos').add({
        'title': memo.title,
        'body': memo.body,
        'createdAt': memo.createdAt.millisecondsSinceEpoch,
      });

      state = state.whenData((memos) => [...memos, memo.copyWith(id: docRef.id)]);
    } catch (e) {
      print("Error saving memo: $e");
    }
  }

  // Delete a memo
  Future<void> deleteMemo(String memoId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).collection('memos').doc(memoId).delete();
      state = state.whenData((memos) => memos.where((memo) => memo.id != memoId).toList());
    } catch (e) {
      print("Error deleting memo: $e");
    }
  }

  // Update a memo
  Future<void> updateMemo(Memo updatedMemo) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('memos')
          .doc(updatedMemo.id)
          .update(updatedMemo.toMap());

      state = state.whenData((memos) =>
          memos.map((memo) => memo.id == updatedMemo.id ? updatedMemo : memo).toList());
    } catch (e) {
      print("Error updating memo: $e");
    }
  }
}
