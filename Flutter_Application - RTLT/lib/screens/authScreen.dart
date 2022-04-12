import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realtime/widget/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isloading = false;

  final _auth = FirebaseAuth.instance;
  void submit(String email, String pass, String username, bool isLogin,
      BuildContext ctx) async {
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
          'username': username,
          'email': email,
        });
      }
      setState(() {
        _isloading = false;
      });
    } on PlatformException catch (msg) {
      String? errorMsg = "Something is wrong, Please check your credentials";
      if (msg.message!.isNotEmpty) {
        errorMsg = msg.message;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMsg!),
        ),
      );
      setState(() {
        _isloading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 2),
        ),
      );
      print(error);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: AuthForm(submit, _isloading),
    );
  }
}
