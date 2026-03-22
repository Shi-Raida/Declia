enum ClientStatus { actif, inactif, nouveau, vip }

extension ClientStatusDisplay on ClientStatus {
  String get label => switch (this) {
    ClientStatus.actif => 'Actif',
    ClientStatus.inactif => 'Inactif',
    ClientStatus.nouveau => 'Nouveau',
    ClientStatus.vip => 'VIP',
  };
}
