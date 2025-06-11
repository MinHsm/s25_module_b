import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'CreatePostPage.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  List<Map<String, dynamic>> myPosts = [];

  @override
  void initState() {
    super.initState();
    loadMyPosts();
  }

  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/community_data.json');
  }

  Future<void> loadMyPosts() async {
    try {
      final file = await _localFile;

      if (await file.exists()) {
        final content = await file.readAsString();
        final data = json.decode(content);
        final latest =
        List<Map<String, dynamic>>.from(data['latestPosts'] ?? []);

        final userPosts =
        latest.where((post) => post['isUserPost'] == true).toList();

        setState(() {
          myPosts = userPosts;
        });
      }
    } catch (e) {
      print('加载我的文章失败: $e');
    }
  }

  Future<void> _saveMyPostsToLocal() async {
    final file = await _localFile;
    final content = await file.readAsString();
    final data = json.decode(content);

    List<Map<String, dynamic>> latest =
    List<Map<String, dynamic>>.from(data['latestPosts'] ?? []);

    // 更新 latest 中所有 isUserPost 的文章
    final newLatest = latest
        .where((post) => post['isUserPost'] != true)
        .toList(); // 先移除旧的用户文章
    newLatest.addAll(myPosts); // 添加新的用户文章

    data['latestPosts'] = newLatest;

    await file.writeAsString(json.encode(data));
  }

  void _showPostMenu(Map<String, dynamic> post, int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('编辑'),
              onTap: () async {
                Navigator.pop(context);
                final updatedPost =
                await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePostPage(existingPost: post),
                  ),
                );

                if (updatedPost != null) {
                  final newPost = {
                    ...updatedPost,
                    'isUserPost': true,
                    'timestamp': post['timestamp'],
                  };
                  setState(() {
                    myPosts[index] = newPost;
                  });
                  await _saveMyPostsToLocal();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('删除'),
              onTap: () async {
                Navigator.pop(context);
                setState(() {
                  myPosts.removeAt(index);
                });
                await _saveMyPostsToLocal();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, int index) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: post['image'].toString().startsWith('/')
            ? Image.file(File(post['image']), width: 60, fit: BoxFit.cover)
            : Image.asset(post['image'], width: 60, fit: BoxFit.cover),
        title: Text(post['title']),
        subtitle: Text(post['author']),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () => _showPostMenu(post, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的发布')),
      body: myPosts.isEmpty
          ? Center(child: Text('你还没有发布任何文章'))
          : ListView.builder(
        itemCount: myPosts.length,
        itemBuilder: (_, index) =>
            _buildPostItem(myPosts[index], index),
      ),
    );
  }
}