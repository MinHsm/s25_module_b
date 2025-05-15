import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String selectedColor = '白色';
  String selectedBattery = '100kWh';
  String payment = '支付宝';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void submitOrder() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请填写完整信息')));
      return;
    }

    // 模拟提交
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('下单成功'),
        content: Text('我们会尽快与您联系确认交付信息'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.orange[700]; // 小米风格主色

    return Scaffold(
      appBar: AppBar(
        title: Text('车辆订购'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),
      backgroundColor: Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 商品信息卡片
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/categories/car1.png',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '小米 SU7 高性能版',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('￥299,900',
                        style: TextStyle(fontSize: 18, color: themeColor)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 选择配置卡片
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('颜色选择', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['白色', '蓝色', '灰色'].map((color) {
                        return ChoiceChip(
                          label: Text(color),
                          selected: selectedColor == color,
                          selectedColor: themeColor?.withOpacity(0.2),
                          onSelected: (_) => setState(() => selectedColor = color),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('电池容量', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['100kWh', '120kWh'].map((batt) {
                        return ChoiceChip(
                          label: Text(batt),
                          selected: selectedBattery == batt,
                          selectedColor: themeColor?.withOpacity(0.2),
                          onSelected: (_) => setState(() => selectedBattery = batt),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 用户信息卡片
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInput(nameController, '联系人姓名'),
                    SizedBox(height: 12),
                    _buildInput(phoneController, '联系电话', keyboardType: TextInputType.phone),
                    SizedBox(height: 12),
                    _buildInput(addressController, '收货地址'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 支付方式
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    RadioListTile(
                      value: '微信',
                      groupValue: payment,
                      onChanged: (value) => setState(() => payment = value!),
                      title: Text('微信支付'),
                    ),
                    RadioListTile(
                      value: '支付宝',
                      groupValue: payment,
                      onChanged: (value) => setState(() => payment = value!),
                      title: Text('支付宝'),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('确认下单', style: TextStyle(fontSize: 16)),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}