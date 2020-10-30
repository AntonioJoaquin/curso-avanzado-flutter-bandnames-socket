import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  // IP para dispositivo físico
  // ignore: non_constant_identifier_names
  final String _DIR_IP = "192.168.1.15";

  // IP para dispositivo emulado
  // ignore: non_constant_identifier_names
  final String _DIR_IP_EMU = "10.0.2.2";

  ServerStatus _serverStatus = ServerStatus.Connecting;
    ServerStatus get serverStatus => this._serverStatus;

  IO.Socket _socket;
    IO.Socket get socket => this._socket;


  Function get emit => this._socket.emit;


  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://$_DIR_IP_EMU:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });


    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;

      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;

      notifyListeners();
    });
  }

}