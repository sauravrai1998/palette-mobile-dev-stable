import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthRepo {
  FirebaseAuthRepo._privateConstructor();
  static final FirebaseAuthRepo instance =
      FirebaseAuthRepo._privateConstructor();

  Future<String> createAccountFirebase(
    String email,
    String password,
    String? firstName,
    String? lastName,
  ) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        print('Unable to register in firebase');
        throw CustomException('Unable to register, please again try later.');
      }

      final uid = userCredential.user!.uid;

      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: firstName != null ? firstName : " ",
          id: uid,
          lastName: lastName != null ? lastName : " ",
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString(roleFromUserExistAPIKey);
      if (role != null && role.isNotEmpty) {
        _postRoleString(uid: uid, role: role);
      }
      return uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('The account already exists for that email.');
      } else {
        throw CustomException(e.toString());
      }
    } on SocketException {
      throw CustomException('No Internet connection');
    } on HttpException {
      throw CustomException('Something went wrong');
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  _postRoleString({required String uid, required String role}) async {
    final json =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final jsonData = json.data();

    if (jsonData == null) return;
    jsonData['role'] = role;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(jsonData, SetOptions(merge: false));
  }

  Future loginFirebase(String email, String password) async {
    print('The user wants to login with $email and $password : Firebase');

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        print('Unable to login in firebase');
        throw CustomException('Unable to login, please again try later.');
      }

      final uid = FirebaseChatCore.instance.firebaseUser!.uid;
      final json =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final firstName = json['firstName'];
      final lastName = json['lastName'];
      final profilePicture = json['avatarUrl'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(fullNameConstant, firstName + ' ' + lastName);
      await prefs.setString(profilePictureConstant, profilePicture ?? '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw CustomException('Wrong password provided for that user.');
      }
    }
  }
}
