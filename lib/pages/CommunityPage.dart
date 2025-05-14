import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'CarDetailPage.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> hotPosts = [];

  List<Map<String, dynamic>> recommendPosts = [];

  List<Map<String, dynamic>> latestPosts = [];

  Future<void> loadPostData() async {
    final String jsonStr =
        await rootBundle.loadString('assets/data/community_list.json');
    final Map<String, dynamic> data = json.decode(jsonStr);

    setState(() {
      hotPosts = List<Map<String, dynamic>>.from(data['hotPosts']);
      recommendPosts = List<Map<String, dynamic>>.from(data['recommendPosts']);
      latestPosts = List<Map<String, dynamic>>.from(data['latestPosts']);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadPostData();
  }

  Widget buildPostGrid(List<Map<String, dynamic>> posts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 8,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final heroTag = 'post-${post['title']}-${post['image']}-$index';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarDetailPage(
                      post: post,
                      heroTag: heroTag,
                    ),
                  ));
            },
            child: Hero(
              tag: heroTag,
              child: Card(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      post['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 140, // 固定图片高度
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(post['title'],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${post['author']}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                          Row(
                            children: [
                              Icon(Icons.thumb_up_alt_outlined, size: 14),
                              SizedBox(width: 4),
                              Text(post['likes'].toString(),
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('精选社区'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: '热门'),
            Tab(text: '推荐'),
            Tab(text: '最新'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildPostGrid(hotPosts),
          buildPostGrid(recommendPosts),
          buildPostGrid(latestPosts),
        ],
      ),
    );
  }
}
