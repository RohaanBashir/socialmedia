

class MyUser {
  MyUser(this.name, this.email, this.uId);

  final String name;
  final String email;
  final String uId;
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      json['name'] as String,
      json['email'] as String,
      json['uId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
    };
  }
}
