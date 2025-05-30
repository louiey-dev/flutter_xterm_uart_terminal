import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_xterm_uart_terminal/screens/serial_terminal_screen.dart';
import 'package:flutter_xterm_uart_terminal/utils/log_file.dart';
import 'package:flutter_xterm_uart_terminal/utils/utils.dart';

List<SerialPort> portList = [];
SerialPort? mSp;

final TextEditingController logFileNameController = TextEditingController();

bool serialSend(String cmd) {
  try {
    if (mSp == null) {
      utils.e("mSp is null");
      return false;
    }
    mSp!.write(utf8.encode(cmd));
  } catch (ex) {
    utils.e(ex.toString());
    return false;
  }
  return true;
}

class ComScreen extends StatefulWidget {
  const ComScreen({super.key});

  @override
  State<ComScreen> createState() => _ComScreenState();
}

class _ComScreenState extends State<ComScreen> {
  int menuBaudrate = 115200;
  String openButtonText = 'N/A';
  List<int> baudRate = [3800, 9600, 115200, 1500000];
  final _logFileName = "xterm.log";

  SerialPortReader? reader;

  final _cmdList = ['pwd', 'ls -al', 'tail -F /var/log/legacy-log'];
  var _selectedValue = 'pwd';
  // final _logFileList = ['DateTime', ''];

  @override
  void dispose() {
    // Close the SerialPortReader stream if it exists
    reader?.close();
    utils.log("Serial reader closed");

    // Close the SerialPort if it is open
    if (mSp != null && mSp!.isOpen) {
      mSp!.close();
    }
    // Optionally set mSp to null if you want to fully release the reference
    mSp = null;
    utils.log("Serial port closed");

    stopLogFlushTimer();
    utils.log("Logging file closed");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    openButtonText = mSp == null
        ? 'N/A'
        : mSp!.isOpen
            ? 'Close'
            : 'Open';

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              _comPort(),
              const SizedBox(width: 20),
              Flexible(
                child: DropdownButton(
                  // hint: const Text("Select Command"),
                  value: _selectedValue,
                  items: _cmdList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    serialSend("$_selectedValue\n");
                  },
                  child: const Text("Send"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              // const SizedBox(width: 20),
              // const Text("Log file input = "),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: logFileNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'input log file name',
                    labelText: 'DateTime',
                    prefixIcon: Icon(Icons.save_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 600)
            ],
          ),
        ],
      ),
    );
  }

  _initPort() {
    setState(() {
      var i = 0;

      portList.clear();

      if (SerialPort.availablePorts.isEmpty) {
        utils.e("There is no available ports");
        return;
      }

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
    try {
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
    } catch (ex) {
      utils.log(ex.toString());
    }
  }

  _comClose() {
    if (mSp!.isOpen) {
      mSp!.close();
      utils.log('${mSp!.name} closed!');
      reader!.close();
      // mSp!.dispose();
    } else {
      utils.e("COM port is not open, cannot close it.");
    }
  }

  _comOpen() {
    if (mSp!.isOpen) {
      mSp!.close();
      utils.log('${mSp!.name} closed!');
      reader!.close();
      // mSp!.dispose();
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
          utils.e("mSP open error\n");
          return;
        }

        logFileOpen(_logFileName);

        terminal.onOutput = (data) {
          mSp!.write(Uint8List.fromList(data.codeUnits));
        };

        _readSerialData();
      } else {
        utils.e("COM port open error\n");
        // if (mSp!.isOpen) {
        // }
        mSp!.close();
        // mSp!.dispose();
      }
    }
  }

  void _readSerialData() {
    reader = SerialPortReader(mSp!, timeout: 1000);
    reader!.stream.listen((data) {
      String str = String.fromCharCodes(data);
      terminal.write(str);
      logBuffer.write(str);
    });
  }

  _comPort() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            // louiey, 2025-05-29. COM port list
            DropdownButton(
              hint: const Text("Select COM port"),
              // menuMaxHeight: 0.5,
              value: mSp,
              items: portList.map((item) {
                return DropdownMenuItem(
                    value: item, child: Text("${item.name}"));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  changedDropDownItem(e as SerialPort);
                  utils.log("Selected port : ${e.name}");
                });
              },
            ),

            const SizedBox(width: 20.0),
            // louiey, 2025-05-29. Baudrate list
            DropdownButton(
              hint: const Text("Select Baudrate"),
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
              // louiey, 2025-05-30. Com Open/Close
              onPressed: () {
                if (mSp == null) {
                  utils.e("port is null");
                  return;
                }

                if (mSp!.isOpen) {
                  _comClose();
                  logFileClose();
                  utils.log("Logging file closed");
                } else {
                  _comOpen();
                }

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
