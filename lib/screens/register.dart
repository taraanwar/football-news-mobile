import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:football_news/screens/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password1Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password2Controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final username = _usernameController.text;
                      final password1 = _password1Controller.text;
                      final password2 = _password2Controller.text;

                      // ANDROID EMULATOR → http://10.0.2.2:8000/
                      // CHROME (web)     → http://localhost:8000/
                      final response = await request.postJson(
                        "http://localhost:8000/auth/register/", // <-- change if you run on Chrome
                        jsonEncode({
                          "username": username,
                          "password1": password1,
                          "password2": password2,
                        }),
                      );

                      if (!mounted) return;
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Successfully registered!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response['message'] ?? 'Failed to register!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
