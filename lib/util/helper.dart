import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class Helper {
  String sha256Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  String humanReadableAgoTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }

  String roleToRoleName(String userRole) {
    switch (userRole) {
      case "U":
        return "User";
      case "A":
        return "Administrator";
      case "H":
        return "Hospital Head";
      case "D":
        return "Doctor";
      case "F":
        return "Frontline Worker";
      default:
        return "Unknown";
    }
  }
}
