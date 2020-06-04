import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String phone;

  Contact(this.name, this.email, this.phone);
}
