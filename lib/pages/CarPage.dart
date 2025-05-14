import 'package:flutter/material.dart';
import 'package:s25_module_b/module/data.dart';

class CarPage extends StatefulWidget {
  final CarData car;

  const CarPage({super.key, required this.car});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  bool _isClick = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360; // 小屏幕设备判断

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 顶部导航栏
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xBBDADADA),
                            width: 2,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '订购',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isSmallScreen ? 22 : 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/user_avatar/user_img.jpg'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 主要内容
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          children: [
                            // 车辆信息卡片
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.car.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isSmallScreen ? 18 : 20,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth * 0.25,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow[50],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow[500],
                                                size: isSmallScreen ? 16 : 20,
                                              ),
                                              Text(
                                                widget.car.rating.toString(),
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 18 : 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.yellow[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      widget.car.description,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: isSmallScreen ? 16 : 18,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Container(
                                      height: 20,
                                      width: screenWidth * 0.4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildFeatureItem(
                                            'assets/icon/seat_icon.png',
                                            '5',
                                            isSmallScreen,
                                          ),
                                          _buildFeatureItem(
                                            'assets/icon/gate_icon.png',
                                            '4',
                                            isSmallScreen,
                                          ),
                                          _buildFeatureItem(
                                            'assets/icon/bag_icon.png',
                                            '3',
                                            isSmallScreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Hero(
                                      tag: 'car-image-${widget.car.imgPath}',
                                      // 确保每个图片有唯一tag
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                appBar: AppBar(),
                                                body: Center(
                                                  child: Hero(
                                                    tag:
                                                        'car-image-${widget.car.imgPath}',
                                                    child: Image.asset(
                                                        widget.car.imgPath),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.asset(
                                            widget.car.imgPath,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "\$${widget.car.price.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 26 : 30,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' per day',
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 10 : 12,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // 地址卡片
                            Card(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_sharp,
                                            color: Colors.grey[400],
                                            size: isSmallScreen ? 24 : 30,
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '1560 Broadway',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Text(
                                                  'Unit 1001',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Text(
                                                  'New York,NY 10036',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                                Text(
                                                  'United States',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * 0.3,
                                      height: screenHeight * 0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/map/ic_map.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // 日期选择卡片
                            Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          color: Colors.grey,
                                          size: isSmallScreen ? 24 : 30,
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '11/12/2020',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize:
                                                    isSmallScreen ? 14 : 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '14/12/2020',
                                              style: TextStyle(
                                                color: Colors.blue[700],
                                                fontSize:
                                                    isSmallScreen ? 14 : 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: screenWidth * 0.4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildCounterButton(
                                            Icons.remove,
                                            () {},
                                            isSmallScreen,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '3',
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 16 : 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                'Days',
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 12 : 14,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                          _buildCounterButton(
                                            Icons.add,
                                            () {},
                                            isSmallScreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // 底部支付栏
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '\$630',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: isSmallScreen ? 26 : 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.blue,
                                          checkColor: Colors.white,
                                          value: _isClick,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isClick = value!;
                                            });
                                          },
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Accepted ',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: 'User Agreement',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                    color: Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.28,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Pay Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 10 : 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(String iconPath, String text, bool isSmallScreen) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: isSmallScreen ? 16 : 20,
          height: isSmallScreen ? 16 : 20,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterButton(
      IconData icon, VoidCallback onPressed, bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 36 : 45,
      height: isSmallScreen ? 36 : 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xBBE0E0E0),
            offset: Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: isSmallScreen ? 20 : 24,
          color: Colors.blue,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
