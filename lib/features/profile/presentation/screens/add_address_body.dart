import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AddAddressBody extends StatefulWidget {
  final bool isEdit;

  const AddAddressBody({super.key, this.isEdit = false});

  @override
  State<AddAddressBody> createState() => _AddAddressBodyState();
}

class _AddAddressBodyState extends State<AddAddressBody> {
  final _formKey = GlobalKey<FormState>();

  final _recipientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _notesController = TextEditingController();

  bool isDefault = true;
  String addressType = "Home";

  @override
  void initState() {
    super.initState();

    // بيانات تجريبية عند التعديل
    if (widget.isEdit) {
      _recipientController.text = "Mohamed Hesham";
      _phoneController.text = "01012345678";
      _streetController.text = "El Gomhoria Street";
      _buildingController.text = "Building 12";
      _apartmentController.text = "Apartment 5";
      _notesController.text = "Call before delivery";
      addressType = "Home";
      isDefault = true;
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _apartmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.isEdit ? "Edit Address" : "Add Address",
                        style: AppTextStyles.headlineMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text("Home"),
                            selected: addressType == "Home",
                            onSelected: (_) {
                              setState(() {
                                addressType = "Home";
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text("Office"),
                            selected: addressType == "Office",
                            onSelected: (_) {
                              setState(() {
                                addressType = "Office";
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: _recipientController,
                      decoration: const InputDecoration(
                        labelText: "Recipient Name",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        labelText: "Street",
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _buildingController,
                      decoration: const InputDecoration(
                        labelText: "Building",
                        prefixIcon: Icon(Icons.apartment_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _apartmentController,
                      decoration: const InputDecoration(
                        labelText: "Apartment",
                        prefixIcon: Icon(Icons.home_work_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Delivery Notes",
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 45),
                          child: Icon(Icons.note_alt_outlined),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SwitchListTile(
                      value: isDefault,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Set as Default Address"),
                      onChanged: (value) {
                        setState(() {
                          isDefault = value;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.isEdit
                                      ? "Address Updated Successfully"
                                      : "Address Saved Successfully",
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          widget.isEdit
                              ? Icons.edit_location_alt_outlined
                              : Icons.save_outlined,
                        ),
                        label: Text(
                          widget.isEdit ? "Update Address" : "Save Address",
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
