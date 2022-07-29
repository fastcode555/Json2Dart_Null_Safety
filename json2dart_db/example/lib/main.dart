import 'dart:ui';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gesound/common/dependency_injection.dart';
import 'package:gesound/res/app_pages.dart';
import 'package:gesound/res/colours.dart';
import 'package:gesound/res/theme_util.dart';
import 'package:gesound/res/translation_service.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorColor = Colors.transparent
      ..backgroundColor = Colors.transparent
      ..textColor = Colors.transparent
      ..maskColor = Colors.transparent
      ..userInteractions = false
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.custom
      ..successWidget = Column(
        children: const [
          Icon(Icons.done, size: 60, color: Colors.white),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("操作成功", style: TextStyle(color: Colors.white)),
          ),
        ],
      );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      unknownRoute: AppPages.unknownRoute,
      locale: const Locale('en', 'US'),
      theme: ThemeUtil.lightTheme(Colours.mainColor),
      translations: TranslationService(),
      builder: EasyLoading.init(
        builder: (ctx, child) {
          return OKToast(
            child: GestureDetector(
              child: child,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
            ),
            backgroundColor: Colors.black54,
            textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            radius: 20.0,
            position: ToastPosition.bottom,
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, PointerDeviceKind.mouse};
}
