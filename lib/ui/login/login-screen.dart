import 'package:e_shop/ui/home-screen.dart';
import 'package:e_shop/widgets/color_data.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/service/auth.dart';
import 'package:e_shop/ui/login/register-screen.dart';
import 'package:e_shop/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _isLoading = false;

  bool rememberMe = false;

  var obscureText = true;

  @override
  void initState() {
    super.initState();
    retrieveRememberMeState();
  }

  AuthService authservice = AuthService();

  Future<void> signInWithGoogle() async {
    try {
      await authservice.signInWithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthService().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == 'success') {
      // Beni Hatırla seçeneğini sakla
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', rememberMe);

      if (rememberMe) {
        // Eğer hatırla seçeneği işaretliyse, e-posta ve şifreyi kaydet
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      } else {
        // Eğer hatırla seçeneği işaretli değilse önceki bilgileri temizle
        prefs.remove('email');
        prefs.remove('password');
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      showSnackBar(context, res);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void retrieveRememberMeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 50,
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1,
                        right: 20,
                        left: 20,
                      ),
                      child: Column(
                        children: [
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
                          const SizedBox(
                            height: 30,
                          ),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text("Se souvenir de moi"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Mot de passe oublié",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              getAccentColor(context),
                            ),
                            fixedSize: MaterialStateProperty.all<Size>(
                              Size(300, 50),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            loginUsers();
                          },
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "Connexion",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Pas encore inscrit ?",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "S'inscrire",
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
