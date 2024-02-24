import 'package:ansan/util/medical_history_screen/the_form_screen.dart';
import 'package:flutter/material.dart';

class AdminPatientNewMhScreen extends StatefulWidget {
  const AdminPatientNewMhScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<AdminPatientNewMhScreen> createState() =>
      _AdminPatientNewMhScreenState();
}

class _AdminPatientNewMhScreenState extends State<AdminPatientNewMhScreen> {
  @override
  Widget build(BuildContext context) {
    return QuestionnaireForm(
        patientId: widget.patientData["userId"],
        patientName: widget.patientData["userName"],
        userData: widget.userData,
    );
  }
}
