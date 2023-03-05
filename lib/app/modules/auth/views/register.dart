import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevshopfirebase/app/bottomBar/bottombar.dart';
import 'package:elevshopfirebase/app/constant/color.dart';
import 'package:elevshopfirebase/app/modules/auth/views/auth_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _key = new GlobalKey<FormState>();

  bool _securedText = true;

  showHide() {
    setState(() {
      _securedText = !_securedText;
    });
  }

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        "Please Register first",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: appGreen),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      controller: usernameController,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert Username";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.blueGrey,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        prefixIconColor: appPrimary,
                        fillColor: Color(0xffF2F2F2),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      controller: emailController,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert Email";
                        }
                      },
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
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _securedText,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert password";
                        }
                      },
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
                      Text('Sudah punya akun?'),
                      const SizedBox(
                        width: 2.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthView()));
                        },
                        child: Text(
                          'Login sekarang',
                          style: TextStyle(color: Color(0xff0000ff)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            final FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

                            final String? username = usernameController.text;
                            final String? email = emailController.text;
                            final String password = passwordController.text;

                            if (username != null && email != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                barrierDismissible: false,
                              );
                              try {
                                UserCredential userCredential =
                                    await _auth.createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                String userId = userCredential.user!.uid;
                                await firestore
                                    .collection('users')
                                    .doc(userId)
                                    .set({
                                  'username': username,
                                  'email': email,
                                });
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomBar()),
                                );
                              } catch (error) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content:
                                          Text('Failed to save data: $error'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          }
                        },
                        child: Text('REGISTER'),
                        style: ElevatedButton.styleFrom(primary: appPrimary),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
