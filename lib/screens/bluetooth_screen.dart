import 'package:flutter/material.dart';

final TextEditingController collectLogController = TextEditingController();

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("BT Screen"));
  }
}
