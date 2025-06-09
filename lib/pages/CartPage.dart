import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/CartProvider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    double totalPrice = cartItems
        .where((item) => item['selected'] == true)
        .fold(0, (sum, item) => sum + (item['price'] as num).toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: cartItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: cartProvider.allSelected,
                      onChanged: (value) => cartProvider
                          .toggleAllSelected(value ?? false),
                    ),
                    const Text('全选'),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    if (cartItems
                        .any((item) => item['selected'] == true)) {
                      _confirmBatchRemove(context, cartProvider);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('请选择要删除的商品')));
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    '删除选中',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(context, item, cartProvider);
              },
            ),
          ),
          _buildBottomBar(totalPrice, context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('购物车是空的',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('去商城看看'),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Map<String, dynamic> item,
      CartProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: item['selected'] ?? false,
              onChanged: (value) {
                provider.toggleItemSelected(item, value ?? false);
              },
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(item['image'], width: 60, height: 60),
            ),
          ],
        ),
        title: Text(item['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('￥${item['price']}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmRemove(context, item, provider),
        ),
      ),
    );
  }

  Widget _buildBottomBar(double totalPrice, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, -1),
              blurRadius: 5)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('总计：￥${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('暂未实现结算功能')));
            },
            child: const Text('结算'),
          )
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, Map<String, dynamic> item,
      CartProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('你确定要从购物车删除 "${item['name']}" 吗？'),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('删除', style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.removeFromCart(item);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmBatchRemove(
      BuildContext context, CartProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('你确定要删除选中的所有商品吗？'),
        actions: [
          TextButton(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('删除', style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.removeSelectedItems();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}