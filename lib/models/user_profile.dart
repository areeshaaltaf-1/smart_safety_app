class UserProfile {
  String name;
  String cnic;
  String imageBase64;
  bool isVerified;

  UserProfile({
    required this.name,
    required this.cnic,
    required this.imageBase64,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "cnic": cnic,
      "imageBase64": imageBase64,
      "isVerified": isVerified,
    };
  }

  static UserProfile fromMap(Map data) {
    return UserProfile(
      name: data["name"] ?? "",
      cnic: data["cnic"] ?? "",
      imageBase64: data["imageBase64"] ?? "",
      isVerified: data["isVerified"] ?? false,
    );
  }
}