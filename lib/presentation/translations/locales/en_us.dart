import '../translation_keys.dart';

final Map<String, String> enUs = {
  Tr.appName: 'Déclia',

  // Login
  Tr.loginSubtitle: 'Photographer Space',
  Tr.loginEmail: 'Email',
  Tr.loginEmailHint: 'your@email.com',
  Tr.loginEmailRequired: 'Please enter your email',
  Tr.loginPassword: 'Password',
  Tr.loginPasswordRequired: 'Please enter your password',
  Tr.loginSubmit: 'Sign in',
  Tr.loginUnauthorizedRole: 'You do not have permission to access this area',
  Tr.loginInvalidCredentials: 'Incorrect email or password',

  // Dashboard
  Tr.dashboardTitle: 'Dashboard',
  Tr.dashboardLogout: 'Sign out',
  Tr.dashboardWelcome: 'Welcome, @email',

  // Client login
  Tr.clientLoginSubtitle: 'Client Space',
  Tr.clientLoginForgotPassword: 'Forgot password?',
  Tr.clientLoginCreateAccount: 'Create account',

  // Client register
  Tr.clientRegisterTitle: 'Create account',
  Tr.clientRegisterConfirmPassword: 'Confirm password',
  Tr.clientRegisterConfirmPasswordRequired: 'Please confirm your password',
  Tr.clientRegisterPasswordMismatch: 'Passwords do not match',
  Tr.clientRegisterSubmit: 'Create my account',
  Tr.clientRegisterSuccess: 'Check your inbox to confirm your email address.',
  Tr.clientRegisterEmailAlreadyInUse: 'This email address is already in use',
  Tr.clientRegisterInvalidLink: 'Invalid invitation link. Please use the link provided by your studio.',
  Tr.clientRegisterHaveAccount: 'Already have an account? Sign in',

  // Forgot password
  Tr.clientForgotPasswordTitle: 'Reset password',
  Tr.clientForgotPasswordSubtitle: 'Enter your email to receive a reset link.',
  Tr.clientForgotPasswordSubmit: 'Send reset link',
  Tr.clientForgotPasswordSuccess: 'A password reset email has been sent.',
  Tr.clientForgotPasswordBackToLogin: 'Back to login',

  // Client home
  Tr.clientHomeTitle: 'Client Space',
  Tr.clientHomeWelcome: 'Welcome, @email',
  Tr.clientHomeLogout: 'Sign out',

  // Admin shell
  Tr.adminBrandSubtitle: 'ADMINISTRATION',
  Tr.adminSectionGeneral: 'GENERAL',
  Tr.adminSectionManagement: 'MANAGEMENT',
  Tr.adminSidebarDashboard: 'Dashboard',
  Tr.adminSidebarClients: 'Clients',
  Tr.adminSidebarPlanning: 'Planning',
  Tr.adminSidebarGalleries: 'Galleries',
  Tr.adminSidebarShop: 'Shop',
  Tr.adminSidebarInvoicing: 'Invoicing',
  Tr.adminSidebarStatistics: 'Statistics',
  Tr.adminSidebarSettings: 'Settings',
  Tr.adminTopbarLogout: 'Sign out',
  Tr.adminPlaceholderComingSoon: 'Coming soon',

  // Cookie banner
  Tr.cookieBannerTitle: 'Cookie settings',
  Tr.cookieBannerDescription:
      'We use cookies to improve your experience. You can accept, refuse, or customize your preferences.',
  Tr.cookieBannerAcceptAll: 'Accept all',
  Tr.cookieBannerRefuseAll: 'Refuse all',
  Tr.cookieBannerCustomize: 'Customize',
  Tr.cookieBannerSavePreferences: 'Save preferences',
  Tr.cookieBannerAnalytics: 'Analytics cookies',
  Tr.cookieBannerMarketing: 'Marketing cookies',
  Tr.cookieBannerFunctional: 'Functional cookies',
  Tr.cookieBannerPrivacyPolicy: 'Privacy policy',

  // Legal pages
  Tr.legalPrivacyTitle: 'Privacy policy',
  Tr.legalPrivacyContent: 'This page content will be available soon.',
  Tr.legalNoticesTitle: 'Legal notices',
  Tr.legalNoticesContent: 'This page content will be available soon.',

  // Clients list
  Tr.adminClientsTitle: 'Clients',
  Tr.adminClientsNew: 'New client',
  Tr.adminClientsSearch: 'Search a client...',
  Tr.adminClientsEmpty: 'No clients found',
  Tr.adminClientsTableName: 'Name',
  Tr.adminClientsTableEmail: 'Email',
  Tr.adminClientsTablePhone: 'Phone',
  Tr.adminClientsTableTags: 'Tags',
  Tr.adminClientsTableDate: 'Added',
  Tr.adminClientsTableActions: 'Actions',
  Tr.adminClientsDeleteConfirm: 'Delete this client?',
  Tr.adminClientsDeleteBody: 'This action is irreversible.',
  Tr.adminClientsDeleteSuccess: 'Client deleted',

  // Client form
  Tr.adminClientFormTitleCreate: 'New client',
  Tr.adminClientFormTitleEdit: 'Edit client',
  Tr.adminClientFormSectionIdentity: 'Identity',
  Tr.adminClientFormFirstName: 'First name',
  Tr.adminClientFormLastName: 'Last name',
  Tr.adminClientFormEmail: 'Email',
  Tr.adminClientFormPhone: 'Phone',
  Tr.adminClientFormDob: 'Date of birth',
  Tr.adminClientFormSectionAddress: 'Address',
  Tr.adminClientFormStreet: 'Street',
  Tr.adminClientFormCity: 'City',
  Tr.adminClientFormPostalCode: 'Postal code',
  Tr.adminClientFormCountry: 'Country',
  Tr.adminClientFormSectionCrm: 'CRM',
  Tr.adminClientFormAcquisitionSource: 'Acquisition source',
  Tr.adminClientFormTags: 'Tags',
  Tr.adminClientFormNotes: 'Notes',
  Tr.adminClientFormSectionGdpr: 'GDPR & Communications',
  Tr.adminClientFormGdprConsentDate: 'Consent date',
  Tr.adminClientFormGdprEmail: 'Email',
  Tr.adminClientFormGdprSms: 'SMS',
  Tr.adminClientFormGdprPhone: 'Phone',
  Tr.adminClientFormSave: 'Save',
  Tr.adminClientFormCancel: 'Cancel',
  Tr.adminClientFormSuccess: 'Client saved',
  Tr.adminClientFormError: 'Error saving client',
  Tr.adminClientFormFirstNameRequired: 'Please enter the first name',
  Tr.adminClientFormLastNameRequired: 'Please enter the last name',

  // Client detail
  Tr.adminClientDetailEdit: 'Edit',
  Tr.adminClientDetailDelete: 'Delete',
  Tr.adminClientDetailNoEmail: 'No email provided',
  Tr.adminClientDetailNoPhone: 'No phone provided',
  Tr.adminClientDetailNoAddress: 'No address provided',
  Tr.adminClientDetailNoNotes: 'No notes',

  // Acquisition source labels
  Tr.acquisitionSourceReferral: 'Referral',
  Tr.acquisitionSourceSocialMedia: 'Social media',
  Tr.acquisitionSourceWebsite: 'Website',
  Tr.acquisitionSourceWordOfMouth: 'Word of mouth',
  Tr.acquisitionSourceEvent: 'Event',
  Tr.acquisitionSourceOther: 'Other',
};
