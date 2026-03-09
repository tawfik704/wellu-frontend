
class UserProfileModel {
  String? goal;
  String? gender;
  double? age;
  double? height;
  double? weight;
  List<String>? mainGoals;
  String? bodyType;
  double? bodyFat;
  String? muscleMass;
  String? fitnessLevel;
  String? duration;
  String? intensity;
  String? workoutTime;
  String? diet;
  List<String>? injuries;

  Map<String, dynamic> toJson() {
    return {
      "goal": goal,
      "gender": gender,
      "age": age,
      "height": height,
      "weight": weight,
      "mainGoals": mainGoals ?? [],
      "bodyType": bodyType,
      "bodyFat": bodyFat,
      "muscleMass": muscleMass,
      "fitnessLevel": fitnessLevel,
      "duration": duration,
      "intensity": intensity,
      "workoutTime": workoutTime,
      "diet": diet,
      "injuries": injuries ?? [],
    };
  }
}