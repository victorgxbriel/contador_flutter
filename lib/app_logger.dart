import 'package:logger/logger.dart';

final logger = (Type type) => Logger(
  printer: AppLogger(type.toString()),
);

class AppLogger extends LogPrinter {
  final String className;
  AppLogger(this.className);
  
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji: $className: $message')];
  }
  
}