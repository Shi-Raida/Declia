import '../../../core/enums/acquisition_source.dart';
import '../../translations/translation_keys.dart';

/// Translates [AcquisitionSource] to its localisation key.
extension AcquisitionSourceTr on AcquisitionSource {
  String get trKey => switch (this) {
    AcquisitionSource.referral => Tr.common.acquisitionSource.referral,
    AcquisitionSource.socialMedia => Tr.common.acquisitionSource.socialMedia,
    AcquisitionSource.website => Tr.common.acquisitionSource.website,
    AcquisitionSource.wordOfMouth => Tr.common.acquisitionSource.wordOfMouth,
    AcquisitionSource.event => Tr.common.acquisitionSource.event,
    AcquisitionSource.other => Tr.common.acquisitionSource.other,
  };
}
