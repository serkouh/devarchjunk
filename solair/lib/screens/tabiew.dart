import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:solair/archive/Constent.dart';
import 'package:solair/archive/onduleur.dart';

import 'package:solair/screens/dialog.dart';
import 'package:solair/screens/results_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solair/widgets/AmimatedTask.dart';
import 'package:solair/widgets/AnimatedTaskSansBatt.dart';
import 'package:solair/widgets/Animated_widget.dart';
import 'package:solair/widgets/Contact_developper.dart';

import '../widgets/Contactus.dart';
import '../widgets/infocardanimated.dart';

class YourClassName extends StatefulWidget {
  String kwh;
  YourClassName({Key? key, required this.kwh}) : super(key: key);

  @override
  _YourClassNameState createState() => _YourClassNameState();
}

class _YourClassNameState extends State<YourClassName>
    with SingleTickerProviderStateMixin {
  //Uint8List bytes;
  double _result = 50000;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Calcule();
  }

  double nbr_paneaux = 0;
  double anduleur = 0;
  double surface = 0;
  double nbr_paneaux_b = 0;
  double anduleur_b = 0;
  double surface_b = 0;
  double capacite_b = 0;
  double money = 0;
  double years = 0;
  double years_b = 0;
  double money_b = 0;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double indart(double number) {
    return (number / 1000).ceil() * 1000;
  }

  void Calcule() {
    OnduleurManager ond = new OnduleurManager();
    double number = double.parse(widget.kwh);
    // number = number / 1.5193;
    nbr_paneaux = (((((number / 30) * 1.2) * 0.6) / 6) / 0.285).ceilToDouble();
    anduleur = indart(nbr_paneaux * 285);
    surface = (nbr_paneaux * 0.866 * 1.640 * 0.992) * 1.05;
    nbr_paneaux_b = (((((number / 30) * 1.2) * 1) / 6) / 0.285).ceilToDouble();
    anduleur_b = indart(nbr_paneaux_b * 285);
    print("anduleur : " + anduleur_b.toString());
    surface_b = (nbr_paneaux_b * 0.866 * 1.640 * 0.992) * 1.05;
    capacite_b = ((((number * 1000) / 30) * 1.2) * 0.5) /
        (0.8 * anduleur_b <= 3000 ? 24 : 48);
    double temp = (nbr_paneaux * 1100 +
        ond.getOnduleurPrice(anduleur) +
        nbr_paneaux * 175);
    print(temp);
    money = temp + (temp * 0.2) + (temp * 0.1) + 2500;
    double temp2 = (nbr_paneaux_b * 1100 +
        ond.getOnduleurPrice_b(anduleur_b) +
        nbr_paneaux_b * 175);
    money_b = temp2 +
        temp2 * 0.2 +
        temp2 * 0.1 +
        500 +
        ond.getBestBatteryCombinationTotalPrice(capacite_b, anduleur_b <= 3000);
    years = money / (number * 1.5193 * 12) * (1 / 0.7);
    years_b = money_b / (number * 1.5193 * 12);
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return SafeArea(
        child: Scaffold(
            /* appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 5, 135, 5),
              elevation: 0,
              toolbarHeight: 40,
              title: Text('Your Page Title'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the page
                  },
                ),
              ],
            ),*/
            /* floatingActionButton: Container(
                width: size,
                child:),*/
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Container(
              // padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: darkblue,
                      /*  borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),*/
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    //  margin: EdgeInsets.symmetric(horizontal: 12),*/
                    decoration: BoxDecoration(
                      color: darkblue,
                      /*  borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),*/
                    ),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons
                                  .power_off), // Power plug icon or any suitable icon
                              SizedBox(width: 5),
                              Text('Sans batterie'),
                            ],
                          ),
                        ),
                        Tab(
                          icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons
                                  .battery_full), // Standard battery icon or any suitable icon
                              SizedBox(width: 5),
                              Text('Avec batterie'),
                            ],
                          ),
                        ),
                      ],
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      indicatorWeight: 2, // Thickness of the indicator

                      indicatorColor: Colors.white,
                      labelColor: darkblue,
                      unselectedLabelColor: Colors.white,
                      unselectedLabelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                            child: Container(
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      top: 16, left: 16, right: 16),
                                  child: Column(children: [
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 10),
                                          /* Container(
                                            height: 40,
                                            child: Text(
                                              'Calcule  Financières',
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 5, 135, 5),
                                              ),
                                            ),
                                          ),*/
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              AnimatedInfoCard(
                                                  title:
                                                      "Coût total de l'installation en Dh",
                                                  value:
                                                      money.toStringAsFixed(0) +
                                                          " Dh",
                                                  icon: Icons.attach_money,
                                                  color: Colors.grey[200]!,
                                                  image:
                                                      "money-illustration-free-vector-removebg-preview-removebg-preview.png"),
                                              AnimatedInfoCard(
                                                title:
                                                    "Récupération des frais ",
                                                value:
                                                    years.toStringAsFixed(1) +
                                                        " ans",
                                                icon: Icons.access_time,
                                                color: Colors.grey[200]!,
                                                image:
                                                    "Screenshot 2024-03-05 204953-Photoroom.png",
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              AnimatedInfoCard(
                                                title:
                                                    'Années gagnées gratuitement',
                                                value: (25 - years)
                                                        .toStringAsFixed(1) +
                                                    " ans",
                                                icon: Icons.thumb_up,
                                                color: Colors.grey[200]!,
                                                image:
                                                    "Screenshot_2024-02-28_125538-removebg-preview.png",
                                              ),
                                              AnimatedInfoCard(
                                                  title:
                                                      'Retour sur investissement',
                                                  value: (((25 - years) /
                                                                  years) *
                                                              100)
                                                          .toStringAsFixed(0) +
                                                      "%",
                                                  icon: Icons.trending_up,
                                                  color: Colors.grey[200]!,
                                                  image:
                                                      "Screenshot 2024-03-05 204720-Photoroom.png"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size * 0.5,
                                      height: 40,
                                      child: Divider(
                                        color: darkblue,
                                        thickness: 1.5,
                                      ),
                                    ),
                                    AnimatedPopupContainerSansBatt(
                                      inverterText: anduleur.toStringAsFixed(0),
                                      panelText: nbr_paneaux.toStringAsFixed(0),
                                      surfaceText:
                                          '${surface.toStringAsFixed(0)}',
                                    ),
                                  ])),
                              Container(
                                width: size * 0.5,
                                height: 40,
                                child: Divider(
                                  color: darkblue,
                                  thickness: 1.5,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: darkblue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Profitez également de',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: size * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white, // White background color
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the border radius as needed
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // Changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildInnerContainer(
                                            Border(
                                              right: BorderSide(
                                                  color: darkblue, width: 1.0),
                                              bottom: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/trendy-safe-energy-vector-Photoroom.png-Photoroom.png',
                                            "Securité énergétique"),
                                        _buildInnerContainer(
                                            Border(
                                              left: BorderSide(
                                                  color: darkblue, width: 1.0),
                                              bottom: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/coins-finance-capital-gold-income-flat-color-icon-free-vector-Photoroom.png-Photoroom.png',
                                            "Protection contre les aléas énergétiques"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        _buildInnerContainer(
                                            Border(
                                              right: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/property-value-isometric-icon-eps-10-vector-Photoroom.png-Photoroom.png',
                                            "Valoriser vos actifs."),
                                        _buildInnerContainer(
                                            Border(
                                              left: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/clean-energy-sustainable-renewable-green-leaf-lightbulb-vector-illustration-Photoroom.png-Photoroom.png',
                                            "Autonomie"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: size * 0.5,
                                height: 40,
                                child: Divider(
                                  color: darkblue,
                                  thickness: 1.5,
                                ),
                              ),
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(-1.0, 0.0),
                                text: 'Obtenez un devis détaillé gratuit.',
                                icon: Icons.request_quote,
                                buttonColor: darkblue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 5),
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(1.0, 0.0),
                                text: 'Nous contacter',
                                icon: Icons.email,
                                buttonColor: Color(0xFF224C98),
                                onPressed: () {
                                  double height =
                                      MediaQuery.of(context).size.height * 0.8;
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    elevation: 4,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: height,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: ContactUs(),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 5),
                              /*  AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(-1.0, 0.0),
                                text: 'Découvrir d\'autres solutions digitales',
                                icon: Icons.computer_rounded,
                                buttonColor: mediumblue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ImageDialog();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 5),*/
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(-1.0, 0.0),
                                text: 'Service informatique',
                                icon: Icons.code_outlined,
                                buttonColor: LightBlue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ContactDevelopper();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )),
                        SingleChildScrollView(
                            child: Container(
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      top: 24, left: 16, right: 16),
                                  child: Column(children: [
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              AnimatedInfoCard(
                                                  title:
                                                      "Coût total de l'installation en Dh",
                                                  value: money_b
                                                          .toStringAsFixed(0) +
                                                      " Dh",
                                                  icon: Icons.attach_money,
                                                  color: Colors.grey[200]!,
                                                  image:
                                                      "money-illustration-free-vector-removebg-preview-removebg-preview.png"),
                                              AnimatedInfoCard(
                                                title:
                                                    "Récupération des frais ",
                                                value:
                                                    years_b.toStringAsFixed(1) +
                                                        " ans",
                                                icon: Icons.access_time,
                                                color: Colors.grey[200]!,
                                                image:
                                                    "Screenshot 2024-03-05 204953-Photoroom.png",
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              AnimatedInfoCard(
                                                title:
                                                    'Années gagnées gratuitement',
                                                value: (25 - years_b)
                                                        .toStringAsFixed(1) +
                                                    " ans",
                                                icon: Icons.thumb_up,
                                                color: Colors.grey[200]!,
                                                image:
                                                    "Screenshot_2024-02-28_125538-removebg-preview.png",
                                              ),
                                              AnimatedInfoCard(
                                                  title:
                                                      'Retour sur investissement',
                                                  value: (((25 - years_b) /
                                                                  years_b) *
                                                              100)
                                                          .toStringAsFixed(0) +
                                                      "%",
                                                  icon: Icons.trending_up,
                                                  color: Colors.grey[200]!,
                                                  image:
                                                      "Screenshot 2024-03-05 204720-Photoroom.png"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size * 0.5,
                                      height: 40,
                                      child: Divider(
                                        color: darkblue,
                                        thickness: 1.5,
                                      ),
                                    ),
                                    AnimatedPopupContainer(
                                      batteryText: capacite_b
                                              .toStringAsFixed(0) +
                                          " Ah - " +
                                          (anduleur_b <= 3000 ? "24" : "48") +
                                          " V",
                                      inverterText:
                                          anduleur_b.toStringAsFixed(0),
                                      panelText:
                                          nbr_paneaux_b.toStringAsFixed(0),
                                      surfaceText: surface_b.toStringAsFixed(0),
                                    ),
                                  ])),
                              Container(
                                width: size * 0.5,
                                height: 40,
                                child: Divider(
                                  color: darkblue,
                                  thickness: 1.5,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: darkblue,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Profitez également de',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: size * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white, // White background color
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the border radius as needed
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // Changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildInnerContainer(
                                            Border(
                                              right: BorderSide(
                                                  color: darkblue, width: 1.0),
                                              bottom: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/trendy-safe-energy-vector-Photoroom.png-Photoroom.png',
                                            "Securité énergétique"),
                                        _buildInnerContainer(
                                            Border(
                                              left: BorderSide(
                                                  color: darkblue, width: 1.0),
                                              bottom: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/coins-finance-capital-gold-income-flat-color-icon-free-vector-Photoroom.png-Photoroom.png',
                                            "Protection contre les aléas énergétiques"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        _buildInnerContainer(
                                            Border(
                                              right: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/property-value-isometric-icon-eps-10-vector-Photoroom.png-Photoroom.png',
                                            "Valoriser vos actifs."),
                                        _buildInnerContainer(
                                            Border(
                                              left: BorderSide(
                                                  color: darkblue, width: 1.0),
                                            ),
                                            'Assets/clean-energy-sustainable-renewable-green-leaf-lightbulb-vector-illustration-Photoroom.png-Photoroom.png',
                                            "Autonomie"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: size * 0.5,
                                height: 40,
                                child: Divider(
                                  color: darkblue,
                                  thickness: 1.5,
                                ),
                              ),
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(-1.0, 0.0),
                                text: 'Obtenez un devis détaillé gratuit.',
                                icon: Icons.request_quote,
                                buttonColor: darkblue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialog();
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 5),
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(1.0, 0.0),
                                text: 'Nous contacter',
                                icon: Icons.email,
                                buttonColor: Color(0xFF224C98),
                                onPressed: () {
                                  double height =
                                      MediaQuery.of(context).size.height * 0.8;
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    elevation: 4,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: height,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: ContactUs(),
                                      );
                                    },
                                  );
                                },
                              ),
                              /* SizedBox(height: 5),
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(-1.0, 0.0),
                                text: 'Découvrir d\'autres solutions digitales',
                                icon: Icons.computer_rounded,
                                buttonColor: mediumblue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ImageDialog();
                                    },
                                  );
                                },
                              ),*/
                              SizedBox(height: 5),
                              AnimatedCustomButton(
                                last: false,
                                startPosition: Offset(-1.0, 0.0),
                                text: 'Service informatique',
                                icon: Icons.code_outlined,
                                buttonColor: LightBlue,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ContactDevelopper();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  //  Text('Result: $_result'),
                ],
              ),
            )));
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color, String image) {
    double size = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width > 600) {
      size = 500;
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: size * 0.42,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [color, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "Assets/$image",
                  height: 35,
                  width: 35,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 12),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 35,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInnerContainer(Border border, String imagePath, String text) {
  return Expanded(
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        border: border,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 4,
          ),
          /*SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),*/
          Icon(
            Icons.check_circle_outline,
            color: darkgreen,
            size: 30,
          ),
          SizedBox(width: 8), // Add some spacing between the image and text
          Expanded(
            child: AutoSizeText(
              text, textAlign: TextAlign.center,
              maxLines: 2, // Limit text to one line
              overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
            ),
          ),
          SizedBox(
            width: 4,
          ),
        ],
      ),
    ),
  );
}
