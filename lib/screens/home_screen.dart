import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Afternoon",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Player",
              style: TextStyle(color: Colors.white54, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              // Navigator.pushNamed(context, '/create-team');
            },
            // AssetImage("assets/images/avatar.png")
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40, // Set the radius of the circle avatar
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                Positioned(
                  top: 1,
                  right: -8,
                  child: CircleAvatar(
                    radius: 12, // Set the radius of the checkmark avatar
                    backgroundColor:
                        Colors.blue, // Set the background color to blue
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_on_outlined,
                color: Colors.white,
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [],
        ),
      ),
      body: authProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: OutlineSearchBar(
                    autoCorrect: true,
                    clearButtonColor: Colors.white,
                    searchButtonIconColor: Colors.white30,
                    backgroundColor: Colors.black,
                    onSearchButtonPressed: ((value) => {print(value)}),
                    hintText: "Search by matches, players, events",
                    hintStyle: TextStyle(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderColor: Colors.white30,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      authProvider
                          .applyforProMember(_userId)
                          .then((value) => {
                                result = json.decode(value.body),
                                print("VAlue returned is:- "),
                                print(result),
                                if (value.statusCode == 200)
                                  {
                                    print("Success"),
                                    print(result['message']),

                                    //Show snakbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(result['message']))),
                                  }
                              })
                          .catchError((error) => {});
                    },
                    child: Text("Apply For Pro Member")),
                Text(
                  "Need To Pay 1100 rs/PA for Registration.",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
    );
  }
}
