import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:s25_module_b/component/SearchModal.dart';

import '../module/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  int _currentIndex = 0;

  final List<CarData> carItems = [
    CarData(
        name: '宝马 X4 Sports',
        imgPath: 'assets/categories/car3.jpeg',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8),
    CarData(
        name: '宝马 X4 Sports',
        imgPath: 'assets/categories/car4.jpeg',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8),
    CarData(
        name: '宝马 X4 Sports',
        imgPath: 'assets/categories/car5.jpeg',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8),
    CarData(
        name: '宝马 X4 Sports',
        imgPath: 'assets/categories/car6.jpeg',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8)
  ];

  Future<void> scanQRCode(BuildContext context) async {
    // 存储最后一次扫描的结果，避免重复处理
    String? lastScannedCode;

    // 打开扫描界面
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('扫描二维码')),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null && code != lastScannedCode) {
                  lastScannedCode = code;
                  Navigator.pop(context, code); // 返回扫描结果
                }
              }
            },
          ),
        ),
      ),
    ).then((result) {
      // 处理扫描结果
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('扫描结果: $result')),
        );
        // 可以在这里处理扫描到的数据（如跳转页面、调用API等）
      }
    });
  }

  int titleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: _SilverHeader(
                  child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '欢迎',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => SearchModal.show(
                                context: context,
                                hintText: '搜索...',
                                onSearch: (query) {
                                  print('搜索内容: $query');
                                  // 这里可以添加实际搜索逻辑
                                },
                                suggestions: [
                                  '公交车',
                                  '火车',
                                  '飞机',
                                  '自行车',
                                  '出租车',
                                ],
                              ),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 10),
                                      child: Icon(Icons.search,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      '你想要什么样的交通工具？',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => scanQRCode(context),
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Icon(Icons.qr_code_scanner,
                                  size: 28, color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                // 🔁 轮播图部分
                CarouselSlider.builder(
                  itemCount: carItems.length,
                  itemBuilder: (context, index, realIndex) {
                    final car = carItems[index];
                    return GestureDetector(
                      onTap: () {
                        // 可选跳转逻辑
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Car1(car: car),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 240,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    viewportFraction: 0.75,
                    autoPlayInterval: Duration(seconds: 6),
                    scrollPhysics: BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),

                // 🔘 指示器部分
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(carItems.length, (index) {
                    bool isActive = index == _currentIndex;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blue : Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '热门类别',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 130,
                                width: 240,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/categories/show_bikes_img.png'))),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 130,
                                width: 240,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/categories/car_img.png'))),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: Row(
                            children: [
                              Container(
                                height: 130,
                                width: 240,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/categories/wedding_car_img.png'))),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 130,
                                width: 240,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/categories/boats_img.png'))),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 620,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '最近浏览',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '查看',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '我们向您展示最新的搜索结果',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Card(
                                clipBehavior: Clip.none,
                                color: Colors.white,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/car/bmw_m5_img.png'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '宝马 M5 G-Power',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '特拉维夫，以色列',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 45,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Image.asset(
                                                          'assets/icon/bookmark.png'),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Icon(
                                                        size: 30,
                                                        Icons.timeline,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  size: 35,
                                                  Icons.more_horiz,
                                                  color: Colors.grey[400],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                        top: 110,
                                        left: 10,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Image.asset(
                                              'assets/user_avatar/bmw_user_img.png'),
                                        )),
                                  ],
                                ))),
                        Expanded(
                            flex: 1,
                            child: Card(
                                clipBehavior: Clip.none,
                                color: Colors.white,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/car/ford_mustang.png'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '福特野马 GT',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '不知名的用户1',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 45,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Image.asset(
                                                          'assets/icon/bookmark.png'),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Icon(
                                                        size: 30,
                                                        Icons.timeline,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  size: 35,
                                                  Icons.more_horiz,
                                                  color: Colors.grey[400],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                        top: 110,
                                        left: 10,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Image.asset(
                                              'assets/user_avatar/ford_user_img.png'),
                                        )),
                                  ],
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Card(
                                clipBehavior: Clip.none,
                                color: Colors.white,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/car/audi.png'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '奥迪 A7 2018',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '平凡的网友1',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 45,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Image.asset(
                                                          'assets/icon/bookmark.png'),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Icon(
                                                        size: 30,
                                                        Icons.timeline,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  size: 35,
                                                  Icons.more_horiz,
                                                  color: Colors.grey[400],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                        top: 110,
                                        left: 10,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Image.asset(
                                              'assets/user_avatar/audi_user_img.png'),
                                        )),
                                  ],
                                ))),
                        Expanded(
                            flex: 1,
                            child: Card(
                                clipBehavior: Clip.none,
                                color: Colors.white,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 130,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15)),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/car/mercedes.png'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '梅赛德斯-奔驰 SLS',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '不知名的用户2',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 45,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Image.asset(
                                                          'assets/icon/bookmark.png'),
                                                    ),
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: Icon(
                                                        size: 30,
                                                        Icons.timeline,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: Icon(
                                                  size: 35,
                                                  Icons.more_horiz,
                                                  color: Colors.grey[400],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                        top: 110,
                                        left: 10,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Image.asset(
                                              'assets/user_avatar/mercedes_user_img.png'),
                                        )),
                                  ],
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]))
        ],
      ),
    );
  }
}

class Car1 extends StatelessWidget {
  final CarData car;

  const Car1({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 8), // 外边距更宽松
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 背景图
            Positioned.fill(
              child: Image.asset(
                car.imgPath,
                fit: BoxFit.cover,
              ),
            ),

            // 顶部渐变遮罩 + 阴影
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // 底部文字信息卡片样式
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题 + 评分
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            car.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                car.rating.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    // 描述
                    Text(
                      car.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 12),
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

class _SilverHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SilverHeader({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
