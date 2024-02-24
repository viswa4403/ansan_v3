import 'package:ansan/util/patients/patient_take_test.dart';
import 'package:flutter/material.dart';

class DoctorPatientTakeTestScreen extends StatefulWidget {
  const DoctorPatientTakeTestScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<DoctorPatientTakeTestScreen> createState() => _DoctorPatientTakeTestScreenState();
}

class _DoctorPatientTakeTestScreenState extends State<DoctorPatientTakeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientTakeTest(userData: widget.userData, patientId: widget.patientId);
  }
}
