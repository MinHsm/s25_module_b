class CarData {
  final String name;
  final String imgPath;
  final String description;
  final double price;
  final double rating;

  CarData(
      {required this.name,
        required this.imgPath,
        required this.description,
        required this.price,
        required this.rating});
}

class User {
  final String email;
  final String password;
  final String? verificationCode;

  User({
    required this.email,
    required this.password,
    this.verificationCode,
  });
}

class UserService {
  static final List<User> _users = [];

  static void register(User newUser) {
    _users.add(newUser);
  }

  static User? login(String email, String password) {
    try {
      return _users.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
