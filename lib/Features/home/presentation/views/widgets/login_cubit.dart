import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../../core/error/failure.dart';
import 'login_resopnse.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio dio;

  LoginCubit(this.dio) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await dio.post(
        'http://192.168.56.1:4000/admin/employees/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.token);

        // Decode the token and store data
        Map<String, dynamic> decodedToken = JwtDecoder.decode(loginResponse.token);
        await prefs.setInt('employee_id', decodedToken['employee_id'] ?? 0);
        await prefs.setString('employee_first_name', decodedToken['employee_first_name'] ?? 'N/A');
        await prefs.setString('employee_last_name', decodedToken['employee_last_name'] ?? 'N/A');
        await prefs.setString('employee_status', decodedToken['employee_status'] ?? 'N/A');
        await prefs.setString('employee_position', decodedToken['employee_position'] ?? 'N/A');
        await prefs.setString('employee_role', decodedToken['employee_role'] ?? 'N/A');
        await prefs.setString('employee_branch_name', decodedToken['employee_branch_name'] ?? 'N/A');
        await prefs.setInt('employee_branch_id', decodedToken['employee_branch_id'] ?? 0);
        await prefs.setInt('branch_section_id', decodedToken['branch_section_id'] ?? 0);
        await prefs.setString('section_name', decodedToken['section_name'] ?? 'N/A');
        await prefs.setString('picture_path', decodedToken['picture_path'] ?? 'N/A');
        emit(LoginSuccess(loginResponse));
      } else {
        emit(LoginFailure(ServerFailure.fromResponse(response.statusCode, response.data)));
      }
    } on DioException catch (e) {
      emit(LoginFailure(ServerFailure.fromDioError(e)));
    }
  }
}
