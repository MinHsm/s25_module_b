import 'package:flutter/material.dart';

class MallPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'name': '小米SU7 Max 高性能版',
      'price': 299900,
      'image': 'assets/categories/car1.png'
    },
    {
      'name': '小米SU7 Lite 标准版',
      'price': 249900,
      'image': 'assets/categories/car2.png'
    },
    {
      'name': '小米原装充电桩',
      'price': 3499,
      'image': 'assets/categories/car5.jpeg'
    },
    {
      'name': 'SU7 内饰氛围灯套装',
      'price': 799,
      'image': 'assets/categories/car4.jpeg'
    },
  ];

  MallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue[700]; // 蓝色主题主色
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // 响应式：宽屏三列，窄屏两列

    return Scaffold(
      appBar: AppBar(
        title: Text('商城'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // 🔍 搜索框
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索车型/配件',
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🛍️ 商品网格列表
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7, // 适配不同屏幕
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 商品图
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          product['image'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '￥${product['price']}',
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: 跳转详情页或下单
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('立即订购', style: TextStyle(fontSize: 13,color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}