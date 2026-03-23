import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/enums/acquisition_source.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/communication_preferences.dart';
import '../../usecases/client/params.dart';
import '../../usecases/usecase.dart';
import '../services/client_navigation_service.dart';

final class ClientFormController extends GetxController {
  ClientFormController(
    this._saveClient, {
    required ClientNavigationService navigationService,
    required UseCase<List<String>, NoParams> fetchDistinctTags,
    this.existingClient,
  }) : _nav = navigationService,
       _fetchDistinctTags = fetchDistinctTags;

  final UseCase<Client, SaveClientParams> _saveClient;
  final ClientNavigationService _nav;
  final UseCase<List<String>, NoParams> _fetchDistinctTags;
  final Client? existingClient;

  bool get isEditing => existingClient != null;

  // Text controllers
  late final TextEditingController firstNameCtrl;
  late final TextEditingController lastNameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController streetCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController postalCodeCtrl;
  late final TextEditingController countryCtrl;
  late final TextEditingController companyCtrl;
  late final TextEditingController notesCtrl;

  // Reactive fields
  final dateOfBirth = Rxn<DateTime>();
  final acquisitionSource = Rxn<AcquisitionSource>();
  final tags = <String>[].obs;
  final availableTags = <String>[].obs;
  final commEmail = false.obs;
  final commSms = false.obs;
  final commPhone = false.obs;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    final c = existingClient;
    firstNameCtrl = TextEditingController(text: c?.firstName ?? '');
    lastNameCtrl = TextEditingController(text: c?.lastName ?? '');
    emailCtrl = TextEditingController(text: c?.email ?? '');
    phoneCtrl = TextEditingController(text: c?.phone ?? '');
    streetCtrl = TextEditingController(text: c?.address?.street ?? '');
    cityCtrl = TextEditingController(text: c?.address?.city ?? '');
    postalCodeCtrl = TextEditingController(text: c?.address?.postalCode ?? '');
    countryCtrl = TextEditingController(text: c?.address?.country ?? 'France');
    companyCtrl = TextEditingController(text: c?.company ?? '');
    notesCtrl = TextEditingController(text: c?.notes ?? '');

    dateOfBirth.value = c?.dateOfBirth;
    acquisitionSource.value = c?.acquisitionSource;
    if (c?.tags != null) tags.assignAll(c!.tags);
    commEmail.value = c?.communicationPrefs?.email ?? false;
    commSms.value = c?.communicationPrefs?.sms ?? false;
    commPhone.value = c?.communicationPrefs?.phone ?? false;

    _loadTags();
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    postalCodeCtrl.dispose();
    countryCtrl.dispose();
    companyCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  Future<void> _loadTags() async {
    final result = await _fetchDistinctTags(const NoParams());
    result.fold(ok: (t) => availableTags.assignAll(t), err: (_) {});
  }

  void cancel() => _nav.goBack();

  void addTag(String tag) {
    final t = tag.trim();
    if (t.isNotEmpty && !tags.contains(t)) {
      tags.add(t);
    }
  }

  void removeTag(String tag) => tags.remove(tag);

  Future<void> submit() async {
    isLoading.value = true;
    errorMessage.value = null;

    final communicationPrefs = CommunicationPreferences(
      email: commEmail.value,
      sms: commSms.value,
      phone: commPhone.value,
    );

    final address = Address(
      street: streetCtrl.text.trim().isEmpty ? null : streetCtrl.text.trim(),
      city: cityCtrl.text.trim().isEmpty ? null : cityCtrl.text.trim(),
      postalCode: postalCodeCtrl.text.trim().isEmpty
          ? null
          : postalCodeCtrl.text.trim(),
      country: countryCtrl.text.trim().isEmpty ? null : countryCtrl.text.trim(),
    );

    final company = companyCtrl.text.trim().isEmpty
        ? null
        : companyCtrl.text.trim();

    final client = isEditing
        ? existingClient!.copyWith(
            firstName: firstNameCtrl.text.trim(),
            lastName: lastNameCtrl.text.trim(),
            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
            phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
            company: company,
            dateOfBirth: dateOfBirth.value,
            address: address,
            acquisitionSource: acquisitionSource.value,
            tags: tags.toList(),
            notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
            communicationPrefs: communicationPrefs,
          )
        : Client(
            id: '',
            tenantId: '', // set by DB DEFAULT (current_user_tenant_id())
            firstName: firstNameCtrl.text.trim(),
            lastName: lastNameCtrl.text.trim(),
            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
            phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
            company: company,
            dateOfBirth: dateOfBirth.value,
            address: address,
            acquisitionSource: acquisitionSource.value,
            tags: tags.toList(),
            notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
            communicationPrefs: communicationPrefs,
            createdAt: DateTime(0), // stamped by use case
            updatedAt: DateTime(0), // stamped by use case
          );

    final result = await _saveClient((client: client));
    result.fold(
      ok: (_) => _nav.goBack(),
      err: (failure) => errorMessage.value = failure.message,
    );

    isLoading.value = false;
  }
}
