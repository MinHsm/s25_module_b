import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../providers/CartProvider.dart';
import 'ProductDetailPage.dart';

class MallPage extends StatefulWidget {
  const MallPage({super.key});

  @override
  State<MallPage> createState() => _MallPageState();
}

class _MallPageState extends State<MallPage> {
  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  String selectedCategory = '全部';
  String selectedSort = '默认';
  String searchKeyword = '';

  final List<String> banners = [
    'assets/banner/banner1.jpg',
    'assets/banner/banner2.jpeg',
  ];

  Future<void> loadProducts() async {
    final String response =
        await rootBundle.loadString('assets/data/products.json');
    final data = json.decode(response);
    setState(() {
      allProducts = data;
      applyFilterAndSort();
    });
  }

  void applyFilterAndSort() {
    List<dynamic> temp = List.from(allProducts);

    if (selectedCategory != '全部') {
      temp =
          temp.where((item) => item['category'] == selectedCategory).toList();
    }

    // 搜索关键词筛选
    if (searchKeyword.isNotEmpty) {
      temp = temp
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(searchKeyword.toLowerCase()))
          .toList();
    }

    if (selectedSort == '价格升序') {
      temp.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (selectedSort == '价格降序') {
      temp.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (selectedSort == '销量降序') {
      temp.sort((a, b) => b['sales'].compareTo(a['sales']));
    }

    filteredProducts = temp;
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchKeyword = value;
                  applyFilterAndSort();
                });
              },
              decoration: InputDecoration(
                hintText: '搜索车型/配件',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchKeyword.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchKeyword = '';
                            applyFilterAndSort();
                          });
                        },
                        icon: Icon(Icons.clear))
                    : null,
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
          CarouselSlider(
            options: CarouselOptions(
              height: 160,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
            ),
            items: banners.map((banner) {
              return Builder(
                builder: (context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(banner,
                        fit: BoxFit.cover, width: double.infinity),
                  );
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items: ['全部', '整车', '配件']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                      applyFilterAndSort();
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedSort,
                  items: ['默认', '价格升序', '价格降序', '销量降序']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value!;
                      applyFilterAndSort();
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await loadProducts(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(context, product, themeColor);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, Map<String, dynamic> product, Color? themeColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: Hero(
                  tag: 'product_${product['id'] ?? UniqueKey()}', // 防止为 null
                  child: Image.asset(product['image'],
                      fit: BoxFit.cover, width: double.infinity),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
              child: Text(product['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('￥${product['price']}',
                  style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('月销: ${product['sales']}+',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const Row(
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      Icon(Icons.star, size: 12, color: Colors.orange),
                      Icon(Icons.star, size: 12, color: Colors.orange),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(product);
                    // 这里可以替换为加入购物车逻辑
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('已加入购物车：${product['name']}')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('加入购物车',
                      style: TextStyle(fontSize: 13, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
