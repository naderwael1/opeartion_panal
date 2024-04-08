class TableModel {
  final String branchId;
  final String capacity;
  final String status;

  TableModel({
    required this.branchId,
    required this.capacity,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> jsonData) {
    return TableModel(
      branchId: jsonData['branchId'] ?? '',
      capacity: jsonData['capacity'] ?? '',
      status: jsonData['status'] ?? '',
    );
  }
}


