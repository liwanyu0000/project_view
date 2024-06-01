import 'package:redis/redis.dart';

class NotifyChannel {
  final dynamic host;
  final dynamic port;
  final void Function(dynamic event) onData;
  final void Function()? onDone;
  final Function? onError;
  final bool canErrReconnection;
  final Duration duration;
  NotifyChannel({
    required this.host,
    required this.onData,
    this.onError,
    this.onDone,
    this.port = 6379,
    this.canErrReconnection = true,
    this.duration = const Duration(seconds: 5),
  });
  Command? _command;
  set command(Command command) => _command = command;

  void _onError(
      Object error, List<String> channels, String? pwd, int count) async {
    if (_command == null) return;
    if (canErrReconnection) {
      _command?.get_connection().close();
      await Future.delayed(duration);
      start(channels, pwd, count + 1);
    }
    onError?.call(error);
  }

  stop() {
    _command?.get_connection().close();
    _command = null;
  }

  Future start(List<String> channels, String? pwd, [int count = 1]) async {
    Command? command;
    try {
      command = await RedisConnection().connect(host, port);
      _command = command;
      if (_command == null) _onError("command is Null", channels, pwd, count);
      if (pwd != null) _command!.send_object(["AUTH", pwd]);
      PubSub pubSub = PubSub(_command!);
      pubSub.subscribe(channels);
      pubSub.getStream().listen((event) async {
        await Future.delayed(const Duration(milliseconds: 500));
        onData(event);
      }, onError: (e) => _onError(e, channels, pwd, count), onDone: onDone);
    } catch (e) {
      command?.get_connection().close();
      _onError(e, channels, pwd, count);
    }
  }
}
