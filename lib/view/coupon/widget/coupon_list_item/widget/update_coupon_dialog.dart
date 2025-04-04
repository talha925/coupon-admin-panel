import 'package:coupon_admin_panel/model/coupon_model.dart';
import 'package:flutter/material.dart';

class UpdateCouponDialog extends StatefulWidget {
  final CouponData coupon;
  final Function(Map<String, dynamic>) onUpdate;

  const UpdateCouponDialog({
    super.key,
    required this.coupon,
    required this.onUpdate,
  });

  @override
  State<UpdateCouponDialog> createState() => _UpdateCouponDialogState();
}

class _UpdateCouponDialogState extends State<UpdateCouponDialog> {
  late final TextEditingController _offerNameController;
  late final TextEditingController _codeController;
  bool _isActiveSelected = true;
  bool _isFeaturedForHome = false;

  @override
  void initState() {
    super.initState();
    _offerNameController =
        TextEditingController(text: widget.coupon.offerDetails);
    _codeController = TextEditingController(text: widget.coupon.code);
    _isActiveSelected = widget.coupon.active;
    _isFeaturedForHome = widget.coupon.featuredForHome;
  }

  @override
  void dispose() {
    _offerNameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Coupon'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _offerNameController,
              decoration: const InputDecoration(
                labelText: 'Offer Details',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Coupon Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Active'),
                const SizedBox(width: 16),
                Switch(
                  value: _isActiveSelected,
                  onChanged: (value) {
                    setState(() {
                      _isActiveSelected = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Featured'),
                const SizedBox(width: 16),
                Switch(
                  value: _isFeaturedForHome,
                  onChanged: (value) {
                    setState(() {
                      _isFeaturedForHome = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final Map<String, dynamic> updatedData = {
              'offerDetails': _offerNameController.text,
              'code': _codeController.text,
              'active': _isActiveSelected,
              'featuredForHome': _isFeaturedForHome,
              'storeId': widget.coupon.storeId,
            };
            widget.onUpdate(updatedData);
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
