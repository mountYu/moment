import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/post.dart';
import '../connect_database/firestore_write.dart';
import '../connect_database/storage_write.dart';
//写真を撮ったら、Storageに画像保存、firestoreに投稿保存

Future<void> uploadImageAndCreatePost() async {
  final user = FirebaseAuth.instance.currentUser!;
  print(user.displayName);
  final ImagePicker _picker = ImagePicker();
  // 写真を撮影
  print('takePicture');
  final XFile? photo =
      await _picker.pickImage(source: ImageSource.camera, imageQuality: 5);
  print('--');
  if (photo != null) {
    File imageFile = File(photo.path);
    String downloadUrl = await saveImage(imageFile);
    String smalldownloadUrl = '';
    // String smalldownloadUrl = await saveSmallImage(imageFile);
    // Firestoreに新しいPostを作成
    Post newPost = Post(
      userId: user.uid,
      storageUrl: downloadUrl,
      smallStorageUrl: smalldownloadUrl,
      createdAt: Timestamp.now(),
    );
    uploadUserPost(newPost);
  }
}
