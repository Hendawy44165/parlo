import 'dart:convert';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final int coinsBalance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSeen;
  // The public key fields are often handled separately for security
  // but included here for model completeness.
  final String? identityPublicKey;
  final String? signedIdentityPublicKey;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.bio,
    this.avatarUrl,
    required this.coinsBalance,
    required this.createdAt,
    required this.updatedAt,
    this.lastSeen,
    this.identityPublicKey,
    this.signedIdentityPublicKey,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'],
      avatarUrl: map['avatar_url'],
      coinsBalance: map['coins_balance']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      lastSeen: map['last_seen'] != null ? DateTime.parse(map['last_seen']) : null,
      identityPublicKey: map['identity_public_key'],
      signedIdentityPublicKey: map['signed_identity_public_key'],
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
