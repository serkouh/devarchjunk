// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      fullName: json['full_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      birthDate: json['birth_date'] as String?,
      username: json['username'] as String?,
      coordinates: json['coordinates'] as String?,
      email: json['email'] as String?,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'birth_date': instance.birthDate,
      'username': instance.username,
      'coordinates': instance.coordinates,
      'email': instance.email,
      'profile_image': instance.profileImage,
    };
