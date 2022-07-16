class RegisterUser {
  String name;
  String gender;
  String birth;
  RegisterUser({
    required this.name,
    required this.birth,
    required this.gender,
  });
}

class RegisterPhoneUser extends RegisterUser {
  String phone;
  RegisterPhoneUser({
    required this.phone,
    required String name,
    required String birth,
    required String gender,
  }) : super(name: name, birth: birth, gender: gender);
}

class RegisterEmailUser extends RegisterUser {
  String email;
  String? password;

  RegisterEmailUser({
    this.password,
    required this.email,
    required String name,
    required String birth,
    required String gender,
  }) : super(name: name, birth: birth, gender: gender);
}
