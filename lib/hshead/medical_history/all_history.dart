import 'package:ansan/util/medical_history_screen/all_history_screen.dart';
import 'package:flutter/material.dart';

class HsHeadAllHistoryScreen extends StatefulWidget {
  const HsHeadAllHistoryScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<HsHeadAllHistoryScreen> createState() => _HsHeadAllHistoryScreenState();
}

class _HsHeadAllHistoryScreenState extends State<HsHeadAllHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return AllMedicalHistory(patientData: widget.patientData, userData: widget.userData,);
  }
}
