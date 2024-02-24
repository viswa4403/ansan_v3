import 'package:ansan/util/officials/new_official_screen.dart';
import 'package:flutter/material.dart';

class AdminNewOfficialScreen extends StatefulWidget {
  const AdminNewOfficialScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AdminNewOfficialScreen> createState() => _AdminNewOfficialScreenState();
}

class _AdminNewOfficialScreenState extends State<AdminNewOfficialScreen> {
  @override
  Widget build(BuildContext context) {
    return NewOfficialScreen(userData: widget.userData);
  }
}
