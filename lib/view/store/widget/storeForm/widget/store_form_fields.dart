import 'package:coupon_admin_panel/res/components/toggle_switch_field.dart';
import 'package:flutter/material.dart';
import 'package:coupon_admin_panel/utils/form_util.dart';
import 'package:coupon_admin_panel/res/components/custom_textfild_component.dart';
import 'package:coupon_admin_panel/res/components/image_picker_widget.dart';
import 'heading_dropdown_button.dart';
import 'store_category_dropdown.dart';

class StoreFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController shortDescriptionController;
  final TextEditingController longDescriptionController;
  final TextEditingController directUrlController;
  final TextEditingController trackingUrlController;
  final TextEditingController metaTitleController;
  final TextEditingController metaDescriptionController;
  final TextEditingController metaKeywordsController;

  final FocusNode nameFocusNode;
  final FocusNode shortDescriptionFocusNode;
  final FocusNode longDescriptionFocusNode;
  final FocusNode directUrlFocusNode;
  final FocusNode trackingUrlFocusNode;
  final FocusNode metaTitleFocusNode;
  final FocusNode metaDescriptionFocusNode;
  final FocusNode metaKeywordsFocusNode;

  final ValueNotifier<String?> selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  // ValueNotifiers for switches
  final ValueNotifier<bool> isTopStore = ValueNotifier(false);
  final ValueNotifier<bool> isEditorsChoice = ValueNotifier(false);

  StoreFormFields({
    super.key,
    required this.nameController,
    required this.shortDescriptionController,
    required this.longDescriptionController,
    required this.directUrlController,
    required this.trackingUrlController,
    required this.metaTitleController,
    required this.metaDescriptionController,
    required this.metaKeywordsController,
    required this.nameFocusNode,
    required this.shortDescriptionFocusNode,
    required this.longDescriptionFocusNode,
    required this.directUrlFocusNode,
    required this.trackingUrlFocusNode,
    required this.metaTitleFocusNode,
    required this.metaDescriptionFocusNode,
    required this.metaKeywordsFocusNode,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Name Field
        CustomTextFormField(
          controller: nameController,
          labelText: 'Store Name',
          focusNode: nameFocusNode,
          nextFocusNode: shortDescriptionFocusNode,
          validator: (value) => FormUtils.validateRequiredField(
            value,
            errorMessage: 'Please enter the store name',
          ),
        ),
        const SizedBox(height: 10),

        // Heading Dropdown
        const HeadingDropdown(),
        const SizedBox(height: 20),

        // Store Category Dropdown
        StoreCategoryDropdown(
            // selectedCategory: selectedCategory,
            onChanged: onCategoryChanged,
            selectedCategoryId: selectedCategory),
        const SizedBox(height: 10),

        // Short Description Field
        CustomTextFormField(
          controller: shortDescriptionController,
          labelText: 'Short Description',
          focusNode: shortDescriptionFocusNode,
          nextFocusNode: longDescriptionFocusNode,
          validator: (value) => FormUtils.validateDescription(value),
        ),
        const SizedBox(height: 10),

        // Long Description Field
        CustomTextFormField(
          controller: longDescriptionController,
          labelText: 'Long Description',
          focusNode: longDescriptionFocusNode,
          nextFocusNode: directUrlFocusNode,
          validator: (value) => FormUtils.validateDescription(value),
        ),
        const SizedBox(height: 10),

        // Direct URL Field
        CustomTextFormField(
          controller: directUrlController,
          labelText: 'Direct URL',
          focusNode: directUrlFocusNode,
          nextFocusNode: trackingUrlFocusNode,
          validator: (value) => FormUtils.validateWebsite(value),
        ),
        const SizedBox(height: 10),

        // Tracking URL Field
        CustomTextFormField(
          controller: trackingUrlController,
          labelText: 'Tracking URL',
          focusNode: trackingUrlFocusNode,
          nextFocusNode: metaTitleFocusNode,
          validator: (value) => FormUtils.validateWebsite(value),
        ),
        const SizedBox(height: 10),

        // Meta Title Field
        CustomTextFormField(
          controller: metaTitleController,
          labelText: 'Meta Title',
          focusNode: metaTitleFocusNode,
          nextFocusNode: metaDescriptionFocusNode,
          validator: (value) => FormUtils.validateRequiredField(
            value,
            errorMessage: 'Please enter meta title',
          ),
        ),
        const SizedBox(height: 10),

        // Meta Description Field
        CustomTextFormField(
          controller: metaDescriptionController,
          labelText: 'Meta Description',
          focusNode: metaDescriptionFocusNode,
          nextFocusNode: metaKeywordsFocusNode,
          validator: (value) => FormUtils.validateRequiredField(
            value,
            errorMessage: 'Please enter meta description',
          ),
        ),
        const SizedBox(height: 10),

        // Meta Keywords Field
        CustomTextFormField(
          controller: metaKeywordsController,
          labelText: 'Meta Keywords (comma separated)',
          focusNode: metaKeywordsFocusNode,
          validator: (value) => FormUtils.validateRequiredField(
            value,
            errorMessage: 'Please enter meta keywords',
          ),
        ),
        const SizedBox(height: 20),

        // Image Picker Widget
        const ImagePickerWidget(),
        const SizedBox(height: 20),

        // Language Dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Language",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            DropdownButton<String>(
              value: "English",
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "Spanish", child: Text("Spanish")),
              ],
              onChanged: (value) {
                // Handle language change if required
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Top Store and Editors Choice Toggles
        ToggleSwitchField(label: "Top Store", switchValue: isTopStore),
        ToggleSwitchField(
            label: "Editors Choice", switchValue: isEditorsChoice),
      ],
    );
  }
}
