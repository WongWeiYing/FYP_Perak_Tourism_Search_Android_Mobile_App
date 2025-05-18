class City {
  final String name;
  final List<String> postcode;

  City({required this.name, required this.postcode});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      postcode: List<String>.from(json['postcode']),
    );
  }
}

class Perak {
  final String name;
  final List<City> city;

  Perak({required this.name, required this.city});

  factory Perak.fromJson(Map<String, dynamic> json) {
    return Perak(
      name: json['name'],
      city: (json['city'] as List).map((city) => City.fromJson(city)).toList(),
    );
  }
}
