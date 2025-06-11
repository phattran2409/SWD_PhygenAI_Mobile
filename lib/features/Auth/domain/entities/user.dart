class User {
  final String id;
  final String email;
  final String? username;
  final String? token; // Optional: Add a username field if needed
  User({required this.id, required this.email, this.username, this.token  });
}
