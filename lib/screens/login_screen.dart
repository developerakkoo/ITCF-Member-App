import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  saveDate(bool isFeePaid, String id) async {
    print("Prefs started");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFeePaid", isFeePaid);
    await prefs.setString("id", id);
    print("Prefs end");

    Navigator.pushNamed(context, '/register');
  }

  final _formKey = GlobalKey<FormState>();
  String _phonenumber = '';

  late double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    var result;
    return Scaffold(
      backgroundColor: Colors.black,
      body: authProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 330,
                      height: 300,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const Text(
                    //   "Indian Tennis Cricket Federation",
                    //   style: TextStyle(fontSize: 16, color: Colors.white),
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Welcome Player!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _phonenumber = value!;
                        },
                        decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white30, width: 2.0),
                            ),
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Column(
                    //     children: [
                    //       TextFormField(
                    //         validator: (value) {
                    //           if (value!.isEmpty) {
                    //             return 'Please enter your password';
                    //           }
                    //           return null;
                    //         },
                    //         onSaved: (value) {
                    //           _password = value!;
                    //         },
                    //         decoration: new InputDecoration(
                    //             border: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Colors.white, width: 2.0),
                    //             ),
                    //             focusedBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Colors.white, width: 1.0),
                    //             ),
                    //             enabledBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: Colors.white30, width: 2.0),
                    //             ),
                    //             hintText: 'Password',
                    //             hintStyle: TextStyle(color: Colors.grey)),
                    //       ),
                    //       Align(
                    //         alignment: Alignment.topRight,
                    //         child: TextButton(
                    //             onPressed: () {},
                    //             child: const Text(
                    //               "Recover Password",
                    //               textAlign: TextAlign.right,
                    //               style: TextStyle(color: Colors.grey),
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    MaterialButton(
                      minWidth: 100.0,
                      onPressed: () {
                        print("Phone Number:- ");
                        print(_phonenumber);

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          authProvider.login(_phonenumber).then((value) => {
                                result = json.decode(value.body),
                                print("VAlue returned is:- "),
                                print(result),
                                print(value.statusCode),
                                if (value.statusCode == 200)
                                  {
                                    print("Success"),
                                    print(result['message']),
                                    print(result['userId']),
                                    print(result['isFeePaid']),

                                    //Show snakbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Sign in Successfull"))),

                                    saveDate(
                                        result['isFeePaid'], result['userId']),
                                  }
                                else if (value.statusCode == 404)
                                  {
                                    print("value error"),
                                    print(result['message']),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "You are not registered as a player.Please contact Admin.")))
                                  }
                              });
                        }
                        // Navigator.pushNamed(context, '/select-city');
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.all(20.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 82, 154, 249),
                              Color.fromARGB(255, 82, 154, 249),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 100.0,
                              minHeight:
                                  50.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // TextButton(
                    //     style: ButtonStyle(),
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, '/select-city');
                    //     },
                    //     child: const Text(
                    //       "Don't have an account? Register.",
                    //       style: TextStyle(color: Colors.grey),
                    //     ))
                  ],
                ),
              ),
            ),
    );
  }
}
