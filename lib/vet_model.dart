class VetModel {
  String name;
  String address;
  String openingTime;
  String website;
  String phone;
  String email;
  String imagePath;

  VetModel({
    required this.name,
    required this.address,
    required this.openingTime,
    required this.website,
    required this.phone,
    required this.email,
    required this.imagePath,
    required bool isEmergencyAvailable,
    required description,
  });

  get isEmergencyAvailable => null;

  String? get description => null;

  get id => null;

  toMap() {}
}
