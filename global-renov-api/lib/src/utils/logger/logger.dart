import 'package:logging/logging.dart';

final Logger log = Logger('GlobalRenovAPI');

void initializeLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(colorLog(record));
  });
}

// Function to determine color according to log level
String colorForLevel(Level level) {
  if (level == Level.SEVERE) {
    return '\x1B[31m'; // Rouge
  } else if (level == Level.WARNING) {
    return '\x1B[33m'; // Jaune
  } else if (level == Level.INFO) {
    return '\x1B[32m'; // Vert
  } else if (level == Level.CONFIG) {
    return '\x1B[36m'; // Cyan
  } else {
    return '\x1B[37m'; // Blanc
  }
}

// Function to format log message with color
String colorLog(LogRecord record) {
  var color = colorForLevel(record.level);
  return '$color[${record.loggerName}]: ${record.level.name}: ${record.time}: ${record.message}\x1B[0m';
}
