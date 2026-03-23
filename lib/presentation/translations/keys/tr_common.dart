class TrCommonScope {
  const TrCommonScope();
  String get appName => 'appName';
  TrCookieBanner get cookieBanner => const TrCookieBanner();
  TrLegal get legal => const TrLegal();
  TrSessionType get sessionType => const TrSessionType();
  TrSessionStatus get sessionStatus => const TrSessionStatus();
  TrPaymentStatus get paymentStatus => const TrPaymentStatus();
  TrGalleryStatus get galleryStatus => const TrGalleryStatus();
  TrOrderStatus get orderStatus => const TrOrderStatus();
  TrCommChannel get commChannel => const TrCommChannel();
  TrCommStatus get commStatus => const TrCommStatus();
  TrLegalForm get legalForm => const TrLegalForm();
  TrAcquisitionSource get acquisitionSource => const TrAcquisitionSource();
}

class TrCookieBanner {
  const TrCookieBanner();
  String get title => 'cookieBannerTitle';
  String get description => 'cookieBannerDescription';
  String get acceptAll => 'cookieBannerAcceptAll';
  String get refuseAll => 'cookieBannerRefuseAll';
  String get customize => 'cookieBannerCustomize';
  String get savePreferences => 'cookieBannerSavePreferences';
  String get analytics => 'cookieBannerAnalytics';
  String get marketing => 'cookieBannerMarketing';
  String get functional => 'cookieBannerFunctional';
  String get privacyPolicy => 'cookieBannerPrivacyPolicy';
}

class TrLegal {
  const TrLegal();
  String get privacyTitle => 'legalPrivacyTitle';
  String get privacyContent => 'legalPrivacyContent';
  String get noticesTitle => 'legalNoticesTitle';
  String get noticesContent => 'legalNoticesContent';
}

class TrSessionType {
  const TrSessionType();
  String get family => 'sessionTypeFamily';
  String get equestrian => 'sessionTypeEquestrian';
  String get event => 'sessionTypeEvent';
  String get maternity => 'sessionTypeMaternity';
  String get school => 'sessionTypeSchool';
  String get portrait => 'sessionTypePortrait';
  String get miniSession => 'sessionTypeMiniSession';
  String get other => 'sessionTypeOther';
}

class TrSessionStatus {
  const TrSessionStatus();
  String get scheduled => 'sessionStatusScheduled';
  String get confirmed => 'sessionStatusConfirmed';
  String get completed => 'sessionStatusCompleted';
  String get cancelled => 'sessionStatusCancelled';
  String get noShow => 'sessionStatusNoShow';
}

class TrPaymentStatus {
  const TrPaymentStatus();
  String get pending => 'paymentStatusPending';
  String get partial => 'paymentStatusPartial';
  String get paid => 'paymentStatusPaid';
  String get refunded => 'paymentStatusRefunded';
}

class TrGalleryStatus {
  const TrGalleryStatus();
  String get draft => 'galleryStatusDraft';
  String get published => 'galleryStatusPublished';
  String get archived => 'galleryStatusArchived';
  String get expired => 'galleryStatusExpired';
}

class TrOrderStatus {
  const TrOrderStatus();
  String get pending => 'orderStatusPending';
  String get processing => 'orderStatusProcessing';
  String get shipped => 'orderStatusShipped';
  String get delivered => 'orderStatusDelivered';
  String get cancelled => 'orderStatusCancelled';
  String get refunded => 'orderStatusRefunded';
}

class TrCommChannel {
  const TrCommChannel();
  String get email => 'commChannelEmail';
  String get sms => 'commChannelSms';
}

class TrCommStatus {
  const TrCommStatus();
  String get queued => 'commStatusQueued';
  String get sent => 'commStatusSent';
  String get delivered => 'commStatusDelivered';
  String get failed => 'commStatusFailed';
  String get bounced => 'commStatusBounced';
}

class TrLegalForm {
  const TrLegalForm();
  String get autoEntrepreneur => 'legalFormAutoEntrepreneur';
  String get ei => 'legalFormEi';
  String get eurl => 'legalFormEurl';
  String get sarl => 'legalFormSarl';
  String get sas => 'legalFormSas';
  String get sasu => 'legalFormSasu';
  String get microEntreprise => 'legalFormMicroEntreprise';
  String get association => 'legalFormAssociation';
  String get other => 'legalFormOther';
  String get otherSpecify => 'legalFormOtherSpecify';
}

class TrAcquisitionSource {
  const TrAcquisitionSource();
  String get referral => 'acquisitionSourceReferral';
  String get socialMedia => 'acquisitionSourceSocialMedia';
  String get website => 'acquisitionSourceWebsite';
  String get wordOfMouth => 'acquisitionSourceWordOfMouth';
  String get event => 'acquisitionSourceEvent';
  String get other => 'acquisitionSourceOther';
}
