class Report {
  final String imgUrl;
  final String location;
  final String suggestion;
  final String carNo;
  final String lang;
  final String lat;

  Report({
    required this.imgUrl,
    required this.location,
    required this.suggestion,
    required this.carNo,
    required this.lang,
    required this.lat,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      imgUrl: json["imgUrl"] ?? "",
      location: json["location"] ?? "",
      suggestion: json["suggestion"] ?? "",
      carNo: json["carNo"] ?? "",
      lang: json["lang"] ?? "",
      lat: json["lat"] ?? "",
    );
  }
}
