import 'package:bloc_v2/Features/home/presentation/views/widgets/login_view.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/new_login_screen.dart';
import 'package:bloc_v2/core/utils/styles.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginScreenNew();
  }
}
