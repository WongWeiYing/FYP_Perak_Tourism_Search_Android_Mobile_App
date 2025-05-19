import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/firebase_options.dart';
import 'package:go_perak/screens/dashboard_page.dart';
import 'package:go_perak/screens/login/login_page.dart';
import 'package:go_perak/screens/merchant/merchant_home_page.dart';
import 'package:go_perak/utils/state_provider.dart/postcode_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  cameras = await availableCameras();

  await Supabase.initialize(
    url: 'https://mgjdhfjzxxmcwhsxjjln.supabase.co',
    anonKey:
        '',
  );

  final prefs = await SharedPreferences.getInstance();
  final userID = prefs.getString('userID');
  final userRole = prefs.getString('userRole');
  //final fcmToken = prefs.getString('fcmToken');

  runApp(
    ProviderScope(
      child: MainApp(
        userID: userID,
        userRole: userRole,
        // fcmToken: fcmToken,
      ),
    ),
  );
}

class MainApp extends HookConsumerWidget {
  final String? userID;
  final String? userRole;

  const MainApp({
    super.key,
    this.userID,
    this.userRole,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(postcodeProvider.notifier).initFromJson();
      if (userID != null && userRole != null) {
        Future.microtask(() {
          ref.read(currentUserProvider.notifier).setUserID(userID!);
          ref.read(currentUserProvider.notifier).setRole(userRole!);
          // ref.read(currentUserProvider.notifier).setFcmToken(fcmToken!);
        });
      }

      return null;
    }, []);

    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          onGenerateRoute: CustomRouter.generateRoute,
          home: userID != null
              ? userRole == 'Users'
                  ? const DashboardPage()
                  : const MerchantHomePage()
              : LoginPage(),
          builder: EasyLoading.init(builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: MediaQuery.of(context)
                    .textScaler
                    .clamp(minScaleFactor: 1, maxScaleFactor: 1.4),
              ),
              child: child!,
            );
          }),
        ));
  }
}
