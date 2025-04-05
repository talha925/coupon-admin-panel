import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/store_view_model/store_view_model.dart';
import 'package:coupon_admin_panel/view/widgets/error_widget.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreViewModel>(context, listen: false).getStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: StoreSearchDelegate(
                      Provider.of<StoreViewModel>(context, listen: false)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StoreViewModel>(
          builder: (context, storeViewModel, _) {
            return ApiStateHandler<List<Data>>(
              isLoading: storeViewModel.isFetching,
              errorMessage: storeViewModel.errorMessage,
              data: storeViewModel.filteredStores,
              onRetry: () {
                storeViewModel.getStores();
              },
              builder: (storeList) {
                if (storeList.isEmpty) {
                  return const Center(
                    child: Text('No stores found'),
                  );
                }

                return ListView.builder(
                  itemCount: storeList.length,
                  itemBuilder: (context, index) {
                    final store = storeList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: CircleAvatar(
                          backgroundImage: store.image.url.isNotEmpty
                              ? NetworkImage(store.image.url)
                              : null,
                          child: store.image.url.isEmpty
                              ? Text(store.name[0].toUpperCase())
                              : null,
                        ),
                        title: Text(
                          store.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          store.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Set selected store and navigate to edit page
                                storeViewModel.selectStore(store);
                                // Navigate to edit page
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _showDeleteConfirmation(context, store);
                              },
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Data store) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Store'),
        content: Text('Are you sure you want to delete ${store.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<StoreViewModel>(context, listen: false)
                  .deleteStore(store.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class StoreSearchDelegate extends SearchDelegate {
  final StoreViewModel storeViewModel;

  StoreSearchDelegate(this.storeViewModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    storeViewModel.searchStores(query);
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    storeViewModel.searchStores(query);
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredStores = storeViewModel.filteredStores;

    return ListView.builder(
      itemCount: filteredStores.length,
      itemBuilder: (context, index) {
        final store = filteredStores[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: store.image.url.isNotEmpty
                ? NetworkImage(store.image.url)
                : null,
            child: store.image.url.isEmpty
                ? Text(store.name[0].toUpperCase())
                : null,
          ),
          title: Text(store.name),
          subtitle: Text(
            store.shortDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, store);
          },
        );
      },
    );
  }
}
