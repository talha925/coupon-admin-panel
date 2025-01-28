import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';

import 'widget/store_list_item.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  StoreListPageState createState() => StoreListPageState();
}

class StoreListPageState extends State<StoreListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreViewModel>(context, listen: false).getStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, child) {
        if (storeViewModel.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (storeViewModel.stores.isEmpty) {
          return const Center(child: Text('No stores available'));
        }

        return ListView.builder(
          itemCount: storeViewModel.stores.length,
          itemBuilder: (context, index) {
            final store = storeViewModel.stores[index];
            return StoreListItem(store: store);
          },
        );
      },
    );
  }
}
