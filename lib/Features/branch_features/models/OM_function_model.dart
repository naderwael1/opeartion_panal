class CategoryModel {
  final String categoryName;
  final String sectionName;
  final String categoryDescription;

  CategoryModel({
    required this.categoryName,
    required this.sectionName,
    required this.categoryDescription,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> jsonData) {
    return CategoryModel(
      categoryName: jsonData['category_name'],
      sectionName: jsonData['section_name'],
      categoryDescription: jsonData['category_description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['section_name'] = this.sectionName;
    data['category_description'] = this.categoryDescription;
    return data;
  }
}
