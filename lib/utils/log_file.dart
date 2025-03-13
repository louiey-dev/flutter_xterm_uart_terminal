import 'dart:async';
import 'package:flutter_xterm_uart_terminal/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

    logFile = File('$path\\${formattedDate}_$logName');

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
}

// Flush the buffer to disk asynchronously
Future<void> flushLogBuffer() async {
  if (logBuffer.isNotEmpty) {
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
