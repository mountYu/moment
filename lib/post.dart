import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.storageUrl,
    required this.createdAt,
  });

  final String storageUrl;
  final Timestamp createdAt;
}
