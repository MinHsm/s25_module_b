import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final themeColor = Colors.blue[700];

    // 模拟多张图片（这里使用相同图片替代）
    final List<String> imageList = [
      product['image'],
      product['image'],
      product['image'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'], style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已点击分享')),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 多图轮播 + Hero 动画
            Hero(
              tag: 'product_${product['id']}',
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: imageList.map((img) {
                  return Builder(
                    builder: (context) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(img, fit: BoxFit.cover, width: double.infinity),
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名称 + 收藏
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(product['name'],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorited = !isFavorited;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isFavorited ? '已收藏' : '已取消收藏')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 价格
                  Text('￥${product['price']}',
                      style: TextStyle(fontSize: 22, color: themeColor, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 8),
                  Text('月销量：${product['sales']}+', style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),

                  const Text('商品描述', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    '这是商品的详细描述内容，可以介绍产品材质、功能、适用范围等信息，让用户更了解你提供的产品。',
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已加入购物车')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('加入购物车'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已订购：${product['name']}')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('立即订购', style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}