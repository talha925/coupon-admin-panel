import 'package:coupon_admin_panel/utils/routes/routes_name.dart';
import 'package:coupon_admin_panel/view/main/main_page.dart';

import 'package:flutter/material.dart';

// Class that handles routing within the application
class Routes {
  // Method to generate routes based on the route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Route to the Home screen
      case RoutesName.main:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainPage());

      // Default route for undefined routes
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
