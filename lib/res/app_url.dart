class AppUrl {
  // static const String baseUrl = "https://coupon-app-backend.vercel.app/api";
  static const String baseUrl = "http://localhost:5000/api";

  // Auth URLs
  static const String loginUrl = "$baseUrl/auth/login";
  static const String registerUrl = "$baseUrl/auth/register";
  static const String refreshTokenUrl = "$baseUrl/auth/refresh";
  static const String logoutUrl = "$baseUrl/auth/logout";

  // Store URLs
  static const String createStoreUrl = "$baseUrl/stores";
  static const String getStoresUrl = "$baseUrl/stores";
  static String updateStoreUrl(String storeId) => "$baseUrl/stores/$storeId";
  static String deleteStoreUrl(String storeId) => "$baseUrl/stores/$storeId";

  // Coupon URLs
  static const String createCouponUrl = "$baseUrl/coupons";
  static const String getCouponsUrl = "$baseUrl/coupons";
  static String updateCouponUrl(String couponId) =>
      "$baseUrl/coupons/$couponId";
  static String deleteCouponUrl(String couponId) =>
      "$baseUrl/coupons/$couponId";

  // Category URLs
  static const String createCategoryUrl = "$baseUrl/categories";
  static const String getCategoriesUrl = "$baseUrl/categories";
  static String updateCategoryUrl(String categoryId) =>
      "$baseUrl/categories/$categoryId";
  static String deleteCategoryUrl(String categoryId) =>
      "$baseUrl/categories/$categoryId";
}
