import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackingly_new/Pages/CriminalCars.dart';
import 'package:hackingly_new/Pages/Garbage.dart';
import 'package:hackingly_new/Pages/PotHolesReport.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import '../Helpers/Provider.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  String userLoc = "";
  double lat = 0.0;
  double lang = 0.0;
  late SharedPreferences prefs; // SharedPreferences instance
  String userAvatarPath="";

  @override
  void initState() {
    super.initState();
    initPrefs();
    getUserLocation();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userAvatarPath = prefs.getString('user_avatar') ?? ''; // Load user's avatar image path
  }

  Future<void> _getAddressFromMap(double lat, double lang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          userLoc =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getUserLocation() async {

    bool serviceEnabled;
    LocationPermission permission;
    Position? position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled.Please enable the services')));
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // return Future.error('Location permissions are denied');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
    }

    // Initialize a timeout duration in milliseconds (adjust as needed)
    const int locationTimeoutMs = 4000; // 4 seconds

    // Use the location package to get the location with a timeout
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true).timeout(
          const Duration(milliseconds: locationTimeoutMs));
      setState(() {
        lang = position!.longitude;
        lat = position.latitude;
      });
    } catch (e) {
      // Location package didn't provide a location within the timeout, so use Geolocator
      Position? lastKnownLocation = await Geolocator.getLastKnownPosition();
      if (lastKnownLocation != null) {
        setState(() {
          lang = lastKnownLocation.longitude;
          lat = lastKnownLocation.latitude;
        });
      } else {
        // Handle the case where Geolocator also didn't provide a location
        // return Future.error('Unable to retrieve location.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to retrieve location.')));
        }
      }


      _getAddressFromMap(lat, lang);
    }
  }

  List images = ["assets/images/car.jpeg", "assets/images/garbage.jpeg", "assets/images/potHoles.jpeg"];

  List labels = ["VEHICLE", "GARBAGE", "POTHOLES"];

  List pages = [const CriminalCars(), const GarbageReport(), const PotHolesReport()];

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userAvatarPath = image.path; // Set the selected image path
      });
      prefs.setString('user_avatar', userAvatarPath!); // Save the image path to SharedPreferences
    }
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<ReportsProvider>(context);
    userProvider.getUserDetail();
    userProvider.greeting();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey,
                      width: 2
                  ),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // User Avatar
                    GestureDetector(
                      onTap: _pickImageFromGallery, // Call function to pick image from gallery
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: userAvatarPath.isNotEmpty
                            ? FileImage(File(userAvatarPath))
                            : null,
                        child: userAvatarPath.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                        // Show icon when no image is selected
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${userProvider.name}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.6,
                          child: const Text(
                            "Be a cleanliness activist, not a dirt contributor",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100, ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your Location: ${userLoc.isEmpty ? "Unknown location" : userLoc}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Welcome to our reporting app!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: SizedBox(
                      height: 200, // Set a fixed height for the ListView
                      child: ListView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>pages[index]));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Image.asset(
                                        images[index],
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    labels[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Choose your issue ?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
