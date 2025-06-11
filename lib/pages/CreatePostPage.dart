import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  final Map<String, dynamic>? existingPost;

  const CreatePostPage({super.key, this.existingPost});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // 如果是编辑模式，填充已有内容
    if (widget.existingPost != null) {
      final post = widget.existingPost!;
      _titleController.text = post['title'] ?? '';
      _authorController.text = post['author'] ?? '';
      _contentController.text = post['content'] ?? '';
      _imagePath = post['image'];
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('选择图片来源'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('请添加一张图片')),
        );
        return;
      }

      final post = {
        'title': _titleController.text,
        'author': _authorController.text,
        'content': _contentController.text,
        'image': _imagePath,
        'likes': widget.existingPost?['likes'] ?? 0,
        'isUserPost': true,
      };

      Navigator.pop(context, post);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPost != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑文章' : '发布文章'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: _imagePath == null
                    ? Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50),
                      SizedBox(height: 8),
                      Text('点击添加图片', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
                    : Stack(
                  children: [
                    Image(
                      image: _imagePath!.startsWith('/')
                          ? FileImage(File(_imagePath!))
                          : AssetImage(_imagePath!) as ImageProvider,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: FloatingActionButton.small(
                        onPressed: _showImageSourceDialog,
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: '标题'),
                validator: (value) =>
                value == null || value.isEmpty ? '请输入标题' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(labelText: '作者'),
                validator: (value) =>
                value == null || value.isEmpty ? '请输入作者名' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: '内容'),
                maxLines: 5,
                validator: (value) =>
                value == null || value.isEmpty ? '请输入内容' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? '保存修改' : '发布'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}