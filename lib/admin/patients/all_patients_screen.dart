import 'package:ansan/util/patients/all_patients_screen.dart';
import 'package:flutter/material.dart';

class AdminAllPatientsScreen extends StatefulWidget {
  const AdminAllPatientsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AdminAllPatientsScreen> createState() => _AdminAllPatientsScreenState();
}

class _AdminAllPatientsScreenState extends State<AdminAllPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return AllPatientsAddedByMeScreen(userData: widget.userData);
  }
}
