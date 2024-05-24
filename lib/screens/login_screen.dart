import 'package:carpio_boardingbuddy/auth/auth.dart';
import 'package:carpio_boardingbuddy/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void loginUser() async {
   
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Enter Credentials',
      );
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Authentication()));
    } on FirebaseAuthException catch (e) {
      print(e);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Invalid Credentials. Try Again',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 35,
          left: 15,
          right: 15,
          bottom: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 280,
                width: double.infinity,
                child: Image.asset('assets/images/1.png'),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Login and Enjoy BoardingBuddy',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    label: Text('Email'),
                    hintText: 'example@gmail.com'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(13),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(13),
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  label: const Text('Password'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
