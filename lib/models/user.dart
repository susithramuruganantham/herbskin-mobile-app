class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final String fullName;
  final String? phone;
  final String? workerCode;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.fullName,
    this.phone,
    this.workerCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
      fullName: json['full_name'] ?? '',
      phone: json['phone'],
      workerCode: json['worker_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'full_name': fullName,
      'phone': phone,
      'worker_code': workerCode,
    };
  }
}
