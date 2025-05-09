enum UserType { buyer, seller }

enum VerificationStatus { unverified, pending, verified }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final VerificationStatus verificationStatus;
  final String? businessName;
  final String? businessAddress;
  final String? businessCategory;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.verificationStatus = VerificationStatus.unverified,
    this.businessName,
    this.businessAddress,
    this.businessCategory,
  });

  bool get isSeller => userType == UserType.seller;
  bool get isVerified => verificationStatus == VerificationStatus.verified;
  bool get isVerificationPending => verificationStatus == VerificationStatus.pending;
}