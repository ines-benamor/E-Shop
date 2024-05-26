import 'package:e_shop/providers/user_provider.dart';
import 'package:e_shop/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserByEmail(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Nom: ${user.name} ${user.surname}'),
          Text('Email: ${user.email}'),
          Text('Nom d\'utilisateur: ${user.username}'),
        ],
      ),
    );
  }
}
