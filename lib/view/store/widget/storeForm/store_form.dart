import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/store_form_button.dart';
import 'widget/store_form_fields.dart';

class StoreFormWidget extends StatefulWidget {
  const StoreFormWidget({super.key});

  @override
  StoreFormWidgetState createState() => StoreFormWidgetState();
}

class StoreFormWidgetState extends State<StoreFormWidget> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final nameController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final longDescriptionController = TextEditingController();
  final directUrlController = TextEditingController();
  final trackingUrlController = TextEditingController();
  final metaTitleController = TextEditingController();
  final metaDescriptionController = TextEditingController();
  final metaKeywordsController = TextEditingController();

  // Focus Nodes for form fields
  final nameFocusNode = FocusNode();
  final shortDescriptionFocusNode = FocusNode();
  final longDescriptionFocusNode = FocusNode();
  final directUrlFocusNode = FocusNode();
  final trackingUrlFocusNode = FocusNode();
  final metaTitleFocusNode = FocusNode();
  final metaDescriptionFocusNode = FocusNode();
  final metaKeywordsFocusNode = FocusNode();

  // ValueNotifier for category selection
  final ValueNotifier<String?> _selectedCategory = ValueNotifier<String?>(null);

  // Toggles for Top Store and Editor's Choice
  final ValueNotifier<bool> topStore = ValueNotifier(false);
  final ValueNotifier<bool> editorsChoice = ValueNotifier(false);

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding StoreFormWidget UI...");
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Store Form Fields
          StoreFormFields(
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
            // topStore: topStore,
            // editorsChoice: editorsChoice,
          ),
          const SizedBox(height: 20),

          // Value Listeners for Toggles and Form Submission
          ValueListenableBuilder<String?>(
            valueListenable: _selectedCategory,
            builder: (context, selectedCategoryValue, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: topStore,
                builder: (context, topStoreValue, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: editorsChoice,
                    builder: (context, editorsChoiceValue, __) {
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
                        selectedCategory: selectedCategoryValue,
                        topStore: topStoreValue,
                        editorsChoice: editorsChoiceValue,
                        language: 'English',
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
