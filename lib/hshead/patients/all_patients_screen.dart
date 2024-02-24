import 'package:ansan/util/patients/all_patients_screen.dart';
import 'package:flutter/material.dart';

class HsHeadAllPatientsScreen extends StatefulWidget {
  const HsHeadAllPatientsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HsHeadAllPatientsScreen> createState() => _HsHeadAllPatientsScreenState();
}

class _HsHeadAllPatientsScreenState extends State<HsHeadAllPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return AllPatientsAddedByMeScreen(userData: widget.userData);
  }
}
