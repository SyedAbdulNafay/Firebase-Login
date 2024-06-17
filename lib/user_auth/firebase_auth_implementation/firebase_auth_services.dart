import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(
            msg: "Email already in use",
            backgroundColor: const Color.fromARGB(255, 113, 82, 167),
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Error: $e",
            backgroundColor: const Color.fromARGB(255, 113, 82, 167),
            textColor: Colors.white);
      }
    }

    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Invalid email or password",
            backgroundColor: const Color.fromARGB(255, 113, 82, 167),
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Error: $e",
            backgroundColor: const Color.fromARGB(255, 113, 82, 167),
            textColor: Colors.white);
      }
    }

    return null;
  }

  signInWithCredential(AuthCredential credential) async {
    await _auth.signInWithCredential(credential);
  }
}
