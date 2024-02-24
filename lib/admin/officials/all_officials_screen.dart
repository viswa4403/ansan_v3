import 'package:ansan/util/officials/all_officials_screen.dart';
import 'package:flutter/material.dart';

class AdminAllOfficialsScreen extends StatefulWidget {
  const AdminAllOfficialsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AdminAllOfficialsScreen> createState() => _AdminAllOfficialsScreenState();
}

class _AdminAllOfficialsScreenState extends State<AdminAllOfficialsScreen> {
  @override
  Widget build(BuildContext context) {
    return AllOfficialsScreen(userData: widget.userData);
  }
}
