import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CarDetailPage.dart';
import 'CreatePostPage.dart';
import 'MyPostsPage.dart';

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
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/community_data.json');

      if (await file.exists()) {
        final content = await file.readAsString();
        final data = json.decode(content);

        final latest = List<Map<String, dynamic>>.from(data['latestPosts'] ?? []);

        // 推荐包含所有类型的文章（包括用户发的）
        final userPosts = latest.where((p) => p['isUserPost'] == true).toList();
        final otherPosts = latest.where((p) => p['isUserPost'] != true).toList();

        final newRecommendPosts = [
          ...userPosts.take(2),      // 优先展示前2条用户发的
          ...otherPosts.take(3),     // 再展示3条其他文章
        ];

        setState(() {
          hotPosts = List<Map<String, dynamic>>.from(data['hotPosts'] ?? []);
          latestPosts = latest;
          recommendPosts = newRecommendPosts;
        });
        return;
      }
    } catch (e) {
      print('加载本地 JSON 数据失败: $e');
    }

    // fallback 数据加载
    final String jsonStr = await rootBundle.loadString('assets/data/community_list.json');
    final Map<String, dynamic> data = json.decode(jsonStr);

    final latest = List<Map<String, dynamic>>.from(data['latestPosts']);
    final newRecommendPosts = latest.take(5).toList();

    setState(() {
      hotPosts = List<Map<String, dynamic>>.from(data['hotPosts']);
      latestPosts = latest;
      recommendPosts = newRecommendPosts;
    });
  }

  void addNewPost(Map<String, dynamic> newPost) {
    final updatedPost = {
      ...newPost,
      'isUserPost': true,
    };

    final updatedLatestPosts = List<Map<String, dynamic>>.from(latestPosts);
    updatedLatestPosts.insert(0, updatedPost);

    setState(() {
      latestPosts = updatedLatestPosts;
      recommendPosts = [updatedPost, ...recommendPosts.take(4)];
    });

    _saveToJson();
  }

  Future<void> _saveToJson() async {
    final newData = {
      'hotPosts': hotPosts,
      'recommendPosts': recommendPosts,
      'latestPosts': latestPosts,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('communityData', json.encode(newData));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/community_data.json');
    await file.writeAsString(json.encode(newData));
  }

  Widget _buildPostImage(String path) {
    if (path.startsWith('/')) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 140,
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 140,
      );
    }
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
                    _buildPostImage(post['image']),
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
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              // 跳转到我的发布页面
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyPostsPage()),
              );
              // 返回后刷新数据
              await loadPostData();
            },
          )
        ],
      ),
      body: RefreshIndicator(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildPostGrid(hotPosts),
              buildPostGrid(recommendPosts),
              buildPostGrid(latestPosts),
            ],
          ),
          onRefresh: loadPostData),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostPage(),
            ),
          );

          if (newPost != null && mounted) {
            final postWithTime = {
              ...newPost,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            };
            addNewPost(postWithTime);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('"${newPost['title']}"已发布'),
              duration: Duration(seconds: 2),
            ));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
