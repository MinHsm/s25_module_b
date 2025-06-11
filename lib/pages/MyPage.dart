import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AboutPage.dart';
import 'CartPage.dart';
import 'FavoritePage.dart';
import 'LoginPage.dart';
import 'MyPostsPage.dart';
import '../module/data.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _username = 'UserTest';
  String? _avatarPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await UserService.getCurrentUser();
    if (user != null) {
      setState(() {
        _username = user.username ?? '未命名用户';
        _avatarPath = user.avatarPath ?? 'assets/user_avatar/user.png';
      });
    }
  }

  Future<void> _saveUserInfo() async {
    final email = await UserService.getLoggedInEmail();
    if (email != null) {
      await UserService.updateProfile(
        email,
        newUsername: _username,
        newAvatarPath: _avatarPath,
      );
    }
  }

  Future<void> _showEditDialog() async {
    final nameController = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('编辑资料'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _chooseImageSource,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _avatarPath != null
                      ? FileImage(File(_avatarPath!))
                      : const AssetImage('assets/user_avatar/user_img.jpg')
                  as ImageProvider,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '昵称'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _username = nameController.text;
                });
                _saveUserInfo();
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _chooseImageSource() async {
    Navigator.pop(context); // 关闭对话框后重新打开（避免两个弹窗冲突）
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('相册选择'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery)),
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('拍照'),
                  onTap: () => Navigator.pop(context, ImageSource.camera)),
            ],
          ),
        );
      },
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _avatarPath = pickedFile.path;
        });
        _saveUserInfo();
      }
    }

    Future.delayed(const Duration(milliseconds: 200), _showEditDialog); // 重新打开编辑弹窗
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: _showEditDialog,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: _avatarPath != null
                        ? FileImage(File(_avatarPath!))
                        : const AssetImage('assets/user_avatar/user.png')
                    as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_username,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('UID: 1008611',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                _buildListItem(context, Icons.star_border, '我的收藏'),
                _buildListItem(context, Icons.edit_note_outlined, '我的发布'),
                _buildListItem(context, Icons.shopping_cart_outlined, '购物车管理'),
                _buildListItem(context, Icons.settings, '设置'),
                _buildListItem(context, Icons.info_outline, '关于我们'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton.icon(
              onPressed: () async {
                await UserService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('退出登录', style: TextStyle(color: Colors.red)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (title == '关于我们') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutPage()));
        } else if (title == '购物车管理') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        } else if (title == '我的收藏') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FavoritePage()));
        } else if (title == '我的发布') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyPostsPage()));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("点击了：$title")));
        }
      },
    );
  }
}