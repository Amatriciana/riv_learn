import 'package:flutter/material.dart';
import 'bmi_calc.dart';

class BmiHistory extends StatelessWidget {
  const BmiHistory({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculate History'),
      ),
    );
  }
}
