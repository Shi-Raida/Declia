enum SettingsSection {
  studio,
  legal,
  colors,
  typography,
  integrations;

  String get label => switch (this) {
    studio => 'Informations du studio',
    legal => 'Légal / CGV / RGPD',
    colors => 'Couleurs & Logo',
    typography => 'Typographie',
    integrations => 'Intégrations',
  };
}
