import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  UserModel({
    required this.fullName,
    required this.username,
    required this.password,
  });
}

// ini biar ga lupa, jalanin ini kalo bikin box hive : 
// flutter packages pub run build_runner build --delete-conflicting-outputs