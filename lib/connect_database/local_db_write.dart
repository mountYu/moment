//自分の新しい投稿の際に呼び出される関数
//(先にballは追加される。)

import 'package:moment/models/post.dart';
//画像とpostクラスのデータを受け取る
//オリジナル画像をposts/に保存
//80px80pxの画像をposts-small/uid+smallimageUrlに保存
//postクラスのデータをuidを含めてローカルのDBに保存

//onLoadの時に呼び出される関数。
//先にlocal_db_readによって、ballは追加される。
//local_db_readの後に、firestoreにあるのにローカルになかったPostクラスのデータを受け取る。
//Postクラスのデータを受け取る
//ローカルのディレクトリに、posts-small/smallimageUrlで画像を保存する
//ローカルのDBにPostクラスのデータをuidを含めて保存する。

// Future<void> saveOnlyFirestoreToLocal(Post post) {
//   String localSmallImagePath = post.userId + post.smallStorageUrl;
// }


//24時間以前のPostデータをposts/から削除
//24時間以前のオリジナル画像をposts/から削除
//24時間以前の画像を80px80pxの画像をposts-small/から削除
