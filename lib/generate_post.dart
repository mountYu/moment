import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:io';
import 'post.dart';

Future<void> uploadImageAndCreatePost() async {
  final user = FirebaseAuth.instance.currentUser!;
  final ImagePicker _picker = ImagePicker();
  // 写真を撮影
  print('takePicture');
  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    // Firebase Storageに写真をアップロード
    print('imageUploadStart');
    File imageFile = File(photo.path);
    String fileName =
        'post/${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.jpg';
    TaskSnapshot snapshot =
        await FirebaseStorage.instance.ref(fileName).putFile(imageFile);

    print('imageUploadEnd');

    // 写真のURLを取得
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    print('createPostStart');
    // Firestoreに新しいPostを作成
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    Post newPost = Post(
      storageUrl: downloadUrl,
      createdAt: Timestamp.now(),
    );
    await userDocRef.set({newPost});
  }
}
