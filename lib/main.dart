// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jsonfile/database_helper.dart';
import 'package:just_audio/just_audio.dart';
import 'export_json.dart'; // 引入导出函数所在的文件
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';

// 显示简单 Toast
Future<void> showSimpleToast(String msg) async {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT, // 显示时长：短
    gravity: ToastGravity.BOTTOM, // 位置：底部
    timeInSecForIosWeb: 1, // iOS 和 Web 上显示时长
    backgroundColor: Colors.black54, // 背景颜色
    textColor: Colors.white, // 文本颜色
    fontSize: 16.0, // 字体大小
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // FlutterSoundPlayer? _flutterSoundPlayer; // Flutter Sound 播放器
  // late AudioPlayer _justAudioPlayer; // Just Audio 播放器
  // bool isPlayingStream = false;

  @override
  void initState() {
    super.initState();
    // _flutterSoundPlayer = FlutterSoundPlayer();
    // _justAudioPlayer = AudioPlayer();
    // _initPlayers();
  }

  // Future<void> _initPlayers() async {
  //   await _flutterSoundPlayer!.openPlayer(); // 初始化 Flutter Sound
  //   await _justAudioPlayer
  //       .setAsset('asstes/warning2.mp3'); // 加载 Just Audio 的短音频
  // }

  // @override
  // void dispose() {
  //   _flutterSoundPlayer!.stopPlayer(); // 停止 Flutter Sound 播放
  //   _flutterSoundPlayer = null; // 释放 Flutter Sound 播放器
  //   _justAudioPlayer.dispose(); // 释放 Just Audio 播放器
  //   super.dispose();
  // }

  // // 播放音频流
  // void _playStream() async {
  //   if (!isPlayingStream) {
  //     await _flutterSoundPlayer!.startPlayer(
  //       fromURI:
  //           'https://fetaphon-test.oss-cn-qingdao.aliyuncs.com/sound_mp3/1089130_1729218563812.mp3',
  //       codec: Codec.mp3,
  //     );
  //     setState(() {
  //       isPlayingStream = true;
  //     });
  //   } else {
  //     await _flutterSoundPlayer!.stopPlayer();
  //     setState(() {
  //       isPlayingStream = false;
  //     });
  //   }
  // }

  // // 播放短音频
  // void _playShortAudio() async {
  //   await _justAudioPlayer.seek(Duration.zero); // 确保从头播放
  //   _justAudioPlayer.play();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _flutterSoundPlayer = FlutterSoundPlayer();

  //   _init();
  // }

  // Future<void> _init() async {
  //   _audioPlayer = AudioPlayer();

  //   // 设置音频会话
  //   final session = await AudioSession.instance;
  //   await session.configure(AudioSessionConfiguration.speech());

  //   // 加载音频文件
  //   try {
  //     await _audioPlayer.setAsset('asstes/warning2.mp3');
  //   } catch (e) {
  //     print("Error loading audio file: $e");
  //   }
  // }

  // // 重新播放音频的方法
  // void _playAudio() async {
  //   await _audioPlayer.seek(Duration.zero); // 将音频播放位置重置为 0
  //   _audioPlayer.play();
  // }

  // @override
  // void dispose() {
  //   _audioPlayer.dispose();
  //   super.dispose();
  // }

  // 插入新数据
  Future<void> insertNewData() async {
    await dbHelper.insertItem('苹果', 10);
    await dbHelper.insertItem('香蕉', 20);
    await dbHelper.insertUser('alice', 'alice@example.com');
    await dbHelper.insertUser('bob', 'bob@example.com');
    showSimpleToast("插入新数据成功");
  }

  // 清空数据库
  Future<void> clearDatabase() async {
    try {
      await dbHelper.clearDatabase();
      showSimpleToast('清空数据库成功');
    } catch (e) {
      showSimpleToast('清空数据库失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '数据库导出示例',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('导出数据库为 JSON'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await exportDatabaseToJson();
                  },
                  child: const Text('导出数据为 JSON'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await insertNewData();
                  },
                  child: const Text('插入新数据'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await importDatabaseFromJson(context);
                  },
                  child: const Text('从外部导入JSON文件并覆盖数据库'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await clearDatabase();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // 将按钮颜色设置为红色以示警告
                  ),
                  child: const Text('清空数据库'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
