import 'package:flutter/material.dart';
import 'package:stream/database/auth_methods.dart';
import 'package:stream/widgets/custom_button.dart';
import 'package:stream/widgets/custom_input.dart';
import 'package:stream/widgets/loading_indicator.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static var route = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginUser(
      context,
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res) {
      Navigator.pushReplacementNamed(context, Home.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomTextField(controller: _emailController),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomTextField(controller: _passwordController),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(onTap: loginUser, text: "Log In")
                  ],
                ),
              ),
            ),
    );
  }
}
