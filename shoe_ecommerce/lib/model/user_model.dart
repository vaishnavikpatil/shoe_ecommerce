class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['userName'],
      email: json['email'],
      token: json['token'],
    );
  }
}

class AddressModel {
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  AddressModel({
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}

class UserDetails {
  final String? phone;
   final List<AddressModel>? addresses;
  final String? name;
  final String? profileImage;
  final String? gender;
  final String? dob;
    final String email;

  UserDetails({
    this.phone,
    this.addresses,
    this.name,
    this.profileImage,
    this.gender,
    this.dob,
    required this.email,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    var addressList = json['addresses'] as List?;
    List<AddressModel>? addressModels = addressList?.map((item) => AddressModel.fromJson(item)).toList();

    return UserDetails(
      phone: json['phone'],
      email: json['email'],
      addresses: addressModels,
      name: json['userName'],
      profileImage: json['profileImage'],
      gender: json['gender'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'addresses': addresses?.map((address) => address.toJson()).toList(),
      'name': name,
      'profileImage': profileImage,
      'gender': gender,
      'dob': dob,
    };
  }
}
