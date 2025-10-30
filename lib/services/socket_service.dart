import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal();

  final StreamController<String> _controller = StreamController.broadcast();
  Stream<String> get messages => _controller.stream;

  // --- Android/iOS ---
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  // --- Windows/Linux/Mac ---
  WebSocketChannel? _channel;

  Future<void> init() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _initMobile();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await _initDesktop();
    } else {
      //print("Plataforma no soportada para sockets");
    }
  }

  Future<void> _initMobile() async {
    await _pusher.init(
      apiKey: '92df15fa44931195761b',
      cluster: 'us2',
      onConnectionStateChange: (currentState, previousState) {
        //print(" Estado conexión: $currentState");
      },
      onError: (message, code, error) {
        //print(" Error: $error, Code: $code, Msg: $message");
      },
    );

    await _pusher.connect();

    await _pusher.subscribe(
      channelName: 'mi-canal',
      onEvent: (dynamic data) {
        final event = data as PusherEvent;
        final msg = "Evento: ${event.eventName} -> ${event.data}";
        //print(msg);
        _controller.add(msg);
      },
    );
  }

  Future<void> _initDesktop() async {
    _channel = WebSocketChannel.connect(
      Uri.parse(
        "wss://ws-us2.pusher.com/app/92df15fa44931195761b?protocol=7&client=dart&version=1.0&flash=false",
      ),
    );

    _channel!.stream.listen((event) {
      //print("💻 Evento recibido: $event");
      _controller.add(event);
    });

    // Suscribirse al canal
    _channel!.sink.add(jsonEncode({
      "event": "pusher:subscribe",
      "data": {"channel": "mi-canal"}
    }));
  }

  void dispose() {
    if (Platform.isAndroid || Platform.isIOS) {
      _pusher.unsubscribe(channelName: 'mi-canal');
      _pusher.disconnect();
    } else {
      _channel?.sink.close();
    }
    _controller.close();
  }
}
