class ActiveEmployeesModel {
  final int employeeId;
  final String employeeName;
  final String employeeDateHired;
  final String employeeStatus;
  final String employeeBranch;
  final String employeeSection;
  final String employeePosition;

  ActiveEmployeesModel({
    required this.employeeId,
    required this.employeeName,
    required this.employeeDateHired,
    required this.employeeStatus,
    required this.employeeBranch,
    required this.employeeSection,
    required this.employeePosition,
  });

  factory ActiveEmployeesModel.fromJson(Map<String, dynamic> jsonData) {
    return ActiveEmployeesModel(
      employeeId: jsonData['employee_id'] ??
          0, // Provide a default value for nullable int
      employeeName: jsonData['employee_name'] ??
          '', // Provide a default value for nullable String
      employeeDateHired: jsonData['employee_date_hired'] ?? '',
      employeeStatus: jsonData['employee_status'] ?? '',
      employeeBranch: jsonData['employee_branch'] ?? '',
      employeeSection: jsonData['employee_section'] ?? '',
      employeePosition: jsonData['employee_position'] ?? '',
    );
  }
}
