import '../translation_keys.dart';

final Map<String, String> frFr = {
  Tr.common.appName: 'Déclia',

  // Login
  Tr.auth.login.subtitle:
      'Gestion de clientèle, réservations, galeries et facturation — tout au même endroit.',
  Tr.auth.login.email: 'Email',
  Tr.auth.login.emailHint: 'vous@exemple.com',
  Tr.auth.login.emailRequired: 'Veuillez saisir votre email',
  Tr.auth.login.emailInvalid: 'Format d\'adresse email invalide',
  Tr.auth.login.password: 'Mot de passe',
  Tr.auth.login.passwordRequired: 'Veuillez saisir votre mot de passe',
  Tr.auth.login.submit: 'Se connecter',
  Tr.auth.login.unauthorizedRole:
      'Vous n\'avez pas la permission d\'accéder à cet espace',
  Tr.auth.login.invalidCredentials: 'Email ou mot de passe incorrect',

  // Dashboard
  Tr.admin.dashboard.title: 'Tableau de bord',
  Tr.admin.dashboard.logout: 'Se déconnecter',
  Tr.admin.dashboard.welcome: 'Bienvenue, @email',

  // Client login
  Tr.auth.clientLogin.subtitle: 'Espace Client',
  Tr.auth.clientLogin.forgotPassword: 'Mot de passe oublié ?',
  Tr.auth.clientLogin.createAccount: 'Créer un compte',

  // Client register
  Tr.auth.clientRegister.title: 'Créer un compte',
  Tr.auth.clientRegister.confirmPassword: 'Confirmer le mot de passe',
  Tr.auth.clientRegister.confirmPasswordRequired:
      'Veuillez confirmer votre mot de passe',
  Tr.auth.clientRegister.passwordMismatch:
      'Les mots de passe ne correspondent pas',
  Tr.auth.clientRegister.submit: 'Créer mon compte',
  Tr.auth.clientRegister.success:
      'Vérifiez votre boîte mail pour confirmer votre adresse email.',
  Tr.auth.clientRegister.emailAlreadyInUse:
      'Cette adresse email est déjà utilisée',
  Tr.auth.clientRegister.invalidLink:
      'Lien d\'invitation invalide. Veuillez utiliser le lien fourni par votre studio.',
  Tr.auth.clientRegister.haveAccount: 'Déjà un compte ? Se connecter',

  // Forgot password
  Tr.auth.forgotPassword.title: 'Réinitialiser le mot de passe',
  Tr.auth.forgotPassword.subtitle:
      'Saisissez votre email pour recevoir un lien de réinitialisation.',
  Tr.auth.forgotPassword.submit: 'Envoyer le lien',
  Tr.auth.forgotPassword.success: 'Un email de réinitialisation a été envoyé.',
  Tr.auth.forgotPassword.backToLogin: 'Retour à la connexion',

  // Client home
  Tr.auth.clientHome.title: 'Espace Client',
  Tr.auth.clientHome.welcome: 'Bienvenue, @email',
  Tr.auth.clientHome.logout: 'Se déconnecter',

  // Admin shell
  Tr.admin.brand.subtitle: 'ADMINISTRATION',
  Tr.admin.section.general: 'GÉNÉRAL',
  Tr.admin.section.management: 'GESTION',
  Tr.admin.sidebar.dashboard: 'Tableau de bord',
  Tr.admin.sidebar.clients: 'Clients',
  Tr.admin.sidebar.planning: 'Planning',
  Tr.admin.sidebar.galleries: 'Galeries',
  Tr.admin.sidebar.shop: 'Boutique',
  Tr.admin.sidebar.invoicing: 'Facturation',
  Tr.admin.sidebar.statistics: 'Statistiques',
  Tr.admin.sidebar.settings: 'Paramètres',
  Tr.admin.topbar.logout: 'Se déconnecter',
  Tr.admin.placeholder.comingSoon: 'Bientôt disponible',

  // Sidebar sections (new)
  Tr.admin.section.principal: 'PRINCIPAL',
  Tr.admin.section.commerce: 'COMMERCE',
  Tr.admin.section.outils: 'OUTILS',

  // Sidebar items (new)
  Tr.admin.sidebar.orders: 'Commandes',
  Tr.admin.sidebar.giftCards: 'Cartes cadeau',
  Tr.admin.sidebar.promotions: 'Promotions',
  Tr.admin.sidebar.tasks: 'Tâches',
  Tr.admin.badge.beta: 'Beta',

  // Cookie banner
  Tr.common.cookieBanner.title: 'Gestion des cookies',
  Tr.common.cookieBanner.description:
      'Nous utilisons des cookies pour améliorer votre expérience. Vous pouvez accepter, refuser ou personnaliser vos préférences.',
  Tr.common.cookieBanner.acceptAll: 'Tout accepter',
  Tr.common.cookieBanner.refuseAll: 'Tout refuser',
  Tr.common.cookieBanner.customize: 'Personnaliser',
  Tr.common.cookieBanner.savePreferences: 'Enregistrer mes préférences',
  Tr.common.cookieBanner.analytics: 'Cookies analytiques',
  Tr.common.cookieBanner.marketing: 'Cookies marketing',
  Tr.common.cookieBanner.functional: 'Cookies fonctionnels',
  Tr.common.cookieBanner.privacyPolicy: 'Politique de confidentialité',

  // Legal pages
  Tr.common.legal.privacyTitle: 'Politique de confidentialité',
  Tr.common.legal.privacyContent:
      'Le contenu de cette page sera disponible prochainement.',
  Tr.common.legal.noticesTitle: 'Mentions légales',
  Tr.common.legal.noticesContent:
      'Le contenu de cette page sera disponible prochainement.',

  // Clients list
  Tr.admin.clients.title: 'Clients',
  Tr.admin.clients.add: 'Nouveau client',
  Tr.admin.clients.search: 'Rechercher un client...',
  Tr.admin.clients.empty: 'Aucun client trouvé',
  Tr.admin.clients.tableName: 'Nom',
  Tr.admin.clients.tableEmail: 'Email',
  Tr.admin.clients.tablePhone: 'Téléphone',
  Tr.admin.clients.tableTags: 'Tags',
  Tr.admin.clients.tableDate: "Date d'ajout",
  Tr.admin.clients.tableActions: 'Actions',
  Tr.admin.clients.deleteConfirm: 'Supprimer ce client ?',
  Tr.admin.clients.deleteBody: 'Cette action est irréversible.',
  Tr.admin.clients.deleteSuccess: 'Client supprimé',
  Tr.admin.clients.filterByTag: 'Tags',
  Tr.admin.clients.filterBySource: 'Source',
  Tr.admin.clients.filterTagHint: 'Ajouter un tag...',
  Tr.admin.clients.sortBy: 'Trier par',
  Tr.admin.clients.sortName: 'Nom',
  Tr.admin.clients.sortDate: "Date d'ajout",
  Tr.admin.clients.count: '@count clients',
  Tr.admin.clients.clearFilters: 'Effacer les filtres',
  Tr.admin.clients.tableSessions: 'Séances',
  Tr.admin.clients.tableTotalSpent: 'Dépenses totales',
  Tr.admin.clients.allStatuses: 'Tous les statuts',
  Tr.admin.clients.allCategories: 'Toutes les catégories',
  Tr.admin.clients.tableCategory: 'Catégorie',
  Tr.admin.clients.tableRevenue: 'CA total',
  Tr.admin.clients.export: 'Exporter',
  Tr.admin.clients.tableLastShooting: 'Dernière séance',
  Tr.admin.clients.paginationInfo: 'Page @page sur @total',
  Tr.admin.clients.allSources: 'Toutes les sources',

  // Client form
  Tr.admin.clientForm.company: 'Société',
  Tr.admin.clientForm.titleCreate: 'Nouveau client',
  Tr.admin.clientForm.titleEdit: 'Modifier le client',
  Tr.admin.clientForm.sectionIdentity: 'Identité',
  Tr.admin.clientForm.firstName: 'Prénom',
  Tr.admin.clientForm.lastName: 'Nom',
  Tr.admin.clientForm.email: 'Email',
  Tr.admin.clientForm.phone: 'Téléphone',
  Tr.admin.clientForm.dob: 'Date de naissance',
  Tr.admin.clientForm.sectionAddress: 'Adresse',
  Tr.admin.clientForm.street: 'Rue',
  Tr.admin.clientForm.city: 'Ville',
  Tr.admin.clientForm.postalCode: 'Code postal',
  Tr.admin.clientForm.country: 'Pays',
  Tr.admin.clientForm.sectionCrm: 'CRM',
  Tr.admin.clientForm.acquisitionSource: "Source d'acquisition",
  Tr.admin.clientForm.tags: 'Tags',
  Tr.admin.clientForm.notes: 'Notes',
  Tr.admin.clientForm.sectionGdpr: 'RGPD & Communications',
  Tr.admin.clientForm.gdprConsentDate: 'Date de consentement',
  Tr.admin.clientForm.gdprEmail: 'Email',
  Tr.admin.clientForm.gdprSms: 'SMS',
  Tr.admin.clientForm.gdprPhone: 'Téléphone',
  Tr.admin.clientForm.save: 'Enregistrer',
  Tr.admin.clientForm.cancel: 'Annuler',
  Tr.admin.clientForm.success: 'Client enregistré',
  Tr.admin.clientForm.error: "Erreur lors de l'enregistrement",
  Tr.admin.clientForm.firstNameRequired: 'Veuillez saisir le prénom',
  Tr.admin.clientForm.lastNameRequired: 'Veuillez saisir le nom',

  // Client detail
  Tr.admin.clientDetail.edit: 'Modifier',
  Tr.admin.clientDetail.delete: 'Supprimer',
  Tr.admin.clientDetail.view: 'Voir',
  Tr.admin.clientDetail.noEmail: 'Email non renseigné',
  Tr.admin.clientDetail.noPhone: 'Téléphone non renseigné',
  Tr.admin.clientDetail.noAddress: 'Adresse non renseignée',
  Tr.admin.clientDetail.noNotes: 'Aucune note',

  // Client history
  Tr.admin.history.statSessions: 'Séances',
  Tr.admin.history.statTotalSpent: 'Dépenses totales',
  Tr.admin.history.statLastShooting: 'Dernière séance',
  Tr.admin.history.sessions: 'Séances',
  Tr.admin.history.sessionsEmpty: 'Aucune séance',
  Tr.admin.history.galleries: 'Galeries',
  Tr.admin.history.galleriesEmpty: 'Aucune galerie',
  Tr.admin.history.orders: 'Commandes',
  Tr.admin.history.ordersEmpty: 'Aucune commande',
  Tr.admin.history.communications: 'Communications',
  Tr.admin.history.communicationsEmpty: 'Aucune communication',
  Tr.admin.history.photos: 'photos',
  Tr.admin.history.colDate: 'Date',
  Tr.admin.history.colType: 'Type',
  Tr.admin.history.colLocation: 'Lieu',
  Tr.admin.history.colStatus: 'Statut',
  Tr.admin.history.colPayment: 'Paiement',
  Tr.admin.history.colAmount: 'Montant',

  // Session type labels
  Tr.common.sessionType.family: 'Famille',
  Tr.common.sessionType.equestrian: 'Équestre',
  Tr.common.sessionType.event: 'Événement',
  Tr.common.sessionType.maternity: 'Maternité',
  Tr.common.sessionType.school: 'Scolaire',
  Tr.common.sessionType.portrait: 'Portrait',
  Tr.common.sessionType.miniSession: 'Mini-séance',
  Tr.common.sessionType.other: 'Autre',

  // Session status labels
  Tr.common.sessionStatus.scheduled: 'Planifiée',
  Tr.common.sessionStatus.confirmed: 'Confirmée',
  Tr.common.sessionStatus.completed: 'Terminée',
  Tr.common.sessionStatus.cancelled: 'Annulée',
  Tr.common.sessionStatus.noShow: 'Absent',

  // Payment status labels
  Tr.common.paymentStatus.pending: 'En attente',
  Tr.common.paymentStatus.partial: 'Partiel',
  Tr.common.paymentStatus.paid: 'Payé',
  Tr.common.paymentStatus.refunded: 'Remboursé',

  // Gallery status labels
  Tr.common.galleryStatus.draft: 'Brouillon',
  Tr.common.galleryStatus.published: 'Publiée',
  Tr.common.galleryStatus.archived: 'Archivée',
  Tr.common.galleryStatus.expired: 'Expirée',

  // Order status labels
  Tr.common.orderStatus.pending: 'En attente',
  Tr.common.orderStatus.processing: 'En traitement',
  Tr.common.orderStatus.shipped: 'Expédiée',
  Tr.common.orderStatus.delivered: 'Livrée',
  Tr.common.orderStatus.cancelled: 'Annulée',
  Tr.common.orderStatus.refunded: 'Remboursée',

  // Communication channel labels
  Tr.common.commChannel.email: 'Email',
  Tr.common.commChannel.sms: 'SMS',

  // Communication status labels
  Tr.common.commStatus.queued: 'En file',
  Tr.common.commStatus.sent: 'Envoyé',
  Tr.common.commStatus.delivered: 'Livré',
  Tr.common.commStatus.failed: 'Échec',
  Tr.common.commStatus.bounced: 'Rebond',

  // Planning calendar
  Tr.admin.planning.title: 'Planning',
  Tr.admin.planning.viewDay: 'Jour',
  Tr.admin.planning.viewWeek: 'Semaine',
  Tr.admin.planning.viewMonth: 'Mois',
  Tr.admin.planning.today: "Aujourd'hui",
  Tr.admin.planning.noSessions: 'Aucune séance',
  Tr.admin.planning.sessionDetail: 'Détail de la séance',
  Tr.admin.planning.viewClient: 'Voir le client',
  Tr.admin.planning.duration: 'Durée',
  Tr.admin.planning.monday: 'Lun',
  Tr.admin.planning.tuesday: 'Mar',
  Tr.admin.planning.wednesday: 'Mer',
  Tr.admin.planning.thursday: 'Jeu',
  Tr.admin.planning.friday: 'Ven',
  Tr.admin.planning.saturday: 'Sam',
  Tr.admin.planning.sunday: 'Dim',

  // Availability management
  Tr.admin.availability.toggle: 'Disponibilités',
  Tr.admin.availability.manage: 'Gérer les disponibilités',
  Tr.admin.availability.title: 'Règles de disponibilité',
  Tr.admin.availability.recurring: 'Récurrente',
  Tr.admin.availability.override: 'Ponctuelle',
  Tr.admin.availability.blocked: 'Jour bloqué',
  Tr.admin.availability.dayOfWeek: 'Jour de la semaine',
  Tr.admin.availability.date: 'Date',
  Tr.admin.availability.startTime: 'Heure de début',
  Tr.admin.availability.endTime: 'Heure de fin',
  Tr.admin.availability.label: 'Libellé (optionnel)',
  Tr.admin.availability.save: 'Enregistrer',
  Tr.admin.availability.delete: 'Supprimer',
  Tr.admin.availability.deleteConfirm: 'Supprimer cette règle ?',
  Tr.admin.availability.empty: 'Aucune règle de disponibilité définie',
  Tr.admin.availability.addRule: 'Ajouter une règle',
  Tr.admin.availability.editRule: 'Modifier la règle',
  Tr.admin.availability.noSlots: 'Aucun créneau disponible',

  // Settings — Google Calendar
  Tr.admin.settings.googleCalendar.title: 'Google Agenda',
  Tr.admin.settings.googleCalendar.desc:
      'Synchronisez vos séances avec Google Agenda pour gérer votre planning en un seul endroit.',
  Tr.admin.settings.googleCalendar.connect: 'Connecter Google Agenda',
  Tr.admin.settings.googleCalendar.disconnect: 'Déconnecter',
  Tr.admin.settings.googleCalendar.disconnectConfirm:
      'Voulez-vous déconnecter Google Agenda ? Les données Déclia seront conservées.',
  Tr.admin.settings.googleCalendar.connected: 'Connecté',
  Tr.admin.settings.googleCalendar.disconnected: 'Non connecté',
  Tr.admin.settings.googleCalendar.id: 'Agenda',
  Tr.admin.settings.googleCalendar.lastSync: 'Dernière sync.',
  Tr.admin.settings.googleCalendar.syncNow: 'Synchroniser',
  Tr.admin.settings.googleCalendar.syncing: 'Synchronisation…',
  Tr.admin.settings.googleCalendar.syncEnabled: 'Sync. automatique',
  Tr.admin.settings.googleCalendar.error: 'Erreur de synchronisation',
  Tr.admin.settings.googleCalendar.authCode:
      'Ouvrez le lien ci-dessous, autorisez l\'accès, puis collez le code d\'autorisation.',
  Tr.admin.settings.googleCalendar.authCodeHint: 'Collez le code ici',

  // Planning — External events
  Tr.admin.planning.externalEvent: 'Événement Google Agenda',
  Tr.admin.planning.externalSource: 'Source',

  // Login page (new)
  Tr.auth.login.tagline: 'Votre studio\ndevient ',
  Tr.auth.login.taglineHighlight: 'intelligent',
  Tr.auth.login.feature1: 'Réservation en ligne simplifiée',
  Tr.auth.login.feature2: 'Galeries privées sécurisées',
  Tr.auth.login.feature3: 'Facturation automatisée',
  Tr.auth.login.feature4: 'Intelligence artificielle intégrée',
  Tr.auth.login.rememberMe: 'Se souvenir de moi',
  Tr.auth.login.forgotPassword: 'Mot de passe oublié ?',
  Tr.auth.login.roleClient: 'Client',
  Tr.auth.login.rolePhotographer: 'Photographe',
  Tr.auth.login.titleClient: 'Connexion Client',
  Tr.auth.login.subtitleClient:
      'Accédez à vos galeries, réservations et commandes.',
  Tr.auth.login.titlePhotographer: 'Espace Photographe',
  Tr.auth.login.subtitlePhotographer: 'Gérez votre studio en toute simplicité',
  Tr.auth.login.submitPhotographer: 'Accéder à mon espace',
  Tr.auth.login.photographerCode: 'Code photographe',
  Tr.auth.login.photographerCodeHint: 'Ex : STUDIO-XXXX',
  Tr.auth.login.footerNoAccount: 'Pas encore de compte ?',
  Tr.auth.login.footerCreateAccount: 'Créer un compte client',
  Tr.auth.login.footerCreateAccountPhotographer:
      'Créer un compte professionnel',
  Tr.auth.login.brandSubtitle: 'Plateforme pour photographes professionnels',

  // Client left panel
  Tr.auth.login.clientTagline: 'Votre espace\nphoto ',
  Tr.auth.login.clientTaglineHighlight: 'personnalisé',
  Tr.auth.login.clientSubtitle:
      'Réservez vos séances, consultez vos galeries et gérez vos commandes — simplement.',
  Tr.auth.login.clientFeature1: 'Réservation de séances en ligne',
  Tr.auth.login.clientFeature2: 'Galeries privées haute résolution',
  Tr.auth.login.clientFeature3: 'Suivi de commandes en temps réel',
  Tr.auth.login.clientFeature4: 'Partage sécurisé de vos photos',

  // Auth — Register form
  Tr.auth.register.titleClient: 'Créer un compte client',
  Tr.auth.register.titlePhotographer: 'Créer un compte photographe',
  Tr.auth.register.subtitleClient: 'Accédez à vos galeries et réservations.',
  Tr.auth.register.subtitlePhotographer: 'Commencez à gérer votre activité.',
  Tr.auth.register.footerHaveAccount: 'Déjà un compte ?',
  Tr.auth.register.footerSignIn: 'Se connecter',
  Tr.auth.register.success:
      'Vérifiez votre boîte mail pour confirmer votre adresse email.',

  // Auth — Error messages
  Tr.auth.error.invalidEmail: 'Format d\'adresse email invalide',
  Tr.auth.error.passwordTooShort:
      'Le mot de passe doit contenir au moins 6 caractères',
  Tr.auth.error.rateLimited:
      'Trop de tentatives. Veuillez patienter avant de réessayer.',
  Tr.auth.error.network:
      'Erreur de connexion. Vérifiez votre connexion internet.',
  Tr.auth.error.generic: 'Une erreur est survenue. Veuillez réessayer.',

  // Auth — Forgot password form
  Tr.auth.forgot.title: 'Mot de passe oublié',
  Tr.auth.forgot.titlePhotographer: 'Réinitialiser l\'accès studio',
  Tr.auth.forgot.subtitle:
      'Entrez votre adresse e-mail pour recevoir un lien de réinitialisation.',
  Tr.auth.forgot.subtitlePhotographer:
      'Entrez l\'email associé à votre compte professionnel.',
  Tr.auth.forgot.submit: 'Envoyer le lien',
  Tr.auth.forgot.success: 'Un email de réinitialisation a été envoyé.',
  Tr.auth.forgot.backToLogin: 'Retour à la connexion',

  // Dashboard (new)
  Tr.admin.dashboard.welcomeGreeting: 'Bonjour,',
  Tr.admin.dashboard.statRevenue: "CHIFFRE D'AFFAIRES",
  Tr.admin.dashboard.statSessions: 'SÉANCES',
  Tr.admin.dashboard.statClients: 'CLIENTS',
  Tr.admin.dashboard.statOrders: 'COMMANDES',
  Tr.admin.dashboard.upcomingSessions: 'Séances à venir',
  Tr.admin.dashboard.recentActivity: 'Activité récente',
  Tr.admin.dashboard.quickActions: 'Actions rapides',
  Tr.admin.dashboard.seeAll: 'Voir tout',
  Tr.admin.dashboard.newSession: 'Nouvelle séance',
  Tr.admin.dashboard.createGallery: 'Créer galerie',
  Tr.admin.dashboard.newClient: 'Nouveau client',
  Tr.admin.dashboard.newInvoice: 'Nouvelle facture',
  Tr.admin.dashboard.welcomeSubtitle: 'Votre prochain shooting vous attend',

  // Clients (new)
  Tr.admin.clients.totalClients: 'TOTAL CLIENTS',
  Tr.admin.clients.active: 'ACTIFS',
  Tr.admin.clients.statNew: 'NOUVEAUX',
  Tr.admin.clients.avgRevenue: 'CA / CLIENT',
  Tr.admin.clients.tableStatus: 'Statut',

  // Planning (new)
  Tr.admin.planning.tabCalendar: 'Calendrier',
  Tr.admin.planning.tabEditor: 'Éditeur',
  Tr.admin.planning.editorIntro:
      'Cliquez sur les créneaux pour définir vos disponibilités',
  Tr.admin.planning.quickFillWeek: 'Semaine type',
  Tr.admin.planning.quickFillMorning: 'Matin seulement',
  Tr.admin.planning.quickFillAfternoon: 'Après-midi',
  Tr.admin.planning.quickFillClear: 'Tout effacer',
  Tr.admin.planning.editorSave: 'Enregistrer',
  Tr.admin.planning.editorCancel: 'Annuler',
  Tr.admin.planning.legendAvailable: 'Disponible',
  Tr.admin.planning.legendBlocked: 'Bloqué',
  Tr.admin.planning.editorClearConfirm:
      'Supprimer toutes les règles récurrentes ?',

  // Settings (new)
  Tr.admin.settings.section.studio: 'Informations du studio',
  Tr.admin.settings.section.legal: 'Légal / CGV / RGPD',
  Tr.admin.settings.section.colors: 'Couleurs & Logo',
  Tr.admin.settings.section.typography: 'Typographie',
  Tr.admin.settings.section.integrations: 'Intégrations',
  Tr.admin.settings.placeholder: 'Section à venir',
  Tr.admin.settings.section.myStudio: 'MON STUDIO',
  Tr.admin.settings.section.identity: 'IDENTITÉ & DESIGN',
  Tr.admin.settings.section.connections: 'CONNEXIONS',

  // Registration wizard
  Tr.auth.register.stepPersonal: 'Informations personnelles',
  Tr.auth.register.stepBusiness: 'Informations professionnelles',
  Tr.auth.register.stepSecurity: 'Sécurité du compte',
  Tr.auth.register.stepConfirmation: 'Confirmation',
  Tr.auth.register.stepPersonalDesc: 'Vos coordonnées',
  Tr.auth.register.stepBusinessDesc: 'Votre studio',
  Tr.auth.register.stepSecurityDesc: 'Protégez votre compte',
  Tr.auth.register.stepConfirmationDesc: 'Vérifiez et validez',
  Tr.auth.register.fieldFirstName: 'Prénom',
  Tr.auth.register.fieldLastName: 'Nom',
  Tr.auth.register.fieldPhone: 'Téléphone',
  Tr.auth.register.fieldStreet: 'Rue',
  Tr.auth.register.fieldPostalCode: 'Code postal',
  Tr.auth.register.fieldCity: 'Ville',
  Tr.auth.register.fieldStudioName: 'Nom du studio',
  Tr.auth.register.fieldCompanyName: 'Raison sociale',
  Tr.auth.register.fieldSiret: 'SIRET',
  Tr.auth.register.fieldLegalForm: 'Forme juridique',
  Tr.auth.register.fieldVatNumber: 'N° TVA',
  Tr.auth.register.fieldBizStreet: 'Adresse professionnelle',
  Tr.auth.register.fieldBizPostalCode: 'Code postal professionnel',
  Tr.auth.register.fieldCountry: 'Pays',
  Tr.auth.register.fieldBizCountry: 'Pays',
  Tr.auth.register.fieldBizCity: 'Ville professionnelle',
  Tr.auth.register.fieldAcquisitionSource: 'Comment nous avez-vous connu ?',
  Tr.auth.register.fieldNotes: 'Notes',
  Tr.auth.register.fieldInvitationCode: 'Code d\'invitation',
  Tr.auth.register.fieldInvitationCodeHint: 'Ex : mon-studio',
  Tr.auth.register.fieldInvitationCodeRequired:
      'Le code d\'invitation est requis',
  Tr.auth.register.fieldCompany: 'Société',
  Tr.auth.register.fieldRequired: 'Ce champ est requis',
  Tr.auth.register.consentCgu:
      'J\'accepte les CGU et la politique de confidentialité',
  Tr.auth.register.consentCguPrefix: 'J\'accepte les ',
  Tr.auth.register.consentCguLink: 'CGU',
  Tr.auth.register.consentCguMiddle: ' et la ',
  Tr.auth.register.consentPrivacyLink: 'politique de confidentialité',
  Tr.auth.register.consentCguRequired:
      'Vous devez accepter les CGU pour continuer',
  Tr.auth.register.consentMarketing:
      'J\'accepte de recevoir des communications marketing',
  Tr.auth.register.btnContinue: 'Continuer',
  Tr.auth.register.btnBack: 'Retour',
  Tr.auth.register.btnSubmit: 'Créer mon compte',
  Tr.auth.register.summaryTitle: 'Récapitulatif',
  Tr.auth.register.summaryIdentity: 'Identité',
  Tr.auth.register.summaryContact: 'Contact',
  Tr.auth.register.summaryAddress: 'Adresse',
  Tr.auth.register.summaryBusiness: 'Entreprise',
  Tr.auth.register.leftTaglineClient: 'Rejoignez\nl\'expérience ',
  Tr.auth.register.leftTaglineClientHighlight: 'Déclia',
  Tr.auth.register.leftTaglinePhotographer: 'Créez\nvotre ',
  Tr.auth.register.leftTaglinePhotographerHighlight: 'studio',
  Tr.auth.register.leftSubtitleClient:
      'Créez votre espace personnel pour accéder à vos galeries et réservations.',
  Tr.auth.register.leftSubtitlePhotographer:
      'Configurez votre espace professionnel et commencez à gérer vos clients.',
  Tr.auth.register.sectionIdentity: 'Identité',
  Tr.auth.register.sectionStudio: 'Studio',
  Tr.auth.register.sectionPreferences: 'Préférences',
  Tr.auth.register.avatarTitle: 'Photo de profil',
  Tr.auth.register.avatarHint: 'JPG ou PNG, max 2 Mo (optionnel)',
  Tr.auth.register.sectionAddress: 'Adresse',
  Tr.auth.register.sectionBizAddress: 'Adresse professionnelle',
  Tr.auth.register.stepStudio: 'Informations studio',
  Tr.auth.register.stepStudioDesc: 'Votre activité',
  Tr.auth.register.avatarComingSoon:
      'L\'ajout de photo sera bientôt disponible',
  Tr.auth.register.passwordHint:
      'Min. 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre, 1 caractère spécial',
  Tr.auth.register.passwordTooWeak: 'Mot de passe trop faible',
  Tr.auth.register.vatInvalid: 'Numéro de TVA invalide',

  // Legal form labels
  Tr.common.legalForm.autoEntrepreneur: 'Auto-entrepreneur',
  Tr.common.legalForm.ei: 'Entreprise individuelle',
  Tr.common.legalForm.eurl: 'EURL',
  Tr.common.legalForm.sarl: 'SARL',
  Tr.common.legalForm.sas: 'SAS',
  Tr.common.legalForm.sasu: 'SASU',
  Tr.common.legalForm.microEntreprise: 'Micro-entreprise',
  Tr.common.legalForm.association: 'Association',
  Tr.common.legalForm.other: 'Autre',
  Tr.common.legalForm.otherSpecify: 'Précisez la forme juridique',

  // Acquisition source labels
  Tr.common.acquisitionSource.referral: 'Parrainage',
  Tr.common.acquisitionSource.socialMedia: 'Réseaux sociaux',
  Tr.common.acquisitionSource.website: 'Site web',
  Tr.common.acquisitionSource.wordOfMouth: 'Bouche à oreille',
  Tr.common.acquisitionSource.event: 'Événement',
  Tr.common.acquisitionSource.other: 'Autre',
};
