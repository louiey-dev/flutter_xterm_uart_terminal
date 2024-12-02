import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_xterm_uart_terminal/serial_terminal.dart';
import 'package:flutter_xterm_uart_terminal/utils/utils.dart';

List<SerialPort> portList = [];
SerialPort? mSp;

class ComScreen extends StatefulWidget {
  const ComScreen({super.key});

  @override
  State<ComScreen> createState() => _ComScreenState();
}

class _ComScreenState extends State<ComScreen> {
  int menuBaudrate = 115200;
  String openButtonText = 'N/A';
  List<int> baudRate = [3800, 9600, 115200, 1500000];

  SerialPortReader? reader;

  @override
  Widget build(BuildContext context) {
    openButtonText = mSp == null
        ? 'N/A'
        : mSp!.isOpen
            ? 'Close'
            : 'Open';

    return Row(
      children: [
        _comPort(),
      ],
    );
  }

  _initPort() {
    setState(() {
      var i = 0;

      portList.clear();

      for (final name in SerialPort.availablePorts) {
        final sp = SerialPort(name);
        utils.log('[${++i}] $name');
        utils.log('\tDescription: ${sp.description ?? ''}');
        utils.log('\tManufacturer: ${sp.manufacturer}');
        utils.log('\tSerial Number: ${sp.serialNumber}');
        utils.log('\tProduct ID: 0x${sp.productId?.toRadixString(16) ?? 00}');
        utils.log('\tVendor ID: 0x${sp.vendorId?.toRadixString(16) ?? 00}');

        portList.add(sp);
      }
      if (portList.isNotEmpty) {
        mSp = portList.first;
      }
    });
  }

  void changedDropDownItem(SerialPort sps) {
    setState(() {
      mSp = sps;
    });
  }

  _comConfig() {
    SerialPortConfig config = mSp!.config;
    // config.baudRate = 115200;
    config.baudRate = menuBaudrate;
    config.parity = 0;
    config.bits = 8;
    config.cts = 0;
    config.rts = 0;
    config.stopBits = 1;
    config.xonXoff = 0;
    mSp!.config = config;

    utils.log("baudrate : $menuBaudrate");
    // inputController.text = configCmd;
  }

  _comOpen() {
    if (mSp!.isOpen) {
      mSp!.close();
      utils.log('${mSp!.name} closed!');
      reader!.close();
    } else {
      if (mSp!.open(mode: SerialPortMode.readWrite)) {
        SerialPortConfig config = mSp!.config;
        // https://www.sigrok.org/api/libserialport/0.1.1/a00007.html#gab14927cf0efee73b59d04a572b688fa0
        // https://www.sigrok.org/api/libserialport/0.1.1/a00004_source.html
        // config.baudRate = 115200;
        config.baudRate = menuBaudrate;
        config.parity = 0;
        config.bits = 8;
        config.cts = 0;
        config.rts = 0;
        config.stopBits = 1;
        config.xonXoff = 0;
        mSp!.config = config;

        utils.log("baudrate : $menuBaudrate");
        if (mSp!.isOpen) {
          utils.log('${mSp!.name} opened!');
        } else {
          utils.log("mSP open error\n");
          return;
        }

        terminal.onOutput = (data) {
          mSp!.write(Uint8List.fromList(data.codeUnits));
        };

        _readSerialData();
      } else {
        utils.log("COM port open error\n");
      }
    }
  }

  void _readSerialData() {
    reader = SerialPortReader(mSp!);
    reader!.stream.listen((data) {
      terminal.write(String.fromCharCodes(data));
    });
  }

  _comPort() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            DropdownButton(
              // focusColor: Colors.white,
              value: mSp,
              items: portList.map((item) {
                return DropdownMenuItem(
                    value: item, child: Text("${item.name}"));
                // "${item.name}: ${cp949.decodeString(item.description ?? '')}"));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  changedDropDownItem(e as SerialPort);
                });
              },
            ),
            const SizedBox(width: 20.0),
            DropdownButton(
              value: menuBaudrate,
              items: baudRate.map((value) {
                return DropdownMenuItem(
                    value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  menuBaudrate = e!;
                });
                utils.showSnackbar(context, menuBaudrate.toString());
                utils.log("Baudrate set to $menuBaudrate");
              },
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () {
                _initPort();
              },
              child: const Text("COM"),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () {
                if (mSp == null) {
                  return;
                }
                _comOpen();

                if (!mSp!.isOpen) {
                  _comConfig();
                } else {}

                setState(() {});
              },
              child: Text(openButtonText),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
