import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class CarDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final String heroTag;

  const CarDetailPage({required this.post, super.key, required this.heroTag});

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  bool hasLiked = false;
  int likeCount = 0;
  String fullContent = '加载中...';
  List<Map<String, String>> comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    loadArticleContent();
    super.initState();
    likeCount = widget.post['likes'];
    comments = [
      {'author': '小王', 'comment': '写得不错，支持一下！'},
      {'author': '老李', 'comment': '我也刚提车，想了解更多经验。'},
      {'author': '用户A', 'comment': '冬季续航确实要注意。'},
    ];
  }

  Future<void> loadArticleContent() async {
    try {
      final String jsonStr =
          await rootBundle.loadString('assets/data/article_content.json');
      final Map<String, dynamic> data = json.decode(jsonStr);
      final List articles = data['articles'];

      final match = articles.firstWhere(
        (item) => item['title'] == widget.post['title'],
        orElse: () => {'content': '暂无正文内容'},
      );

      setState(() {
        fullContent = match['content'];
      });
    } catch (e) {
      setState(() {
        fullContent = '加载失败：$e';
      });
    }
  }

  void toggleLike() {
    if (!hasLiked) {
      setState(() {
        likeCount++;
        hasLiked = true;
      });
    }
  }

  void sendComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        comments.insert(0, {
          'author': '我', // 可替换为当前用户昵称
          'comment': text,
        });
        _commentController.clear();
      });
    }
  }

  void _sharePost() {
    final post = widget.post;
    final shareText = '${post['title']} - 来自Min的汽车社区\n'
        '作者: ${post['author']}\n'
        '点赞数: ${post['likes']}\n\n'
        '查看详情: https://分享测试暂无跳转链接${post['id']}';

    Share.share(shareText);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(
        title: Text('文章详情'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _sharePost();
                });
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 80), // 给底部按钮预留空间
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 封面图
                  Hero(
                    tag: widget.heroTag,
                    child: Image.asset(
                      post['image'],
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // 标题
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      post['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // 作者 & 点赞数
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 18, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text(post['author'],
                            style: TextStyle(color: Colors.grey[700])),
                        Spacer(),
                        Icon(Icons.thumb_up_alt_outlined,
                            size: 18, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text('$likeCount',
                            style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // 正文内容
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${post['title']}，${fullContent}',
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                  ),

                  SizedBox(height: 24),

                  // 评论标题
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('评论',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 8),

                  // 评论列表
                  ...comments.map((c) => ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text(c['author']!),
                        subtitle: Text(c['comment']!),
                      )),
                ],
              ),
            ),
          ),

          // 底部栏
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // 评论输入框
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '写评论...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // 点赞按钮
                IconButton(
                  icon: Icon(
                    hasLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                    color: hasLiked ? Colors.red : Colors.grey[600],
                  ),
                  onPressed: toggleLike,
                ),

                // 发送按钮
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
