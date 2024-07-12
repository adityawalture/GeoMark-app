import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final DateTime date;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String totalHoursWorked;

  Attendance({
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    required this.totalHoursWorked,
  });

  factory Attendance.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Attendance(
      date: data['checkInTime'].toDate(),
      checkInTime: data['checkInTime'].toDate(),
      checkOutTime: data['checkOutTime']?.toDate(),
      totalHoursWorked: data['totalHoursWorked'],
    );
  }
}
