import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get loading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<dynamic> applyforProMember(String userId) async {
    try {
      setLoading(true);
      print("Provier Pro Mmeber Apply");
      Response res = await http.post(
          Uri.parse("http://35.78.76.21:8000/proMember/player/req/$userId"),
          body: {});

      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (e) {
      setLoading(false);

      print(e);
      return e;
    }
  }

  Future<dynamic> registerMember(
      String fName,
      String fatherName,
      String email,
      String userId,
      String age,
      String dob,
      String phoneNumber,
      String specialisation) async {
    try {
      setLoading(true);
      print("Provier register");
      Response res = await http
          .post(Uri.parse("http://35.78.76.21:8000/player/$userId"), body: {
        "Name": fName,
        "age": age,
        "DOB": dob,
        "email": email,
        "Phone": phoneNumber,
        "Skills": specialisation,
      });

      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (e) {
      setLoading(false);

      print(e);
      return e;
    }
  }

  Future<dynamic> login(
    String number,
  ) async {
    try {
      setLoading(true);
      print("Provier register");
      print(number);
      Response res = await http.get(
        Uri.parse(
            "http://35.78.76.21:8000/plyer/phoneNo/verify?phoneNumber=$number"),
      );

      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
        return res as Response;
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
      }

      return res as Response;
    } catch (e) {
      print(e);
    }
  }
}
