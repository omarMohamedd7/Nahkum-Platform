import 'package:flutter/material.dart';

enum CaseStatus {
  accepted,
  pending,
  rejected;

  String getLocalizedStatus() {
    switch (this) {
      case accepted:
        return 'مقبول';
      case pending:
        return 'قيد الانتظار';
      case rejected:
        return 'مرفوض';
    }
  }

  Color getStatusColor() {
    switch (this) {
      case accepted:
        return Colors.green;
      case pending:
        return Colors.amber;
      case rejected:
        return Colors.red;
    }
  }

  static CaseStatus parseCaseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return CaseStatus.accepted;
      case 'pending':
        return CaseStatus.pending;
      case 'rejected':
        return CaseStatus.rejected;
      default:
        return CaseStatus.pending;
    }
  }
}
