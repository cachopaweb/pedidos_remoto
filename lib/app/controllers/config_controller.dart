class ConfigController {
  static final ConfigController instance = ConfigController._();

  String getUrlBase() {
    // return 'https://servidor-primor-fboxwqyjfq-rj.a.run.app/v1';
    return 'http://localhost:3333/v1';
  }

  ConfigController._();
}
