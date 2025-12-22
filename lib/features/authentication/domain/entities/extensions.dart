import 'enums.dart';

extension SexX on String {
  Sex toSex() {
    return Sex.values.firstWhere((e) => e.name == this, orElse: () => Sex.male);
  }
}
