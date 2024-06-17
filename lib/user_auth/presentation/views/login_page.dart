import 'package:app/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:app/user_auth/presentation/views/homepage.dart';
import 'package:app/user_auth/presentation/views/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool password = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Text(
                      "Back",
                      style: TextStyle(
                          color: Color.fromARGB(255, 136, 103, 192),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.white),
                      contentPadding: const EdgeInsets.only(
                          left: 30, right: 10, top: 20, bottom: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: "    Your email",
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    if (value.length < 8) {
                      return "Password must be 6 characters long";
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  obscureText: password,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.white),
                      contentPadding: const EdgeInsets.only(
                          left: 30, top: 8, right: 10, bottom: 8),
                      suffix: IconButton(
                        iconSize: 20,
                        icon: password
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          password = !password;
                          setState(() {});
                        },
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: "    Password",
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?  ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage())),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              color: Color.fromARGB(255, 136, 103, 192)),
                        ))
                  ],
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      _signIn();
                    }
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 113, 82, 167),
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Log in",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _signInWithGoogle,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 60,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.blue[900],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign Up With Google",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Failed")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
