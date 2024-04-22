import '../models/active_emp_model.dart';
import '../../../core/utils/helper/api_helper.dart';

class GetActiveEmployee {
  Future<List<ActiveEmployeesModel>> getActiveEmployee() async {
    List<dynamic> data = await ApiHelper().get(
        url: "http://192.168.175.1:4000/admin/employees/active-employees-list");

    List<ActiveEmployeesModel> ActemplyeeList = [];
    for (int i = 0; i < data.length; i++) {
      ActemplyeeList.add(ActiveEmployeesModel.fromJson(data[i]));
    }
    return ActemplyeeList;
  }
}

class GeIntActiveEmployee {
  Future<List<ActiveEmployeesModel>> geIntActiveEmployee() async {
    List<dynamic> data = await ApiHelper().get(
        url:
            "http://192.168.175.1:4000/admin/employees/inactive-employees-list");

    List<ActiveEmployeesModel> ActemplyeeList = [];
    for (int i = 0; i < data.length; i++) {
      ActemplyeeList.add(ActiveEmployeesModel.fromJson(data[i]));
    }
    return ActemplyeeList;
  }
}
