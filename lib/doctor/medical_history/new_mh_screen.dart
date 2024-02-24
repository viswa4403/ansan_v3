import 'package:ansan/util/medical_history_screen/the_form_screen.dart';
import 'package:flutter/material.dart';

class DoctorPatientNewMhScreen extends StatefulWidget {
  const DoctorPatientNewMhScreen({super.key, required this.patientData, required this.userData});

  final Map<String, dynamic> patientData, userData;

  @override
  State<DoctorPatientNewMhScreen> createState() =>
      _DoctorPatientNewMhScreenState();
}

class _DoctorPatientNewMhScreenState extends State<DoctorPatientNewMhScreen> {
  @override
  Widget build(BuildContext context) {
    return QuestionnaireForm(
        patientId: widget.patientData["userId"],
        patientName: widget.patientData["userName"],
        userData: widget.userData,
    );
  }
}
