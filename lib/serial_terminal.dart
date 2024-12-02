import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/menu.dart';
import 'package:xterm/xterm.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

late Terminal terminal;

class SerialTerminal extends StatefulWidget {
  const SerialTerminal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SerialTerminalState createState() => _SerialTerminalState();
}

class _SerialTerminalState extends State<SerialTerminal> {
  @override
  void initState() {
    super.initState();
    terminal = Terminal();
    // _initSerialPort();
  }

  // void _initSerialPort() {
  //   final availablePorts = SerialPort.availablePorts;
  //   if (availablePorts.isNotEmpty) {
  //     mSp = SerialPort(availablePorts.first);
  //     mSp!.openReadWrite();

  //     terminal.onOutput = (data) {
  //       mSp!.write(Uint8List.fromList(data.codeUnits));
  //     };

  //     _readSerialData();
  //   }
  // }

  // void _readSerialData() {
  //   final reader = SerialPortReader(mSp!);
  //   reader.stream.listen((data) {
  //     terminal.write(String.fromCharCodes(data));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: TerminalView(terminal));
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(title: const Text('Xterm Uart Terminal')),
  //     body: TerminalView(terminal),
  //   );
  // }

  @override
  void dispose() {
    mSp?.close();
    super.dispose();
  }
}
