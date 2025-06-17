import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String name,
    List<String>? alternateNames,
    required String species,
    required String gender,
    String? house,
    String? dateOfBirth,
    int? yearOfBirth,
    required bool wizard,
    required String ancestry,
    required String eyeColour,
    required String hairColour,
    Wand? wand,
    String? patronus,
    required bool hogwartsStudent,
    required bool hogwartsStaff,
    String? actor,
    List<String>? alternateActors,
    required bool alive,
    String? image,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@freezed
class Wand with _$Wand {
  const factory Wand({String? wood, String? core, double? length}) = _Wand;

  factory Wand.fromJson(Map<String, dynamic> json) => _$WandFromJson(json);
}
