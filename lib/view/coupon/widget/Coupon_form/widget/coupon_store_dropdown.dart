import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

class StoreDropdown extends StatefulWidget {
  final String? selectedStoreId;
  final Function(String?) onStoreSelected;

  const StoreDropdown({
    super.key,
    required this.selectedStoreId,
    required this.onStoreSelected,
  });

  @override
  StoreDropdownState createState() => StoreDropdownState();
}

class StoreDropdownState extends State<StoreDropdown> {
  bool _hasFetchedStores = false; // Flag to prevent re-fetching

  @override
  void initState() {
    super.initState();
    // Fetch stores only once when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasFetchedStores) {
        final storeViewModel =
            Provider.of<StoreViewModel>(context, listen: false);
        storeViewModel.getStores();
        _hasFetchedStores = true; // Set flag to true to prevent further fetches
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("StoreDropdownState");

    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, child) {
        // Show loader while fetching stores
        if (storeViewModel.isFetching) {
          return const CircularProgressIndicator();
        }

        // If no stores available
        if (storeViewModel.stores.isEmpty) {
          return const Text('No stores available');
        }

        return DropdownButtonFormField<String>(
          hint: const Text('Select Store'),
          value: widget.selectedStoreId,
          onChanged: (String? newValue) {
            widget.onStoreSelected(newValue);
          },
          items: storeViewModel.stores.map((Data store) {
            return DropdownMenuItem<String>(
              value: store.id,
              child: Text(store.name),
            );
          }).toList(),
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
