import 'package:bloc_v2/Features/home/presentation/views/home_view.dart';
import 'package:bloc_v2/core/utils/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sliding_text.dart';

class SplashViewbody extends StatefulWidget {
  const SplashViewbody({super.key});

  @override
  State<SplashViewbody> createState() => _SplashViewbodyState();
}

class _SplashViewbodyState extends State<SplashViewbody>
    with SingleTickerProviderStateMixin {
  //handle rete of change of value      -----------------------------=
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    initAnimated();
    navigateToHome();
  }

  void navigateToHome() {
    Future.delayed(Duration(seconds: 2), () {
      Get.to(() => HomeView(), transition: Transition.fade);
    });
  }

//////////////////////////////////////////////////////////////////////////////////////
  void initAnimated() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, 0))
            .animate(animationController);
    animationController.forward();
  }

////////////////////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            height: 130, // Set desired height
            width: 290, // Set desired width
            child: Image.network(
              'https://mir-s3-cdn-cf.behance.net/project_modules/fs/1e8feb109720503.5fda2a433c12d.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),

        const SizedBox(
          height: 4,
        ),
        AnimateText(slidingAnimation: slidingAnimation),
      ],
    );
  }
}

class AnimateText extends StatelessWidget {
  const AnimateText({
    super.key,
    required this.slidingAnimation,
  });

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: slidingAnimation,
        builder: (context, _) {
          return SlideTransition(
            position: slidingAnimation,
            child: const Text(
              "King of FooD ",
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
