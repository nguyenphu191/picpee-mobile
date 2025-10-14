import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';
import 'package:picpee_mobile/providers/designer_provider.dart';
import 'package:picpee_mobile/providers/notification_provider.dart';
import 'package:picpee_mobile/providers/review_provider.dart';
import 'package:picpee_mobile/providers/skill_provider.dart';
import 'package:picpee_mobile/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SkillProvider()),
        ChangeNotifierProvider(create: (_) => DesignerProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ProjectHub',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.transparent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'BeVietnamPro',
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
