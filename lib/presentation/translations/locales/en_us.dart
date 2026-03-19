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
  Tr.clientRegisterInvalidLink:
      'Invalid invitation link. Please use the link provided by your studio.',
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
  Tr.adminClientsFilterByTag: 'Tags',
  Tr.adminClientsFilterBySource: 'Source',
  Tr.adminClientsFilterTagHint: 'Add a tag...',
  Tr.adminClientsSortBy: 'Sort by',
  Tr.adminClientsSortName: 'Name',
  Tr.adminClientsSortDate: 'Date added',
  Tr.adminClientsCount: '@count clients',
  Tr.adminClientsClearFilters: 'Clear filters',
  Tr.adminClientsTableSessions: 'Sessions',
  Tr.adminClientsTableTotalSpent: 'Total spent',
  Tr.adminClientsTableLastShooting: 'Last shooting',
  Tr.adminClientsPaginationInfo: 'Page @page of @total',
  Tr.adminClientsAllSources: 'All sources',

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
  Tr.adminClientDetailView: 'View',
  Tr.adminClientDetailNoEmail: 'No email provided',
  Tr.adminClientDetailNoPhone: 'No phone provided',
  Tr.adminClientDetailNoAddress: 'No address provided',
  Tr.adminClientDetailNoNotes: 'No notes',

  // Client history
  Tr.adminHistoryStatSessions: 'Sessions',
  Tr.adminHistoryStatTotalSpent: 'Total spent',
  Tr.adminHistoryStatLastShooting: 'Last shooting',
  Tr.adminHistorySessions: 'Sessions',
  Tr.adminHistorySessionsEmpty: 'No sessions',
  Tr.adminHistoryGalleries: 'Galleries',
  Tr.adminHistoryGalleriesEmpty: 'No galleries',
  Tr.adminHistoryOrders: 'Orders',
  Tr.adminHistoryOrdersEmpty: 'No orders',
  Tr.adminHistoryCommunications: 'Communications',
  Tr.adminHistoryCommunicationsEmpty: 'No communications',
  Tr.adminHistoryPhotos: 'photos',
  Tr.adminHistoryColDate: 'Date',
  Tr.adminHistoryColType: 'Type',
  Tr.adminHistoryColLocation: 'Location',
  Tr.adminHistoryColStatus: 'Status',
  Tr.adminHistoryColPayment: 'Payment',
  Tr.adminHistoryColAmount: 'Amount',

  // Session type labels
  Tr.sessionTypeFamily: 'Family',
  Tr.sessionTypeEquestrian: 'Equestrian',
  Tr.sessionTypeEvent: 'Event',
  Tr.sessionTypeMaternity: 'Maternity',
  Tr.sessionTypeSchool: 'School',
  Tr.sessionTypePortrait: 'Portrait',
  Tr.sessionTypeMiniSession: 'Mini session',
  Tr.sessionTypeOther: 'Other',

  // Session status labels
  Tr.sessionStatusScheduled: 'Scheduled',
  Tr.sessionStatusConfirmed: 'Confirmed',
  Tr.sessionStatusCompleted: 'Completed',
  Tr.sessionStatusCancelled: 'Cancelled',
  Tr.sessionStatusNoShow: 'No show',

  // Payment status labels
  Tr.paymentStatusPending: 'Pending',
  Tr.paymentStatusPartial: 'Partial',
  Tr.paymentStatusPaid: 'Paid',
  Tr.paymentStatusRefunded: 'Refunded',

  // Gallery status labels
  Tr.galleryStatusDraft: 'Draft',
  Tr.galleryStatusPublished: 'Published',
  Tr.galleryStatusArchived: 'Archived',
  Tr.galleryStatusExpired: 'Expired',

  // Order status labels
  Tr.orderStatusPending: 'Pending',
  Tr.orderStatusProcessing: 'Processing',
  Tr.orderStatusShipped: 'Shipped',
  Tr.orderStatusDelivered: 'Delivered',
  Tr.orderStatusCancelled: 'Cancelled',
  Tr.orderStatusRefunded: 'Refunded',

  // Communication channel labels
  Tr.commChannelEmail: 'Email',
  Tr.commChannelSms: 'SMS',

  // Communication status labels
  Tr.commStatusQueued: 'Queued',
  Tr.commStatusSent: 'Sent',
  Tr.commStatusDelivered: 'Delivered',
  Tr.commStatusFailed: 'Failed',
  Tr.commStatusBounced: 'Bounced',

  // Planning calendar
  Tr.adminPlanningTitle: 'Planning',
  Tr.adminPlanningViewDay: 'Day',
  Tr.adminPlanningViewWeek: 'Week',
  Tr.adminPlanningViewMonth: 'Month',
  Tr.adminPlanningToday: 'Today',
  Tr.adminPlanningNoSessions: 'No sessions',
  Tr.adminPlanningSessionDetail: 'Session detail',
  Tr.adminPlanningViewClient: 'View client',
  Tr.adminPlanningMonday: 'Mon',
  Tr.adminPlanningTuesday: 'Tue',
  Tr.adminPlanningWednesday: 'Wed',
  Tr.adminPlanningThursday: 'Thu',
  Tr.adminPlanningFriday: 'Fri',
  Tr.adminPlanningSaturday: 'Sat',
  Tr.adminPlanningSunday: 'Sun',

  // Availability management
  Tr.adminAvailabilityToggle: 'Availability',
  Tr.adminAvailabilityManage: 'Manage availability',
  Tr.adminAvailabilityTitle: 'Availability rules',
  Tr.adminAvailabilityRecurring: 'Recurring',
  Tr.adminAvailabilityOverride: 'One-time override',
  Tr.adminAvailabilityBlocked: 'Blocked day',
  Tr.adminAvailabilityDayOfWeek: 'Day of week',
  Tr.adminAvailabilityDate: 'Date',
  Tr.adminAvailabilityStartTime: 'Start time',
  Tr.adminAvailabilityEndTime: 'End time',
  Tr.adminAvailabilityLabel: 'Label (optional)',
  Tr.adminAvailabilitySave: 'Save',
  Tr.adminAvailabilityDelete: 'Delete',
  Tr.adminAvailabilityDeleteConfirm: 'Delete this rule?',
  Tr.adminAvailabilityEmpty: 'No availability rules defined',
  Tr.adminAvailabilityAddRule: 'Add rule',
  Tr.adminAvailabilityEditRule: 'Edit rule',
  Tr.adminAvailabilityNoSlots: 'No available slots',

  // Settings — Google Calendar
  Tr.settingsGoogleCalendarTitle: 'Google Calendar',
  Tr.settingsGoogleCalendarDesc:
      'Sync your sessions with Google Calendar to manage your schedule in one place.',
  Tr.settingsGoogleCalendarConnect: 'Connect Google Calendar',
  Tr.settingsGoogleCalendarDisconnect: 'Disconnect',
  Tr.settingsGoogleCalendarDisconnectConfirm:
      'Disconnect Google Calendar? Your Déclia data will be preserved.',
  Tr.settingsGoogleCalendarConnected: 'Connected',
  Tr.settingsGoogleCalendarDisconnected: 'Not connected',
  Tr.settingsGoogleCalendarId: 'Calendar',
  Tr.settingsGoogleCalendarLastSync: 'Last sync',
  Tr.settingsGoogleCalendarSyncNow: 'Sync now',
  Tr.settingsGoogleCalendarSyncing: 'Syncing…',
  Tr.settingsGoogleCalendarSyncEnabled: 'Auto-sync',
  Tr.settingsGoogleCalendarError: 'Sync error',
  Tr.settingsGoogleCalendarAuthCode:
      'Open the link below, grant access, then paste the authorization code.',
  Tr.settingsGoogleCalendarAuthCodeHint: 'Paste code here',

  // Planning — External events
  Tr.adminPlanningExternalEvent: 'Google Calendar event',
  Tr.adminPlanningExternalSource: 'Source',

  // Acquisition source labels
  Tr.acquisitionSourceReferral: 'Referral',
  Tr.acquisitionSourceSocialMedia: 'Social media',
  Tr.acquisitionSourceWebsite: 'Website',
  Tr.acquisitionSourceWordOfMouth: 'Word of mouth',
  Tr.acquisitionSourceEvent: 'Event',
  Tr.acquisitionSourceOther: 'Other',
};
