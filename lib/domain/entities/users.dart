class User {
  final int id;
  final String email;
  final String name;
  final String username;
  final String password;
  final String address;
  final String phone;
  final String role;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.username,
      required this.address,
      required this.password,
      required this.phone,
      required this.role});
}
