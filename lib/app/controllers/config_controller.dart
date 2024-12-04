class ConfigController {
  static final ConfigController instance = ConfigController._();

  String getUrlBase() {
    return 'localhost:3333';
  }

  ConfigController._();
}
