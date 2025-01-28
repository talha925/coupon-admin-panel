import 'package:flutter/material.dart';

import 'category_dialog.dart';

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showCategoryDialog(context, null); // Now it will work
      },
    );
  }
}
