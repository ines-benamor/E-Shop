import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/ui/login/login-screen.dart';
import 'package:http/http.dart' as http;

class AuthService {
  late User user;
  late Timer timer;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> getCurrentUserId() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        print("L'utilisateur n'est pas connecté");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'ID utilisateur: $e");
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
        return responseData['users'][0];
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } else {
      throw Exception(
          'Échec de la récupération des données utilisateur: ${response.reasonPhrase}');
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
      print(
          'Échec de l\'enregistrement de l\'utilisateur: ${response.reasonPhrase}');
    }
  }

  Future<String> signupUser({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
  }) async {
    String res = "Une erreur s'est produite!";
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
      print('Erreur capturée: $err');
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Une erreur s'est produite!";

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
          res = "Veuillez remplir tous les champs.";
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut(BuildContext context) async {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Oui',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                try {
                  await auth.signOut();
                  Fluttertoast.showToast(
                    msg: "Déconnexion réussie",
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
