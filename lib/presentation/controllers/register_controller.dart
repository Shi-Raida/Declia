import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/legal_form.dart';
import '../../core/errors/failures.dart';
import '../../core/logger/app_logger.dart';
import '../../core/utils/clock.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/tenant/params.dart';
import '../../usecases/usecase.dart';
import '../services/image_picker_service.dart';
import '../translations/translation_keys.dart';
import 'auth_controller.dart';
import 'auth_failure_translator.dart';
import 'auth_orchestrator_access.dart';
import 'login_form_mixin.dart';
import 'register_form_mixin.dart';

final class RegisterController extends GetxController
    with LoginFormMixin, RegisterFormMixin, AuthOrchestratorAccess {
  RegisterController(
    this._signUp,
    this._checkTenantSlug,
    this._logger,
    this._imagePicker,
    this._clock, {
    String? initialTenantSlug,
  }) : _initialTenantSlug = initialTenantSlug;

  final UseCase<void, SignUpParams> _signUp;
  final UseCase<bool, CheckTenantSlugParams> _checkTenantSlug;
  final AppLogger _logger;
  final ImagePickerService _imagePicker;
  final Clock _clock;
  final String? _initialTenantSlug;

  // Per-step form keys (registration wizard)
  final registerStep1Key = GlobalKey<FormState>();
  final registerStepStudioKey = GlobalKey<FormState>();
  final registerStep2Key = GlobalKey<FormState>();

  // Registration wizard step (0-indexed)
  final registerStep = 0.obs;

  // Register tenant slug
  final tenantSlugController = TextEditingController();

  // State
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isRegisterSuccess = false.obs;

  // Password strength (0–4)
  final passwordStrength = 0.obs;

  bool get isClient => selectedRoleValue == 0;
  int get totalSteps => isClient ? 3 : 4;

  @override
  void onInit() {
    super.onInit();
    if (_initialTenantSlug != null) {
      tenantSlugController.text = _initialTenantSlug;
    }
    // Reset wizard to step 0 when role changes during registration
    ever(orchestrator.selectedRole, (_) {
      if (orchestrator.currentView.value == AuthView.register) {
        registerStep.value = 0;
      }
    });
    // Password strength listener
    passwordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    final pw = passwordController.text;
    if (pw.length < 8) {
      passwordStrength.value = pw.isEmpty ? 0 : 1;
      return;
    }
    var score = 0;
    if (pw.contains(RegExp(r'[A-Z]'))) score++;
    if (pw.contains(RegExp(r'[a-z]'))) score++;
    if (pw.contains(RegExp(r'[0-9]'))) score++;
    if (pw.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    passwordStrength.value = score;
  }

  Future<void> pickAvatar() async {
    try {
      final bytes = await _imagePicker.pickGalleryImage(
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 70,
      );
      if (bytes != null) {
        avatarBytes.value = bytes;
      }
    } catch (_) {
      // image_picker not available on web — silent fail
    }
  }

  // -- Registration wizard step navigation --

  GlobalKey<FormState>? _formKeyForStep(int step) {
    if (isClient) {
      return switch (step) {
        0 => registerStep1Key,
        1 => registerStep2Key,
        _ => null,
      };
    }
    return switch (step) {
      0 => registerStep1Key,
      1 => registerStepStudioKey,
      2 => registerStep2Key,
      _ => null,
    };
  }

  void goToNextStep() {
    errorMessage.value = null;
    final key = _formKeyForStep(registerStep.value);
    if (key == null || (key.currentState?.validate() ?? false)) {
      registerStep.value++;
    }
  }

  void goToPreviousStep() {
    errorMessage.value = null;
    if (registerStep.value > 0) {
      registerStep.value--;
    }
  }

  Future<void> register() async {
    // Validate CGU consent on final step
    if (!cguAccepted.value) {
      errorMessage.value = Tr.registerConsentCguRequired.tr;
      return;
    }

    // Client must provide an invitation code
    if (isClient && tenantSlugController.text.trim().isEmpty) {
      errorMessage.value = Tr.registerFieldInvitationCodeRequired.tr;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final slug = tenantSlugController.text.trim();

    // Validate tenant slug if provided
    if (slug.isNotEmpty) {
      final slugResult = await _checkTenantSlug((slug: slug));
      final isValid = slugResult.fold(
        ok: (exists) => exists,
        err: (_) => true, // fail open
      );
      if (!isValid) {
        isLoading.value = false;
        errorMessage.value = Tr.clientRegisterInvalidLink.tr;
        return;
      }
    }

    final metadata = _buildMetadata();

    final result = await _signUp((
      email: emailController.text.trim(),
      password: passwordController.text,
      tenantSlug: slug.isNotEmpty ? slug : null,
      metadata: metadata,
    ));
    isLoading.value = false;
    result.fold(
      ok: (_) => isRegisterSuccess.value = true,
      err: (failure) {
        _logger.warning('Registration failed', error: failure);
        errorMessage.value = switch (failure) {
          EmailAlreadyInUseFailure() => Tr.clientRegisterEmailAlreadyInUse.tr,
          _ => translateAuthFailure(failure),
        };
      },
    );
  }

  Map<String, dynamic> _buildMetadata() {
    final meta = <String, dynamic>{
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'role': isClient ? 'client' : 'photographer',
    };

    if (isClient) {
      if (clientCompanyController.text.trim().isNotEmpty) {
        meta['company'] = clientCompanyController.text.trim();
      }
      final address = <String, String>{};
      if (streetController.text.trim().isNotEmpty) {
        address['street'] = streetController.text.trim();
      }
      if (postalCodeController.text.trim().isNotEmpty) {
        address['postal_code'] = postalCodeController.text.trim();
      }
      if (cityController.text.trim().isNotEmpty) {
        address['city'] = cityController.text.trim();
      }
      if (countryController.text.trim().isNotEmpty) {
        address['country'] = countryController.text.trim();
      }
      if (address.isNotEmpty) meta['address'] = address;
    } else {
      meta['studio_name'] = studioNameController.text.trim();
      if (companyNameController.text.trim().isNotEmpty) {
        meta['company_name'] = companyNameController.text.trim();
      }
      if (siretController.text.trim().isNotEmpty) {
        meta['siret'] = siretController.text.trim();
      }
      if (legalForm.value != null) {
        if (legalForm.value == LegalForm.other) {
          final other = legalFormOtherController.text.trim();
          meta['legal_form'] = other.isNotEmpty ? other : 'other';
        } else {
          meta['legal_form'] = legalForm.value!.jsonValue;
        }
      }
      if (vatNumberController.text.trim().isNotEmpty) {
        meta['vat_number'] = vatNumberController.text.trim();
      }

      final bizAddress = <String, String>{};
      if (bizStreetController.text.trim().isNotEmpty) {
        bizAddress['street'] = bizStreetController.text.trim();
      }
      if (bizPostalCodeController.text.trim().isNotEmpty) {
        bizAddress['postal_code'] = bizPostalCodeController.text.trim();
      }
      if (bizCityController.text.trim().isNotEmpty) {
        bizAddress['city'] = bizCityController.text.trim();
      }
      if (bizCountryController.text.trim().isNotEmpty) {
        bizAddress['country'] = bizCountryController.text.trim();
      }
      if (bizAddress.isNotEmpty) meta['address'] = bizAddress;
    }

    meta['consent_cgu'] = cguAccepted.value;
    meta['consent_marketing'] = emailMarketingAccepted.value;
    meta['gdpr_consent_date'] = _clock.now().toIso8601String();

    if (avatarBytes.value != null) {
      meta['avatar'] = base64Encode(avatarBytes.value!);
    }
    if (acquisitionSource.value != null) {
      meta['acquisition_source'] = acquisitionSource.value!.jsonValue;
    }
    if (notesController.text.trim().isNotEmpty) {
      meta['notes'] = notesController.text.trim();
    }

    return meta;
  }

  @override
  void onClose() {
    tenantSlugController.dispose();
    super.onClose();
  }
}
