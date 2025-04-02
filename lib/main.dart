import 'package:coupon_admin_panel/view/main/main_page.dart';
import 'package:coupon_admin_panel/view_model/admin_view_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'view_model/categoryViewModel/category_view_model.dart';
import 'view_model/coupon_view_model/coupon_view_model.dart';
import 'view_model/services/image_picker_view_model_web.dart';
import 'view_model/store_view_model/store_selection_view_model.dart';

void main() {
  debugRepaintRainbowEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => StoreViewModel()),
        ChangeNotifierProvider(create: (_) => ImagePickerViewModel()),
        ChangeNotifierProvider(create: (_) => CouponViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(
            create: (_) => StoreSelectionCategoryViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: const MainPage(),
      ),
    );
  }
}
