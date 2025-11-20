import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, phoneNumber, createdAt];
}
