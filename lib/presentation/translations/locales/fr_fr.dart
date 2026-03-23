import '../translation_keys.dart';

final Map<String, String> frFr = {
  Tr.appName: 'Déclia',

  // Login
  Tr.loginSubtitle:
      'Gestion de clientèle, réservations, galeries et facturation — tout au même endroit.',
  Tr.loginEmail: 'Email',
  Tr.loginEmailHint: 'vous@exemple.com',
  Tr.loginEmailRequired: 'Veuillez saisir votre email',
  Tr.loginEmailInvalid: 'Format d\'adresse email invalide',
  Tr.loginPassword: 'Mot de passe',
  Tr.loginPasswordRequired: 'Veuillez saisir votre mot de passe',
  Tr.loginSubmit: 'Se connecter',
  Tr.loginUnauthorizedRole:
      'Vous n\'avez pas la permission d\'accéder à cet espace',
  Tr.loginInvalidCredentials: 'Email ou mot de passe incorrect',

  // Dashboard
  Tr.dashboardTitle: 'Tableau de bord',
  Tr.dashboardLogout: 'Se déconnecter',
  Tr.dashboardWelcome: 'Bienvenue, @email',

  // Client login
  Tr.clientLoginSubtitle: 'Espace Client',
  Tr.clientLoginForgotPassword: 'Mot de passe oublié ?',
  Tr.clientLoginCreateAccount: 'Créer un compte',

  // Client register
  Tr.clientRegisterTitle: 'Créer un compte',
  Tr.clientRegisterConfirmPassword: 'Confirmer le mot de passe',
  Tr.clientRegisterConfirmPasswordRequired:
      'Veuillez confirmer votre mot de passe',
  Tr.clientRegisterPasswordMismatch: 'Les mots de passe ne correspondent pas',
  Tr.clientRegisterSubmit: 'Créer mon compte',
  Tr.clientRegisterSuccess:
      'Vérifiez votre boîte mail pour confirmer votre adresse email.',
  Tr.clientRegisterEmailAlreadyInUse: 'Cette adresse email est déjà utilisée',
  Tr.clientRegisterInvalidLink:
      'Lien d\'invitation invalide. Veuillez utiliser le lien fourni par votre studio.',
  Tr.clientRegisterHaveAccount: 'Déjà un compte ? Se connecter',

  // Forgot password
  Tr.clientForgotPasswordTitle: 'Réinitialiser le mot de passe',
  Tr.clientForgotPasswordSubtitle:
      'Saisissez votre email pour recevoir un lien de réinitialisation.',
  Tr.clientForgotPasswordSubmit: 'Envoyer le lien',
  Tr.clientForgotPasswordSuccess: 'Un email de réinitialisation a été envoyé.',
  Tr.clientForgotPasswordBackToLogin: 'Retour à la connexion',

  // Client home
  Tr.clientHomeTitle: 'Espace Client',
  Tr.clientHomeWelcome: 'Bienvenue, @email',
  Tr.clientHomeLogout: 'Se déconnecter',

  // Admin shell
  Tr.adminBrandSubtitle: 'ADMINISTRATION',
  Tr.adminSectionGeneral: 'GÉNÉRAL',
  Tr.adminSectionManagement: 'GESTION',
  Tr.adminSidebarDashboard: 'Tableau de bord',
  Tr.adminSidebarClients: 'Clients',
  Tr.adminSidebarPlanning: 'Planning',
  Tr.adminSidebarGalleries: 'Galeries',
  Tr.adminSidebarShop: 'Boutique',
  Tr.adminSidebarInvoicing: 'Facturation',
  Tr.adminSidebarStatistics: 'Statistiques',
  Tr.adminSidebarSettings: 'Paramètres',
  Tr.adminTopbarLogout: 'Se déconnecter',
  Tr.adminPlaceholderComingSoon: 'Bientôt disponible',

  // Sidebar sections (new)
  Tr.adminSectionPrincipal: 'PRINCIPAL',
  Tr.adminSectionCommerce: 'COMMERCE',
  Tr.adminSectionOutils: 'OUTILS',

  // Sidebar items (new)
  Tr.adminSidebarOrders: 'Commandes',
  Tr.adminSidebarGiftCards: 'Cartes cadeau',
  Tr.adminSidebarPromotions: 'Promotions',
  Tr.adminSidebarTasks: 'Tâches',
  Tr.adminBadgeBeta: 'Beta',

  // Cookie banner
  Tr.cookieBannerTitle: 'Gestion des cookies',
  Tr.cookieBannerDescription:
      'Nous utilisons des cookies pour améliorer votre expérience. Vous pouvez accepter, refuser ou personnaliser vos préférences.',
  Tr.cookieBannerAcceptAll: 'Tout accepter',
  Tr.cookieBannerRefuseAll: 'Tout refuser',
  Tr.cookieBannerCustomize: 'Personnaliser',
  Tr.cookieBannerSavePreferences: 'Enregistrer mes préférences',
  Tr.cookieBannerAnalytics: 'Cookies analytiques',
  Tr.cookieBannerMarketing: 'Cookies marketing',
  Tr.cookieBannerFunctional: 'Cookies fonctionnels',
  Tr.cookieBannerPrivacyPolicy: 'Politique de confidentialité',

  // Legal pages
  Tr.legalPrivacyTitle: 'Politique de confidentialité',
  Tr.legalPrivacyContent:
      'Le contenu de cette page sera disponible prochainement.',
  Tr.legalNoticesTitle: 'Mentions légales',
  Tr.legalNoticesContent:
      'Le contenu de cette page sera disponible prochainement.',

  // Clients list
  Tr.adminClientsTitle: 'Clients',
  Tr.adminClientsNew: 'Nouveau client',
  Tr.adminClientsSearch: 'Rechercher un client...',
  Tr.adminClientsEmpty: 'Aucun client trouvé',
  Tr.adminClientsTableName: 'Nom',
  Tr.adminClientsTableEmail: 'Email',
  Tr.adminClientsTablePhone: 'Téléphone',
  Tr.adminClientsTableTags: 'Tags',
  Tr.adminClientsTableDate: "Date d'ajout",
  Tr.adminClientsTableActions: 'Actions',
  Tr.adminClientsDeleteConfirm: 'Supprimer ce client ?',
  Tr.adminClientsDeleteBody: 'Cette action est irréversible.',
  Tr.adminClientsDeleteSuccess: 'Client supprimé',
  Tr.adminClientsFilterByTag: 'Tags',
  Tr.adminClientsFilterBySource: 'Source',
  Tr.adminClientsFilterTagHint: 'Ajouter un tag...',
  Tr.adminClientsSortBy: 'Trier par',
  Tr.adminClientsSortName: 'Nom',
  Tr.adminClientsSortDate: "Date d'ajout",
  Tr.adminClientsCount: '@count clients',
  Tr.adminClientsClearFilters: 'Effacer les filtres',
  Tr.adminClientsTableSessions: 'Séances',
  Tr.adminClientsTableTotalSpent: 'Dépenses totales',
  Tr.adminClientsAllStatuses: 'Tous les statuts',
  Tr.adminClientsAllCategories: 'Toutes les catégories',
  Tr.adminClientsTableCategory: 'Catégorie',
  Tr.adminClientsTableRevenue: 'CA total',
  Tr.adminClientsExport: 'Exporter',
  Tr.adminClientsTableLastShooting: 'Dernière séance',
  Tr.adminClientsPaginationInfo: 'Page @page sur @total',
  Tr.adminClientsAllSources: 'Toutes les sources',

  // Client form
  Tr.adminClientFormCompany: 'Société',
  Tr.adminClientFormTitleCreate: 'Nouveau client',
  Tr.adminClientFormTitleEdit: 'Modifier le client',
  Tr.adminClientFormSectionIdentity: 'Identité',
  Tr.adminClientFormFirstName: 'Prénom',
  Tr.adminClientFormLastName: 'Nom',
  Tr.adminClientFormEmail: 'Email',
  Tr.adminClientFormPhone: 'Téléphone',
  Tr.adminClientFormDob: 'Date de naissance',
  Tr.adminClientFormSectionAddress: 'Adresse',
  Tr.adminClientFormStreet: 'Rue',
  Tr.adminClientFormCity: 'Ville',
  Tr.adminClientFormPostalCode: 'Code postal',
  Tr.adminClientFormCountry: 'Pays',
  Tr.adminClientFormSectionCrm: 'CRM',
  Tr.adminClientFormAcquisitionSource: "Source d'acquisition",
  Tr.adminClientFormTags: 'Tags',
  Tr.adminClientFormNotes: 'Notes',
  Tr.adminClientFormSectionGdpr: 'RGPD & Communications',
  Tr.adminClientFormGdprConsentDate: 'Date de consentement',
  Tr.adminClientFormGdprEmail: 'Email',
  Tr.adminClientFormGdprSms: 'SMS',
  Tr.adminClientFormGdprPhone: 'Téléphone',
  Tr.adminClientFormSave: 'Enregistrer',
  Tr.adminClientFormCancel: 'Annuler',
  Tr.adminClientFormSuccess: 'Client enregistré',
  Tr.adminClientFormError: "Erreur lors de l'enregistrement",
  Tr.adminClientFormFirstNameRequired: 'Veuillez saisir le prénom',
  Tr.adminClientFormLastNameRequired: 'Veuillez saisir le nom',

  // Client detail
  Tr.adminClientDetailEdit: 'Modifier',
  Tr.adminClientDetailDelete: 'Supprimer',
  Tr.adminClientDetailView: 'Voir',
  Tr.adminClientDetailNoEmail: 'Email non renseigné',
  Tr.adminClientDetailNoPhone: 'Téléphone non renseigné',
  Tr.adminClientDetailNoAddress: 'Adresse non renseignée',
  Tr.adminClientDetailNoNotes: 'Aucune note',

  // Client history
  Tr.adminHistoryStatSessions: 'Séances',
  Tr.adminHistoryStatTotalSpent: 'Dépenses totales',
  Tr.adminHistoryStatLastShooting: 'Dernière séance',
  Tr.adminHistorySessions: 'Séances',
  Tr.adminHistorySessionsEmpty: 'Aucune séance',
  Tr.adminHistoryGalleries: 'Galeries',
  Tr.adminHistoryGalleriesEmpty: 'Aucune galerie',
  Tr.adminHistoryOrders: 'Commandes',
  Tr.adminHistoryOrdersEmpty: 'Aucune commande',
  Tr.adminHistoryCommunications: 'Communications',
  Tr.adminHistoryCommunicationsEmpty: 'Aucune communication',
  Tr.adminHistoryPhotos: 'photos',
  Tr.adminHistoryColDate: 'Date',
  Tr.adminHistoryColType: 'Type',
  Tr.adminHistoryColLocation: 'Lieu',
  Tr.adminHistoryColStatus: 'Statut',
  Tr.adminHistoryColPayment: 'Paiement',
  Tr.adminHistoryColAmount: 'Montant',

  // Session type labels
  Tr.sessionTypeFamily: 'Famille',
  Tr.sessionTypeEquestrian: 'Équestre',
  Tr.sessionTypeEvent: 'Événement',
  Tr.sessionTypeMaternity: 'Maternité',
  Tr.sessionTypeSchool: 'Scolaire',
  Tr.sessionTypePortrait: 'Portrait',
  Tr.sessionTypeMiniSession: 'Mini-séance',
  Tr.sessionTypeOther: 'Autre',

  // Session status labels
  Tr.sessionStatusScheduled: 'Planifiée',
  Tr.sessionStatusConfirmed: 'Confirmée',
  Tr.sessionStatusCompleted: 'Terminée',
  Tr.sessionStatusCancelled: 'Annulée',
  Tr.sessionStatusNoShow: 'Absent',

  // Payment status labels
  Tr.paymentStatusPending: 'En attente',
  Tr.paymentStatusPartial: 'Partiel',
  Tr.paymentStatusPaid: 'Payé',
  Tr.paymentStatusRefunded: 'Remboursé',

  // Gallery status labels
  Tr.galleryStatusDraft: 'Brouillon',
  Tr.galleryStatusPublished: 'Publiée',
  Tr.galleryStatusArchived: 'Archivée',
  Tr.galleryStatusExpired: 'Expirée',

  // Order status labels
  Tr.orderStatusPending: 'En attente',
  Tr.orderStatusProcessing: 'En traitement',
  Tr.orderStatusShipped: 'Expédiée',
  Tr.orderStatusDelivered: 'Livrée',
  Tr.orderStatusCancelled: 'Annulée',
  Tr.orderStatusRefunded: 'Remboursée',

  // Communication channel labels
  Tr.commChannelEmail: 'Email',
  Tr.commChannelSms: 'SMS',

  // Communication status labels
  Tr.commStatusQueued: 'En file',
  Tr.commStatusSent: 'Envoyé',
  Tr.commStatusDelivered: 'Livré',
  Tr.commStatusFailed: 'Échec',
  Tr.commStatusBounced: 'Rebond',

  // Planning calendar
  Tr.adminPlanningTitle: 'Planning',
  Tr.adminPlanningViewDay: 'Jour',
  Tr.adminPlanningViewWeek: 'Semaine',
  Tr.adminPlanningViewMonth: 'Mois',
  Tr.adminPlanningToday: "Aujourd'hui",
  Tr.adminPlanningNoSessions: 'Aucune séance',
  Tr.adminPlanningSessionDetail: 'Détail de la séance',
  Tr.adminPlanningViewClient: 'Voir le client',
  Tr.adminPlanningDuration: 'Durée',
  Tr.adminPlanningMonday: 'Lun',
  Tr.adminPlanningTuesday: 'Mar',
  Tr.adminPlanningWednesday: 'Mer',
  Tr.adminPlanningThursday: 'Jeu',
  Tr.adminPlanningFriday: 'Ven',
  Tr.adminPlanningSaturday: 'Sam',
  Tr.adminPlanningSunday: 'Dim',

  // Availability management
  Tr.adminAvailabilityToggle: 'Disponibilités',
  Tr.adminAvailabilityManage: 'Gérer les disponibilités',
  Tr.adminAvailabilityTitle: 'Règles de disponibilité',
  Tr.adminAvailabilityRecurring: 'Récurrente',
  Tr.adminAvailabilityOverride: 'Ponctuelle',
  Tr.adminAvailabilityBlocked: 'Jour bloqué',
  Tr.adminAvailabilityDayOfWeek: 'Jour de la semaine',
  Tr.adminAvailabilityDate: 'Date',
  Tr.adminAvailabilityStartTime: 'Heure de début',
  Tr.adminAvailabilityEndTime: 'Heure de fin',
  Tr.adminAvailabilityLabel: 'Libellé (optionnel)',
  Tr.adminAvailabilitySave: 'Enregistrer',
  Tr.adminAvailabilityDelete: 'Supprimer',
  Tr.adminAvailabilityDeleteConfirm: 'Supprimer cette règle ?',
  Tr.adminAvailabilityEmpty: 'Aucune règle de disponibilité définie',
  Tr.adminAvailabilityAddRule: 'Ajouter une règle',
  Tr.adminAvailabilityEditRule: 'Modifier la règle',
  Tr.adminAvailabilityNoSlots: 'Aucun créneau disponible',

  // Settings — Google Calendar
  Tr.settingsGoogleCalendarTitle: 'Google Agenda',
  Tr.settingsGoogleCalendarDesc:
      'Synchronisez vos séances avec Google Agenda pour gérer votre planning en un seul endroit.',
  Tr.settingsGoogleCalendarConnect: 'Connecter Google Agenda',
  Tr.settingsGoogleCalendarDisconnect: 'Déconnecter',
  Tr.settingsGoogleCalendarDisconnectConfirm:
      'Voulez-vous déconnecter Google Agenda ? Les données Déclia seront conservées.',
  Tr.settingsGoogleCalendarConnected: 'Connecté',
  Tr.settingsGoogleCalendarDisconnected: 'Non connecté',
  Tr.settingsGoogleCalendarId: 'Agenda',
  Tr.settingsGoogleCalendarLastSync: 'Dernière sync.',
  Tr.settingsGoogleCalendarSyncNow: 'Synchroniser',
  Tr.settingsGoogleCalendarSyncing: 'Synchronisation…',
  Tr.settingsGoogleCalendarSyncEnabled: 'Sync. automatique',
  Tr.settingsGoogleCalendarError: 'Erreur de synchronisation',
  Tr.settingsGoogleCalendarAuthCode:
      'Ouvrez le lien ci-dessous, autorisez l\'accès, puis collez le code d\'autorisation.',
  Tr.settingsGoogleCalendarAuthCodeHint: 'Collez le code ici',

  // Planning — External events
  Tr.adminPlanningExternalEvent: 'Événement Google Agenda',
  Tr.adminPlanningExternalSource: 'Source',

  // Login page (new)
  Tr.loginTagline: 'Votre studio\ndevient ',
  Tr.loginTaglineHighlight: 'intelligent',
  Tr.loginFeature1: 'Réservation en ligne simplifiée',
  Tr.loginFeature2: 'Galeries privées sécurisées',
  Tr.loginFeature3: 'Facturation automatisée',
  Tr.loginFeature4: 'Intelligence artificielle intégrée',
  Tr.loginRememberMe: 'Se souvenir de moi',
  Tr.loginForgotPassword: 'Mot de passe oublié ?',
  Tr.loginRoleClient: 'Client',
  Tr.loginRolePhotographer: 'Photographe',
  Tr.loginTitleClient: 'Connexion Client',
  Tr.loginSubtitleClient: 'Accédez à vos galeries, réservations et commandes.',
  Tr.loginTitlePhotographer: 'Espace Photographe',
  Tr.loginSubtitlePhotographer: 'Gérez votre studio en toute simplicité',
  Tr.loginSubmitPhotographer: 'Accéder à mon espace',
  Tr.loginPhotographerCode: 'Code photographe',
  Tr.loginPhotographerCodeHint: 'Ex : STUDIO-XXXX',
  Tr.loginFooterNoAccount: 'Pas encore de compte ?',
  Tr.loginFooterCreateAccount: 'Créer un compte client',
  Tr.loginFooterCreateAccountPhotographer: 'Créer un compte professionnel',
  Tr.loginBrandSubtitle: 'Plateforme pour photographes professionnels',

  // Client left panel
  Tr.loginClientTagline: 'Votre espace\nphoto ',
  Tr.loginClientTaglineHighlight: 'personnalisé',
  Tr.loginClientSubtitle:
      'Réservez vos séances, consultez vos galeries et gérez vos commandes — simplement.',
  Tr.loginClientFeature1: 'Réservation de séances en ligne',
  Tr.loginClientFeature2: 'Galeries privées haute résolution',
  Tr.loginClientFeature3: 'Suivi de commandes en temps réel',
  Tr.loginClientFeature4: 'Partage sécurisé de vos photos',

  // Auth — Register form
  Tr.authRegisterTitleClient: 'Créer un compte client',
  Tr.authRegisterTitlePhotographer: 'Créer un compte photographe',
  Tr.authRegisterSubtitleClient: 'Accédez à vos galeries et réservations.',
  Tr.authRegisterSubtitlePhotographer: 'Commencez à gérer votre activité.',
  Tr.authRegisterFooterHaveAccount: 'Déjà un compte ?',
  Tr.authRegisterFooterSignIn: 'Se connecter',
  Tr.authRegisterSuccess:
      'Vérifiez votre boîte mail pour confirmer votre adresse email.',

  // Auth — Error messages
  Tr.authErrorInvalidEmail: 'Format d\'adresse email invalide',
  Tr.authErrorPasswordTooShort:
      'Le mot de passe doit contenir au moins 6 caractères',
  Tr.authErrorRateLimited:
      'Trop de tentatives. Veuillez patienter avant de réessayer.',
  Tr.authErrorNetwork:
      'Erreur de connexion. Vérifiez votre connexion internet.',
  Tr.authErrorGeneric: 'Une erreur est survenue. Veuillez réessayer.',

  // Auth — Forgot password form
  Tr.authForgotTitle: 'Mot de passe oublié',
  Tr.authForgotTitlePhotographer: 'Réinitialiser l\'accès studio',
  Tr.authForgotSubtitle:
      'Entrez votre adresse e-mail pour recevoir un lien de réinitialisation.',
  Tr.authForgotSubtitlePhotographer:
      'Entrez l\'email associé à votre compte professionnel.',
  Tr.authForgotSubmit: 'Envoyer le lien',
  Tr.authForgotSuccess: 'Un email de réinitialisation a été envoyé.',
  Tr.authForgotBackToLogin: 'Retour à la connexion',

  // Dashboard (new)
  Tr.dashboardWelcomeGreeting: 'Bonjour,',
  Tr.dashboardStatRevenue: "CHIFFRE D'AFFAIRES",
  Tr.dashboardStatSessions: 'SÉANCES',
  Tr.dashboardStatClients: 'CLIENTS',
  Tr.dashboardStatOrders: 'COMMANDES',
  Tr.dashboardUpcomingSessions: 'Séances à venir',
  Tr.dashboardRecentActivity: 'Activité récente',
  Tr.dashboardQuickActions: 'Actions rapides',
  Tr.dashboardSeeAll: 'Voir tout',
  Tr.dashboardNewSession: 'Nouvelle séance',
  Tr.dashboardCreateGallery: 'Créer galerie',
  Tr.dashboardNewClient: 'Nouveau client',
  Tr.dashboardNewInvoice: 'Nouvelle facture',
  Tr.dashboardWelcomeSubtitle: 'Votre prochain shooting vous attend',

  // Clients (new)
  Tr.adminClientsTotalClients: 'TOTAL CLIENTS',
  Tr.adminClientsActive: 'ACTIFS',
  Tr.adminClientsStatNew: 'NOUVEAUX',
  Tr.adminClientsAvgRevenue: 'CA / CLIENT',
  Tr.adminClientsTableStatus: 'Statut',

  // Planning (new)
  Tr.planningTabCalendar: 'Calendrier',
  Tr.planningTabEditor: 'Éditeur',
  Tr.planningEditorIntro:
      'Cliquez sur les créneaux pour définir vos disponibilités',
  Tr.planningQuickFillWeek: 'Semaine type',
  Tr.planningQuickFillMorning: 'Matin seulement',
  Tr.planningQuickFillAfternoon: 'Après-midi',
  Tr.planningQuickFillClear: 'Tout effacer',
  Tr.planningEditorSave: 'Enregistrer',
  Tr.planningEditorCancel: 'Annuler',
  Tr.planningLegendAvailable: 'Disponible',
  Tr.planningLegendBlocked: 'Bloqué',
  Tr.planningEditorClearConfirm: 'Supprimer toutes les règles récurrentes ?',

  // Settings (new)
  Tr.settingsSectionStudio: 'Informations du studio',
  Tr.settingsSectionLegal: 'Légal / CGV / RGPD',
  Tr.settingsSectionColors: 'Couleurs & Logo',
  Tr.settingsSectionTypography: 'Typographie',
  Tr.settingsSectionIntegrations: 'Intégrations',
  Tr.settingsPlaceholder: 'Section à venir',
  Tr.settingsSectionMyStudio: 'MON STUDIO',
  Tr.settingsSectionIdentity: 'IDENTITÉ & DESIGN',
  Tr.settingsSectionConnections: 'CONNEXIONS',

  // Registration wizard
  Tr.registerStepPersonal: 'Informations personnelles',
  Tr.registerStepBusiness: 'Informations professionnelles',
  Tr.registerStepSecurity: 'Sécurité du compte',
  Tr.registerStepConfirmation: 'Confirmation',
  Tr.registerStepPersonalDesc: 'Vos coordonnées',
  Tr.registerStepBusinessDesc: 'Votre studio',
  Tr.registerStepSecurityDesc: 'Protégez votre compte',
  Tr.registerStepConfirmationDesc: 'Vérifiez et validez',
  Tr.registerFieldFirstName: 'Prénom',
  Tr.registerFieldLastName: 'Nom',
  Tr.registerFieldPhone: 'Téléphone',
  Tr.registerFieldStreet: 'Rue',
  Tr.registerFieldPostalCode: 'Code postal',
  Tr.registerFieldCity: 'Ville',
  Tr.registerFieldStudioName: 'Nom du studio',
  Tr.registerFieldCompanyName: 'Raison sociale',
  Tr.registerFieldSiret: 'SIRET',
  Tr.registerFieldLegalForm: 'Forme juridique',
  Tr.registerFieldVatNumber: 'N° TVA',
  Tr.registerFieldBizStreet: 'Adresse professionnelle',
  Tr.registerFieldBizPostalCode: 'Code postal professionnel',
  Tr.registerFieldCountry: 'Pays',
  Tr.registerFieldBizCountry: 'Pays',
  Tr.registerFieldBizCity: 'Ville professionnelle',
  Tr.registerFieldAcquisitionSource: 'Comment nous avez-vous connu ?',
  Tr.registerFieldNotes: 'Notes (optionnel)',
  Tr.registerFieldInvitationCode: 'Code d\'invitation',
  Tr.registerFieldInvitationCodeHint: 'Ex : mon-studio',
  Tr.registerFieldInvitationCodeRequired:
      'Le code d\'invitation est requis',
  Tr.registerFieldCompany: 'Société (optionnel)',
  Tr.registerFieldRequired: 'Ce champ est requis',
  Tr.registerConsentCgu:
      'J\'accepte les CGU et la politique de confidentialité',
  Tr.registerConsentCguPrefix: 'J\'accepte les ',
  Tr.registerConsentCguLink: 'CGU',
  Tr.registerConsentCguMiddle: ' et la ',
  Tr.registerConsentPrivacyLink: 'politique de confidentialité',
  Tr.registerConsentCguRequired: 'Vous devez accepter les CGU pour continuer',
  Tr.registerConsentMarketing:
      'J\'accepte de recevoir des communications marketing',
  Tr.registerBtnContinue: 'Continuer',
  Tr.registerBtnBack: 'Retour',
  Tr.registerBtnSubmit: 'Créer mon compte',
  Tr.registerSummaryTitle: 'Récapitulatif',
  Tr.registerSummaryIdentity: 'Identité',
  Tr.registerSummaryContact: 'Contact',
  Tr.registerSummaryAddress: 'Adresse',
  Tr.registerSummaryBusiness: 'Entreprise',
  Tr.registerLeftTaglineClient: 'Rejoignez\nl\'expérience ',
  Tr.registerLeftTaglineClientHighlight: 'Déclia',
  Tr.registerLeftTaglinePhotographer: 'Créez\nvotre ',
  Tr.registerLeftTaglinePhotographerHighlight: 'studio',
  Tr.registerLeftSubtitleClient:
      'Créez votre espace personnel pour accéder à vos galeries et réservations.',
  Tr.registerLeftSubtitlePhotographer:
      'Configurez votre espace professionnel et commencez à gérer vos clients.',
  Tr.registerSectionIdentity: 'Identité',
  Tr.registerSectionStudio: 'Studio',
  Tr.registerSectionPreferences: 'Préférences',
  Tr.registerAvatarTitle: 'Photo de profil',
  Tr.registerAvatarHint: 'JPG ou PNG, max 2 Mo (optionnel)',
  Tr.registerSectionAddress: 'Adresse',
  Tr.registerSectionBizAddress: 'Adresse professionnelle',
  Tr.registerStepStudio: 'Informations studio',
  Tr.registerStepStudioDesc: 'Votre activité',
  Tr.registerAvatarComingSoon: 'L\'ajout de photo sera bientôt disponible',
  Tr.registerPasswordHint:
      'Min. 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre, 1 caractère spécial',
  Tr.registerPasswordTooWeak: 'Mot de passe trop faible',
  Tr.registerVatInvalid: 'Numéro de TVA invalide',

  // Legal form labels
  Tr.legalFormAutoEntrepreneur: 'Auto-entrepreneur',
  Tr.legalFormEi: 'Entreprise individuelle',
  Tr.legalFormEurl: 'EURL',
  Tr.legalFormSarl: 'SARL',
  Tr.legalFormSas: 'SAS',
  Tr.legalFormSasu: 'SASU',
  Tr.legalFormMicroEntreprise: 'Micro-entreprise',
  Tr.legalFormAssociation: 'Association',
  Tr.legalFormOther: 'Autre',
  Tr.legalFormOtherSpecify: 'Précisez la forme juridique',

  // Acquisition source labels
  Tr.acquisitionSourceReferral: 'Parrainage',
  Tr.acquisitionSourceSocialMedia: 'Réseaux sociaux',
  Tr.acquisitionSourceWebsite: 'Site web',
  Tr.acquisitionSourceWordOfMouth: 'Bouche à oreille',
  Tr.acquisitionSourceEvent: 'Événement',
  Tr.acquisitionSourceOther: 'Autre',
};
