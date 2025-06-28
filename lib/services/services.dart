import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
// import 'package:connectivity_plus/connectivity_plus.dart';

String serverUrl = 'http://192.168.18.2:3000';

class MySocket {
  io.Socket? socket;

  void connectSocket(userId) {
    if (socket != null && socket!.connected) {
      return;
    }

    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      _registerUser(userId);
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   if (WidgetsBinding.instance.lifecycleState ==
      //       AppLifecycleState.resumed) {
      //     _sendStatusUpdate(userId, 'online');
      //   } else {
      //     _sendStatusUpdate(userId, 'idle');
      //   }
      // });
      debugPrint('Socket connected!');
    });

    socket!.onDisconnect((_) {
      debugPrint('Socket disconnected!');
    });

    socket!.onConnectError((err) {
      debugPrint('Socket Connect Error: $err');
    });

    socket!.onError((err) {
      debugPrint('Socket Error: $err');
    });
  }

  void _registerUser(String uid) {
    if (socket?.connected ?? false) {
      socket!.emit('register_user', uid);
    } else {
      debugPrint('Socket not connected, cannot register user $uid.');
    }
  }

  // void _sendStatusUpdate(String uid, String status) {
  //   if (socket?.connected ?? false) {
  //     socket!.emit('user_status_update', {'uid': uid, 'status': status});
  //     debugPrint('Sent status update for $uid: $status');
  //   }
  // }

  void disconnectSocket() {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      debugPrint('Manually disconnected socket.');
    }
  }
}

class APICalls {
  Future<List<String>> classifyTextPerform(String text) async {
    var url = Uri.parse('$serverUrl/classify-text');
    Map data = {'text': text};
    var response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['categories'].cast<String>();
      } else if (response.statusCode == 400) {
        debugPrint('invalid input');
        return <String>[];
      } else {
        debugPrint('communication error');
        return <String>[];
      }
    } catch (e) {
      debugPrint('error in post data: $e');
      return <String>[];
    }
  }
}
