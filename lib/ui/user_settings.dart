import 'package:flutter/material.dart';
import 'package:e_shop/ui/User_info_update.dart';
import 'package:e_shop/ui/User_password_update.dart';

class UsersettingsScreen extends StatelessWidget {
  const UsersettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    final double width = screenSize.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Ayarları"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildCategoryTile(context, "Kullanıcı Bilgilerim", Icons.person_2,
                width, UsersInfoUpdate()),
            //buildCategoryTile(context, "Adres Bilgilerim", Icons.home, width,UsersInfoUpdate()),
            buildCategoryTile(context, "E-Posta değişikliği", Icons.mail, width,
                UsersInfoUpdate()),
            buildCategoryTile(context, "Şifre değişikliği", Icons.password,
                width, UsersPasswordUpdate()),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryTile(BuildContext context, String title, IconData icon,
      double width, Widget destinationScreen) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
        child: Container(
          color: Colors.white,
          width: width,
          child: ListTile(
            leading: Icon(icon),
            title: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
