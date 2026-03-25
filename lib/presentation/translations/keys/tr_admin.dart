class TrAdminScope {
  const TrAdminScope();
  TrAdminBrand get brand => const TrAdminBrand();
  TrAdminSection get section => const TrAdminSection();
  TrAdminSidebar get sidebar => const TrAdminSidebar();
  TrAdminTopbar get topbar => const TrAdminTopbar();
  TrAdminPlaceholder get placeholder => const TrAdminPlaceholder();
  TrAdminBadge get badge => const TrAdminBadge();
  TrAdminDashboard get dashboard => const TrAdminDashboard();
  TrAdminClients get clients => const TrAdminClients();
  TrAdminClientForm get clientForm => const TrAdminClientForm();
  TrAdminClientDetail get clientDetail => const TrAdminClientDetail();
  TrAdminHistory get history => const TrAdminHistory();
  TrAdminPlanning get planning => const TrAdminPlanning();
  TrAdminAvailability get availability => const TrAdminAvailability();
  TrAdminSettings get settings => const TrAdminSettings();
}

class TrAdminBrand {
  const TrAdminBrand();
  String get subtitle => 'adminBrandSubtitle';
}

class TrAdminSection {
  const TrAdminSection();
  String get general => 'adminSectionGeneral';
  String get management => 'adminSectionManagement';
  String get principal => 'adminSectionPrincipal';
  String get commerce => 'adminSectionCommerce';
  String get outils => 'adminSectionOutils';
}

class TrAdminSidebar {
  const TrAdminSidebar();
  String get dashboard => 'adminSidebarDashboard';
  String get clients => 'adminSidebarClients';
  String get planning => 'adminSidebarPlanning';
  String get galleries => 'adminSidebarGalleries';
  String get shop => 'adminSidebarShop';
  String get invoicing => 'adminSidebarInvoicing';
  String get statistics => 'adminSidebarStatistics';
  String get settings => 'adminSidebarSettings';
  String get orders => 'adminSidebarOrders';
  String get giftCards => 'adminSidebarGiftCards';
  String get promotions => 'adminSidebarPromotions';
  String get tasks => 'adminSidebarTasks';
}

class TrAdminTopbar {
  const TrAdminTopbar();
  String get logout => 'adminTopbarLogout';
}

class TrAdminPlaceholder {
  const TrAdminPlaceholder();
  String get comingSoon => 'adminPlaceholderComingSoon';
}

class TrAdminBadge {
  const TrAdminBadge();
  String get beta => 'adminBadgeBeta';
}

class TrAdminDashboard {
  const TrAdminDashboard();
  String get title => 'dashboardTitle';
  String get logout => 'dashboardLogout';
  String get welcome => 'dashboardWelcome';
  String get welcomeGreeting => 'dashboardWelcomeGreeting';
  String get welcomeSubtitle => 'dashboardWelcomeSubtitle';
  String get statRevenue => 'dashboardStatRevenue';
  String get statSessions => 'dashboardStatSessions';
  String get statClients => 'dashboardStatClients';
  String get statOrders => 'dashboardStatOrders';
  String get upcomingSessions => 'dashboardUpcomingSessions';
  String get recentActivity => 'dashboardRecentActivity';
  String get quickActions => 'dashboardQuickActions';
  String get seeAll => 'dashboardSeeAll';
  String get newSession => 'dashboardNewSession';
  String get createGallery => 'dashboardCreateGallery';
  String get newClient => 'dashboardNewClient';
  String get newInvoice => 'dashboardNewInvoice';
}

class TrAdminClients {
  const TrAdminClients();
  String get title => 'adminClientsTitle';
  String get add => 'adminClientsNew';
  String get search => 'adminClientsSearch';
  String get empty => 'adminClientsEmpty';
  String get tableName => 'adminClientsTableName';
  String get tableEmail => 'adminClientsTableEmail';
  String get tablePhone => 'adminClientsTablePhone';
  String get tableTags => 'adminClientsTableTags';
  String get tableDate => 'adminClientsTableDate';
  String get tableActions => 'adminClientsTableActions';
  String get deleteConfirm => 'adminClientsDeleteConfirm';
  String get deleteBody => 'adminClientsDeleteBody';
  String get deleteSuccess => 'adminClientsDeleteSuccess';
  String get filterByTag => 'adminClientsFilterByTag';
  String get filterBySource => 'adminClientsFilterBySource';
  String get filterTagHint => 'adminClientsFilterTagHint';
  String get sortBy => 'adminClientsSortBy';
  String get sortName => 'adminClientsSortName';
  String get sortDate => 'adminClientsSortDate';
  String get count => 'adminClientsCount';
  String get clearFilters => 'adminClientsClearFilters';
  String get tableSessions => 'adminClientsTableSessions';
  String get tableTotalSpent => 'adminClientsTableTotalSpent';
  String get tableLastShooting => 'adminClientsTableLastShooting';
  String get paginationInfo => 'adminClientsPaginationInfo';
  String get allSources => 'adminClientsAllSources';
  String get totalClients => 'adminClientsTotalClients';
  String get active => 'adminClientsActive';
  String get statNew => 'adminClientsStatNew';
  String get avgRevenue => 'adminClientsAvgRevenue';
  String get tableStatus => 'adminClientsTableStatus';
  String get allStatuses => 'adminClientsAllStatuses';
  String get allCategories => 'adminClientsAllCategories';
  String get tableCategory => 'adminClientsTableCategory';
  String get tableRevenue => 'adminClientsTableRevenue';
  String get export => 'adminClientsExport';
  String get tableClient => 'adminClientsTableClient';
  String get activeClients => 'adminClientsActiveClients';
  String get vipClients => 'adminClientsVipClients';
  String get avgRevenuePerClient => 'adminClientsAvgRevenuePerClient';
  String get trendPercentOfTotal => 'adminClientsTrendPercentOfTotal';
}

class TrAdminClientForm {
  const TrAdminClientForm();
  String get company => 'adminClientFormCompany';
  String get titleCreate => 'adminClientFormTitleCreate';
  String get titleEdit => 'adminClientFormTitleEdit';
  String get sectionIdentity => 'adminClientFormSectionIdentity';
  String get firstName => 'adminClientFormFirstName';
  String get lastName => 'adminClientFormLastName';
  String get email => 'adminClientFormEmail';
  String get phone => 'adminClientFormPhone';
  String get dob => 'adminClientFormDob';
  String get sectionAddress => 'adminClientFormSectionAddress';
  String get street => 'adminClientFormStreet';
  String get city => 'adminClientFormCity';
  String get postalCode => 'adminClientFormPostalCode';
  String get country => 'adminClientFormCountry';
  String get sectionCrm => 'adminClientFormSectionCrm';
  String get acquisitionSource => 'adminClientFormAcquisitionSource';
  String get tags => 'adminClientFormTags';
  String get notes => 'adminClientFormNotes';
  String get sectionGdpr => 'adminClientFormSectionGdpr';
  String get gdprConsentDate => 'adminClientFormGdprConsentDate';
  String get gdprEmail => 'adminClientFormGdprEmail';
  String get gdprSms => 'adminClientFormGdprSms';
  String get gdprPhone => 'adminClientFormGdprPhone';
  String get save => 'adminClientFormSave';
  String get cancel => 'adminClientFormCancel';
  String get success => 'adminClientFormSuccess';
  String get error => 'adminClientFormError';
  String get firstNameRequired => 'adminClientFormFirstNameRequired';
  String get lastNameRequired => 'adminClientFormLastNameRequired';
}

class TrAdminClientDetail {
  const TrAdminClientDetail();
  String get edit => 'adminClientDetailEdit';
  String get delete => 'adminClientDetailDelete';
  String get view => 'adminClientDetailView';
  String get message => 'adminClientDetailMessage';
  String get noEmail => 'adminClientDetailNoEmail';
  String get noPhone => 'adminClientDetailNoPhone';
  String get noAddress => 'adminClientDetailNoAddress';
  String get noNotes => 'adminClientDetailNoNotes';
}

class TrAdminHistory {
  const TrAdminHistory();
  String get statSessions => 'adminHistoryStatSessions';
  String get statTotalSpent => 'adminHistoryStatTotalSpent';
  String get statLastShooting => 'adminHistoryStatLastShooting';
  String get sessions => 'adminHistorySessions';
  String get sessionsEmpty => 'adminHistorySessionsEmpty';
  String get galleries => 'adminHistoryGalleries';
  String get galleriesEmpty => 'adminHistoryGalleriesEmpty';
  String get orders => 'adminHistoryOrders';
  String get ordersEmpty => 'adminHistoryOrdersEmpty';
  String get communications => 'adminHistoryCommunications';
  String get communicationsEmpty => 'adminHistoryCommunicationsEmpty';
  String get photos => 'adminHistoryPhotos';
  String get colDate => 'adminHistoryColDate';
  String get colType => 'adminHistoryColType';
  String get colLocation => 'adminHistoryColLocation';
  String get colStatus => 'adminHistoryColStatus';
  String get colPayment => 'adminHistoryColPayment';
  String get colAmount => 'adminHistoryColAmount';
}

class TrAdminPlanning {
  const TrAdminPlanning();
  String get title => 'adminPlanningTitle';
  String get viewDay => 'adminPlanningViewDay';
  String get viewWeek => 'adminPlanningViewWeek';
  String get viewMonth => 'adminPlanningViewMonth';
  String get today => 'adminPlanningToday';
  String get noSessions => 'adminPlanningNoSessions';
  String get sessionDetail => 'adminPlanningSessionDetail';
  String get viewClient => 'adminPlanningViewClient';
  String get duration => 'adminPlanningDuration';
  String get monday => 'adminPlanningMonday';
  String get tuesday => 'adminPlanningTuesday';
  String get wednesday => 'adminPlanningWednesday';
  String get thursday => 'adminPlanningThursday';
  String get friday => 'adminPlanningFriday';
  String get saturday => 'adminPlanningSaturday';
  String get sunday => 'adminPlanningSunday';
  String get externalEvent => 'adminPlanningExternalEvent';
  String get externalSource => 'adminPlanningExternalSource';
  String get tabCalendar => 'planningTabCalendar';
  String get tabEditor => 'planningTabEditor';
  String get editorIntro => 'planningEditorIntro';
  String get quickFillWeek => 'planningQuickFillWeek';
  String get quickFillMorning => 'planningQuickFillMorning';
  String get quickFillAfternoon => 'planningQuickFillAfternoon';
  String get quickFillClear => 'planningQuickFillClear';
  String get editorSave => 'planningEditorSave';
  String get editorCancel => 'planningEditorCancel';
  String get legendAvailable => 'planningLegendAvailable';
  String get legendBlocked => 'planningLegendBlocked';
  String get editorClearConfirm => 'planningEditorClearConfirm';
}

class TrAdminAvailability {
  const TrAdminAvailability();
  String get toggle => 'adminAvailabilityToggle';
  String get manage => 'adminAvailabilityManage';
  String get title => 'adminAvailabilityTitle';
  String get recurring => 'adminAvailabilityRecurring';
  String get override => 'adminAvailabilityOverride';
  String get blocked => 'adminAvailabilityBlocked';
  String get dayOfWeek => 'adminAvailabilityDayOfWeek';
  String get date => 'adminAvailabilityDate';
  String get startTime => 'adminAvailabilityStartTime';
  String get endTime => 'adminAvailabilityEndTime';
  String get label => 'adminAvailabilityLabel';
  String get save => 'adminAvailabilitySave';
  String get delete => 'adminAvailabilityDelete';
  String get deleteConfirm => 'adminAvailabilityDeleteConfirm';
  String get empty => 'adminAvailabilityEmpty';
  String get addRule => 'adminAvailabilityAddRule';
  String get editRule => 'adminAvailabilityEditRule';
  String get noSlots => 'adminAvailabilityNoSlots';
}

class TrAdminSettings {
  const TrAdminSettings();
  TrAdminSettingsGoogleCalendar get googleCalendar =>
      const TrAdminSettingsGoogleCalendar();
  TrAdminSettingsSection get section => const TrAdminSettingsSection();
  String get placeholder => 'settingsPlaceholder';
}

class TrAdminSettingsGoogleCalendar {
  const TrAdminSettingsGoogleCalendar();
  String get title => 'settingsGoogleCalendarTitle';
  String get desc => 'settingsGoogleCalendarDesc';
  String get connect => 'settingsGoogleCalendarConnect';
  String get disconnect => 'settingsGoogleCalendarDisconnect';
  String get disconnectConfirm => 'settingsGoogleCalendarDisconnectConfirm';
  String get connected => 'settingsGoogleCalendarConnected';
  String get disconnected => 'settingsGoogleCalendarDisconnected';
  String get id => 'settingsGoogleCalendarId';
  String get lastSync => 'settingsGoogleCalendarLastSync';
  String get syncNow => 'settingsGoogleCalendarSyncNow';
  String get syncing => 'settingsGoogleCalendarSyncing';
  String get syncEnabled => 'settingsGoogleCalendarSyncEnabled';
  String get error => 'settingsGoogleCalendarError';
  String get authCode => 'settingsGoogleCalendarAuthCode';
  String get authCodeHint => 'settingsGoogleCalendarAuthCodeHint';
}

class TrAdminSettingsSection {
  const TrAdminSettingsSection();
  String get studio => 'settingsSectionStudio';
  String get legal => 'settingsSectionLegal';
  String get colors => 'settingsSectionColors';
  String get typography => 'settingsSectionTypography';
  String get integrations => 'settingsSectionIntegrations';
  String get myStudio => 'settingsSectionMyStudio';
  String get identity => 'settingsSectionIdentity';
  String get connections => 'settingsSectionConnections';
}
