import 'package:ansan/util/medical_history_screen/the_form_screen.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerPatientNewMhScreen extends StatefulWidget {
  const FrontlineWorkerPatientNewMhScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<FrontlineWorkerPatientNewMhScreen> createState() =>
      _FrontlineWorkerPatientNewMhScreenState();
}

class _FrontlineWorkerPatientNewMhScreenState extends State<FrontlineWorkerPatientNewMhScreen> {
  @override
  Widget build(BuildContext context) {
    return QuestionnaireForm(
        patientId: widget.patientData["userId"],
        patientName: widget.patientData["userName"],
        userData: widget.userData,
    );
  }
}
