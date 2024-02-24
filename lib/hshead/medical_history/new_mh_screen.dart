import 'package:ansan/util/medical_history_screen/the_form_screen.dart';
import 'package:flutter/material.dart';

class HsHeadPatientNewMhScreen extends StatefulWidget {
  const HsHeadPatientNewMhScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<HsHeadPatientNewMhScreen> createState() =>
      _HsHeadPatientNewMhScreenState();
}

class _HsHeadPatientNewMhScreenState extends State<HsHeadPatientNewMhScreen> {
  @override
  Widget build(BuildContext context) {
    return QuestionnaireForm(
        patientId: widget.patientData["userId"],
        patientName: widget.patientData["userName"],
        userData: widget.userData,
    );
  }
}
