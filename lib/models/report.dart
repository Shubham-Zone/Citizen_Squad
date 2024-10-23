class Report {
  final List<String> imageUrl;
  final String location;
  final String lang;
  final String lat;
  final String suggestion;
  final String carNo;

  Report({
    required this.imageUrl,
    required this.location,
    required this.lang,
    required this.lat,
    required this.suggestion,
    required this.carNo,
  });

  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      "location": location,
      "lang": lang,
      "lat": lat,
      "suggestion": suggestion,
      "carNo": carNo,
    };
  }
}
