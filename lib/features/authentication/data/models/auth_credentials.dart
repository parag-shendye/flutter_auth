class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
