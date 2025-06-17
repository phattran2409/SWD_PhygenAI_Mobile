class User {
  final String id;
  final String email;
  final String? username;
  final String? token;
  final int? role;
  final String? identityId;  // Optional: Add a username field if needed
  User({required this.id, required this.email, this.username, this.token,  this.role, this.identityId });
}
