class TrAuthScope {
  const TrAuthScope();
  TrAuthLogin get login => const TrAuthLogin();
  TrAuthClientLogin get clientLogin => const TrAuthClientLogin();
  TrAuthClientRegister get clientRegister => const TrAuthClientRegister();
  TrAuthForgotPassword get forgotPassword => const TrAuthForgotPassword();
  TrAuthClientHome get clientHome => const TrAuthClientHome();
  TrAuthRegister get register => const TrAuthRegister();
  TrAuthError get error => const TrAuthError();
  TrAuthForgot get forgot => const TrAuthForgot();
}

class TrAuthLogin {
  const TrAuthLogin();
  String get subtitle => 'loginSubtitle';
  String get email => 'loginEmail';
  String get emailHint => 'loginEmailHint';
  String get emailRequired => 'loginEmailRequired';
  String get emailInvalid => 'loginEmailInvalid';
  String get password => 'loginPassword';
  String get passwordRequired => 'loginPasswordRequired';
  String get submit => 'loginSubmit';
  String get unauthorizedRole => 'loginUnauthorizedRole';
  String get invalidCredentials => 'loginInvalidCredentials';
  String get tagline => 'loginTagline';
  String get taglineHighlight => 'loginTaglineHighlight';
  String get feature1 => 'loginFeature1';
  String get feature2 => 'loginFeature2';
  String get feature3 => 'loginFeature3';
  String get feature4 => 'loginFeature4';
  String get rememberMe => 'loginRememberMe';
  String get forgotPassword => 'loginForgotPassword';
  String get roleClient => 'loginRoleClient';
  String get rolePhotographer => 'loginRolePhotographer';
  String get titleClient => 'loginTitleClient';
  String get subtitleClient => 'loginSubtitleClient';
  String get titlePhotographer => 'loginTitlePhotographer';
  String get subtitlePhotographer => 'loginSubtitlePhotographer';
  String get submitPhotographer => 'loginSubmitPhotographer';
  String get photographerCode => 'loginPhotographerCode';
  String get photographerCodeHint => 'loginPhotographerCodeHint';
  String get footerNoAccount => 'loginFooterNoAccount';
  String get footerCreateAccount => 'loginFooterCreateAccount';
  String get footerCreateAccountPhotographer =>
      'loginFooterCreateAccountPhotographer';
  String get brandSubtitle => 'loginBrandSubtitle';
  String get clientTagline => 'loginClientTagline';
  String get clientTaglineHighlight => 'loginClientTaglineHighlight';
  String get clientSubtitle => 'loginClientSubtitle';
  String get clientFeature1 => 'loginClientFeature1';
  String get clientFeature2 => 'loginClientFeature2';
  String get clientFeature3 => 'loginClientFeature3';
  String get clientFeature4 => 'loginClientFeature4';
}

class TrAuthClientLogin {
  const TrAuthClientLogin();
  String get subtitle => 'clientLoginSubtitle';
  String get forgotPassword => 'clientLoginForgotPassword';
  String get createAccount => 'clientLoginCreateAccount';
}

class TrAuthClientRegister {
  const TrAuthClientRegister();
  String get title => 'clientRegisterTitle';
  String get confirmPassword => 'clientRegisterConfirmPassword';
  String get confirmPasswordRequired => 'clientRegisterConfirmPasswordRequired';
  String get passwordMismatch => 'clientRegisterPasswordMismatch';
  String get submit => 'clientRegisterSubmit';
  String get success => 'clientRegisterSuccess';
  String get emailAlreadyInUse => 'clientRegisterEmailAlreadyInUse';
  String get invalidLink => 'clientRegisterInvalidLink';
  String get haveAccount => 'clientRegisterHaveAccount';
}

class TrAuthForgotPassword {
  const TrAuthForgotPassword();
  String get title => 'clientForgotPasswordTitle';
  String get subtitle => 'clientForgotPasswordSubtitle';
  String get submit => 'clientForgotPasswordSubmit';
  String get success => 'clientForgotPasswordSuccess';
  String get backToLogin => 'clientForgotPasswordBackToLogin';
}

class TrAuthClientHome {
  const TrAuthClientHome();
  String get title => 'clientHomeTitle';
  String get welcome => 'clientHomeWelcome';
  String get logout => 'clientHomeLogout';
}

class TrAuthRegister {
  const TrAuthRegister();
  String get titleClient => 'authRegisterTitleClient';
  String get titlePhotographer => 'authRegisterTitlePhotographer';
  String get subtitleClient => 'authRegisterSubtitleClient';
  String get subtitlePhotographer => 'authRegisterSubtitlePhotographer';
  String get footerHaveAccount => 'authRegisterFooterHaveAccount';
  String get footerSignIn => 'authRegisterFooterSignIn';
  String get success => 'authRegisterSuccess';
  String get stepPersonal => 'registerStepPersonal';
  String get stepBusiness => 'registerStepBusiness';
  String get stepSecurity => 'registerStepSecurity';
  String get stepConfirmation => 'registerStepConfirmation';
  String get stepPersonalDesc => 'registerStepPersonalDesc';
  String get stepBusinessDesc => 'registerStepBusinessDesc';
  String get stepSecurityDesc => 'registerStepSecurityDesc';
  String get stepConfirmationDesc => 'registerStepConfirmationDesc';
  String get fieldFirstName => 'registerFieldFirstName';
  String get fieldLastName => 'registerFieldLastName';
  String get fieldPhone => 'registerFieldPhone';
  String get fieldStreet => 'registerFieldStreet';
  String get fieldPostalCode => 'registerFieldPostalCode';
  String get fieldCity => 'registerFieldCity';
  String get fieldStudioName => 'registerFieldStudioName';
  String get fieldCompanyName => 'registerFieldCompanyName';
  String get fieldSiret => 'registerFieldSiret';
  String get fieldLegalForm => 'registerFieldLegalForm';
  String get fieldVatNumber => 'registerFieldVatNumber';
  String get fieldBizStreet => 'registerFieldBizStreet';
  String get fieldBizPostalCode => 'registerFieldBizPostalCode';
  String get fieldCountry => 'registerFieldCountry';
  String get fieldBizCountry => 'registerFieldBizCountry';
  String get fieldBizCity => 'registerFieldBizCity';
  String get fieldAcquisitionSource => 'registerFieldAcquisitionSource';
  String get fieldNotes => 'registerFieldNotes';
  String get fieldInvitationCode => 'registerFieldInvitationCode';
  String get fieldInvitationCodeHint => 'registerFieldInvitationCodeHint';
  String get fieldInvitationCodeRequired =>
      'registerFieldInvitationCodeRequired';
  String get fieldCompany => 'registerFieldCompany';
  String get fieldRequired => 'registerFieldRequired';
  String get consentCgu => 'registerConsentCgu';
  String get consentCguPrefix => 'registerConsentCguPrefix';
  String get consentCguLink => 'registerConsentCguLink';
  String get consentCguMiddle => 'registerConsentCguMiddle';
  String get consentPrivacyLink => 'registerConsentPrivacyLink';
  String get consentCguRequired => 'registerConsentCguRequired';
  String get consentMarketing => 'registerConsentMarketing';
  String get btnContinue => 'registerBtnContinue';
  String get btnBack => 'registerBtnBack';
  String get btnSubmit => 'registerBtnSubmit';
  String get summaryTitle => 'registerSummaryTitle';
  String get summaryIdentity => 'registerSummaryIdentity';
  String get summaryContact => 'registerSummaryContact';
  String get summaryAddress => 'registerSummaryAddress';
  String get summaryBusiness => 'registerSummaryBusiness';
  String get leftTaglineClient => 'registerLeftTaglineClient';
  String get leftTaglineClientHighlight => 'registerLeftTaglineClientHighlight';
  String get leftTaglinePhotographer => 'registerLeftTaglinePhotographer';
  String get leftTaglinePhotographerHighlight =>
      'registerLeftTaglinePhotographerHighlight';
  String get leftSubtitleClient => 'registerLeftSubtitleClient';
  String get leftSubtitlePhotographer => 'registerLeftSubtitlePhotographer';
  String get sectionIdentity => 'registerSectionIdentity';
  String get sectionStudio => 'registerSectionStudio';
  String get sectionPreferences => 'registerSectionPreferences';
  String get avatarTitle => 'registerAvatarTitle';
  String get avatarHint => 'registerAvatarHint';
  String get sectionAddress => 'registerSectionAddress';
  String get sectionBizAddress => 'registerSectionBizAddress';
  String get stepStudio => 'registerStepStudio';
  String get stepStudioDesc => 'registerStepStudioDesc';
  String get avatarComingSoon => 'registerAvatarComingSoon';
  String get passwordHint => 'registerPasswordHint';
  String get passwordTooWeak => 'registerPasswordTooWeak';
  String get vatInvalid => 'registerVatInvalid';
}

class TrAuthError {
  const TrAuthError();
  String get invalidEmail => 'authErrorInvalidEmail';
  String get passwordTooShort => 'authErrorPasswordTooShort';
  String get rateLimited => 'authErrorRateLimited';
  String get network => 'authErrorNetwork';
  String get generic => 'authErrorGeneric';
}

class TrAuthForgot {
  const TrAuthForgot();
  String get title => 'authForgotTitle';
  String get titlePhotographer => 'authForgotTitlePhotographer';
  String get subtitle => 'authForgotSubtitle';
  String get subtitlePhotographer => 'authForgotSubtitlePhotographer';
  String get submit => 'authForgotSubmit';
  String get success => 'authForgotSuccess';
  String get backToLogin => 'authForgotBackToLogin';
}
