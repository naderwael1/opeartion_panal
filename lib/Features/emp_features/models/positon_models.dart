class PositionModel {
  final String position_name;
  final String job_description;

  PositionModel({
    required this.position_name,
    required this.job_description,
  });

  factory PositionModel.fromJson(Map<String, dynamic> jsonData) {
    return PositionModel(
      position_name: jsonData['position_name'] ?? '',
      job_description: jsonData['job_description'] ?? '',
    );
  }

}
