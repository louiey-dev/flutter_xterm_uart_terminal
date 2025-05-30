import 'dart:async';
import 'package:flutter_xterm_uart_terminal/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as desktop_path;

File? logFile;
IOSink? logSink;
StringBuffer logBuffer = StringBuffer(); // To store terminal output. // louiey
const int flushLogTimerInterval = 500;
Timer? flushLogTimer; // Periodic flush timer

const Duration flushLogInterval =
    Duration(milliseconds: flushLogTimerInterval); // Flush every 500ms

const int maxLogBufferSize = 1024; // Flush when buffer reaches 1KB

// Get the local path for the application's documents directory
Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// Open the log file
void logFileOpen(String logName) async {
  try {
    final path = await localPath;
    // Get current date and time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    // louiey, 2025-05-29. Get the user's desktop path
    String? userProfile = Platform.environment['USERPROFILE'];
    if (userProfile == null) {
      throw Exception('USERPROFILE environment variable not found.');
    }
    String desktopPath = desktop_path.join(userProfile, 'Desktop') + "\\LOG";
    utils.log(desktopPath.toString());
    /////////////////////////////////////////////////////////////////

    logFile = File('$path\\${formattedDate}_$logName');

    // logFile = File('$desktopPath\\LOG\\${formattedDate}_$logName');
    // louiey, 2025-05-29. if use desktop, it stopped working....??

    if (logFile != null) {
      logSink = logFile!.openWrite(mode: FileMode.append);
      startLogFlushTimer();
    } else {
      utils.e("logFile is null");
      return;
    }

    utils.log(logFile.toString());
  } catch (e) {
    utils.e(e.toString());
  }
}

Future<void> logFileClose() async {
  stopLogFlushTimer();

  await logSink!.flush();
  await logSink!.close();

  utils.log("log file closed");
}

// Start a timer to periodically flush the buffer
void startLogFlushTimer() {
  utils.log("Log flushLogTimer started : $flushLogInterval");
  flushLogTimer = Timer.periodic(flushLogInterval, (timer) {
    flushLogBuffer();
  });
}

// Stop the timer when no longer needed
void stopLogFlushTimer() {
  if (flushLogTimer != null && flushLogTimer!.isActive) {
    flushLogTimer!.cancel(); // Stop the timer
    flushLogTimer = null; // release reference.
    utils.log("Log flushLogTimer stopped : $flushLogInterval");
  } else {
    utils.log('Log flushLogTimer is not active!');
  }
  logBuffer.clear();
  // logSink?.flush();
  // logSink?.close(); // Close the sink to release resources
}

// Flush the buffer to disk asynchronously
Future<void> flushLogBuffer() async {
  if (logBuffer.isNotEmpty) {
    // louiey, 2025-05-30. adding time stamp...still working
    // List<String> str = logBuffer.toString().split('\r\n');
    // String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // for (int i = 0; i < str.length; i++) {
    //   str[i] += '[$time] ';
    //   logSink?.write(str);
    // }

    logSink?.write(logBuffer.toString());
    logBuffer.clear(); // Clear the buffer after writing
    utils.log("log saved");
  }
}

// Check if buffer exceeds size limit and flush if necessary
void checkBufferAndFlush() {
  if (logBuffer.length >= maxLogBufferSize) {
    flushLogBuffer();
  }
}
