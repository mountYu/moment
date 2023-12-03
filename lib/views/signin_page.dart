import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'pops_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> signInWithGoogle() async {
    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Google Sign In'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.black), // ボタンの背景色を黒に設定
            foregroundColor:
                MaterialStateProperty.all(Colors.white), // テキスト色を白に設定
            // ここでボタンのボーダーを設定
            side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
          ),
          onPressed: () async {
            await signInWithGoogle();

            print(FirebaseAuth.instance.currentUser?.displayName);

            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return MomentWidget();
              }), (route) => false);
            }
          },
          child: const Text('Google Sign In'),
        ),
      ),
    );
  }
}
