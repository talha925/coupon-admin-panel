import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

class StoreSearchDropdown extends StatelessWidget {
  final ValueNotifier<String?> selectedStoreId;
  final ValueChanged<String?> onChanged;

  const StoreSearchDropdown({
    super.key,
    required this.selectedStoreId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeVM, _) {
        final stores = storeVM.filteredStores;

        if (stores.isEmpty) {
          return const Center(child: Text('No stores available'));
        }

        final items = stores.map((store) {
          return {'id': store.id, 'name': store.name};
        }).toList();

        return DropdownSearch<Map<String, String>>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                labelText: 'Search Store',
                border: OutlineInputBorder(),
              ),
            ),
            constraints: BoxConstraints(maxHeight: 250),
          ),
          items: items,
          itemAsString: (item) => item['name']!,
          selectedItem: items.firstWhere(
            (item) => item['id'] == selectedStoreId.value,
            orElse: () => {'id': '', 'name': 'Select a Store'},
          ),
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: 'Select Store',
              border: OutlineInputBorder(),
            ),
          ),
          onChanged: (Map<String, String>? newValue) {
            if (newValue != null && newValue['id']!.isNotEmpty) {
              selectedStoreId.value = newValue['id'];
              onChanged(newValue['id']);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a store';
            }
            return null;
          },
        );
      },
    );
  }
}
