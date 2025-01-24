// ignore_for_file: file_names

class UserProfile {
  UserProfile({
    required this.uId,
    this.name = "",
    this.email = "",
    this.description = "Enter Description",
    this.profilePicture = "",
    this.followers = '0',
    this.follwing = '0',
  });
  final String uId;
  final String name;
  final String email;
  String description;
  String profilePicture;
  final String followers;
  final String follwing;
}
