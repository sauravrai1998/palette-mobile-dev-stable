class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': this.email, 'password': this.password};
  }

  factory LoginModel.fromMap(Map item) {
    return LoginModel(
      email: item['email'].toString(),
      password: item['password'].toString(),
    );
  }
}
