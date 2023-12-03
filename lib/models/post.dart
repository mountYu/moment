import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(
      {required this.userId,
      required this.storageUrl,
      required this.smallStorageUrl,
      required this.createdAt});

  final String userId;
  final String storageUrl;
  final String smallStorageUrl;
  final Timestamp createdAt;

  factory Post.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot, userId) {
    final map = snapshot.data()!;
    return Post(
        userId: userId,
        storageUrl: map["storageUrl"],
        smallStorageUrl: map["smallStorageUrl"],
        createdAt: map["createdAt"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'storageUrl': storageUrl,
      'smallStorageUrl': storageUrl,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toLocalMap(String userId) {
    return {
      'userId': userId,
      'storageUrl': storageUrl,
      'smallStorageUrl': storageUrl,
      'createdAt': createdAt,
    };
  }
}
