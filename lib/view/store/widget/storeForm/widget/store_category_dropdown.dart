import 'package:coupon_admin_panel/data/response/status.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class StoreCategoryDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedCategoryId; // ValueNotifier for ObjectId
  final ValueChanged<String?> onChanged;

  const StoreCategoryDropdown({
    super.key,
    required this.selectedCategoryId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryViewModel>(
      builder: (context, categoryViewModel, _) {
        // Loading State
        if (categoryViewModel.categoryResponse.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error State
        if (categoryViewModel.categoryResponse.status == Status.error) {
          return Center(
            child: Text(
              'Error: ${categoryViewModel.categoryResponse.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Completed State
        if (categoryViewModel.categoryResponse.status == Status.completed &&
            categoryViewModel.categoryResponse.data != null) {
          var categories = categoryViewModel.categoryResponse.data!;

          // No Categories Available
          if (categories.isEmpty) {
            return const Text('No categories available');
          }

          // Debug: Print categories to see what data is available
          print("Available Categories: $categories");

          // Map categories for dropdown
          final items = categories.map((category) {
            return {'id': category.id, 'name': category.name};
          }).toList();

          return DropdownSearch<Map<String, String>>(
            popupProps: const PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  labelText: 'Search Category',
                  border: OutlineInputBorder(),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 200),
            ),
            items: (String filter, LoadProps? loadProps) async {
              return items; // Return the list of items asynchronously
            },
            itemAsString: (item) => item['name']!,
            compareFn: (item1, item2) {
              return item1['id'] == item2['id']; // Comparing by 'id'
            },
            dropdownBuilder: (context, selectedItem) {
              return Text(selectedItem?['name'] ?? 'Select Category');
            },
            onChanged: (Map<String, String>? newValue) {
              if (newValue != null && newValue['id']!.isNotEmpty) {
                selectedCategoryId.value = newValue['id']; // Save ObjectId
                onChanged(newValue['id']);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          );
        }

        // Default State
        return const SizedBox.shrink();
      },
    );
  }
}
