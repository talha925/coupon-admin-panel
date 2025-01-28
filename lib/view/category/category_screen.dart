import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:coupon_admin_panel/view_model/categoryViewModel/category_view_model.dart';

import 'widget/add_category_button.dart';
import 'widget/category_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: const [AddCategoryButton()],
      ),
      body: const CategoryListWidget(),
    );
  }
}
