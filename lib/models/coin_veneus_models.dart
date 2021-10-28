class CoinVenues {
  List<Venues>? venues;

  CoinVenues({this.venues});

  CoinVenues.fromJson(Map<String, dynamic> json) {
    if (json['venues'] != null) {
      venues = [];
      json['venues'].forEach((v) {
        venues!.add(new Venues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.venues != null) {
      data['venues'] = this.venues?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Venues {
  int? id;
  double? lat;
  double? lon;
  String? category;
  String? name;
  int? createdOn;
  String? geolocationDegrees;

  Venues(
      {this.id,
      this.lat,
      this.lon,
      this.category,
      this.name,
      this.createdOn,
      this.geolocationDegrees});

  Venues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    lon = json['lon'];
    category = json['category'];
    name = json['name'];
    createdOn = json['created_on'];
    geolocationDegrees = json['geolocation_degrees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['category'] = this.category;
    data['name'] = this.name;
    data['created_on'] = this.createdOn;
    data['geolocation_degrees'] = this.geolocationDegrees;
    return data;
  }
}
