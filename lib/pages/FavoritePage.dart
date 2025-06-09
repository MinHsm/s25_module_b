import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/FavoriteProvider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoriteProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: favorites.isEmpty
          ? const Center(child: Text('暂无收藏'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final product = favorites[index];
          return ListTile(
            leading: Image.asset(product['image'], width: 50, fit: BoxFit.cover),
            title: Text(product['name']),
            subtitle: Text('￥${product['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<FavoriteProvider>(context, listen: false).toggleFavorite(product);
              },
            ),
          );
        },
      ),
    );
  }
}