import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/CartProvider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartProvider>(context).cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('购物车是空的'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.asset(item['image'], width: 50),
                  title: Text(item['name']),
                  subtitle: Text('￥${item['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .removeFromCart(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
