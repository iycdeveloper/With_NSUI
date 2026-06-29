import 'dart:convert';

class Address {
  Address(
      {this.addressType,
      this.landmark,
      this.country,
      this.houseNumber,
      this.id,
      this.latitude,
      this.locality,
      this.longitude,
      this.postCode,
      this.streetName,
      this.unitNumber,
      this.formattedAddress,
      this.placeId,
      this.city,
      this.state,
      this.selected = false,
      this.validated = false});

  String? addressType;
  String? landmark;
  String? country;
  String? houseNumber;
  String? id;
  double? latitude;
  String? locality;
  double? longitude;
  String? postCode;
  String? streetName;
  String? unitNumber;

  String? formattedAddress;
  String? placeId;
  bool validated;
  bool selected;

  String? state;
  String? city;

  /// json string to model class
  factory Address.fromJson(Map<String, dynamic> jsonData) {
    return Address(
      selected: jsonData["selected"] ?? false,
      formattedAddress: jsonData["formatted_address"],
      latitude: jsonData["latitude"],
      longitude: jsonData["longitude"],
      placeId: jsonData["place_id"],
      postCode: jsonData["postCode"],
      streetName: jsonData["streetName"],
      houseNumber: jsonData["houseNumber"],
      landmark: jsonData["buildingNameOrLandmark"],
      unitNumber: jsonData["unitNumber"],
      locality: jsonData["locality"],
      country: jsonData["country"],
      addressType: jsonData["addressType"],
      id: jsonData["id"],
    );
  }

  /// to json string

  static Map<String, dynamic> toMap(Address address) => {
        if (address.formattedAddress != null)
          'formatted_address': address.formattedAddress,
        if (address.latitude != null) 'latitude': address.latitude,
        if (address.longitude != null) 'longitude': address.longitude,
        if (address.placeId != null) 'place_id': address.placeId,
        if (address.postCode != null) 'postCode': address.postCode,
        if (address.streetName != null) 'streetName': address.streetName,
        if (address.houseNumber != null) 'houseNumber': address.houseNumber,
        if (address.unitNumber != null) 'unitNumber': address.unitNumber,
        if (address.landmark != null)
          'buildingNameOrLandmark': address.landmark,
        if (address.locality != null) 'locality': address.locality,
        if (address.country != null) 'country': address.country,
        if (address.id != null) 'id': address.id
      };

  static String encode(List<Address> addresss) => json.encode(
        addresss
            .map<Map<String, dynamic>>((address) => Address.toMap(address))
            .toList(),
      );

  static List<Address> decode(String addressListString) =>
      (json.decode(addressListString) as List<dynamic>)
          .map<Address>((item) => Address.fromJson(item))
          .toList();

  static String encodeSingleAddress(Address address) =>
      json.encode(Address.toMap(address));

  static Address decodeSingleAddress(String addressString) =>
      Address.fromJson(json.decode(addressString));
}
