import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geomark/services/attendance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<Attendance>> _attendanceRecordsFuture;

  @override
  void initState() {
    super.initState();
    _attendanceRecordsFuture = _fetchAttendanceRecords();
  }

  Future<List<Attendance>> _fetchAttendanceRecords() async {
    if (user != null) {
      String userId = user!.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection('attendance')
          .doc(userId)
          .collection(
              DateFormat('yyyy').format(DateTime.now())) // Year collection
          .doc(DateFormat('MM').format(DateTime.now())) // Month document
          .collection('days') // Days collection
          .get();

      return querySnapshot.docs
          .map((doc) => Attendance.fromFirestore(doc))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          'Attendance',
          style: GoogleFonts.dmSans(
            fontSize: MediaQuery.of(context).size.width * 0.055,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<Attendance>>(
        future: _attendanceRecordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No attendance records found.'));
          }
          List<Attendance> attendanceRecords = snapshot.data!;

          return ListView.builder(
            itemCount: attendanceRecords.length,
            itemBuilder: (context, index) {
              Attendance attendance = attendanceRecords[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(attendance.date),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          'Check-in: ${DateFormat('HH:mm').format(attendance.checkInTime)}'),
                      if (attendance.checkOutTime != null)
                        Text(
                            'Check-out: ${DateFormat('HH:mm').format(attendance.checkOutTime!)}'),
                      Text(
                          'Total hours worked: ${attendance.totalHoursWorked}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
