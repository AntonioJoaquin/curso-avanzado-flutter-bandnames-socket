import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  // ignore: non_constant_identifier_names
  final String _DIR_IP = "192.168.1.15";

  ServerStatus _serverStatus = ServerStatus.Connecting;
    get serverStatus => this._serverStatus;


  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io('http://$_DIR_IP:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });


    socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;

      notifyListeners();
    });

    socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;

      notifyListeners();
    });

    socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje: $payload');
    });
  }

}