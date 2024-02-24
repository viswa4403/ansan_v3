import 'package:ansan/util/patients/new_patient_screen.dart';
import 'package:flutter/material.dart';

class HsHeadNewPatientScreen extends StatefulWidget {
  const HsHeadNewPatientScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HsHeadNewPatientScreen> createState() => _HsHeadNewPatientScreenState();
}

class _HsHeadNewPatientScreenState extends State<HsHeadNewPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return NewPatientScreen(userData: widget.userData);
  }
}
