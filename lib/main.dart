import 'package:coupon_admin_panel/res/theme/app_theme.dart';
import 'package:coupon_admin_panel/view/main/main_page.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';
import 'package:coupon_admin_panel/view_model/services/image_picker_view_model_mobile.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view_model/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'view_model/categoryViewModel/category_view_model.dart';
import 'view_model/coupon_view_model/coupon_view_model.dart';
import 'view_model/services/image_picker_view_model.dart';
import 'view_model/store_view_model/store_selection_view_model.dart';
import 'package:coupon_admin_panel/utils/keyboard_fix.dart';
import 'package:coupon_admin_panel/utils/platform_toast.dart';

void main() {
  debugRepaintRainbowEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the keyboard fix for Windows
  KeyboardFix().initialize();

  // Handle errors gracefully - especially keyboard assertion errors
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;

    // Special handling for keyboard assertion errors
    if (exception is AssertionError &&
        (exception.message.toString().contains('KeyDown') ||
            exception.message.toString().contains('key') ||
            exception.message.toString().contains('pressed'))) {
      debugPrint('Handled keyboard assertion error: ${exception.message}');
      return; // Prevent app crash
    }

    // Special handling for missing plugin exceptions
    if (exception is MissingPluginException &&
        exception.message.toString().contains('fluttertoast')) {
      // This is expected on desktop/web platforms
      debugPrint('Handled missing plugin: ${exception.message}');
      return; // Prevent app crash
    }

    // Normal error handling for other errors
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => StoreViewModel()),
        ChangeNotifierProvider<ImagePickerViewModel>(
          create: (_) => ImagePickerViewModelImpl(),
        ),
        ChangeNotifierProvider(create: (_) => CouponViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(
            create: (_) => StoreSelectionCategoryViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return KeyboardFix().wrapWithKeyboardFix(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Coupon Admin Panel',
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeProvider.themeMode,
              scaffoldMessengerKey: PlatformToast.messengerKey,
              home: const MainPage(),
            ),
          );
        },
      ),
    );
  }
}
