class Directions {
  final String polylines;

  Directions({this.polylines});

  factory Directions.fromJson(Map<String, dynamic> json) {
    return Directions(
        polylines: json['routes'][0]['overview_polyline']['points']);
  }
}
