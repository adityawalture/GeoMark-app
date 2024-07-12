import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geomark/Pages/maps.dart';

import 'package:geomark/components/camera_screen.dart';
import 'package:geomark/components/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:geomark/components/custom_appbar.dart';
import 'package:geomark/services/mark_attendance.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //function for mark attendance
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  bool _isCheckedIn = false;

  String _formattedCheckInTime = '';
  String _formattedCheckOutTime = '';
  String _totalHoursWorked = '';

  String? _checkInImagePath;
  LatLng? _currentPosition;
  String? _currentAddress;

  //for shared_preferences
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadCheckInTime();
    _requestPermission();
  }

  Future<void> _loadCheckInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? checkInTimeString = prefs.getString('checkInTime');
    if (checkInTimeString != null) {
      setState(() {
        _checkInTime = DateTime.parse(checkInTimeString);
        _formattedCheckInTime =
            DateFormat('dd-MM-yyy HH:mm').format(_checkInTime!);
        _isCheckedIn = true;
      });
    }
  }

  Future<void> _saveCheckInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkInTime', _checkInTime!.toIso8601String());
  }

  Future<void> _clearCheckInTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('checkInTime');
  }

  //to upload attendance on firestore
  Future<void> _saveAttendanceToFireStore({String? imageUrl}) async {
    // final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String userId = user!.uid;
        DateTime now = DateTime.now();
        String year = DateFormat('yyyy').format(now);
        String month = DateFormat('MM').format(now);
        String day = DateFormat('dd').format(now);

//creating a document reference in attendance collection
        DocumentReference userDocRef =
            _firestore.collection('attendance').doc(userId);

        await userDocRef
            .collection(year)
            .doc(month)
            .collection('days')
            .doc(day)
            .set({
          'checkInTime': _checkInTime,
          'checkOutTime': _checkOutTime,
          'totalHoursWorked': _totalHoursWorked,
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': imageUrl,
          'location': _currentPosition != null
              ? GeoPoint(
                  _currentPosition!.latitude, _currentPosition!.longitude)
              : null,
          'address': _currentAddress,
        }, SetOptions(merge: true));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(message: 'Error saving attendance : $e').snackbar);
        }
      }
    }
  }

  Future<String?> _uploadImage(File image) async {
    if (user != null) {
      String userId = user!.uid;
      DateTime now = DateTime.now();
      String year = DateFormat('yyyy').format(now);
      String month = DateFormat('MM').format(now);
      String day = DateFormat('dd').format(now);

      Reference imageRef = FirebaseStorage.instance
          .ref()
          .child('attendance')
          .child(userId)
          .child(year)
          .child(month)
          .child(day)
          .child('checkin_image.jpg');

      UploadTask uploadTask = imageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    }
    return null;
  }

  //to get permission
  Future<void> _requestPermission() async {
    // if (await Permission.location.isDenied) {
    await Permission.location.request();
    // }
  }

  // to save location
  Future<void> _saveLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      _currentAddress =
          '${place.street},${place.subLocality},${place.locality},${place.postalCode},${place.country}';
      // print(_currentAddress);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(message: 'Error saving attendance : $e').snackbar);
      }
    }
  }

  void _toggleCheckInOut() async {
    await _requestPermission();
    await _saveLocation();

    setState(() {
      if (_isCheckedIn) {
        _checkOutTime = DateTime.now();
        _formattedCheckOutTime =
            DateFormat('dd-MM-yyyy HH:mm').format(_checkOutTime!);
        Duration difference = _checkOutTime!.difference(_checkInTime!);
        _totalHoursWorked =
            '${difference.inHours.toString().padLeft(2, '0')}:${(difference.inMinutes % 60).toString().padLeft(2, '0')}:${(difference.inSeconds % 60).toString().padLeft(2, '0')}';
        _isCheckedIn = false;
      } else {
        _checkInTime = DateTime.now();
        _formattedCheckInTime =
            DateFormat('dd-MM-yyyy HH:mm').format(_checkInTime!);
        _checkOutTime = null;
        _formattedCheckOutTime = '';
        _totalHoursWorked = '';
        _isCheckedIn = true;
      }
    });

    if (_isCheckedIn) {
      await _saveCheckInTime();
      await _navigateToCameraScreen();
    } else {
      String? imageUrl;
      if (_checkInTime != null &&
          _checkOutTime != null &&
          _checkInImagePath != null) {
        imageUrl = await _uploadImage(File(_checkInImagePath!));

        //delete the image from local storage after uploading
        File(_checkInImagePath!).deleteSync();
        _checkInImagePath = null;
      }
      await _saveAttendanceToFireStore(imageUrl: imageUrl);
      await _clearCheckInTime();
    }
  }

  Future<void> _navigateToCameraScreen() async {
    final cameras = await availableCameras();
    // final firstCamera = cameras[1];
    final firstCamera = cameras.isNotEmpty ? cameras[1] : null;
    if (firstCamera != null && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            camera: firstCamera,
            onPictureTaken: (File image) async {
              _checkInImagePath = image.path;
              _checkInTime = DateTime.now();
              _formattedCheckInTime =
                  DateFormat('dd-MM-yyyy HH:mm').format(_checkInTime!);
              _checkOutTime = null;
              _formattedCheckOutTime = '';
              _totalHoursWorked = '';
              _isCheckedIn = true;

              await _saveCheckInTime();
              String? imageUrl = await _uploadImage(image);
              await _saveAttendanceToFireStore(imageUrl: imageUrl);
            },
          ),
        ),
      );
    }
  }

// @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: CustomAppBar(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.19,
          left: MediaQuery.of(context).size.height * 0.043,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.81,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: MarkAttendance(
              isCheckedIn: _isCheckedIn,
              formattedCheckInTime: _formattedCheckInTime,
              formattedCheckoutTime: _formattedCheckOutTime,
              totalHoursWorked: _totalHoursWorked,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.44,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0, 0),
                ),
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, -4.0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
              child: MapsPage(
                currentLocation: _currentPosition,
              ),
            ),
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.022,
          child: FloatingActionButton.extended(
            onPressed: _toggleCheckInOut,
            backgroundColor: _isCheckedIn
                ? const Color.fromARGB(255, 237, 161, 168)
                : Colors.green[100],
            label: Text(_isCheckedIn ? "Check Out" : "Check In"),
            icon:
                Icon(_isCheckedIn ? Icons.logout_rounded : Icons.login_rounded),
          ),
        ),
      ],
    );
  }
}
