import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../HomeTab.dart';
import '../module/data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '', _pwd = '', _verificationCode = '';
  bool _isClick = true;
  bool _isObscure = true;
  int _countdown = 0;
  String _tempCode = ''; // 存储临时验证码
  Timer? _countdownTimer;

  DateTime? _codeExpireTime;
  final _codeController = TextEditingController();

  // 邮箱正则验证
  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // 生成6位随机验证码
  String _generateVerificationCode() {
    final random = Random();
    return List.generate(6, (index) => random.nextInt(10)).join();
  }

  // 获取验证码（带邮箱验证）
  void _getVerificationCode() {
    // 检查冷却时间
    if (_countdown > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请等待${_countdown}秒后再获取')),
      );
      return;
    }
    // 验证邮箱格式
    if (_email.isEmpty || !_emailRegex.hasMatch(_email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的邮箱地址')),
      );
      return;
    }

    // 2. 生成验证码并设置有效期（5分钟）
    _tempCode = _generateVerificationCode();
    _codeExpireTime = DateTime.now().add(const Duration(minutes: 5));

    // 开始倒计时
    setState(() => _countdown = 60);
    _countdownTimer?.cancel(); // 取消之前的计时器
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });

    // 3. 显示验证码对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('验证码（开发测试用）'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('邮箱: $_email'),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('验证码: $_tempCode'),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _tempCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已复制验证码')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                '有效期至: ${_codeExpireTime!.hour}:${_codeExpireTime!.minute.toString().padLeft(2, '0')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 自动填充验证码
              _codeController.text = _tempCode;
              // 开始倒计时
              setState(() => _countdown = 60);
              Timer.periodic(const Duration(seconds: 1), (timer) {
                setState(() => _countdown--);
                if (_countdown <= 0) timer.cancel();
              });
            },
            child: const Text('自动填充'),
          ),
        ],
      ),
    );
  }

  // 验证码有效性检查
  bool _validateVerificationCode() {
    if (_codeExpireTime == null || DateTime.now().isAfter(_codeExpireTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已过期，请重新获取')),
      );
      return false;
    }
    if (_verificationCode != _tempCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码不正确')),
      );
      return false;
    }
    return true;
  }

  Future<void> _handleLoginOrRegister() async {
    if (_isClick) {
      // 登录逻辑
      final user = await UserService.login(_email, _pwd);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeTab()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('用户名或密码错误')),
        );
      }
    } else {
      // 注册逻辑
      if (_verificationCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('请输入验证码')),
        );
        return;
      }

      await UserService.register(User(
        email: _email,
        password: _pwd,
        verificationCode: _verificationCode,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('注册成功，请登录')),
      );
      setState(() => _isClick = true);
    }
  }

  void _submit() {
    if (!_isClick) {
      // 注册时需要验证验证码
      if (!_validateVerificationCode()) return;
    }
    _handleLoginOrRegister();
    print('邮箱: $_email, 密码: $_pwd');
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _codeController.dispose();
    super.dispose();
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
                                  '登录',
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
                                  '注册',
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
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (value) => value?.isEmpty ??
                                  true || !_emailRegex.hasMatch(value!)
                              ? '请输入有效的邮箱'
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => _email = value,
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
                          onChanged: (value) => _pwd = value,
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
                                    : Icons.visibility)),
                          ),
                        ),
                      ),
                      if (!_isClick)
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15, left: 10, right: 10, bottom: 20),
                          child: TextFormField(
                            onChanged: (value) => _verificationCode = value,
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
                                    _countdown > 0 ? '${_countdown}s' : '获取验证码',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Center(
                        child: GestureDetector(
                          onTap: _submit,
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
                                SizedBox(width: 30),
                                Icon(
                                  Icons.ads_click,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 45),
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
                      SizedBox(height: 20),
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
