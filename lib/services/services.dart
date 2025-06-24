import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:connectivity_plus/connectivity_plus.dart';

class MySocket {
  io.Socket? socket;
  final String serverUrl = 'http://192.168.18.2:3000';

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (WidgetsBinding.instance.lifecycleState ==
            AppLifecycleState.resumed) {
          _sendStatusUpdate(userId, 'online');
        } else {
          _sendStatusUpdate(userId, 'idle');
        }
      });
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

  void _sendStatusUpdate(String uid, String status) {
    if (socket?.connected ?? false) {
      socket!.emit('user_status_update', {'uid': uid, 'status': status});
      debugPrint('Sent status update for $uid: $status');
    }
  }

  void disconnectSocket() {
    if (socket != null && socket!.connected) {
      socket!.disconnect();
      debugPrint('Manually disconnected socket.');
    }
  }
}
