import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/legal_form.dart';
import 'login_form_mixin.dart';

mixin RegisterFormMixin on GetxController, LoginFormMixin {
  final confirmPasswordController = TextEditingController();

  // Step 1 — Personal / Business info
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController(text: 'France');

  // Step 1 — Client-only
  final clientCompanyController = TextEditingController();

  // Step 1 — Photographer-only
  final studioNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final siretController = TextEditingController();
  final legalForm = Rxn<LegalForm>();
  final vatNumberController = TextEditingController();
  final bizStreetController = TextEditingController();
  final bizPostalCodeController = TextEditingController();
  final bizCityController = TextEditingController();
  final bizCountryController = TextEditingController(text: 'France');

  // Avatar
  final avatarBytes = Rxn<Uint8List>();

  // Step 2 — CRM (shared)
  final notesController = TextEditingController();
  final acquisitionSource = Rxn<AcquisitionSource>();

  // Legal form "Other" free text
  final legalFormOtherController = TextEditingController();

  // Step 3 — Consents
  final cguAccepted = false.obs;
  final emailMarketingAccepted = false.obs;

  @override
  void onClose() {
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    countryController.dispose();
    clientCompanyController.dispose();
    studioNameController.dispose();
    companyNameController.dispose();
    siretController.dispose();
    vatNumberController.dispose();
    bizStreetController.dispose();
    bizPostalCodeController.dispose();
    bizCityController.dispose();
    bizCountryController.dispose();
    legalFormOtherController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
