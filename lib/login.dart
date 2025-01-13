import 'package:flutter/material.dart';
import 'package:intern_task/auth.dart';
import 'package:intern_task/portfolioPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: 250,
                child: Image.asset(
                  'assets/images/rb.png',
                ),
              ),
              Text(
                'Log Into The App',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                height: 500,
                width: 500,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText(text: "Email", fontSize: 20, color: Colors.black),
                    myTextfield(
                      controller: emailController,
                      fontSize: 20,
                      hinttext: "Email",
                      obscuretext: false,
                      suffixIcon: Icon(Icons.person),
                    ),
                    myText(text: "password", fontSize: 20, color: Colors.black),
                    myTextfield(
                      hinttext: "Password",
                      obscuretext: true,
                      controller: passcontroller,
                      fontSize: 20,
                      suffixIcon: Icon(Icons.security),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool isAuthenticated =
                            await _authService.authenticateWithBiometrics();
                        if (isAuthenticated) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PortfolioPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Authentication failed')),
                          );
                        }
                      },
                      child: Text('Authenticate'),
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

class myTextfield extends StatelessWidget {
  final String hinttext;
  final bool obscuretext;
  final TextEditingController controller;
  final Widget? suffixIcon;
  double fontSize = 16;
  myTextfield(
      {super.key,
      required this.hinttext,
      required this.obscuretext,
      required this.controller,
      required double fontSize,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextField(
        controller: controller,
        obscureText: obscuretext,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: fontSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class myText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  myText(
      {super.key,
      required this.fontSize,
      required this.color,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
