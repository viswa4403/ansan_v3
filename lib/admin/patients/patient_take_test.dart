import 'package:ansan/util/patients/patient_take_test.dart';
import 'package:flutter/material.dart';

class AdminPatientTakeTestScreen extends StatefulWidget {
  const AdminPatientTakeTestScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<AdminPatientTakeTestScreen> createState() => _AdminPatientTakeTestScreenState();
}

class _AdminPatientTakeTestScreenState extends State<AdminPatientTakeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTakeTest(userData: widget.userData, patientId: widget.patientId);
  }
}
