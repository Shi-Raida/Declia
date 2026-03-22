import 'package:json_annotation/json_annotation.dart';

enum LegalForm {
  @JsonValue('auto_entrepreneur')
  autoEntrepreneur,
  @JsonValue('ei')
  ei,
  @JsonValue('eurl')
  eurl,
  @JsonValue('sarl')
  sarl,
  @JsonValue('sas')
  sas,
  @JsonValue('sasu')
  sasu,
  @JsonValue('other')
  other,
}

extension LegalFormJson on LegalForm {
  String get jsonValue => switch (this) {
    LegalForm.autoEntrepreneur => 'auto_entrepreneur',
    LegalForm.ei => 'ei',
    LegalForm.eurl => 'eurl',
    LegalForm.sarl => 'sarl',
    LegalForm.sas => 'sas',
    LegalForm.sasu => 'sasu',
    LegalForm.other => 'other',
  };
}
