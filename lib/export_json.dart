// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jsonfile/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'database_helper.dart'; // 引入上面创建的 DatabaseHelper

Future<void> exportDatabaseToJson() async {
  final dbHelper = DatabaseHelper();

  // 获取所有表名
  List<String> tableNames = await dbHelper.getTableNames();

  // 创建一个 Map 来存储所有表的数据
  Map<String, dynamic> databaseData = {};

  for (String table in tableNames) {
    List<Map<String, dynamic>> tableData = await dbHelper.getTableData(table);
    databaseData[table] = tableData;
  }

  // 将 Map 转换为 JSON 字符串
  String jsonString = jsonEncode(databaseData);

  // 获取临时目录路径
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/database_export.json';

  // 写入 JSON 文件
  File file = File(path);
  await file.writeAsString(jsonString);

  // 确保文件存在后再分享
  if (await file.exists()) {
    await Share.shareXFiles([XFile(path)],
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100));
  } else {
    showSimpleToast('文件不存在: $path');
  }
}

// 从 JSON 文件导入数据到数据库
Future<void> importDatabaseFromJson(BuildContext context) async {
  final dbHelper = DatabaseHelper();

  // 选择 JSON 文件
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, type: FileType.custom, allowedExtensions: ['json']);

  if (result != null && result.files.single.path != null) {
    await dbHelper.clearDatabase();

    String path = result.files.single.path!;

    // 读取 JSON 文件内容
    String jsonString = await File(path).readAsString();

    // 解析 JSON
    Map<String, dynamic> databaseData = jsonDecode(jsonString);

    // 遍历所有表并插入数据
    for (String table in databaseData.keys) {
      List<dynamic> tableData = databaseData[table];
      List<Map<String, dynamic>> dataToInsert = List<Map<String, dynamic>>.from(
        tableData.map((item) => Map<String, dynamic>.from(item)),
      );

      await dbHelper.insertMultipleData(table, dataToInsert);
    }
    showSimpleToast('成功导入 JSON 数据');
  } else {
    showSimpleToast('用户未选择文件');
  }
}
