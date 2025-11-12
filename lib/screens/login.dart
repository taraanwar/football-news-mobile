import 'package:flutter/material.dart';
import 'package:football_news/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:football_news/screens/register.dart'; // navigate to Register

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                  const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final username = _usernameController.text;
                      final password = _passwordController.text;

                      // ANDROID EMULATOR → use http://10.0.2.2:8000/
                      // CHROME (web)     → use http://localhost:8000/
                      final response = await request.login(
                        "http://localhost:8000/auth/login/", // <-- change if you run on Chrome
                        {
                          'username': username,
                          'password': password,
                        },
                      );

                      if (request.loggedIn) {
                        final message = response['message'];
                        final uname = response['username'];
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MyHomePage()),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text("$message Welcome, $uname.")));
                      } else {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Login Failed'),
                            content: Text(response['message'] ?? 'Invalid credentials'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
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
