import 'package:ansan/util/patients/new_patient_screen.dart';
import 'package:flutter/material.dart';

class AdminNewPatientScreen extends StatefulWidget {
  const AdminNewPatientScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AdminNewPatientScreen> createState() => _AdminNewPatientScreenState();
}

class _AdminNewPatientScreenState extends State<AdminNewPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return NewPatientScreen(userData: widget.userData);
  }
}
