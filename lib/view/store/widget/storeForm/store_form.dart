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
    isEditing = widget.store != null;

    nameController = TextEditingController(text: widget.store?.name ?? '');
    shortDescriptionController =
        TextEditingController(text: widget.store?.shortDescription ?? '');
    longDescriptionController =
        TextEditingController(text: widget.store?.longDescription ?? '');
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

    Future.microtask(() =>
        Provider.of<CategoryViewModel>(context, listen: false)
            .fetchCategories());
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
          Selector<StoreViewModel, Data?>(
            selector: (_, viewModel) => viewModel.selectedStore,
            builder: (context, selectedStore, child) {
              return StoreFormButton(
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
                store: selectedStore,
              );
            },
          ),
        ],
      ),
    );
  }
}
