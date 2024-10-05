import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/mongodb/mongo_provider.dart';
import '../../../data/mongodb/reports.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MongoProvider>(
        builder: (context, provider, _) {
          if (provider.db == null) {
            provider.connectToMongo();
          } else {
            return FutureBuilder<List<Report>>(
                future: provider.getReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          "Error while fetching reports: ${snapshot.error}"),
                    );
                  } else {
                    List<Report> data = snapshot.data!;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Report report = data[index];
                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8), // Margin around the card
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white, // Background color
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: Image.network(
                                      report.imgUrl,
                                      height:
                                          200, // Adjust the height of the image
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the entire space
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Car no: ${report.carNo}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Location: ${report.location}",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            children: [
                                              const TextSpan(
                                                text: "Suggestion: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: "${report.suggestion}",
                                              ),
                                            ],
                                          ),
                                          maxLines:
                                              2, // Limit the number of lines displayed
                                          overflow: TextOverflow
                                              .ellipsis, // Show ellipsis if text exceeds 2 lines
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                });
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
