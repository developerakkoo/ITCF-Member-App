import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:member/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _razorpay = Razorpay();
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _userId = '';
  String _lastName = '';
  String _email = '';
  String _age = "";
  String _dob = "";
  String _mobileNumber = '';
  String _postalAddress = '';
  String _specialization = '';
  DateTime _selectedDate = DateTime.now();
  bool isFeePaid = false;

  List<String> _specializations = [
    'Batting',
    'Bowling',
    'All Rounder',
  ];

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform form submission logic here
      print('Submitted!');
      print('First Name: $_firstName');
      print('Last Name: $_lastName');
      print('Email: $_email');
      print('Mobile Number: $_mobileNumber');
      print('Specialization: $_specialization');
      print('Age: $_age');
      print('Selected Date: $_selectedDate');
      Navigator.pushNamed(context, '/upload');
    }
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = await prefs.getString("id").toString();
    // _mobileNumber = await prefs.getString("phone").toString();
    // _email = await prefs.getString("email").toString();
    // _firstName = await prefs.getString("name").toString();
    isFeePaid = await prefs.getBool("isFeePaid") ?? false;
    print("Register data");
    // print(_firstName);
    // print(_email);
    // print(_mobileNumber);
    print(isFeePaid);
    print(_userId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    var result;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
          // titleTextStyle: TextStyle(),
          title: const Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          leading: InkWell(
              onTap: () => {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: LoginScreen(),
                            type: PageTransitionType.leftToRight))
                  },
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white)),
        ),
        body: authProvider.loading
            ? Center(
                child: LoadingAnimationWidget.bouncingBall(
                    color: Color(0xff5264F9), size: 30),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _firstName = value!;
                                  },
                                  style: TextStyle(
                                      height: 1.2, color: Colors.white),
                                  decoration: const InputDecoration(
                                      filled: false,
                                      fillColor: Color(0xffE9F7FE),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white70, width: 2.0),
                                      ),
                                      hintText: 'First Name',
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: TextFormField(
                                style:
                                    TextStyle(height: 1.2, color: Colors.white),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _lastName = value!;
                                },
                                decoration: const InputDecoration(
                                    filled: false,
                                    fillColor: Color(0xffE9F7FE),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white70, width: 2.0),
                                    ),
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(color: Colors.white)),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(height: 1.2, color: Colors.white),
                            decoration: const InputDecoration(
                                filled: false,
                                fillColor: Color(0xffE9F7FE),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 2.0),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Add additional email validation logic if needed
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(height: 1.2, color: Colors.white),
                            decoration: const InputDecoration(
                                filled: false,
                                fillColor: Color(0xffE9F7FE),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 2.0),
                                ),
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(color: Colors.white)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              // Add additional email validation logic if needed
                              return null;
                            },
                            onSaved: (value) {
                              _mobileNumber = value!;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      height: 1.2, color: Colors.white),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _age = value!;
                                  },
                                  decoration: const InputDecoration(
                                      filled: false,
                                      fillColor: Color(0xffE9F7FE),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white70, width: 2.0),
                                      ),
                                      hintText: 'Age',
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: _formatDate(_selectedDate)),
                                style:
                                    TextStyle(height: 1.2, color: Colors.white),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your DOB';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  _selectDate(context);
                                },
                                onSaved: (value) {
                                  _dob = value!;
                                },
                                decoration: const InputDecoration(
                                  filled: false,
                                  fillColor: Color(0xffE9F7FE),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white70, width: 2.0),
                                  ),
                                  hintText: 'DOB',
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.black,
                            style: TextStyle(height: 1.2, color: Colors.white),
                            value: _specialization.isNotEmpty
                                ? _specialization
                                : null,
                            decoration: const InputDecoration(
                                filled: false,
                                fillColor: Color(0xffE9F7FE),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70, width: 2.0),
                                ),
                                hintText: 'Skill',
                                hintStyle: TextStyle(color: Colors.white)),
                            items:
                                _specializations.map((String specialization) {
                              return DropdownMenuItem<String>(
                                value: specialization,
                                child: Text(specialization),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a skill';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _specialization = value!;
                              });
                            },
                            onSaved: (value) {
                              _specialization = value!;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            minWidth: 200.0,
                            onPressed: () {
                              print("Pressed");
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                if (isFeePaid == false) {
                                  var amount = 1 * 300;
                                  var options = {
                                    'key': 'rzp_test_NZPT7cTtpJaWr2',
                                    'amount': amount * 100,
                                    'name':
                                        'Pivot Technosports Private Limited.',
                                    'description': 'Fees',
                                    // 'prefill': {
                                    //   'contact': '8888888888',
                                    //   'email': 'test@razorpay.com'
                                    // }
                                  };
                                  _razorpay.open(options);
                                  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                      (PaymentSuccessResponse response) {
                                    authProvider
                                        .registerMember(
                                            _firstName,
                                            _lastName,
                                            _email,
                                            _userId,
                                            _age,
                                            _dob,
                                            _mobileNumber,
                                            _specialization)
                                        .then((value) => {
                                              print(value),
                                              result = json.decode(value.body),
                                              print("VAlue returned is:- "),
                                              print(result),
                                              if (value.statusCode == 200)
                                                {
                                                  print("Success"),
                                                  print(result['message']),

                                                  //Show snakbar
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(result[
                                                              'message']))),
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: LoginScreen(),
                                                          type:
                                                              PageTransitionType
                                                                  .leftToRight))
                                                }
                                              else if (value.statusCode == 400)
                                                {
                                                  print("400 error"),
                                                  print(result['message']),

                                                  //Show snakbar
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(result[
                                                              'message']))),
                                                }
                                              else
                                                {
                                                  print(value.message),
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(result[
                                                              'message'])))
                                                }
                                            })
                                        .catchError((error) => {
                                              print(error),
                                            });
                                  });
                                } else {
                                  authProvider
                                      .registerMember(
                                          _firstName,
                                          _lastName,
                                          _email,
                                          _userId,
                                          _age,
                                          _dob,
                                          _mobileNumber,
                                          _specialization)
                                      .then((value) => {
                                            print(value),
                                            result = json.decode(value.body),
                                            print("VAlue returned is:- "),
                                            print(result),
                                            if (value.statusCode == 200)
                                              {
                                                print("Success"),
                                                print(result['message']),

                                                //Show snakbar
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(result[
                                                            'message']))),
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: HomeScreen(),
                                                        type: PageTransitionType
                                                            .rightToLeft))
                                              }
                                            else if (value.statusCode == 400)
                                              {
                                                print("400 error"),
                                                print(result['message']),

                                                //Show snakbar
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(result[
                                                            'message']))),
                                              }
                                            else
                                              {
                                                print(value.message),
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                            result['message'])))
                                              }
                                          })
                                      .catchError((error) => {
                                            print(error),
                                          });
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.all(20.0),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xff5264F9),
                                    Color(0xff1433FF)
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 230.0,
                                    minHeight:
                                        66.0), // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ));
  }
}
