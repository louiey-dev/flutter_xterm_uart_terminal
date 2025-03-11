import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/screens/com_port_screen.dart';
import 'package:flutter_xterm_uart_terminal/utils/log_file.dart';
import 'package:xterm/xterm.dart';

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

    // Listen to terminal output, // louiey
    terminal.onOutput = (data) {
      setState(() {
        // logBuffer.write(data); // Append output to buffer
        // logFileWrite("");
      });
    };
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
    return Expanded(flex: 1, child: TerminalView(terminal));
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
