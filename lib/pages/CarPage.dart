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
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Color(0xBBDADADA), width: 2))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image:
                                AssetImage('assets/user_avatar/user_img.jpg'))),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.car.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.yellow[50],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow[500],
                                  ),
                                  Text(
                                    widget.car.rating.toString(),
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
                        padding: EdgeInsets.only(left: 20, top: 5),
                        child: Text(
                          widget.car.description,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
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
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(widget.car.imgPath),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            width: 300,
                            height: 45,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // 使两部分分开
                              children: [
                                // 价格部分
                                Container(
                                  width: 140,
                                  height: 40,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "\$${widget.car.price.toStringAsFixed(0)}",
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
                              ],
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Card(
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 10),
                            child: Icon(
                              Icons.location_on_sharp,
                              color: Colors.grey[400],
                              size: 30,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1560 Broadway',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500]),
                              ),
                              Text(
                                'Unit 1001',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500]),
                              ),
                              Text(
                                'New York,NY 10036',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500]),
                              ),
                              Text(
                                'United States',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[500]),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      width: 110,
                      height: 85,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(1, 2))
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/map/ic_map.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: Card(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '11/12/2020',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '14/12/2020',
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: 150,
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xBBE0E0E0),
                                    offset: Offset(3, 3),
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ]),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.white,
                                  padding:
                                      EdgeInsets.only(left: 0, bottom: 20)),
                              onPressed: () {},
                              child: Icon(
                                Icons.minimize_outlined,
                                size: 30,
                                color: Colors.blue,
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '3',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              'Days',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[500]),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xBBE0E0E0),
                                    offset: Offset(3, 3),
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ]),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.only(
                                    left: 0,
                                  )),
                              onPressed: () {},
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.blue,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '\$630',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
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
                        Text(
                          'Accepted ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Expanded(
                            child: Text(
                          'User Agreement',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.wavy,
                              decorationThickness: 1,
                              decorationColor: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                  ),
                  Container(
                    width: 105,
                    height: 40,
                    margin: EdgeInsets.only(right: 5, left: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      onPressed: () {},
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
