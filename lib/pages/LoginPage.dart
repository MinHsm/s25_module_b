import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../HomeTab.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '', _pwd = '',_verificationCode = '';
  bool _isClick = true;
  bool _isObscure = true;
  int _countdown = 0;

  void _getVerificationCode() {
    setState(() => _countdown = 60);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _countdown--);
      if (_countdown <= 0) timer.cancel();
    });
  }

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
      resizeToAvoidBottomInset: false,
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
              height: _isClick ? 450 : 500,
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
                              onTap: () => setState(() => _isClick = true),
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
                                  '登录', // 动态文本
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
                              onTap: () => setState(() => _isClick = false),
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
                                  '注册', // 动态文本
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
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: '邮箱',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey[600],
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 25, left: 10, right: 10, bottom: 20),
                        child: TextFormField(
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              labelText: '密码',
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
                      if (!_isClick) ...[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15, left: 10, right: 10, bottom: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: '验证码',
                                prefixIcon: Icon(Icons.verified_user,
                                    color: Colors.grey[600]),
                                suffixIcon: Container(
                                  width: 100,
                                  child: TextButton(
                                      onPressed: _countdown > 0
                                          ? null
                                          : _getVerificationCode,
                                      child: Text(
                                        _countdown > 0
                                            ? '${_countdown}s'
                                            : '获取验证码',
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                )),
                          ),
                        )
                      ],
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
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  width: 45,
                                ),
                                Text(
                                  _isClick ? '登录' : '注册',
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
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          _isClick ? '忘记密码 ?' : '',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
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
