class User {
  final int id;
  final String name;
  final String email;
  final String city;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? city,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      city: city ?? this.city,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? 0;
    }

    String parsedCity = '';
    if (json['address'] != null && json['address'] is Map) {
      parsedCity = json['address']['city']?.toString() ?? '';
    } else if (json['city'] != null) {
      parsedCity = json['city'].toString();
    }

    return User(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      city: parsedCity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city': city,
      'address': {'city': city},
    };
  }
}
