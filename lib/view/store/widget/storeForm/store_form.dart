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
  final Data? store; // If provided, it's in edit mode

  const StoreFormWidget({super.key, this.store});

  @override
  StoreFormWidgetState createState() => StoreFormWidgetState();
}

class StoreFormWidgetState extends State<StoreFormWidget> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  late TextEditingController nameController;
  late TextEditingController shortDescriptionController;
  late TextEditingController longDescriptionController;
  late TextEditingController directUrlController;
  late TextEditingController trackingUrlController;
  late TextEditingController metaTitleController;
  late TextEditingController metaDescriptionController;
  late TextEditingController metaKeywordsController;

  // Focus Nodes for form fields
  late FocusNode nameFocusNode;
  late FocusNode shortDescriptionFocusNode;
  late FocusNode longDescriptionFocusNode;
  late FocusNode directUrlFocusNode;
  late FocusNode trackingUrlFocusNode;
  late FocusNode metaTitleFocusNode;
  late FocusNode metaDescriptionFocusNode;
  late FocusNode metaKeywordsFocusNode;

  // ValueNotifier for category selection
  late ValueNotifier<String?> _selectedCategory;

  // Toggles for Top Store and Editor's Choice
  late ValueNotifier<bool> topStore;
  late ValueNotifier<bool> editorsChoice;

  bool isEditing = false; // To track whether it's edit mode

  @override
  void initState() {
    super.initState();

    isEditing = widget.store != null;

    // ✅ Initialize controllers only once
    nameController = TextEditingController(text: widget.store?.name ?? '');
    shortDescriptionController =
        TextEditingController(text: widget.store?.shortDescription ?? '');
    longDescriptionController =
        TextEditingController(text: widget.store?.longDescription ?? '');
    directUrlController =
        TextEditingController(text: widget.store?.directUrl ?? '');
    trackingUrlController =
        TextEditingController(text: widget.store?.trackingUrl ?? '');
    metaTitleController =
        TextEditingController(text: widget.store?.seo.metaTitle ?? '');
    metaDescriptionController =
        TextEditingController(text: widget.store?.seo.metaDescription ?? '');
    metaKeywordsController =
        TextEditingController(text: widget.store?.seo.metaKeywords ?? '');

    nameFocusNode = FocusNode();
    shortDescriptionFocusNode = FocusNode();
    longDescriptionFocusNode = FocusNode();
    directUrlFocusNode = FocusNode();
    trackingUrlFocusNode = FocusNode();
    metaTitleFocusNode = FocusNode();
    metaDescriptionFocusNode = FocusNode();
    metaKeywordsFocusNode = FocusNode();

    _selectedCategory = ValueNotifier<String?>(
        widget.store?.categories.isNotEmpty == true
            ? widget.store!.categories[0].id
            : null);
    topStore = ValueNotifier(widget.store?.isTopStore ?? false);
    editorsChoice = ValueNotifier(widget.store?.isEditorsChoice ?? false);

    // ✅ Use Future.microtask() to avoid unnecessary rebuilds
    Future.microtask(() =>
        Provider.of<CategoryViewModel>(context, listen: false)
            .fetchCategories());
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    shortDescriptionController.dispose();
    longDescriptionController.dispose();
    directUrlController.dispose();
    trackingUrlController.dispose();
    metaTitleController.dispose();
    metaDescriptionController.dispose();
    metaKeywordsController.dispose();

    // Dispose focus nodes
    nameFocusNode.dispose();
    shortDescriptionFocusNode.dispose();
    longDescriptionFocusNode.dispose();
    directUrlFocusNode.dispose();
    trackingUrlFocusNode.dispose();
    metaTitleFocusNode.dispose();
    metaDescriptionFocusNode.dispose();
    metaKeywordsFocusNode.dispose();

    // Dispose ValueNotifier
    _selectedCategory.dispose();
    topStore.dispose();
    editorsChoice.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Use Selector instead of Consumer for better rebuilds
          Selector<CategoryViewModel, ApiResponse<List<CategoryData>>>(
            selector: (_, viewModel) => viewModel.categoryResponse,
            builder: (context, categoryResponse, child) {
              return StoreFormFields(
                nameController: nameController,
                shortDescriptionController: shortDescriptionController,
                longDescriptionController: longDescriptionController,
                directUrlController: directUrlController,
                trackingUrlController: trackingUrlController,
                metaTitleController: metaTitleController,
                metaDescriptionController: metaDescriptionController,
                metaKeywordsController: metaKeywordsController,
                nameFocusNode: nameFocusNode,
                shortDescriptionFocusNode: shortDescriptionFocusNode,
                longDescriptionFocusNode: longDescriptionFocusNode,
                directUrlFocusNode: directUrlFocusNode,
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

          // ✅ Use Selector to only rebuild specific parts when needed
          Selector<StoreViewModel, Data?>(
            selector: (_, viewModel) => viewModel.selectedStore,
            builder: (context, selectedStore, child) {
              return StoreFormButton(
                formKey: _formKey,
                nameController: nameController,
                shortDescriptionController: shortDescriptionController,
                longDescriptionController: longDescriptionController,
                directUrlController: directUrlController,
                trackingUrlController: trackingUrlController,
                metaTitleController: metaTitleController,
                metaDescriptionController: metaDescriptionController,
                metaKeywordsController: metaKeywordsController,
                selectedCategory: _selectedCategory.value,
                topStore: topStore.value,
                editorsChoice: editorsChoice.value,
                language: 'English',
                store: selectedStore,
              );
            },
          ),
        ],
      ),
    );
  }
}
