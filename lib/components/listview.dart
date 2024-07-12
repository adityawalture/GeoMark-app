import 'package:flutter/material.dart';
import 'package:geomark/Pages/profile.dart';
import 'package:geomark/components/alertbox.dart';

class SettingsListView extends StatefulWidget {
  const SettingsListView({super.key});

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  //profile
  void _navigateToProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  //alertDialogue
  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: _navigateToProfile,
        ),
        const Divider(
          height: 0,
          indent: 17.0,
          endIndent: 30.0,
        ),
        const ListTile(
          leading: Icon(Icons.calendar_today_outlined),
          title: Text('Attendance report'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        const Divider(
          height: 0,
          indent: 17.0,
          endIndent: 30.0,
        ),
        const ListTile(
          leading: Icon(Icons.contact_mail_sharp),
          title: Text('Contact us'),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
        ),
        const Divider(
          height: 0,
          indent: 17.0,
          endIndent: 30.0,
        ),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: const Text('Logout'),
          trailing: GestureDetector(
            onTap: _showDialog,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
