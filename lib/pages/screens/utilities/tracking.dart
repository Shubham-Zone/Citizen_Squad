import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Track extends StatefulWidget {
  const Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  List pages = [
    const Vehicles(),
    const Garbage(),
    const PotHoles(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedIndex == 0 ? Colors.deepOrangeAccent : null,
                  ),
                  child: const Text("Vehicles"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedIndex == 1 ? Colors.deepOrangeAccent : null,
                  ),
                  child: const Text("Garbage"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedIndex == 2 ? Colors.deepOrangeAccent : null,
                  ),
                  child: const Text("PotHoles"),
                ),
              ],
            ),
            Expanded(child: pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class Vehicles extends StatefulWidget {
  const Vehicles({super.key});

  @override
  State<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db =
      FirebaseDatabase.instance.ref().child("RTO").child(userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abandoned vehicle reports"),
      ),
      body: StreamBuilder(
        stream: db.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic>? map =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

            if (map != null) {
              List<dynamic> list = map.values.toList();

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  List<String> imgUrls =
                      List<String>.from(list[index]["imageUrl"] ?? []);
                  String status = list[index]["status"];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.deepOrangeAccent.withOpacity(0.7),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Car Number:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["carNo"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: imgUrls.map((imageUrl) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          appBar: AppBar(),
                                          body: PhotoView(
                                            imageProvider:
                                                NetworkImage(imageUrl),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Suggestion:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["suggestion"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Car Location:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["location"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Icon(Icons.check,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Received",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 6,
                                color: (status == "1" || status == "2")
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: (status == "1" || status == "2")
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: (status == "1" || status == "2")
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Processing",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 6,
                                color: (status == "2")
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: (status == "2")
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: (status == "2")
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Action",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.data!.snapshot.exists) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Garbage extends StatefulWidget {
  const Garbage({Key? key});

  @override
  State<Garbage> createState() => _GarbageState();
}

class _GarbageState extends State<Garbage> {
  static String userid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference db = FirebaseDatabase.instance
      .ref()
      .child("MCB")
      .child("Garbage")
      .child(userid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Garbage reports"),
      ),
      body: StreamBuilder(
        stream: db.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic>? map =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

            if (map != null) {
              List<dynamic> list = map.values.toList();

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  List<String> imgUrls =
                      List<String>.from(list[index]["imageUrl"] ?? []);
                  String status = list[index]["status"];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: imgUrls.map((imageUrl) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          appBar: AppBar(),
                                          body: PhotoView(
                                            imageProvider:
                                                NetworkImage(imageUrl),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Suggestion:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["suggestion"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Car Location:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["location"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Icon(Icons.check,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Received",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 6,
                                color: (status == "1" || status == "2")
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: (status == "1" || status == "2")
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: (status == "1" || status == "2")
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Processing",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 6,
                                color: (status == "2")
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: (status == "2")
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: (status == "2")
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Action",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.data!.snapshot.exists) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PotHoles extends StatefulWidget {
  const PotHoles({Key? key});

  @override
  State<PotHoles> createState() => _PotHolesState();
}

class _PotHolesState extends State<PotHoles> {
  static String userid = FirebaseAuth.instance.currentUser!.uid;

  DatabaseReference db = FirebaseDatabase.instance
      .ref()
      .child("MCB")
      .child("PotHoles")
      .child(userid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PotHoles reports"),
      ),
      body: StreamBuilder(
        stream: db.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic>? map =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

            if (map != null) {
              List<dynamic> list = map.values.toList();

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  List<String> imgUrls =
                      List<String>.from(list[index]["imageUrl"] ?? []);
                  String status = list[index]["status"];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: imgUrls.map((imageUrl) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                          appBar: AppBar(),
                                          body: PhotoView(
                                            imageProvider:
                                                NetworkImage(imageUrl),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Suggestion:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["suggestion"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Car Location:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  list[index]["location"] ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Icon(Icons.check,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Received",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 6,
                                color: (status == "1" || status == "2")
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: (status == "1" || status == "2")
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: (status == "1" || status == "2")
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Processing",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 6,
                                color: (status == "2")
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: (status == "2")
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: (status == "2")
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("Action",
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.data!.snapshot.exists) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
