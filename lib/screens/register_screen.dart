import 'package:carpio_boardingbuddy/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    bool passwordConfirmed() {
      if (passwordController.text.trim() == confirmController.text.trim()) {
        return true;
      } else {
        return false;
      }
    }

    void registerUser() async {
      if (!passwordConfirmed()) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Password not matched');
        return;
      }
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        final User? user = FirebaseAuth.instance.currentUser;
        final _uid = user?.uid;

        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'first name': firstnameController.text.trim(),
          'last name': lastnameController.text.trim(),
          'email': emailController.text.trim(),
          'boarding id': '',
        });
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      } catch (error) {
        Navigator.of(context).pop();
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Invalid Credentials');
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LoginScreen(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 5,
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
                child: Image.asset('assets/images/3.png'),
              ),
              Text(
                'Welcome new user',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Login and Enjoy BoardingBuddy',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: firstnameController,
                decoration: InputDecoration(
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
                  label: Text('First Name'),
                  hintText: 'Christopherson',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: lastnameController,
                decoration: InputDecoration(
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
                  label: Text('Last Name'),
                  hintText: 'Carpio',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
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
                  hintText: 'cicici@gmail.com',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
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
                  label: Text('Password'),
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
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: confirmController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
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
                  label: Text('Confirm Password'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.loading,
                      title: 'Registering your account...');
                  registerUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
