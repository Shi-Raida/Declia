abstract interface class ClientNavigationService {
  void toClientDetail(String id, {dynamic arguments});
  void toClientEdit(String id, {dynamic arguments});
  void toClientNew();
  void goBack();
}
