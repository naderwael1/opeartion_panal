// Import necessary packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../emp_features/presentation/all_emp_screen.dart';

// Add your Facebook and Google client IDs here
const String facebookClientId = 'YOUR_FACEBOOK_CLIENT_ID';
const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final mail = TextEditingController();
  final pass = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // Logged in successfully
        // Handle further actions
      } else {
        // Login failed
        // Handle error
      }
    } catch (e) {
      print('Facebook login error: $e');
      // Handle error
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Logged in successfully
        // Handle further actions
      } else {
        // Login failed
        // Handle error
      }
    } catch (e) {
      print('Google login error: $e');
      // Handle error
    }
  }

  Future<void> passLoginData() async {
    final response = await http.post(
      Uri.parse("https://4000/admin/auth/login"),
      body: {"email": mail.text, "pass": pass.text},
    );
    // Handle response
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "you must put your mail";
                        }
                        if (!RegExp(
                            r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      controller: mail,
                      //obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Employee mail',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "you must put your pass";
                        }
                      },
                      controller: pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        /*
                        if (formKey.currentState?.validate() ?? false) {
                          // If form is validated, proceed with login
                          passLoginData();

                          // Add navigation logic here to route to another page upon successful login
                          // For example:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllEmployeeScreen()), // Replace NextPage() with your desired page widget
                          );
                        }*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllEmployeeScreen()),
                        );
                      },
                      child: const Text('Login'),
                    ),

                    const SizedBox(height: 10),
                    // Login with Google button
                    ElevatedButton.icon(
                      onPressed: loginWithGoogle,
                      icon: Icon(Icons.add),
                      label: Text('Login with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color for Google button
                      ),
                    ),
                    // Login with Facebook button
          IconButton(
            onPressed: loginWithFacebook,
            icon: Icon(Icons.facebook),
            color: Colors.blue,
            iconSize: 48.0, // Adjust icon size as needed
          ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
http://localhost:4000/admin/branch/add-new , http://localhost:4000/admin/table/add-newTable , http://localhost:4000/admin/branch/list , http://localhost:4000/admin/auth/login , http://localhost:4000/admin/auth/dashboard
 */