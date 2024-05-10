import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Helpers/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FadeInIcon(
              icon: Icons.favorite,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to Abondoned Vehicles",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InformationCollection()),
                );
              },
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}

class FadeInIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;

  const FadeInIcon({super.key, required this.icon, required this.size, required this.color});

  @override
  _FadeInIconState createState() => _FadeInIconState();

}

class _FadeInIconState extends State<FadeInIcon>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Icon(
        widget.icon,
        size: widget.size,
        color: widget.color,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class InformationCollection extends StatefulWidget {
  const InformationCollection({super.key});

  @override
  State<InformationCollection> createState() => _InformationCollectionState();
}

class _InformationCollectionState extends State<InformationCollection> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  bool male = false;
  bool female = false;
  bool other = false;
  String gender = "";
  String userid = "";

  DatabaseReference db = FirebaseDatabase.instance.ref("Users");
  final FirebaseAuth auth = FirebaseAuth.instance;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {

    final User? user = auth.currentUser;
    userid = user!.uid;
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.teal,
        title: const Center(
          child: Text(
            "Input information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const FadeInIcon(
                icon: Icons.insert_drive_file_outlined,
                size: 100,
                color: Colors.teal,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              // Form to collect basic information
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                        border: OutlineInputBorder()
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: dateInput,
                      //editing controller of this TextField
                      decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      labelText: "Enter DOB",
                        border: OutlineInputBorder(

                        )
                      ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateInput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text("Male"),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.deepOrangeAccent,
                          value: male,
                          onChanged: (value) {
                            setState(() {
                              male = value!;
                              if(value){
                                female = false;
                                other = false;
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Female"),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.deepOrangeAccent,
                          value: female,
                          onChanged: (value) {
                            setState(() {
                              female = value!;
                              if(value){
                                male = false;
                                other = false;
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Other"),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.deepOrangeAccent,
                          value: other,
                          onChanged: (value) {
                            setState(() {
                              other = value!;
                              if(value){
                                male = false;
                                female = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{

                  if(male == true){
                    gender = "male";
                  }else if(female == true){
                    gender = "female";
                  }else{
                    gender = "other";
                  }

                  // Get the entered information
                  Map<String, String> user = {

                    "Name":nameController.text,
                    "DOB":dateInput.text,
                    "Gender":gender

                  };

                  // Store the information to firebase database
                  if (nameController.text.isEmpty) {
                    showSnackBar("Please enter your name");
                  } else if (!male && !female && !other) {
                    showSnackBar("Please enter your gender");
                  } else if (dateInput.text.isEmpty) {
                    showSnackBar("Please enter your date of birth");
                  } else {
                    // Set the data to the database
                    await db.child(userid).set(user);

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("UserDetails", true);

                    // Navigate to the NavBar screen and pass the information
                    if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBar(idx: 0,),),);
                  }


                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
