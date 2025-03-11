import 'package:flutter_xterm_uart_terminal/utils/utils.dart';
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

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

void logFileOpen(String logName) async {
  final path = await localPath;
  logFile = File('$path\\$logName');
  utils.log(logFile.toString());
}

/*
Future<void> logFileWrite(String log) async {
  // await logFile.writeAsString(log, mode: FileMode.append);
  await logFile!.writeAsString(log, mode: FileMode.append, flush: true);
  // utils.d(log);
}
*/
void logFileWrite(String log) {
  logFile!.writeAsString(log, mode: FileMode.append, flush: true);
}
