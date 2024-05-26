import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/providers/user_provider.dart';
import 'package:e_shop/service/auth.dart';

class ProfileScreen extends StatefulWidget {
  final String email; // Assume we are passing email to fetch user

  const ProfileScreen({super.key, required this.email});

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
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Display user data
                Text('Name: ${user.name} ${user.surname}'),
                Text('Email: ${user.email}'),
                Text('Username: ${user.username}'),
                // Other UI elements
              ],
            ),
    );
  }
}
