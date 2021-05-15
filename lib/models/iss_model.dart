class Iss {
  final double issLat;
  final double issLng;

  Iss({this.issLat, this.issLng});

  factory Iss.fromJson(Map<String, dynamic> json) {
    return Iss(
      issLat: double.parse(json['iss_position']['latitude']),
      issLng: double.parse(json['iss_position']['longitude'])
    );
  }
}
