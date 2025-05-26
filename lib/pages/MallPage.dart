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
    final themeColor = Colors.blue[700];
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('商城'),
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
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // 🛍️ 商品网格
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product, themeColor);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧩 单个商品卡片组件（避免溢出）
  Widget _buildProductCard(Map<String, dynamic> product, Color? themeColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 商品图
              SizedBox(
                height: constraints.maxHeight * 0.45,
                width: double.infinity,
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
                child: Text(
                  product['name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 跳转详情页或下单
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      '立即订购',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}