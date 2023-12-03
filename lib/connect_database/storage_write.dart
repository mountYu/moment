import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

//画像をstorageに保存
Future<String> saveImage(imageFile) async {
  print('startupload');
  String fileName =
      'post/${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.jpg';
  TaskSnapshot snapshot =
      await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
  final String downloadUrl = await snapshot.ref.getDownloadURL();
  print('endupload');
  return downloadUrl;
}

//サイズを小さくした画像をstorageに保存
Future<String> saveSmallImage(imageFile) async {
  img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
  img.Image smallImage = img.copyResize(image, width: 80, height: 120);

  Directory tempDir = await getTemporaryDirectory();
  String tempPath = '${tempDir.path}/resized.jpg';
  File(tempPath)..writeAsBytesSync(img.encodeJpg(smallImage));

  String smallFileName =
      'post-small/${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.jpg';
  TaskSnapshot snapshotSmall =
      await FirebaseStorage.instance.ref(smallFileName).putFile(File(tempPath));
  final String smalldownloadUrl = await snapshotSmall.ref.getDownloadURL();
  print('endupload');
  return smalldownloadUrl;
}
