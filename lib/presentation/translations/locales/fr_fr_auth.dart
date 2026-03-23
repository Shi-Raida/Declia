import '../translation_keys.dart';

final Map<String, String> frFrAuth = {
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
};
