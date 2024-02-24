import 'package:ansan/util/officials/new_official_screen.dart';
import 'package:flutter/material.dart';

class HsHeadNewOfficialScreen extends StatefulWidget {
  const HsHeadNewOfficialScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HsHeadNewOfficialScreen> createState() => _HsHeadNewOfficialScreenState();
}

class _HsHeadNewOfficialScreenState extends State<HsHeadNewOfficialScreen> {
  @override
  Widget build(BuildContext context) {
    return NewOfficialScreen(userData: widget.userData);
  }
}
