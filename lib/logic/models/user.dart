class RegisterUser {
  String name;
  String city;
  String gender;
  String birth;
  RegisterUser({
    required this.name,
    required this.birth,
    required this.city,
    required this.gender,
  });
}

class RegisterPhoneUser extends RegisterUser {
  String phone;
  RegisterPhoneUser({
    required this.phone,
    required String name,
    required String birth,
    required String city,
    required String gender,
  }) : super(name: name, birth: birth, city: city, gender: gender);
}

class RegisterEmailUser extends RegisterUser {
  String email;
  String? password;

  RegisterEmailUser({
    this.password,
    required this.email,
    required String name,
    required String birth,
    required String city,
    required String gender,
  }) : super(name: name, birth: birth, city: city, gender: gender);
}
