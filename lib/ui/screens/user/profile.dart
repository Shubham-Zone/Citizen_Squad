import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hackingly_new/Helpers/Provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<String?>(
            future: _getProfileImagePath(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final profileImagePath = snapshot.data;
                return Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath))
                        : null,
                    child: profileImagePath == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final pickedFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );

              if (pickedFile != null) {
                // Save image path to local storage
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('profileImage', pickedFile.path);

                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepOrange, // Text color
            ),
            child: const Text(
              "Pick from Gallery",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text("Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(
              provider.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            title: const Text("Date of Birth",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(
              provider.dob,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            title: const Text("Gender",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(
              provider.gender,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _getProfileImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImage');
  }
}
