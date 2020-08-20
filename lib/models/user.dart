class User {
  final String accountName;
  final String avatar;
  final String email;
  User(this.accountName, this.avatar, this.email);
  User.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'],
        email = json['email'],
        accountName = json['accountName'];
}
