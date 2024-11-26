import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../entities/user.dart';
import 'dashboard.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  User user = User("", "");
  String url = "http://192.168.56.1:8081/login";
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  Future save(user) async {
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': user.email, 'password': user.password}));
    print(res.body);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 520.0,
                            width: 340.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text("Login",
                                      style: GoogleFonts.oswald(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 50,
                                          color: Colors.black45)),
                                  const Align(
                                    alignment: Alignment.center,
                                  ),
                                  TextFormField(
                                    controller: emailCtrl,
                                    decoration:
                                    const InputDecoration(labelText: "Email"),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    controller: passwordCtrl,
                                    decoration:
                                    const InputDecoration(labelText: "Password"),
                                    obscureText: true,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const Register()));
                                      },
                                      child: const Text("Dont have Account ?"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle:
                                        const TextStyle(fontSize: 20),
                                        backgroundColor: const Color.fromRGBO(
                                            233, 65, 82, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          save(User(emailCtrl.text,
                                              passwordCtrl.text));
                                        }
                                      },
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])))));
  }
}