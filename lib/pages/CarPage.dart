import 'package:flutter/material.dart';
import 'package:s25_module_b/module/data.dart';

class CarPage extends StatefulWidget {
  final CarData car;

  const CarPage({super.key, required this.car});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  // 状态变量
  bool _isAgreementAccepted = true;
  DateTimeRange? _selectedDateRange;
  final _imageCache = <String, ImageProvider>{};

  // 计算属性
  double get _calculatedPrice {
    final days = _selectedDateRange?.duration.inDays ?? 1;
    return widget.car.price * days;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageCache[widget.car.imgPath] ??= AssetImage(widget.car.imgPath);
    precacheImage(_imageCache[widget.car.imgPath]!, context);
  }

  void _handlePayment() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("确认支付"),
        content: Text("确定支付 ¥${_calculatedPrice.toStringAsFixed(0)} 吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("取消"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("支付成功！")),
              );
            },
            child: Text("确认"),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      currentDate: DateTime.now(),
      saveText: "确认",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => Scaffold(
          backgroundColor: Colors.black.withOpacity(0.95),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Hero(
              tag: 'car-${widget.car.name}-hero',
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 3.0,
                child: Image(image: _imageCache[widget.car.imgPath]!),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // 顶部导航栏
          _buildAppBar(isSmallScreen),

          // 主要内容
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildCarInfoCard(isSmallScreen),
                  SizedBox(height: 16),
                  _buildAddressCard(isSmallScreen),
                  SizedBox(height: 16),
                  _buildDatePickerCard(isSmallScreen),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // 底部支付栏
          _buildPaymentBar(isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isSmallScreen) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xBBDADADA), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '车辆详情',
            style: TextStyle(
              fontSize: isSmallScreen ? 22 : 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/user_avatar/user_img.jpg'),
          ),
        ],
      ),
    );
  }

  Widget _buildCarInfoCard(bool isSmallScreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.car.name,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text(
                        widget.car.rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.car.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureItem('assets/icon/seat_icon.png', '5座'),
                _buildFeatureItem('assets/icon/gate_icon.png', '4门'),
                _buildFeatureItem('assets/icon/bag_icon.png', '3箱'),
              ],
            ),
            SizedBox(height: 16),
            Hero(
              tag: 'car-${widget.car.name}-hero',
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showFullScreenImage(context),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: _imageCache[widget.car.imgPath]!,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) {
                          return progress == null
                              ? child
                              : Container(color: Colors.grey[200]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "¥${widget.car.price.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/天',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.blue[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String iconPath, String text) {
    return Column(
      children: [
        Image.asset(iconPath, width: 24, height: 24),
        SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAddressCard(bool isSmallScreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1560 Broadway', style: TextStyle(fontSize: 14)),
                  Text('Unit 1001', style: TextStyle(fontSize: 14)),
                  Text('New York, NY 10036', style: TextStyle(fontSize: 14)),
                  Text('United States', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage('assets/map/ic_map.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerCard(bool isSmallScreen) {
    final startDate = _selectedDateRange?.start ?? DateTime.now();
    final endDate =
        _selectedDateRange?.end ?? DateTime.now().add(Duration(days: 3));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _selectDateRange,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${startDate.year}/${startDate.month}/${startDate.day}",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${endDate.year}/${endDate.month}/${endDate.day}",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      "${_selectedDateRange?.duration.inDays ?? 3}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "天",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBar(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Text(
            "¥${_calculatedPrice.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  value: _isAgreementAccepted,
                  onChanged: (v) => setState(() => _isAgreementAccepted = v!),
                  activeColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      children: [
                        TextSpan(text: "同意 "),
                        TextSpan(
                          text: "用户协议",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAgreementAccepted ? Colors.blue : Colors.grey,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _isAgreementAccepted ? _handlePayment : null,
            child: Text(
              '立即支付',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
