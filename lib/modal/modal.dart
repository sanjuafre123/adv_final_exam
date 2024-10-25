import 'package:flutter/material.dart';

class TrackerModal {
  int? id;
  late String name, date, present;

  TrackerModal({
    this.id,
    required this.name,
    required this.date,
    required this.present,
  });

  factory TrackerModal.fromMap(Map m1) {
    return TrackerModal(
      name: m1['name'],
      date: m1['date'],
      present: m1['present'],
    );
  }

  Map toMap(TrackerModal attendence) {
    return {
      'name': attendence.name,
      'data': attendence.date,
      'present': attendence.present
    };
  }
}
