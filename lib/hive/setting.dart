import 'package:hive_flutter/hive_flutter.dart';

part 'setting.g.dart';

@HiveType(typeId: 2)
class Settings extends HiveObject {
  @HiveField(0)
  final String isDarkTheme;
  @HiveField(1)
  final String shouldSpeak;

  Settings({required this.isDarkTheme, required this.shouldSpeak});
}
