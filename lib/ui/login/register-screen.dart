import 'package:e_shop/widgets/color_data.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/service/auth.dart';
import 'package:e_shop/ui/login/login-screen.dart';
import 'package:e_shop/utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var UsersNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _isLoading = false;

  var obscureText = true;

  AuthService authservice = AuthService();

  @override
  void dispose() {
    super.dispose();
    UsersNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    surnameController.dispose();
  }

  void signUpUsers() async {
    setState(() {
      _isLoading = true;
    });

    // signup Users using our authmethodds
    String res = await AuthService().signupUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        username: UsersNameController.text,
        surname: surnameController.text);

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));

      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
      clearTextFields();
    }
  }

  void clearTextFields() {
    nameController.clear();
    surnameController.clear();
    UsersNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60, bottom: 10),
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.person_outline),
                              fillColor: Colors.transparent,
                              filled: true,
                              hintText: "Prénom",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: surnameController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.person_outline_outlined),
                              fillColor: Colors.transparent,
                              filled: true,
                              hintText: "Nom",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: UsersNameController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.person_outline),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Nom d'utilisateur",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.mail),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "E-mail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          child: obscureText
                              ? Icon(Icons.key_off)
                              : Icon(Icons.key),
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Mot de passe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            getAccentColor(context)),
                        fixedSize: MaterialStateProperty.all<Size>(
                          const Size(300, 50),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        signUpUsers();
                        //registerWithEmailAndPassword();
                      },
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "S'inscrire",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Vous avez déjà un compte ?",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Connexion",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
