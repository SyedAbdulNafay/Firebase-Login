import 'package:app/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:app/user_auth/presentation/views/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool password = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      "Sign ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Text(
                      "Up",
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
                  style: const TextStyle(color: Colors.white),
                  controller: _usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: "    Username",
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
                const SizedBox(
                  height: 20,
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
                  obscureText: password,
                  style: const TextStyle(color: Colors.white),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.white),
                      contentPadding: const EdgeInsets.only(right: 10, top: 15, left: 30, bottom: 15),
                      suffix: IconButton(
                        iconSize: 20,
                        icon: Icon(
                          password ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          password = !password;
                          setState(() {});
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      filled: true,
                      fillColor: Colors.grey[800],
                      hintText: "    Password",
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      _signUp();
                    }
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 113, 82, 167),
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
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

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Sign Up Failed")));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
