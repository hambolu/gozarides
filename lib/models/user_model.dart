class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String type;
  final String profilePhotoUrl;
  final DateTime? emailVerifiedAt;
  final bool isAdmin;
  final bool isDriver;
  final bool isActive;
  final DateTime? driverVerifiedAt;
  final Map<String, dynamic>? wallet;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.profilePhotoUrl,
    this.emailVerifiedAt,
    required this.isAdmin,
    required this.isDriver,
    required this.isActive,
    this.driverVerifiedAt,
    this.wallet,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isSeller => type == 'seller';
  bool get isBuyer => type == 'buyer';
}