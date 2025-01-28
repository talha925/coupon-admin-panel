// lib/model/page_model.dart

enum AdminPage { coupons, stores, users, category }

extension AdminPageExtension on AdminPage {
  String get name {
    switch (this) {
      case AdminPage.coupons:
        return 'Coupons';
      case AdminPage.stores:
        return 'Stores';
      case AdminPage.users:
        return 'Users';
      case AdminPage.category:
        return 'Category';
    }
  }
}
