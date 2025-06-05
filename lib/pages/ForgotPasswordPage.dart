import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../module/data.dart'; // 引入 User 定义

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _email = '', _code = '', _newPwd = '', _confirmPwd = '';
  String _generatedCode = '';
  DateTime? _codeExpireTime;
  int _countdown = 0;
  Timer? _timer;

  bool _isObscure = true;
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmController = TextEditingController();

  void _showCodeDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('验证码已发送'),
        content: Row(
          children: [
            Expanded(
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('验证码已复制')),
                );
              },
            )
          ],
        ),
        actions: [
          TextButton(
            child: const Text('关闭'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    _pwdController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  String _generateCode() {
    final rand = Random();
    return (100000 + rand.nextInt(900000)).toString(); // 6 位验证码
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/car/ic_travel_car.jpg',
                  fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
            Center(
              child: Container(
                width: 350,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          '忘记密码',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (v) => _email = v,
                            decoration: InputDecoration(
                              labelText: '邮箱',
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _codeController,
                                  onChanged: (v) => _code = v,
                                  decoration: InputDecoration(
                                    labelText: '验证码',
                                    prefixIcon: Icon(Icons.verified,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              _countdown > 0
                                  ? Text('$_countdown 秒后重试',
                                      style: TextStyle(color: Colors.grey))
                                  : TextButton(
                                      onPressed: () async {
                                        if (!_emailRegex.hasMatch(_email)) {
                                          _showMessage('请输入有效的邮箱');
                                          return;
                                        }

                                        final isRegistered =
                                            await UserService.isEmailRegistered(
                                                _email);
                                        if (!isRegistered) {
                                          _showMessage('该邮箱尚未注册');
                                          return;
                                        }

                                        setState(() {
                                          _generatedCode = _generateCode();
                                          _codeExpireTime = DateTime.now()
                                              .add(Duration(minutes: 5));
                                          _countdown = 60;
                                        });
                                        _startCountdown();
                                        _showCodeDialog(_generatedCode);
                                      },
                                      child: Text('发送验证码',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold)),
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: TextFormField(
                            controller: _pwdController,
                            onChanged: (v) => _newPwd = v,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: '新密码',
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.grey[600]),
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: TextFormField(
                            controller: _confirmController,
                            onChanged: (v) => _confirmPwd = v,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              labelText: '确认密码',
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.grey[600]),
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_code != _generatedCode) {
                              _showMessage('验证码错误');
                              return;
                            }
                            if (_codeExpireTime != null &&
                                DateTime.now().isAfter(_codeExpireTime!)) {
                              _showMessage('验证码已过期');
                              return;
                            }
                            if (_newPwd.isEmpty || _confirmPwd.isEmpty) {
                              _showMessage('请输入新密码');
                              return;
                            }
                            if (_newPwd != _confirmPwd) {
                              _showMessage('两次密码不一致');
                              return;
                            }

                            // 加入此段判断
                            final users = await UserService.loadUsers();
                            final currentUser = users.firstWhere(
                                (u) => u['email'] == _email,
                                orElse: () => {});
                            if (currentUser.isNotEmpty &&
                                currentUser['password'] == _newPwd) {
                              _showMessage('新密码不能与旧密码相同');
                              return;
                            }

                            await UserService.updatePassword(_email, _newPwd);
                            _showMessage('密码已重置，请返回登录');
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 230,
                            height: 55,
                            margin: EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.ads_click, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  '重置密码',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
