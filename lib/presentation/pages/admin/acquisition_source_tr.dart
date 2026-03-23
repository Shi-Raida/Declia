import '../../../core/enums/acquisition_source.dart';
import '../../translations/translation_keys.dart';

/// Translates [AcquisitionSource] to its localisation key.
extension AcquisitionSourceTr on AcquisitionSource {
  String get trKey => switch (this) {
    AcquisitionSource.referral => Tr.acquisitionSourceReferral,
    AcquisitionSource.socialMedia => Tr.acquisitionSourceSocialMedia,
    AcquisitionSource.website => Tr.acquisitionSourceWebsite,
    AcquisitionSource.wordOfMouth => Tr.acquisitionSourceWordOfMouth,
    AcquisitionSource.event => Tr.acquisitionSourceEvent,
    AcquisitionSource.other => Tr.acquisitionSourceOther,
  };
}
