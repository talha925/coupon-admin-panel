import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view/store/widget/storeForm/store_form.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'widget/store_list_item.dart';

class StoreListPage extends StatelessWidget {
  const StoreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storeViewModel = Provider.of<StoreViewModel>(context, listen: false);

    // ✅ Ensure stores are fetched when the page loads
    Future.microtask(() {
      if (storeViewModel.stores.isEmpty) {
        storeViewModel.getStores();
      }
    });

    print("StoreListPage");
    return Scaffold(
      appBar: AppBar(
        title: Selector<StoreViewModel, Data?>(
          selector: (_, storeViewModel) => storeViewModel.selectedStore,
          builder: (context, selectedStore, child) {
            return Text(selectedStore == null ? 'Store List' : 'Edit Store');
          },
        ),
        leading: Selector<StoreViewModel, Data?>(
          selector: (_, storeViewModel) => storeViewModel.selectedStore,
          builder: (context, selectedStore, child) {
            return selectedStore != null
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Provider.of<StoreViewModel>(context, listen: false)
                          .selectStore(null);
                    },
                  )
                : SizedBox.shrink(); // ✅ Avoid null widget issue
          },
        ),
      ),
      body: Selector<StoreViewModel, Data?>(
        selector: (_, storeViewModel) => storeViewModel.selectedStore,
        builder: (context, selectedStore, child) {
          return selectedStore == null
              ? _buildStoreListView(context)
              : _buildEditStoreForm(context);
        },
      ),
    );
  }

  /// Build Store List View
  Widget _buildStoreListView(BuildContext context) {
    return Column(
      children: [
        // 🔹 Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Search Stores',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) {
              Provider.of<StoreViewModel>(context, listen: false)
                  .searchStores(value);
            },
          ),
        ),

        // 🔹 Store List
        Expanded(
          child: Consumer<StoreViewModel>(
            builder: (context, storeViewModel, child) {
              if (storeViewModel.isFetching) {
                return const Center(child: CircularProgressIndicator());
              }

              if (storeViewModel.filteredStores.isEmpty) {
                return const Center(
                    child: Text(
                        'No stores found')); //  Fix: Show message correctly
              }

              return ListView.builder(
                itemCount: storeViewModel.filteredStores.length,
                itemBuilder: (context, index) {
                  final store = storeViewModel.filteredStores[index];

                  return GestureDetector(
                    onTap: () {
                      Provider.of<StoreViewModel>(context, listen: false)
                          .selectStore(store); // Store selection using Provider
                    },
                    child: StoreListItem(store: store),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build Store Form for Editing
  Widget _buildEditStoreForm(BuildContext context) {
    final storeViewModel = Provider.of<StoreViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StoreFormWidget(store: storeViewModel.selectedStore),
    );
  }
}
