

class Store {
  final int id;
  final String name;
  final String phoneNumber;
  final String coverImage;
  final int followerCount;
  final int reviewCount;
  final Address address;
  final String location;
  final String suburb;
  final String city;
  final List<String> cuisines;
  final List<int> rewards;
  final int heartCount;
  final int okayCount;
  final int burntCount;

  Store({
    this.id,
    this.name,
    this.phoneNumber,
    this.coverImage,
    this.followerCount,
    this.reviewCount,
    this.address,
    this.location,
    this.suburb,
    this.city,
    this.cuisines,
    this.rewards,
    this.heartCount,
    this.okayCount,
    this.burntCount,
  });

  Store copyWith({String name, List<int> rewards}) {
    return Store(
      id: this.id,
      name: name ?? this.name,
      phoneNumber: this.phoneNumber,
      coverImage: this.coverImage,
      address: this.address,
      location: this.location,
      suburb: this.suburb,
      city: this.city,
      cuisines: this.cuisines,
      rewards: rewards ?? this.rewards,
      heartCount: this.heartCount,
      okayCount: this.okayCount,
      burntCount: this.burntCount,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'coverImage': this.coverImage,
      'location': this.location,
      'suburb': this.suburb,
      'city': this.city,
      'cuisines': this.cuisines,
      'heartCount': this.heartCount,
      'okayCount': this.okayCount,
      'burntCount': this.burntCount,
    };
  }

  factory Store.rehydrate(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      coverImage: json['coverImage'],
      location: json['location'],
      suburb: json['suburb'],
      city: json['city'],
      cuisines: List<String>.from(json['cuisines']),
      heartCount: json['heartCount'],
      okayCount: json['okayCount'],
      burntCount: json['burntCount'],
    );
  }

  factory Store.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Store(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      coverImage: json['cover_image'],
      followerCount: json['follower_count'],
      reviewCount: json['review_count'],
      address: json['address'] != null ? Address.fromToaster(json['address']) : null,
      location: json['location'] != null ? json['location']['name'] : null,
      suburb: json['suburb'] != null ? json['suburb']['name'] : null,
      city: json['city'] != null ? json['city']['name'] : null,
      heartCount: json['ratings'] != null ? json['ratings']['heart_ratings'] : null,
      okayCount: json['ratings'] != null ? json['ratings']['okay_ratings'] : null,
      burntCount: json['ratings'] != null ? json['ratings']['burnt_ratings'] : null,
      cuisines: json['cuisines'] != null ? List<String>.from(json['cuisines'].map((c) => c['name'])) : null,
    );
  }

  static const attributes = """
    id,
    name,
    phone_number,
    cover_image,
    follower_count,
    review_count,
    address {
      address_first_line,
      address_second_line,
      address_street_number,
      address_street_name,
    },
    location {
      name,
    },
    suburb {
      name,
    },
    city {
      name,
    },
    cuisines {
      id,
      name,
    },
    ratings {
      heart_ratings,
      okay_ratings,
      burnt_ratings
    }
  """;

  String getDirectionUrl() {
    var query = [
      name,
      if (address.firstLine != null) address.firstLine,
      if (address.secondLine != null) address.secondLine,
      if (address.streetNumber != null) address.streetNumber,
      if (address.streetName != null) address.streetName,
      if (location != null)  location,
      if (suburb != null) suburb,
      if (city != null) city,
    ].join(' ');
    return 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
  }

  @override
  String toString() {
    return '{ id: $id, name: $name }';
  }
}

class Cuisine {
  final int id;
  final String name;

  Cuisine({this.id, this.name});

  factory Cuisine.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Cuisine(id: json['id'], name: json['name']);
  }
}

class Suburb {
  final int id;
  final String name;

  Suburb({this.id, this.name});

  factory Suburb.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Suburb(id: json['id'], name: json['name']);
  }
}

class Address {
  final String firstLine;
  final String secondLine;
  final String streetNumber;
  final String streetName;

  Address({this.firstLine, this.secondLine, this.streetNumber, this.streetName});

  factory Address.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Address(
      firstLine: json['address_first_line'],
      secondLine: json['address_second_line'],
      streetNumber: json['address_street_number'],
      streetName: json['address_street_name'],
    );
  }
}
