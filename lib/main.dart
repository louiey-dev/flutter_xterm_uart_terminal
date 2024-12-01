import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SerialTerminal(),
    );
  }
}

class SerialTerminal extends StatefulWidget {
  const SerialTerminal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SerialTerminalState createState() => _SerialTerminalState();
}

class _SerialTerminalState extends State<SerialTerminal> {
  late Terminal terminal;
  SerialPort? port;

  @override
  void initState() {
    super.initState();
    terminal = Terminal();
    _initSerialPort();
  }

  void _initSerialPort() {
    final availablePorts = SerialPort.availablePorts;
    if (availablePorts.isNotEmpty) {
      port = SerialPort(availablePorts.first);
      port!.openReadWrite();

      terminal.onOutput = (data) {
        port!.write(Uint8List.fromList(data.codeUnits));
      };

      _readSerialData();
    }
  }

  void _readSerialData() {
    final reader = SerialPortReader(port!);
    reader.stream.listen((data) {
      terminal.write(String.fromCharCodes(data));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xterm Uart Terminal')),
      body: TerminalView(terminal),
    );
  }

  @override
  void dispose() {
    port?.close();
    super.dispose();
  }
}
