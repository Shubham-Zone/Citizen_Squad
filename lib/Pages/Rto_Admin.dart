import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RtoAdmin extends StatefulWidget {
  const RtoAdmin({super.key});

  @override
  State<RtoAdmin> createState() => _RtoAdminState();

}


class _RtoAdminState extends State<RtoAdmin> {

  DatabaseReference rto = FirebaseDatabase.instance.ref().child("RTO");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abondoned cars"),
      ),
      body: StreamBuilder(
        stream: rto.onValue,
        builder: (context, snapshot){

          if(snapshot.hasData && snapshot.data!.snapshot.value != null){

            // Getting data from firebase realtime database
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;

            List<dynamic> list = map.values.toList();

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index){
                
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: list[index]["ImageUrl"],
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter:
                                  const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                            ),
                          ),
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Car number : ${list[index]["CarNo"]}"),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Suggestions : ${list[index]["Suggestion"]}"),
                        const SizedBox(
                          height: 10,
                        ),
                        OutlinedButton(
                            onPressed: () async {
                              String googleUrl = "https://www.google.com/maps/search/?api=1&query=${list[index]["Lat"]},${list[index]["Lang"]}";
                              if (await canLaunchUrl(Uri.parse(googleUrl))) {
                              await launchUrl(Uri.parse(googleUrl));
                              } else {
                              throw 'Could not launch $googleUrl';
                              }
                            },
                            child: const Icon(Icons.location_on, color: Colors.red,)
                        )
                      ],
                    ),
                  ),
                );
                
              },
            );
          }

          return const Center(child: CircularProgressIndicator(),);

        },
      )
    );
  }
}
