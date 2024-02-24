import 'package:ansan/util/patients/patient_take_test.dart';
import 'package:flutter/material.dart';

class UserPatientTakeTestScreen extends StatefulWidget {
  const UserPatientTakeTestScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<UserPatientTakeTestScreen> createState() => _UserPatientTakeTestScreenState();
}

class _UserPatientTakeTestScreenState extends State<UserPatientTakeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTakeTest(userData: widget.userData, patientId: widget.patientId);
  }
}
