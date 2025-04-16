import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'HomeTab.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '', _pwd = '';
  bool _isClick = true;
  bool _isObscure = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'assets/car/ic_travel_car.jpg',
            fit: BoxFit.cover,
          )),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          )),
          Center(
            child: Container(
              width: 350,
              height: 450,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 55,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isClick = true;
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        _isClick ? Colors.blue : Colors.white),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2))),
                                    side: MaterialStateProperty.all(BorderSide(
                                        width: 1, color: Colors.blue))),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: _isClick
                                          ? Colors.white
                                          : Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 55,
                              child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isClick = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        _isClick ? Colors.white : Colors.blue,
                                      ),
                                      shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2))),
                                      side: WidgetStateProperty.all(BorderSide(
                                          color: Colors.blue, width: 1))),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: _isClick
                                            ? Colors.blue
                                            : Colors.white),
                                  )),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          _isClick ? 'Sign In' : 'Sign Up',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey[600],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Colors.grey[600],
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        child: SizedBox(
                          height: 55,
                          width: 230,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.blue),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: () {
                              setState(() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeTab()));
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.ads_click,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  _isClick ? 'Sign In' : 'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          _isClick ? 'Forgot your password?' : '',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      top: -65,
                      left: 112,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2)),
                        child: CircleAvatar(
                          backgroundImage: _isClick
                              ? AssetImage(
                                  'assets/user_avatar/sigin_boy_img.jpg')
                              : AssetImage(
                                  'assets/user_avatar/sigup_boy_img.jpg'),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
