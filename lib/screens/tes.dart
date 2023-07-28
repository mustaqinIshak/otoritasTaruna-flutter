import 'package:flutter/material.dart';

class tes extends StatefulWidget {
  const tes({super.key});

  @override
  State<tes> createState() => _tesState();
}

class _tesState extends State<tes> {
  @override
  void initState() {
    // TODO: implement initState
    print('masuk ji');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('bisa'),
    );
  }
}
