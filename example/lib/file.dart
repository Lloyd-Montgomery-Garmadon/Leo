import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class UploadMinioDioPage extends StatefulWidget {
  @override
  _UploadMinioDioPageState createState() => _UploadMinioDioPageState();
}

class _UploadMinioDioPageState extends State<UploadMinioDioPage> {
  final TextEditingController bucketController = TextEditingController(
    text: 'test',
  );
  final TextEditingController filenameController = TextEditingController(
    text:
        '/user/${DateTime.now().toString().replaceAll(RegExp(r'[^\w\-_\.\/]'), '_')}',
  );
  File? selectedFile;
  String log = '';
  double progress = 0.0;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null ||
        bucketController.text.isEmpty ||
        filenameController.text.isEmpty) {
      setState(() {
        log = '请填写所有字段并选择文件。';
      });
      return;
    }

    final mimeType =
        lookupMimeType(selectedFile!.path) ?? 'application/octet-stream';
    final fileName = path.basename(selectedFile!.path);

    // 获取原始文件名后缀
    String originalExtension = selectedFile!.path.split('.').last;

    // 构造最终文件名：文本框内容 + 原文件后缀
    String finalFileName = '${filenameController.text}.$originalExtension';

    // 构造 FormData
    FormData formData = FormData.fromMap({
      'bucket': bucketController.text,
      'filename': finalFileName, // 上传给服务器的参数
      'file': await MultipartFile.fromFile(
        selectedFile!.path,
        filename: finalFileName, // 实际上传时的文件名
      ),
    });

    setState(() {
      log =
          '=== 请求体参数详情 ===\n'
          'bucket: ${bucketController.text}\n'
          'filename: ${filenameController.text}\n'
          'file.name: $fileName\n'
          'file.size: ${selectedFile!.lengthSync()} 字节\n'
          'file.type: $mimeType\n';
      progress = 0.0;
    });

    try {
      Dio dio = Dio();

      final response = await dio.post(
        'http://192.168.31.163:8080/upload',
        data: formData,
        onSendProgress: (sent, total) {
          setState(() {
            progress = sent / total;
          });
        },
        options: Options(contentType: 'multipart/form-data'),
      );

      setState(() {
        log += '\n=== 上传成功 ===\n${response.data}';
      });
    } catch (e) {
      setState(() {
        log += '\n=== 上传失败 ===\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('使用 Dio 上传文件到 MinIO')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: bucketController,
              decoration: InputDecoration(labelText: '存储桶名'),
            ),
            TextField(
              controller: filenameController,
              decoration: InputDecoration(labelText: '文件名'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickFile,
              child: Text(
                selectedFile == null
                    ? '选择文件'
                    : '已选择：${path.basename(selectedFile!.path)}',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: uploadFile, child: Text('上传')),
            if (progress > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(value: progress),
              ),
            SizedBox(height: 20),
            Text('日志输出：', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.grey[100],
              child: Text(log),
            ),
          ],
        ),
      ),
    );
  }
}
