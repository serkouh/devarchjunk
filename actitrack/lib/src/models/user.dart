import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'full_name')
  final String? fullName;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'birth_date')
  final String? birthDate;

  @JsonKey(name: 'username')
  final String? username;

  @JsonKey(name: 'coordinates')
  final String? coordinates;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'profile_image')
  final String? profileImage;

  User({
    this.id,
    this.fullName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.birthDate,
    this.username,
    this.coordinates,
    this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Extract the profileImage from the media object if it exists
    String? profileImageUrl;
    if (json['media'] != null && json['media']['url'] != null) {
      profileImageUrl = json['media']['url'];
    }
    json['profile_image'] = profileImageUrl;
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    final data = _$UserToJson(this);
    // Manually set the media url in the json if profileImage is not null
    if (profileImage != null) {
      data['media'] = {'url': profileImage};
    }
    return data;
  }
}
