import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';
import 'package:Kaledal/presentation/widgets/textfeild.dart'; // Import the flag package

class coutries extends StatefulWidget {
  final Function(String) onDataChanged;
  coutries({required this.onDataChanged});

  @override
  _coutriesState createState() => _coutriesState();
}

class _coutriesState extends State<coutries> {
  String selectedCountry = ''; // Store selected country
  bool isDropdownVisible = false; // Toggle visibility of the country list
  TextEditingController countryController = TextEditingController();
  List<Map<String, String>> countries = [
    {'country': 'United States', 'code': 'US'}, // US flag
    {'country': 'France', 'code': 'FR'}, // France flag
    {'country': 'Germany', 'code': 'DE'}, // Germany flag
    {'country': 'Morocco', 'code': 'MA'}, // Morocco flag
    {'country': 'Argentina', 'code': 'AR'}, // Argentina flag
    {'country': 'Australia', 'code': 'AU'}, // Australia flag
    {'country': 'Brazil', 'code': 'BR'}, // Brazil flag
    {'country': 'Canada', 'code': 'CA'}, // Canada flag
    {'country': 'China', 'code': 'CN'}, // China flag
    {'country': 'India', 'code': 'IN'}, // India flag
    {'country': 'Italy', 'code': 'IT'}, // Italy flag
    {'country': 'Japan', 'code': 'JP'}, // Japan flag
    {'country': 'Mexico', 'code': 'MX'}, // Mexico flag
    {'country': 'South Korea', 'code': 'KR'}, // South Korea flag
    {'country': 'Russia', 'code': 'RU'}, // Russia flag
    {'country': 'Saudi Arabia', 'code': 'SA'}, // Saudi Arabia flag
    {'country': 'Spain', 'code': 'ES'}, // Spain flag
    {'country': 'Sweden', 'code': 'SE'}, // Sweden flag
    {'country': 'United Kingdom', 'code': 'GB'}, // UK flag
    {'country': 'South Africa', 'code': 'ZA'}, // South Africa flag
    {'country': 'Egypt', 'code': 'EG'}, // Egypt flag
    {'country': 'Pakistan', 'code': 'PK'}, // Pakistan flag
    {'country': 'Turkey', 'code': 'TR'}, // Turkey flag
    {'country': 'United Arab Emirates', 'code': 'AE'}, // UAE flag
    {'country': 'Netherlands', 'code': 'NL'}, // Netherlands flag
    {'country': 'Belgium', 'code': 'BE'}, // Belgium flag
    {'country': 'Switzerland', 'code': 'CH'}, // Switzerland flag
    {'country': 'Portugal', 'code': 'PT'}, // Portugal flag
    {'country': 'Nigeria', 'code': 'NG'}, // Nigeria flag
    {'country': 'Indonesia', 'code': 'ID'}, // Indonesia flag
    {'country': 'Thailand', 'code': 'TH'}, // Thailand flag
    {'country': 'Vietnam', 'code': 'VN'}, // Vietnam flag
    {'country': 'Malaysia', 'code': 'MY'}, // Malaysia flag
    {'country': 'Singapore', 'code': 'SG'}, // Singapore flag
    {'country': 'Chile', 'code': 'CL'}, // Chile flag
    {'country': 'Peru', 'code': 'PE'}, // Peru flag
    {'country': 'Colombia', 'code': 'CO'}, // Colombia flag
    {'country': 'Poland', 'code': 'PL'}, // Poland flag
    {'country': 'Greece', 'code': 'GR'}, // Greece flag
    {'country': 'Ukraine', 'code': 'UA'}, // Ukraine flag
    {'country': 'Israel', 'code': 'IL'}, // Israel flag
    {'country': 'Lebanon', 'code': 'LB'}, // Lebanon flag
    {'country': 'Jordan', 'code': 'JO'}, // Jordan flag
    {'country': 'Kenya', 'code': 'KE'}, // Kenya flag
    {'country': 'Bangladesh', 'code': 'BD'}, // Bangladesh flag
    {'country': 'Philippines', 'code': 'PH'}, // Philippines flag
    {'country': 'New Zealand', 'code': 'NZ'}, // New Zealand flag
    {'country': 'Czech Republic', 'code': 'CZ'}, // Czech Republic flag
    {'country': 'Romania', 'code': 'RO'}, // Romania flag
    {'country': 'Hungary', 'code': 'HU'}, // Hungary flag
    {'country': 'Finland', 'code': 'FI'}, // Finland flag
    {'country': 'Denmark', 'code': 'DK'}, // Denmark flag
    {'country': 'Norway', 'code': 'NO'}, // Norway flag
    {'country': 'Ireland', 'code': 'IE'}, // Ireland flag
    {'country': 'Slovakia', 'code': 'SK'}, // Slovakia flag
    {'country': 'Croatia', 'code': 'HR'}, // Croatia flag
    {'country': 'Slovenia', 'code': 'SI'}, // Slovenia flag
    {'country': 'Bulgaria', 'code': 'BG'}, // Bulgaria flag
    {'country': 'Serbia', 'code': 'RS'}, // Serbia flag
    {'country': 'Kazakhstan', 'code': 'KZ'}, // Kazakhstan flag
    {'country': 'Uzbekistan', 'code': 'UZ'}, // Uzbekistan flag
    {'country': 'Azerbaijan', 'code': 'AZ'}, // Azerbaijan flag
    {'country': 'Armenia', 'code': 'AM'}, // Armenia flag
    {'country': 'Georgia', 'code': 'GE'}, // Georgia flag
    {'country': 'Kuwait', 'code': 'KW'}, // Kuwait flag
    {'country': 'Qatar', 'code': 'QA'}, // Qatar flag
    {'country': 'Oman', 'code': 'OM'}, // Oman flag
  ];
  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = countries;
  }

  // Filter countries based on the search input
  // Filter countries based on the search input
  void filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        // If query is empty, show the full list
        filteredCountries = countries;
      } else {
        // Filter countries based on query
        filteredCountries = countries
            .where((country) =>
                country['country']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Container(
            margin: EdgeInsets.only(top: 40), // Add space from the top
            width: MediaQuery.of(context).size.width *
                0.8, // 60% of the screen width
            child: H2TITLE(
              'Choose your country',
            ),
          ),
          SizedBox(height: 60), // Add some space between title and the rest

          // TextField for country selection
          Center(
              child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Adjust width
            /* decoration: BoxDecoration(
                border: Border.all(color: deepgrey),
                borderRadius: BorderRadius.circular(8),
              ),*/
            child: SeachFeild(
              label: '',
              controller: countryController,
              icon: Icons.search,
              hintText: 'Search',
              onchange: (query) {
                filterCountries(query); // Filter countries based on input
              },
              keyboardType: TextInputType.visiblePassword,
            ),
          )),

          // Show country list in dropdown container
          if (filteredCountries.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  var country = filteredCountries[index];
                  bool isSelected = selectedCountry == country['country'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCountry = country['country']!;
                        countryController.text = selectedCountry;
                        isDropdownVisible = false; // Close the dropdown
                      });
                      widget.onDataChanged(selectedCountry); // Send to parent
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        color: isSelected ? Colors.blue.shade100 : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Flag.fromCode(
                            getFlagCode(country['code']!),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              country['country']!,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue, // Blue background color
                                shape: BoxShape.circle, // Make it a circle
                              ),
                              padding: EdgeInsets.all(
                                  6), // Adjust padding to size the circle
                              child: Icon(
                                Icons.check,
                                color: Colors
                                    .white, // White color for the check icon
                                size: 20, // Size of the check icon
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (filteredCountries.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No countries found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  FlagsCode getFlagCode(String countryCode) {
    switch (countryCode) {
      case 'US':
        return FlagsCode.US;
      case 'FR':
        return FlagsCode.FR;
      case 'DE':
        return FlagsCode.DE;
      case 'MA':
        return FlagsCode.MA; // Morocco flag
      case 'AR':
        return FlagsCode.AR; // Argentina flag
      case 'AU':
        return FlagsCode.AU; // Australia flag
      case 'BR':
        return FlagsCode.BR; // Brazil flag
      case 'CA':
        return FlagsCode.CA; // Canada flag
      case 'CN':
        return FlagsCode.CN; // China flag
      case 'IN':
        return FlagsCode.IN; // India flag
      case 'IT':
        return FlagsCode.IT; // Italy flag
      case 'JP':
        return FlagsCode.JP; // Japan flag
      case 'MX':
        return FlagsCode.MX; // Mexico flag
      case 'KR':
        return FlagsCode.KR; // South Korea flag
      case 'RU':
        return FlagsCode.RU; // Russia flag
      case 'SA':
        return FlagsCode.SA; // Saudi Arabia flag
      case 'ES':
        return FlagsCode.ES; // Spain flag
      case 'SE':
        return FlagsCode.SE; // Sweden flag
      case 'GB':
        return FlagsCode.GB; // United Kingdom flag
      case 'ZA':
        return FlagsCode.ZA; // South Africa flag
      case 'EG':
        return FlagsCode.EG; // Egypt flag
      case 'PK':
        return FlagsCode.PK; // Pakistan flag
      case 'TR':
        return FlagsCode.TR; // Turkey flag
      case 'AE':
        return FlagsCode.AE; // United Arab Emirates flag
      case 'NL':
        return FlagsCode.NL; // Netherlands flag
      case 'BE':
        return FlagsCode.BE; // Belgium flag
      case 'CH':
        return FlagsCode.CH; // Switzerland flag
      case 'PT':
        return FlagsCode.PT; // Portugal flag
      case 'NG':
        return FlagsCode.NG; // Nigeria flag
      case 'ID':
        return FlagsCode.ID; // Indonesia flag
      case 'TH':
        return FlagsCode.TH; // Thailand flag
      case 'VN':
        return FlagsCode.VN; // Vietnam flag
      case 'MY':
        return FlagsCode.MY; // Malaysia flag
      case 'SG':
        return FlagsCode.SG; // Singapore flag
      case 'CL':
        return FlagsCode.CL; // Chile flag
      case 'PE':
        return FlagsCode.PE; // Peru flag
      case 'CO':
        return FlagsCode.CO; // Colombia flag
      case 'PL':
        return FlagsCode.PL; // Poland flag
      case 'GR':
        return FlagsCode.GR; // Greece flag
      case 'UA':
        return FlagsCode.UA; // Ukraine flag
      case 'IL':
        return FlagsCode.IL; // Israel flag
      case 'LB':
        return FlagsCode.LB; // Lebanon flag
      case 'JO':
        return FlagsCode.JO; // Jordan flag
      case 'KE':
        return FlagsCode.KE; // Kenya flag
      case 'BD':
        return FlagsCode.BD; // Bangladesh flag
      case 'PH':
        return FlagsCode.PH; // Philippines flag
      case 'NZ':
        return FlagsCode.NZ; // New Zealand flag
      case 'CZ':
        return FlagsCode.CZ; // Czech Republic flag
      case 'RO':
        return FlagsCode.RO; // Romania flag
      case 'HU':
        return FlagsCode.HU; // Hungary flag
      case 'FI':
        return FlagsCode.FI; // Finland flag
      case 'DK':
        return FlagsCode.DK; // Denmark flag
      case 'NO':
        return FlagsCode.NO; // Norway flag
      case 'IE':
        return FlagsCode.IE; // Ireland flag
      case 'SK':
        return FlagsCode.SK; // Slovakia flag
      case 'HR':
        return FlagsCode.HR; // Croatia flag
      case 'SI':
        return FlagsCode.SI; // Slovenia flag
      case 'BG':
        return FlagsCode.BG; // Bulgaria flag
      case 'RS':
        return FlagsCode.RS; // Serbia flag
      case 'KZ':
        return FlagsCode.KZ; // Kazakhstan flag
      case 'UZ':
        return FlagsCode.UZ; // Uzbekistan flag
      case 'AZ':
        return FlagsCode.AZ; // Azerbaijan flag
      case 'AM':
        return FlagsCode.AM; // Armenia flag
      case 'GE':
        return FlagsCode.GE; // Georgia flag
      case 'KW':
        return FlagsCode.KW; // Kuwait flag
      case 'QA':
        return FlagsCode.QA; // Qatar flag
      case 'OM':
        return FlagsCode.OM; // Oman flag
      default:
        return FlagsCode.GB; // Default to GB flag if not found
    }
  }
}
