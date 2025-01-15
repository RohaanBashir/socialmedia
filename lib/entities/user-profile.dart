// ignore_for_file: file_names

class UserProfile {
  UserProfile({
    required this.name,
    required this.email,
    this.description = "Enter Description",
  });

  final String name;
  final String email;
  final String description;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'description': description,
    };
  }
}
