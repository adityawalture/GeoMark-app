import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkAttendance extends StatelessWidget {
  final bool isCheckedIn;
  final String formattedCheckInTime;
  final String formattedCheckoutTime;
  final String totalHoursWorked;

  const MarkAttendance({
    super.key,
    required this.isCheckedIn,
    required this.formattedCheckInTime,
    required this.formattedCheckoutTime,
    required this.totalHoursWorked,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double basefontSize = 15.0;
    double fontSize = basefontSize * (screenWidth / 375);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Check-In: ',
                  style: GoogleFonts.dmSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formattedCheckInTime,
                  style: GoogleFonts.dmSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Check-Out: ',
                  style: GoogleFonts.dmSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formattedCheckoutTime,
                  style: GoogleFonts.dmSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Total Hours: ',
                  style: GoogleFonts.dmSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  totalHoursWorked,
                  style: GoogleFonts.dmSans(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
