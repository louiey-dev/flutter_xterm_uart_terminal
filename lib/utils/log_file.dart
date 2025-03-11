import 'dart:async';

import 'package:flutter_xterm_uart_terminal/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
/*
Future<File>? logFile;

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/xterm_log.txt');
}

Future<void> writeLog(String log) async {
  final file = await localFile;
  await file.writeAsString('$log\n', mode: FileMode.append);
}

Future<File> logFileOpen(String logName) async {
  final path = await localPath;
  return File('$path/$logName');
}

Future<void> logFileWrite(String log) async {
  final file = await localFile;
  await file.writeAsString(log, mode: FileMode.append);
}
*/

File? logFile;

IOSink? logSink;

StringBuffer logBuffer = StringBuffer(); // To store terminal output. // louiey

Timer? flushTimer; // Periodic flush timer

const Duration flushInterval = Duration(milliseconds: 500); // Flush every 500ms

const int maxBufferSize = 1024; // Flush when buffer reaches 1KB

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

void logFileOpen(String logName) async {
  try {
    final path = await localPath;
    // Get current date and time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    logFile = File('$path\\${formattedDate}_$logName');

    if (logFile != null) {
      logSink = logFile!.openWrite(mode: FileMode.append);
      startFlushTimer();
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
void startFlushTimer() {
  utils.log("Log FlushTimer started : $flushInterval");
  flushTimer = Timer.periodic(flushInterval, (timer) {
    flushBuffer();
  });
}

// Flush the buffer to disk asynchronously
Future<void> flushBuffer() async {
  if (logBuffer.isNotEmpty) {
    logSink?.write(logBuffer.toString());
    logBuffer.clear(); // Clear the buffer after writing
    utils.log("log saved");
  }
}

// Check if buffer exceeds size limit and flush if necessary
void checkBufferAndFlush() {
  if (logBuffer.length >= maxBufferSize) {
    flushBuffer();
  }
}

/*
Future<void> logFileWrite(String log) async {
  // await logFile.writeAsString(log, mode: FileMode.append);
  await logFile!.writeAsString(log, mode: FileMode.append, flush: true);
  // utils.d(log);
}
*/
void logFileWrite(String log) async {
  try {
    // await logFile!.writeAsString(log, mode: FileMode.append, flush: true);
    await logFile!.writeAsString(logBuffer.toString(),
        mode: FileMode.append, flush: true);
    logBuffer.clear();
    // utils.d(log);
  } catch (e) {
    utils.e(e.toString());
  }
}
