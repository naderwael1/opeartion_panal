class BranchModel {
  final int branchID;
  final String branchName;
  final String branchAddress;
  //final Null managerName;
  String? branchContactInformation;

  BranchModel(
      {required this.branchID,
        required this.branchName,
        required this.branchAddress,
    //    this.managerName,
        this.branchContactInformation});

  factory BranchModel.fromJson(Map<String, dynamic> jsonData) {
    return BranchModel(
      branchID: jsonData['branch ID'],
      branchName: jsonData['branch name'],
      branchAddress: jsonData['branch address'],
   //   managerName: jsonData['manager name'],
      branchContactInformation: jsonData['branch contact information'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch ID'] = this.branchID;
    data['branch name'] = this.branchName;
    data['branch address'] = this.branchAddress;
   // data['manager name'] = this.managerName;
    data['branch contact information'] = this.branchContactInformation;
    return data;
  }
}
