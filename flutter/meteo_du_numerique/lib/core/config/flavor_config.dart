enum Flavor { prod, test, testProd }

class FlavorConfig {
  static Flavor flavor = Flavor.prod;

  static void init(String f) {
    flavor = f == "prod"
        ? Flavor.prod
        : f == "test"
            ? Flavor.test
            : Flavor.testProd;
  }
}
