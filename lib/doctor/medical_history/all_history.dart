import 'package:ansan/util/medical_history_screen/all_history_screen.dart';
import 'package:flutter/material.dart';

class DoctorAllHistoryScreen extends StatefulWidget {
  const DoctorAllHistoryScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<DoctorAllHistoryScreen> createState() => _DoctorAllHistoryScreenState();
}

class _DoctorAllHistoryScreenState extends State<DoctorAllHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return AllMedicalHistory(patientData: widget.patientData, userData: widget.userData,);
  }
}
