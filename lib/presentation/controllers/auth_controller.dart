import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/legal_form.dart';
import '../../core/enums/user_role.dart';
import '../../core/errors/failures.dart';
import '../../core/logger/app_logger.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/tenant/params.dart';
import '../../usecases/usecase.dart';
import '../models/user_view_model.dart';
import '../routes/route_args.dart';
import '../routes/app_routes.dart';
import '../services/navigation_service.dart';
import '../translations/translation_keys.dart';
import '../theme/app_colors.dart';
import 'auth_state_controller.dart';
import 'login_form_mixin.dart';
import 'register_form_mixin.dart';

enum AuthView { login, register, forgotPassword }

final class AuthController extends GetxController
    with LoginFormMixin, RegisterFormMixin {
  AuthController(
    this._signIn,
    this._signUp,
    this._resetPassword,
    this._checkTenantSlug,
    this._authState,
    this._nav,
    this._logger, {
    this.initialReason,
    AuthView initialView = AuthView.login,
    String? initialTenantSlug,
  }) : currentView = initialView.obs,
       _initialTenantSlug = initialTenantSlug;

  final SignInUseCase _signIn;
  final UseCase<void, SignUpParams> _signUp;
  final UseCase<void, ResetPasswordParams> _resetPassword;
  final UseCase<bool, CheckTenantSlugParams> _checkTenantSlug;
  final AuthStateController _authState;
  final NavigationService _nav;
  final AppLogger _logger;
  final String? initialReason;
  final String? _initialTenantSlug;

  // View state
  final Rx<AuthView> currentView;
  final selectedRole = 0.obs; // 0=Client, 1=Photographer
  final rememberMe = true.obs;

  // Per-view form keys
  final registerFormKey = GlobalKey<FormState>();
  final forgotFormKey = GlobalKey<FormState>();

  // Per-step form keys (registration wizard)
  final registerStep1Key = GlobalKey<FormState>();
  final registerStepStudioKey = GlobalKey<FormState>();
  final registerStep2Key = GlobalKey<FormState>();

  // Registration wizard step (0-indexed)
  final registerStep = 0.obs;

  // Forgot password email (separate from login email)
  final forgotEmailController = TextEditingController();

  // Register tenant slug
  final tenantSlugController = TextEditingController();

  // State
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isRegisterSuccess = false.obs;
  final isForgotSuccess = false.obs;

  // Password strength (0–4)
  final passwordStrength = 0.obs;

  Color get accentColor =>
      selectedRole.value == 0 ? AppColors.bleuOuvert : AppColors.terracotta;

  @override
  void onInit() {
    super.onInit();
    if (initialReason == RouteArgs.unauthorizedRole) {
      errorMessage.value = Tr.loginUnauthorizedRole.tr;
      _authState.signOut();
    }
    if (_initialTenantSlug != null) {
      tenantSlugController.text = _initialTenantSlug;
    }
    // Reset wizard to step 0 when role changes during registration
    ever(selectedRole, (_) {
      if (currentView.value == AuthView.register) {
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
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 70,
      );
      if (picked != null) {
        avatarBytes.value = await picked.readAsBytes();
      }
    } catch (_) {
      // image_picker not available on web — silent fail
    }
  }

  // -- View navigation --

  void goToRegister() {
    errorMessage.value = null;
    isRegisterSuccess.value = false;
    registerStep.value = 0;
    currentView.value = AuthView.register;
    _replaceUrl(AppRoutes.authRegister);
  }

  void goToForgotPassword() {
    errorMessage.value = null;
    isForgotSuccess.value = false;
    forgotEmailController.text = emailController.text;
    currentView.value = AuthView.forgotPassword;
    _replaceUrl(AppRoutes.authForgotPassword);
  }

  void goToLogin() {
    errorMessage.value = null;
    isRegisterSuccess.value = false;
    isForgotSuccess.value = false;
    currentView.value = AuthView.login;
    _replaceUrl(AppRoutes.login);
  }

  void _replaceUrl(String path) {
    SystemNavigator.routeInformationUpdated(
      uri: Uri.parse(path),
      replace: true,
    );
  }

  // -- Actions --

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final allowedRoles = selectedRole.value == 0
        ? {UserRole.client}
        : {UserRole.photographer, UserRole.tech};

    final result = await _signIn((
      email: emailController.text.trim(),
      password: passwordController.text,
      allowedRoles: allowedRoles,
    ));
    isLoading.value = false;
    result.fold(
      ok: (user) {
        _authState.setUser(UserViewModel.fromEntity(user));
        _nav.toHome(user.role);
      },
      err: (failure) {
        _logger.warning('Login failed', error: failure);
        errorMessage.value = switch (failure) {
          UnauthorisedRoleFailure() => Tr.loginUnauthorizedRole.tr,
          InvalidCredentialsFailure() => Tr.loginInvalidCredentials.tr,
          _ => _translateFailure(failure),
        };
      },
    );
  }

  // -- Registration wizard step navigation --

  bool get isClient => selectedRole.value == 0;

  int get totalSteps => isClient ? 3 : 4;

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
          _ => _translateFailure(failure),
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
      // Client-specific fields
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
      if (address.isNotEmpty) meta['address'] = address;
    } else {
      // Photographer-specific fields
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
      if (bizAddress.isNotEmpty) meta['address'] = bizAddress;
    }

    // Shared consents
    meta['consent_cgu'] = cguAccepted.value;
    meta['consent_marketing'] = emailMarketingAccepted.value;
    meta['gdpr_consent_date'] = DateTime.now().toIso8601String();

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

  Future<void> submitForgotPassword() async {
    if (!forgotFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _resetPassword((
      email: forgotEmailController.text.trim(),
    ));
    isLoading.value = false;
    result.fold(
      ok: (_) => isForgotSuccess.value = true,
      err: (failure) {
        _logger.warning('Password reset failed', error: failure);
        errorMessage.value = _translateFailure(failure);
      },
    );
  }

  String _translateFailure(Failure failure) {
    if (failure is NetworkFailure) return Tr.authErrorNetwork.tr;

    final msg = failure.message.toLowerCase();
    if (msg.contains('email') && msg.contains('invalid')) {
      return Tr.authErrorInvalidEmail.tr;
    }
    if (msg.contains('password') && msg.contains('characters')) {
      return Tr.authErrorPasswordTooShort.tr;
    }
    if (msg.contains('rate') ||
        msg.contains('once every') ||
        msg.contains('too many')) {
      return Tr.authErrorRateLimited.tr;
    }
    return Tr.authErrorGeneric.tr;
  }

  @override
  void onClose() {
    forgotEmailController.dispose();
    tenantSlugController.dispose();
    super.onClose();
  }
}
