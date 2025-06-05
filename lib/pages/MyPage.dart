import 'package:flutter/material.dart';
import 'package:s25_module_b/module/data.dart';
import 'package:s25_module_b/pages/AboutPage.dart';

import 'CartPage.dart';
import 'FavoritePage.dart';
import 'LoginPage.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 个人信息
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage:
                      AssetImage('assets/user_avatar/user_img.jpg'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UserTest',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('UID: 1008611', style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),

          Divider(height: 1),

          // 菜单项
          Expanded(
            child: ListView(
              children: [
                _buildListItem(context, Icons.star_border, '我的收藏'),
                _buildListItem(context, Icons.edit_note_outlined, '我的发布'),
                _buildListItem(context, Icons.shopping_cart_outlined, '购物车管理'),
                _buildListItem(context, Icons.favorite_outline, '收藏管理'),
                _buildListItem(context, Icons.settings, '设置'),
                _buildListItem(context, Icons.info_outline, '关于我们'),
              ],
            ),
          ),

          // 退出按钮
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton.icon(
              onPressed: () async {
                // 添加退出逻辑
                await UserService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // 移除所有旧页面
                );
              },
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text('退出登录', style: TextStyle(color: Colors.red)),
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
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        if (title == '关于我们') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutPage()));
        } else if (title == '购物车管理') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        } else if (title == '收藏管理') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FavoritePage()));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("点击了：$title")));
        }
      },
    );
  }
}
