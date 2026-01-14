class Onduleur {
  double price;
  double power;

  Onduleur(this.price, this.power);
}

class Batterie {
  double price;

  double ampere;

  Batterie(this.price, this.ampere);
}

class OnduleurManager {
  List<Onduleur> Onduleur_s = [
    Onduleur(6200, 3000),
    Onduleur(8500, 4000),
    Onduleur(10000, 5000),
    Onduleur(17000, 8000),
    Onduleur(18000, 10000),
    Onduleur(24000, 15000),
    Onduleur(25000, 20000),
    Onduleur(32000, 30000),
    Onduleur(44000, 40000),
    Onduleur(53000, 50000),
    Onduleur(50000, 60000),
  ];
  List<Batterie> ListBateerie24 = [
    Batterie(2000 * 2, 100),
    Batterie(3150 * 2, 150),
    Batterie(3850 * 2, 200),
    Batterie(4450 * 2, 250),
    Batterie(4600 * 2, 270),
  ];
  List<Batterie> ListBateerie48 = [
    Batterie(2000 * 4, 100),
    Batterie(3150 * 4, 150),
    Batterie(3850 * 4, 200),
    Batterie(4450 * 4, 250),
    Batterie(4600 * 4, 270),
  ];

  double getOnduleurPrice(double requiredPower) {
    Onduleur? cheapestOnduleur;

    for (var onduleur in Onduleur_s) {
      if (onduleur.power >= requiredPower) {
        if (cheapestOnduleur == null ||
            onduleur.price < cheapestOnduleur.price) {
          cheapestOnduleur = onduleur;
        }
      }
    }
    if (cheapestOnduleur == null) {
      return -1; // Indicate no suitable onduleur found
    } else {
      print(cheapestOnduleur.price.toString());

      return cheapestOnduleur.price;
    }
  }

  double getBestBatteryCombinationTotalPrice(double consumption, bool is24) {
    print(consumption);
    consumption = consumption * 0.90;
    List<Batterie> sortedBatteries = is24 ? ListBateerie24 : ListBateerie48;
    sortedBatteries
        .sort((a, b) => (a.price / a.ampere).compareTo(b.price / b.ampere));
    double bestCost = double.infinity;
    List<Batterie> selectedBatteries = [];

    for (int i = 0; i < sortedBatteries.length; i++) {
      int numBatteries = (consumption / sortedBatteries[i].ampere).ceil();

      double totalCost = numBatteries * sortedBatteries[i].price;

      if (totalCost < bestCost) {
        bestCost = totalCost;
        selectedBatteries =
            List.generate(numBatteries, (_) => sortedBatteries[i]);
      }
    }

    print("Selected List of Batteries:");
    selectedBatteries.forEach((battery) {
      print("Ampere: ${battery.ampere}, Price: ${battery.price}");
    });
    print("//////////////////////////////////////////");
    print(bestCost);
    return bestCost;
  }

  List<Onduleur> Onduleur_b = [
    Onduleur(3600, 2000),
    Onduleur(4500, 3000),
    Onduleur(7200, 5000),
    Onduleur(9000, 6000),
    Onduleur(14500, 10000),
    Onduleur(13500, 12000),
    Onduleur(21600, 15000),
  ];

  double getOnduleurPrice_b(double requiredPower) {
    Onduleur? cheapestOnduleur;

    for (var onduleur in Onduleur_b) {
      if (onduleur.power >= requiredPower) {
        if (cheapestOnduleur == null ||
            onduleur.price < cheapestOnduleur.price) {
          cheapestOnduleur = onduleur;
        }
      }
    }

    if (cheapestOnduleur == null) {
      return -1; // Indicate no suitable onduleur found
    } else {
      print("hezz " + cheapestOnduleur.price.toString());
      return cheapestOnduleur.price;
    }
  }
}
