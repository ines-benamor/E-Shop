import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersInfoUpdate extends StatefulWidget {
  @override
  State<UsersInfoUpdate> createState() => _UsersInfoUpdateState();
}

class _UsersInfoUpdateState extends State<UsersInfoUpdate> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isDataChanged = false;

  @override
  void initState() {
    // TODO: implement initState
    getUsersInfoFromFirebase();
  }

  TextEditingController nameController = TextEditingController();

  TextEditingController surnameController = TextEditingController();

  TextEditingController UsersnameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    UsersnameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void getUsersInfoFromFirebase() async {
    User? Users = auth.currentUser;

    if (Users != null) {
      DocumentSnapshot Usersnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(Users.uid)
          .get();

      Map<String, dynamic>? UsersData =
          Usersnapshot.data() as Map<String, dynamic>?;

      if (UsersData != null) {
        setState(() {
          nameController.text = UsersData['name'] ?? '';
          surnameController.text = UsersData['surname'] ?? '';
          UsersnameController.text = UsersData['UsersName'] ?? '';
          emailController.text = UsersData['email'] ?? '';
        });
      }
    }
  }

  Future<void> updateUsersInfoInFirebase() async {
    User? Users = auth.currentUser;

    if (Users != null) {
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(Users.uid)
            .update({
          'name': nameController.text,
          'surname': surnameController.text,
          'Usersname': UsersnameController.text,
          // 'email' alanını güncellemiyoruz, çünkü bu alan değiştirilemez (enabled: false)
        });
        //Provider.of<UsersProvider>(context, listen: false).updateUsers(UsersnameController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kullanıcı bilgileri güncellendi.'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $error'),
          ),
        );
      }
    }
  }

  void onDataChanged() {
    setState(() {
      isDataChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Bilgilerim"),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          Icon(Icons.more_vert),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    onChanged: (value) {
                      onDataChanged();
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.person_outline),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Ad",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: surnameController,
                    onChanged: (value) {
                      onDataChanged();
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.person_outline_outlined),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Soyad",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: UsersnameController,
              onChanged: (value) {
                onDataChanged();
              },
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person_outline),
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: "Kullanıcı Adı",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.mail),
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: "E-Posta",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.pinkAccent.shade100),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(300, 50),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed:
                    isDataChanged ? () => updateUsersInfoInFirebase() : null,
                child: Text("Güncelle")),
          ],
        ),
      ),
    );
  }
}
