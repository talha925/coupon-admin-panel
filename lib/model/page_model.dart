enum AdminPage {
  coupons,
  stores,
  users,
  category,
  addCoupon,
  updateCoupon,
  addStore,
  allStore,
  updateStore,
  addCategory,
  updateCategory,
}

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
      case AdminPage.addCoupon:
        return 'Add Coupon';
      case AdminPage.updateCoupon:
        return 'Update Coupon';
      case AdminPage.addStore:
        return 'Add Store';
      case AdminPage.allStore:
        return 'All Store';
      case AdminPage.updateStore:
        return 'Update Store';
      case AdminPage.addCategory:
        return 'Add Category';
      case AdminPage.updateCategory:
        return 'Update Category';
    }
  }
}
