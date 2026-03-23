import '../translation_keys.dart';

final Map<String, String> enUsAuth = {
  // Login
  Tr.auth.login.subtitle:
      'Client management, bookings, galleries and invoicing — all in one place.',
  Tr.auth.login.email: 'Email',
  Tr.auth.login.emailHint: 'you@example.com',
  Tr.auth.login.emailRequired: 'Please enter your email',
  Tr.auth.login.emailInvalid: 'Invalid email address format',
  Tr.auth.login.password: 'Password',
  Tr.auth.login.passwordRequired: 'Please enter your password',
  Tr.auth.login.submit: 'Sign in',
  Tr.auth.login.unauthorizedRole:
      'You do not have permission to access this area',
  Tr.auth.login.invalidCredentials: 'Incorrect email or password',

  // Client login
  Tr.auth.clientLogin.subtitle: 'Client Space',
  Tr.auth.clientLogin.forgotPassword: 'Forgot password?',
  Tr.auth.clientLogin.createAccount: 'Create account',

  // Client register
  Tr.auth.clientRegister.title: 'Create account',
  Tr.auth.clientRegister.confirmPassword: 'Confirm password',
  Tr.auth.clientRegister.confirmPasswordRequired:
      'Please confirm your password',
  Tr.auth.clientRegister.passwordMismatch: 'Passwords do not match',
  Tr.auth.clientRegister.submit: 'Create my account',
  Tr.auth.clientRegister.success:
      'Check your inbox to confirm your email address.',
  Tr.auth.clientRegister.emailAlreadyInUse:
      'This email address is already in use',
  Tr.auth.clientRegister.invalidLink:
      'Invalid invitation link. Please use the link provided by your studio.',
  Tr.auth.clientRegister.haveAccount: 'Already have an account? Sign in',

  // Forgot password
  Tr.auth.forgotPassword.title: 'Reset password',
  Tr.auth.forgotPassword.subtitle: 'Enter your email to receive a reset link.',
  Tr.auth.forgotPassword.submit: 'Send reset link',
  Tr.auth.forgotPassword.success: 'A password reset email has been sent.',
  Tr.auth.forgotPassword.backToLogin: 'Back to login',

  // Client home
  Tr.auth.clientHome.title: 'Client Space',
  Tr.auth.clientHome.welcome: 'Welcome, @email',
  Tr.auth.clientHome.logout: 'Sign out',

  // Login page (new)
  Tr.auth.login.tagline: 'Your studio\nbecomes ',
  Tr.auth.login.taglineHighlight: 'intelligent',
  Tr.auth.login.feature1: 'Simplified online booking',
  Tr.auth.login.feature2: 'Secure private galleries',
  Tr.auth.login.feature3: 'Automated invoicing',
  Tr.auth.login.feature4: 'Built-in artificial intelligence',
  Tr.auth.login.rememberMe: 'Remember me',
  Tr.auth.login.forgotPassword: 'Forgot password?',
  Tr.auth.login.roleClient: 'Client',
  Tr.auth.login.rolePhotographer: 'Photographer',
  Tr.auth.login.titleClient: 'Client Login',
  Tr.auth.login.subtitleClient: 'Access your galleries, bookings and orders.',
  Tr.auth.login.titlePhotographer: 'Photographer Space',
  Tr.auth.login.subtitlePhotographer: 'Manage your studio with ease',
  Tr.auth.login.submitPhotographer: 'Access my space',
  Tr.auth.login.photographerCode: 'Photographer code',
  Tr.auth.login.photographerCodeHint: 'E.g.: STUDIO-XXXX',
  Tr.auth.login.footerNoAccount: 'Don\'t have an account?',
  Tr.auth.login.footerCreateAccount: 'Create a client account',
  Tr.auth.login.footerCreateAccountPhotographer:
      'Create a professional account',
  Tr.auth.login.brandSubtitle: 'Platform for professional photographers',

  // Client left panel
  Tr.auth.login.clientTagline: 'Your photo\nspace, ',
  Tr.auth.login.clientTaglineHighlight: 'personalized',
  Tr.auth.login.clientSubtitle:
      'Book sessions, browse your galleries and manage your orders — simply.',
  Tr.auth.login.clientFeature1: 'Online session booking',
  Tr.auth.login.clientFeature2: 'Private high-resolution galleries',
  Tr.auth.login.clientFeature3: 'Real-time order tracking',
  Tr.auth.login.clientFeature4: 'Secure photo sharing',

  // Auth — Register form
  Tr.auth.register.titleClient: 'Create a client account',
  Tr.auth.register.titlePhotographer: 'Create a photographer account',
  Tr.auth.register.subtitleClient: 'Access your galleries and bookings.',
  Tr.auth.register.subtitlePhotographer: 'Start managing your business.',
  Tr.auth.register.footerHaveAccount: 'Already have an account?',
  Tr.auth.register.footerSignIn: 'Sign in',
  Tr.auth.register.success: 'Check your inbox to confirm your email address.',

  // Auth — Error messages
  Tr.auth.error.invalidEmail: 'Invalid email address format',
  Tr.auth.error.passwordTooShort: 'Password must be at least 6 characters',
  Tr.auth.error.rateLimited:
      'Too many attempts. Please wait before trying again.',
  Tr.auth.error.network: 'Connection error. Check your internet connection.',
  Tr.auth.error.generic: 'An error occurred. Please try again.',

  // Auth — Forgot password form
  Tr.auth.forgot.title: 'Forgot password',
  Tr.auth.forgot.titlePhotographer: 'Reset studio access',
  Tr.auth.forgot.subtitle: 'Enter your email address to receive a reset link.',
  Tr.auth.forgot.subtitlePhotographer:
      'Enter the email associated with your professional account.',
  Tr.auth.forgot.submit: 'Send reset link',
  Tr.auth.forgot.success: 'A password reset email has been sent.',
  Tr.auth.forgot.backToLogin: 'Back to login',

  // Registration wizard
  Tr.auth.register.stepPersonal: 'Personal information',
  Tr.auth.register.stepBusiness: 'Business information',
  Tr.auth.register.stepSecurity: 'Account security',
  Tr.auth.register.stepConfirmation: 'Confirmation',
  Tr.auth.register.stepPersonalDesc: 'Your details',
  Tr.auth.register.stepBusinessDesc: 'Your studio',
  Tr.auth.register.stepSecurityDesc: 'Protect your account',
  Tr.auth.register.stepConfirmationDesc: 'Review and confirm',
  Tr.auth.register.fieldFirstName: 'First name',
  Tr.auth.register.fieldLastName: 'Last name',
  Tr.auth.register.fieldPhone: 'Phone',
  Tr.auth.register.fieldStreet: 'Street',
  Tr.auth.register.fieldPostalCode: 'Postal code',
  Tr.auth.register.fieldCity: 'City',
  Tr.auth.register.fieldStudioName: 'Studio name',
  Tr.auth.register.fieldCompanyName: 'Company name',
  Tr.auth.register.fieldSiret: 'SIRET',
  Tr.auth.register.fieldLegalForm: 'Legal form',
  Tr.auth.register.fieldVatNumber: 'VAT number',
  Tr.auth.register.fieldBizStreet: 'Business address',
  Tr.auth.register.fieldBizPostalCode: 'Business postal code',
  Tr.auth.register.fieldCountry: 'Country',
  Tr.auth.register.fieldBizCountry: 'Country',
  Tr.auth.register.fieldBizCity: 'Business city',
  Tr.auth.register.fieldAcquisitionSource: 'How did you hear about us?',
  Tr.auth.register.fieldNotes: 'Notes',
  Tr.auth.register.fieldInvitationCode: 'Invitation code',
  Tr.auth.register.fieldInvitationCodeHint: 'E.g.: my-studio',
  Tr.auth.register.fieldInvitationCodeRequired:
      'The invitation code is required',
  Tr.auth.register.fieldCompany: 'Company',
  Tr.auth.register.fieldRequired: 'This field is required',
  Tr.auth.register.consentCgu: 'I accept the T&C and the privacy policy',
  Tr.auth.register.consentCguPrefix: 'I accept the ',
  Tr.auth.register.consentCguLink: 'T&C',
  Tr.auth.register.consentCguMiddle: ' and the ',
  Tr.auth.register.consentPrivacyLink: 'privacy policy',
  Tr.auth.register.consentCguRequired:
      'You must accept the terms and conditions to continue',
  Tr.auth.register.consentMarketing:
      'I agree to receive marketing communications',
  Tr.auth.register.btnContinue: 'Continue',
  Tr.auth.register.btnBack: 'Back',
  Tr.auth.register.btnSubmit: 'Create my account',
  Tr.auth.register.summaryTitle: 'Summary',
  Tr.auth.register.summaryIdentity: 'Identity',
  Tr.auth.register.summaryContact: 'Contact',
  Tr.auth.register.summaryAddress: 'Address',
  Tr.auth.register.summaryBusiness: 'Business',
  Tr.auth.register.leftTaglineClient: 'Join the\n',
  Tr.auth.register.leftTaglineClientHighlight: 'Déclia experience',
  Tr.auth.register.leftTaglinePhotographer: 'Create\nyour ',
  Tr.auth.register.leftTaglinePhotographerHighlight: 'studio',
  Tr.auth.register.leftSubtitleClient:
      'Create your personal space to access your galleries and bookings.',
  Tr.auth.register.leftSubtitlePhotographer:
      'Set up your professional space and start managing your clients.',
  Tr.auth.register.sectionIdentity: 'Identity',
  Tr.auth.register.sectionStudio: 'Studio',
  Tr.auth.register.sectionPreferences: 'Preferences',
  Tr.auth.register.avatarTitle: 'Profile picture',
  Tr.auth.register.avatarHint: 'JPG or PNG, max 2 MB (optional)',
  Tr.auth.register.sectionAddress: 'Address',
  Tr.auth.register.sectionBizAddress: 'Business address',
  Tr.auth.register.stepStudio: 'Studio information',
  Tr.auth.register.stepStudioDesc: 'Your business',
  Tr.auth.register.avatarComingSoon: 'Photo upload will be available soon',
  Tr.auth.register.passwordHint:
      'Min. 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character',
  Tr.auth.register.passwordTooWeak: 'Password too weak',
  Tr.auth.register.vatInvalid: 'Invalid VAT number',
};
