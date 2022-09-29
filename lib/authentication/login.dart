// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fingerprint_authentication/homepage/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LocalAuthentication auth = LocalAuthentication();

  bool? _cancheckbiometrics;
  List<BiometricType>? availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  late String email, password;

  @override
  void initState() {
    cancheckBiometrics();
    getavailablebiometrics();
    super.initState();
  }

  Future<void> cancheckBiometrics() async {
    late bool cancheckbiometrics;
    try {
      cancheckbiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      cancheckbiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _cancheckbiometrics = cancheckbiometrics;
      print(_cancheckbiometrics);
    });
  }

  Future<void> getavailablebiometrics() async {
    late List<BiometricType> _availablebiometrics;
    try {
      _availablebiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      _availablebiometrics = <BiometricType>[];
      print(e.message);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      availableBiometrics = _availablebiometrics;
      print(availableBiometrics);
    });
  }

  Future<void> authenticate() async {
    bool authenticated = false;

    try {
      setState(() {
        _authorized = "Authenticating";
        _isAuthenticating = true;
        print("scanning");
      });

      authenticated = await auth.authenticate(
        localizedReason: "Scan your fingerprint to continue",
        options: AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _authorized = "Error + ${e.message}";
        print(_authorized);
      });

      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _authorized = authenticated ? "Authorized" : "Not Authorized";
      print(_authorized);
    });
    if (_authorized == "Authorized") {
      Get.to(() => Homepage());
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthofdevice = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: widthofdevice * 0.5,
            child: TextFormField(
              validator: (value) =>
                  value!.isEmpty ? "Please enter email" : null,
              onSaved: (value) => email = value!,
              decoration: const InputDecoration(
                hintText: "Enter Email address",
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            width: widthofdevice * 0.5,
            child: TextFormField(
              validator: (value) =>
                  value!.isEmpty ? "Please enter email" : null,
              onSaved: (value) => password = value!,
              decoration: const InputDecoration(
                hintText: "Enter Email address",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              authenticate();
              setState(() {});
              print(_authorized);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(_isAuthenticating ? 'Authenticating ...' : 'Authenticate'),
                const Icon(Icons.fingerprint),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
