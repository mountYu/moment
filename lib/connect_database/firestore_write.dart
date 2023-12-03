import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

Future<void> uploadUserPost(Post post) async {
  // ユーザーのpostsサブコレクションへの参照を取得

  CollectionReference postsRef = FirebaseFirestore.instance
      .collection('users')
      .doc(post.userId)
      .collection('posts');

  // 新しいドキュメントを追加
  await postsRef.add(post.toMap());
  print('endupload');
}
