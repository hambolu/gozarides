class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final bool isActive;
  final String profilePicture;
  final bool profileCompleted;
  final double rating;
  final int totalRides;
  final Map<String, dynamic>? wallet;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.isActive,
    required this.profilePicture,
    required this.profileCompleted,
    required this.rating,
    required this.totalRides,
    this.wallet,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isSeller => userType == 'seller';
  bool get isBuyer => userType == 'buyer';
}