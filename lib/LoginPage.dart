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
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isClick = !_isClick; // 切换状态
                                });
                              },
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: _isClick ? Colors.blue : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign In', // 动态文本
                                  style: TextStyle(
                                    color:
                                        _isClick ? Colors.white : Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isClick = !_isClick; // 切换状态
                                });
                              },
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: _isClick ? Colors.white : Colors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign Up', // 动态文本
                                  style: TextStyle(
                                    color:
                                        _isClick ? Colors.blue : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
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
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeTab()));
                            });
                          },
                          child: Container(
                            width: 230,
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
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
