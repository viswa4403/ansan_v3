import 'package:ansan/util/medical_history_screen/all_history_screen.dart';
import 'package:flutter/material.dart';

class AdminAllHistoryScreen extends StatefulWidget {
  const AdminAllHistoryScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<AdminAllHistoryScreen> createState() => _AdminAllHistoryScreenState();
}

class _AdminAllHistoryScreenState extends State<AdminAllHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return AllMedicalHistory(patientData: widget.patientData, userData: widget.userData,);
  }
}
