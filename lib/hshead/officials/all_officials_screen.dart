import 'package:ansan/util/officials/all_officials_screen.dart';
import 'package:flutter/material.dart';

class HsHeadAllOfficialsScreen extends StatefulWidget {
  const HsHeadAllOfficialsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<HsHeadAllOfficialsScreen> createState() => _HsHeadAllOfficialsScreenState();
}

class _HsHeadAllOfficialsScreenState extends State<HsHeadAllOfficialsScreen> {
  @override
  Widget build(BuildContext context) {
    return AllOfficialsScreen(userData: widget.userData);
  }
}
