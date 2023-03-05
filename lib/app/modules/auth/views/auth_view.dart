import 'package:elevshopfirebase/app/bottomBar/bottombar.dart';
import 'package:elevshopfirebase/app/constant/color.dart';
import 'package:elevshopfirebase/app/modules/auth/views/register.dart';
import 'package:elevshopfirebase/app/modules/home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _securedText = true;
  showHide() {
    setState(() {
      _securedText = !_securedText;
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _key = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Center(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Welcome!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: appPrimary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Please login first",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: appGreen),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(),
                      child: TextFormField(
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Please Insert Email";
                          }
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          prefixIconColor: appPrimary,
                          fillColor: Color(0xffF2F2F2),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(),
                      child: TextFormField(
                        obscureText: _securedText,
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Please Insert password";
                          }
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_securedText
                                  ? Icons.visibility_off
                                  : Icons.visibility)),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          fillColor: Color(0xffF2F2F2),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none)),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum punya akun?'),
                        const SizedBox(
                          width: 2.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterView()));
                          },
                          child: Text(
                            'Daftar sekarang',
                            style: TextStyle(color: Color(0xff0000ff)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              User? user = await loginUsingEmailPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context);
                              print(user);
                              if (user != null) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => BottomBar()));
                              }
                            }
                          },
                          child: Text('LOGIN'),
                          style: ElevatedButton.styleFrom(primary: appPrimary),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    }

    return user;
  }
}
