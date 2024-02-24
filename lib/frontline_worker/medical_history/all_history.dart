import 'package:ansan/util/medical_history_screen/all_history_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerAllHistoryScreen extends StatefulWidget {
  const FrontlineWorkerAllHistoryScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<FrontlineWorkerAllHistoryScreen> createState() => _FrontlineWorkerAllHistoryScreenState();
}

class _FrontlineWorkerAllHistoryScreenState extends State<FrontlineWorkerAllHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return AllMedicalHistory(patientData: widget.patientData, userData: widget.userData,);
  }
}
