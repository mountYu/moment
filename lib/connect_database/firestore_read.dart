import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

Future<List<Post>> getUserPosts(String userId) async {
  // ユーザーのpostsサブコレクションへの参照を取得
  CollectionReference postsRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('posts');

  // クエリを実行し、スナップショットを取得
  QuerySnapshot querySnapshot = await postsRef.get();

  // スナップショットからPostのリストを作成
  List<Post> posts = querySnapshot.docs.map((doc) {
    return Post.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>, userId);
  }).toList();

  return posts;
}
