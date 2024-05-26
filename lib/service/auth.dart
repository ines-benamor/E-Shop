import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_shop/models/users.dart' as model;
import 'package:e_shop/ui/login/login-screen.dart';
import '../models/wallet.dart';
import 'package:http/http.dart' as http;

class AuthService {
  late User user;
  late Timer timer;

  final userCollection = FirebaseFirestore.instance.collection("users");

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserId() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        // Kullanıcı oturum açmamışsa null dönebilirsiniz.
        print("oturuöööö");
        return null;
      }
    } catch (e) {
      print("Kullanıcı kimliği alınırken hata oluştu: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      User? user = auth.currentUser;

      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        return userData;
      } else {
        // User not signed in
        return null;
      }
    } catch (e) {
      print("Error while getting user data: $e");
      return null;
    }
  }

  Future<bool> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      // Get the current user
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: currentUser.email!, password: currentPassword);
        await currentUser.reauthenticateWithCredential(credential);
        // Update the password
        await currentUser.updatePassword(newPassword);
        return true; // Password update successful
      } else {
        print('User is not logged in');
        return false; // User is not logged in
      }
    } on FirebaseAuthException catch (e) {
      print('Error updating password: $e');
      return false; // Password update failed
    }
  }

  Future<String?> getCurrentUsername() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        return userData?['userName'];
      } else {
        // Kullanıcı oturum açmamışsa null dönebilirsiniz.
        return null;
      }
    } catch (e) {
      print("Kullanıcı adı alınırken hata oluştu: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final url =
        Uri.parse('http://dummyjson.com/users/filter?key=email&value=$email');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['users'] != null && responseData['users'].isNotEmpty) {
        return responseData['users'][0]; // Return the first matching user
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
    }
  }

  Future<void> registerUserToApi({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
  }) async {
    final url = Uri.parse('http://dummyjson.com/users/add');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
    } else {
      print('Failed to register user: ${response.reasonPhrase}');
    }
  }

  Future<String> signupUser({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred!";
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          name.isNotEmpty &&
          surname.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = cred.user!.uid;
        String modifiedUsername = '$username-$uid';
        print(uid);
        await registerUserToApi(
          firstName: name,
          lastName: surname,
          email: email,
          username: modifiedUsername,
        );

        res = "success";
      }
    } catch (err) {
      print('Hata yakalandı: $err');
      res = err.toString();
    }
    return res;
  }
  //login in user

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured!";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (credential.user != null) {
          res = "success";
        } else {
          res = "Tüm alanları doldurun.";
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<Wallet> getWallet(String userId) async {
    DocumentSnapshot walletSnapshot =
        await _firestore.collection("wallets").doc(userId).get();

    return Wallet.fromSnap(walletSnapshot);
  }

  Future<void> updateWalletBalance(String userId, String newBalance) async {
    // Update the 'price' field in the 'wallets' collection
    await _firestore
        .collection("wallets")
        .doc(userId)
        .update({"price": newBalance});
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut(BuildContext context) async {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Çıkış Yap'),
          content: Text('Çıkış yapmak istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Evet',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                try {
                  await auth.signOut();
                  Fluttertoast.showToast(
                    msg: "Çıkış yapıldı",
                    toastLength: Toast.LENGTH_LONG,
                  );
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
