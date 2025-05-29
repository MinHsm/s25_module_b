import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // 🖼 Logo 或图片
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/icon/ic_launcher.png', // 替换为你的 logo 路径
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📱 应用名称 & 版本
              Text(
                '汽车社区',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '版本号：v1.0.0',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // 📄 简介
              const Text(
                '本汽车社区应用致力于为用户提供便捷、高效的购物体验。'
                    '您可以在这里浏览并选购热门车型及周边配件，'
                    '享受官方渠道提供的优质服务。',
                style: TextStyle(fontSize: 15, height: 1.5),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // 📞 联系方式
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(Icons.email, '联系邮箱：test@gmail.com'),
                  _buildInfoItem(Icons.phone, '客服电话：400-100-5678'),
                  _buildInfoItem(Icons.location_on, '公司地址：中山XXX-XXX-XXX'),
                ],
              ),

              const SizedBox(height: 40),

              // 🔒 版权信息
              const Text(
                '© 2025 Min 版权所有',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 工具方法：信息行样式
  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}