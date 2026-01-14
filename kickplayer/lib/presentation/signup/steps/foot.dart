import 'package:flutter/material.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';

class FootSelection extends StatefulWidget {
  final Function(String) onDataChanged;
  FootSelection({required this.onDataChanged});

  @override
  _FootSelectionState createState() => _FootSelectionState();
}

class _FootSelectionState extends State<FootSelection> {
  bool isLeftFootSelected = false;
  bool isRightFootSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        width: screenWidth * 0.65,
                        child: H2TITLE('What is your preferred foot?'),
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLeftFootSelected = !isLeftFootSelected;
                              });
                              _updateFootSelection();
                            },
                            child: Image.asset(
                              !isLeftFootSelected
                                  ? 'assets/images/footSHEOS  2.png'
                                  : 'assets/images/football sheos 1.png',
                              width: screenWidth * 0.3,
                              height: screenHeight * 0.35,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.08),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRightFootSelected = !isRightFootSelected;
                              });
                              _updateFootSelection();
                            },
                            child: Image.asset(
                              !isRightFootSelected
                                  ? 'assets/images/footSHEOS  1.png'
                                  : 'assets/images/football sheos 3.png',
                              width: screenWidth * 0.3,
                              height: screenHeight * 0.35,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateFootSelection() {
    String selectedFoot = '';

    if (isLeftFootSelected && isRightFootSelected) {
      selectedFoot = 'Both';
    } else if (isLeftFootSelected) {
      selectedFoot = 'Left';
    } else if (isRightFootSelected) {
      selectedFoot = 'Right';
    } else {
      selectedFoot = 'None';
    }

    widget.onDataChanged(selectedFoot);
  }
}
