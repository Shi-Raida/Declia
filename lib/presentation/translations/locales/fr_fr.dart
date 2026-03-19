import '../translation_keys.dart';

final Map<String, String> frFr = {
  Tr.appName: 'Déclia',

  // Login
  Tr.loginSubtitle: 'Espace Photographe',
  Tr.loginEmail: 'Email',
  Tr.loginEmailHint: 'votre@email.com',
  Tr.loginEmailRequired: 'Veuillez saisir votre email',
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

  // Client form
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

  // Acquisition source labels
  Tr.acquisitionSourceReferral: 'Parrainage',
  Tr.acquisitionSourceSocialMedia: 'Réseaux sociaux',
  Tr.acquisitionSourceWebsite: 'Site web',
  Tr.acquisitionSourceWordOfMouth: 'Bouche à oreille',
  Tr.acquisitionSourceEvent: 'Événement',
  Tr.acquisitionSourceOther: 'Autre',
};
