import 'package:coupon_admin_panel/model/store_model.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/store_view_model/store_view_model.dart';
import 'widget/store_form_button.dart';
import 'widget/store_form_fields.dart';
import 'package:coupon_admin_panel/data/response/api_response.dart';
import 'package:coupon_admin_panel/model/category_model.dart';

class StoreFormWidget extends StatefulWidget {
  // This property may not be needed anymore since we'll use the ViewModel directly
  final Data? store;

  // Constructor without the store parameter, as it can be obtained from ViewModel
  const StoreFormWidget({super.key, this.store});

  @override
  StoreFormWidgetState createState() => StoreFormWidgetState();
}

class StoreFormWidgetState extends State<StoreFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController shortDescriptionController;
  late TextEditingController longDescriptionController;
  late TextEditingController trackingUrlController;
  late TextEditingController metaTitleController;
  late TextEditingController metaDescriptionController;
  late TextEditingController metaKeywordsController;

  late FocusNode nameFocusNode;
  late FocusNode shortDescriptionFocusNode;
  late FocusNode longDescriptionFocusNode;
  late FocusNode trackingUrlFocusNode;
  late FocusNode metaTitleFocusNode;
  late FocusNode metaDescriptionFocusNode;
  late FocusNode metaKeywordsFocusNode;

  late ValueNotifier<String?> _selectedCategory;
  late ValueNotifier<bool> topStore;
  late ValueNotifier<bool> editorsChoice;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    // Initialize with empty controllers
    nameController = TextEditingController();
    shortDescriptionController = TextEditingController();
    longDescriptionController = TextEditingController();
    trackingUrlController = TextEditingController();
    metaTitleController = TextEditingController();
    metaDescriptionController = TextEditingController();
    metaKeywordsController = TextEditingController();

    nameFocusNode = FocusNode();
    shortDescriptionFocusNode = FocusNode();
    longDescriptionFocusNode = FocusNode();
    trackingUrlFocusNode = FocusNode();
    metaTitleFocusNode = FocusNode();
    metaDescriptionFocusNode = FocusNode();
    metaKeywordsFocusNode = FocusNode();

    _selectedCategory = ValueNotifier<String?>(null);
    topStore = ValueNotifier(false);
    editorsChoice = ValueNotifier(false);

    // Fetch categories immediately
    Future.microtask(() =>
        Provider.of<CategoryViewModel>(context, listen: false)
            .fetchCategories());

    // Set up post-frame callback to update fields with selected store data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFieldsFromSelectedStore();
    });
  }

  void _updateFieldsFromSelectedStore() {
    // Get the selected store from ViewModel
    final selectedStore =
        Provider.of<StoreViewModel>(context, listen: false).selectedStore;

    if (selectedStore != null) {
      // We're in edit mode
      isEditing = true;

      // Update all controllers with values from the selected store
      nameController.text = selectedStore.name;
      shortDescriptionController.text = selectedStore.shortDescription;
      longDescriptionController.text = selectedStore.longDescription;
      trackingUrlController.text = selectedStore.trackingUrl;
      metaTitleController.text = selectedStore.seo.metaTitle;
      metaDescriptionController.text = selectedStore.seo.metaDescription;
      metaKeywordsController.text = selectedStore.seo.metaKeywords;

      // Update value notifiers
      if (selectedStore.categories.isNotEmpty) {
        _selectedCategory.value = selectedStore.categories[0].id;
      }
      topStore.value = selectedStore.isTopStore;
      editorsChoice.value = selectedStore.isEditorsChoice;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    shortDescriptionController.dispose();
    longDescriptionController.dispose();
    trackingUrlController.dispose();
    metaTitleController.dispose();
    metaDescriptionController.dispose();
    metaKeywordsController.dispose();

    nameFocusNode.dispose();
    shortDescriptionFocusNode.dispose();
    longDescriptionFocusNode.dispose();
    trackingUrlFocusNode.dispose();
    metaTitleFocusNode.dispose();
    metaDescriptionFocusNode.dispose();
    metaKeywordsFocusNode.dispose();

    _selectedCategory.dispose();
    topStore.dispose();
    editorsChoice.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, _) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Selector<CategoryViewModel, ApiResponse<List<CategoryData>>>(
                selector: (_, viewModel) => viewModel.categoryResponse,
                builder: (context, categoryResponse, child) {
                  return StoreFormFields(
                    nameController: nameController,
                    shortDescriptionController: shortDescriptionController,
                    longDescriptionController: longDescriptionController,
                    trackingUrlController: trackingUrlController,
                    metaTitleController: metaTitleController,
                    metaDescriptionController: metaDescriptionController,
                    metaKeywordsController: metaKeywordsController,
                    nameFocusNode: nameFocusNode,
                    shortDescriptionFocusNode: shortDescriptionFocusNode,
                    longDescriptionFocusNode: longDescriptionFocusNode,
                    trackingUrlFocusNode: trackingUrlFocusNode,
                    metaTitleFocusNode: metaTitleFocusNode,
                    metaDescriptionFocusNode: metaDescriptionFocusNode,
                    metaKeywordsFocusNode: metaKeywordsFocusNode,
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (String? newValue) {
                      _selectedCategory.value = newValue;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              StoreFormButton(
                formKey: _formKey,
                nameController: nameController,
                shortDescriptionController: shortDescriptionController,
                longDescriptionController: longDescriptionController,
                trackingUrlController: trackingUrlController,
                metaTitleController: metaTitleController,
                metaDescriptionController: metaDescriptionController,
                metaKeywordsController: metaKeywordsController,
                selectedCategory: _selectedCategory.value,
                topStore: topStore.value,
                editorsChoice: editorsChoice.value,
                language: 'English',
                store: storeViewModel
                    .selectedStore, // Pass the current selectedStore
              ),
            ],
          ),
        );
      },
    );
  }
}
