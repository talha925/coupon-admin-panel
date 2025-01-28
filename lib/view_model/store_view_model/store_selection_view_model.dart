import 'package:flutter/foundation.dart';

class StoreSelectionCategoryViewModel extends ChangeNotifier {
  // Your existing properties and methods...

  String? _selectedCategory;

  String? get selectedCategory => _selectedCategory;

  void updateSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners(); // Notify listeners about the change
  }
}
