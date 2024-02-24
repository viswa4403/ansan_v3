import 'package:ansan/util/patients/patient_screen.dart';
import 'package:flutter/material.dart';

class HsHeadPatientScreen extends StatefulWidget {
  const HsHeadPatientScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<HsHeadPatientScreen> createState() => _HsHeadPatientScreenState();
}

class _HsHeadPatientScreenState extends State<HsHeadPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewPatientScreen(patientId: widget.patientId, userData: widget.userData);
  }
}
