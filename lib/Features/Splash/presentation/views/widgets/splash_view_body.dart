import 'package:bloc_v2/Features/home/presentation/views/widgets/choose_based_token.dart';
import 'package:bloc_v2/Features/home/presentation/views/widgets/new_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initAnimated();
    Future.delayed(const Duration(seconds: 5), checkTokenAndNavigate); // تأخير التنقل لمدة 5 ثوانٍ

    // التحقق الدوري من صلاحية التوكن
    Timer.periodic(Duration(seconds: 10), (timer) async {
      final isValid = await _checkToken();
      if (!isValid) {
        _navigateTo(const LoginScreenNew());
        timer.cancel(); // إيقاف المؤقت بعد تسجيل الخروج
      }
    });
  }

  void initAnimated() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // مدة التحريك 5 ثوانٍ
    );
    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: const Offset(0, 0),
    ).animate(animationController);
    animationController.forward();
  }

  Future<void> checkTokenAndNavigate() async {
    final hasToken = await _checkToken();
    if (hasToken) {
      _navigateTo(const HomeBody());
    } else {
      _navigateTo(const LoginScreenNew());
    }
  }

  Future<bool> _checkToken() async {
    final token = await secureStorage.read(key: 'token');
    final expirationTimeStr = await secureStorage.read(key: 'token_expiration');

    if (token == null || expirationTimeStr == null) {
      return false;
    }

    final expirationTime = int.tryParse(expirationTimeStr);
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (expirationTime == null || currentTime >= expirationTime) {
      // التوكن انتهى
      await secureStorage.delete(key: 'token');
      await secureStorage.delete(key: 'token_expiration');
      return false;
    }

    return true;
  }

  void _navigateTo(Widget screen) {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              height: 130,
              width: 290,
              child: Image.network(
                'https://mir-s3-cdn-cf.behance.net/project_modules/fs/1e8feb109720503.5fda2a433c12d.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          AnimateText(slidingAnimation: slidingAnimation),
        ],
      ),
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
            "King of FooD",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
