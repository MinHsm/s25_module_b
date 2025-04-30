import 'package:flutter/material.dart';
import 'package:s25_module_b/pages/CarPage.dart';

import '../module/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  final List<CarData> carItems = [
    CarData(
        name: 'BMW X4 Sports',
        imgPath: 'assets/car/bmw_car_img.png',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8),
    CarData(
        name: 'BMW X4 Sports',
        imgPath: 'assets/car/bmw_car_img_black.png',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8),
    CarData(
        name: 'BMW X4 Sports',
        imgPath: 'assets/car/bmw_car_img_red.jpg',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8),
    CarData(
        name: 'BMW X4 Sports',
        imgPath: 'assets/car/bmw_car_img_sliver.jpg',
        description: '2019 · Comfort Class',
        price: 210,
        rating: 4.8)
  ];

  List listTitle = ["EXPLORE", "CARS", "TRUCKS", "SCOOTERS", "HELICOPTERS"];
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
                            'Explore',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/user_avatar/user_img.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width - 80,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15)),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: _controller,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'What transport do you want?',
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _controller.clear();
                                          });
                                        },
                                        icon: Icon(Icons.clear)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Image.asset('assets/icon/filter_icon.png'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          for (var i = 0; i < listTitle.length; i++)
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    titleIndex = i;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  margin:
                                      EdgeInsets.only(left: i == 0 ? 0 : 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: titleIndex == i
                                                  ? Colors.blue
                                                  : Colors.white,
                                              width: 2))),
                                  child: Text(
                                    listTitle[i],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
            Container(
              height: 340,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: carItems.length,
                    itemBuilder: (context, index) {
                      final car = carItems[index];
                      return Car1(car: car);
                    },
                  )),
            ),
            Container(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Trending Categories',
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
                          'Recently viewed',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'We show you latest search results',
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
                                            'BMW M5 G-Power',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Tel-Aviv,israel',
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
                                    Positioned(
                                        top: 110,
                                        left: 95,
                                        child: Container(
                                            width: 90,
                                            height: 38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blue),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '\$220/day',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )))
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
                                            'Ford Mustang GT',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Tel-Aviv,israel',
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
                                    Positioned(
                                        top: 110,
                                        left: 95,
                                        child: Container(
                                            width: 90,
                                            height: 38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blue),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '\$220/day',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )))
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
                                            'Audi A7 2018',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Warsaw,Poland',
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
                                    Positioned(
                                        top: 110,
                                        left: 95,
                                        child: Container(
                                            width: 90,
                                            height: 38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blue),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '\$220/day',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )))
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
                                            'Mercedes-Benz SLS',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Haifa,Israel',
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
                                    Positioned(
                                        top: 110,
                                        left: 95,
                                        child: Container(
                                            width: 90,
                                            height: 38,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blue),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '\$220/day',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )))
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
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      car.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 80),
                      width: 80,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[500],
                          ),
                          Text(
                            car.rating.toString(),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[500]),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  car.description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 20,
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/icon/seat_icon.png'),
                      ),
                      Text(
                        '5',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/icon/gate_icon.png'),
                      ),
                      Text(
                        '4',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/icon/bag_icon.png'),
                      ),
                      Text(
                        '3',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  height: 140,
                  width: 300,
                  child: Image.asset(car.imgPath),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    width: 300,
                    height: 45,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // 使两部分分开
                      children: [
                        // 价格部分
                        Container(
                          width: 120,
                          height: 40,
                          child: Row(
                            children: [
                              Text(
                                "\$${car.price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' per day',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 预订按钮
                        SizedBox(
                          width: 110,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CarPage(
                                            car: car,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero, // 移除默认内边距
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          )
        ],
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
  double get maxExtent => 190;

  @override
  double get minExtent => 190;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
