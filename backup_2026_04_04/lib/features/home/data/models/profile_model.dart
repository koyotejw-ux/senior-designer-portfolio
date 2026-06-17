class ProfileModel {
  final String id;
  final String name;
  final String birth;
  final String address;
  final String military;
  final String phone;
  final String email;
  final String introduction;
  final String philosophy;
  final String aspirations;

  ProfileModel({
    required this.id,
    required this.name,
    required this.birth,
    required this.address,
    required this.military,
    required this.phone,
    required this.email,
    required this.introduction,
    required this.philosophy,
    required this.aspirations,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birth': birth,
      'address': address,
      'military': military,
      'phone': phone,
      'email': email,
      'introduction': introduction,
      'philosophy': philosophy,
      'aspirations': aspirations,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return ProfileModel(
      id: id,
      name: map['name'] ?? '',
      birth: map['birth'] ?? '',
      address: map['address'] ?? '',
      military: map['military'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      introduction: map['introduction'] ?? '',
      philosophy: map['philosophy'] ?? '',
      aspirations: map['aspirations'] ?? '',
    );
  }
}
