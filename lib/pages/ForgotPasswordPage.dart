import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../module/data.dart'; // 你的 User 定义

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _email = '', _code = '', _newPwd = '', _confirmPwd = '';
  String _generatedCode = '';
  Timer? _timer;
  int _countdown = 0;
  DateTime? _codeExpireTime;

  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    _pwdController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String _generateCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  Future<void> _sendCode() async {
    if (!_emailRegex.hasMatch(_email)) {
      _showMessage('请输入有效的邮箱');
      return;
    }

    final users = await UserService.loadUsers();
    if (!users.any((u) => u['email'] == _email)) {
      _showMessage('该邮箱未注册');
      return;
    }

    _generatedCode = _generateCode();
    _codeExpireTime = DateTime.now().add(Duration(minutes: 5));

    _showMessage('验证码已发送（测试用：$_generatedCode）');
    setState(() => _countdown = 60);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _countdown--);
      if (_countdown <= 0) timer.cancel();
    });
  }

  void _resetPassword() async {
    if (_code != _generatedCode || DateTime.now().isAfter(_codeExpireTime ?? DateTime.now())) {
      _showMessage('验证码错误或已过期');
      return;
    }

    if (_newPwd.isEmpty || _newPwd != _confirmPwd) {
      _showMessage('两次密码输入不一致');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final users = await UserService.loadUsers();

    final index = users.indexWhere((u) => u['email'] == _email);
    if (index == -1) {
      _showMessage('用户不存在');
      return;
    }

    users[index]['password'] = _newPwd;
    await prefs.setString(UserService.userKey, jsonEncode(users));

    _showMessage('密码重置成功');
    Navigator.pop(context); // 返回登录页
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('忘记密码')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: '邮箱'),
            onChanged: (v) => _email = v,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(labelText: '验证码'),
                  onChanged: (v) => _code = v,
                ),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: _countdown > 0 ? null : _sendCode,
                child: Text(_countdown > 0 ? '$_countdown 秒' : '发送验证码'),
              )
            ],
          ),
          TextField(
            controller: _pwdController,
            obscureText: true,
            decoration: InputDecoration(labelText: '新密码'),
            onChanged: (v) => _newPwd = v,
          ),
          TextField(
            controller: _confirmController,
            obscureText: true,
            decoration: InputDecoration(labelText: '确认密码'),
            onChanged: (v) => _confirmPwd = v,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetPassword,
            child: Text('重置密码'),
          )
        ]),
      ),
    );
  }
}