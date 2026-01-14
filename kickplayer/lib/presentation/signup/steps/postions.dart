import 'package:flutter/material.dart';
import 'package:Kaledal/presentation/widgets/Texts.dart';

class PositionSelection extends StatefulWidget {
  final Function(List<String>) onDataChanged;
  PositionSelection({required this.onDataChanged});

  @override
  _PositionSelectionState createState() => _PositionSelectionState();
}

class _PositionSelectionState extends State<PositionSelection> {
  final GlobalKey _imageKey = GlobalKey();

  final Map<String, Offset> baseCoordinates = {
    'Goalkeeper': Offset(150, 30),
    'Right Back': Offset(240, 100),
    'Left Back': Offset(60, 100),
    'Center Back 1': Offset(150, 100),
    'Center Back 2': Offset(150, 130),
    'Defensive Midfielder': Offset(150, 200),
    'Central Midfielder': Offset(150, 250),
    'Attacking Midfielder': Offset(150, 300),
    'Right Winger': Offset(230, 250),
    'Left Winger': Offset(70, 250),
    'Striker': Offset(150, 350),
  };

  List<Map<String, dynamic>> tappedPositions = [];

  void _handleTap(TapUpDetails details) {
    final renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    Offset localPosition = renderBox.globalToLocal(details.globalPosition);

    String positionName = _getClosestPosition(localPosition);

    setState(() {
      var existing = tappedPositions.firstWhere(
        (entry) => (entry['position'] - localPosition).distance < 25,
        orElse: () => {},
      );

      if (existing.isNotEmpty) {
        tappedPositions
            .removeWhere((entry) => entry['name'] == existing['name']);
      } else {
        if (tappedPositions.length >= 3) return;
        tappedPositions.add({'position': localPosition, 'name': positionName});
      }

      widget.onDataChanged(
          tappedPositions.map((e) => e['name'] as String).toList());
    });
  }

  String _getClosestPosition(Offset tapped) {
    double minDist = double.infinity;
    String closest = 'Unknown';
    baseCoordinates.forEach((name, coord) {
      double dist = (tapped - coord).distance;
      if (dist < minDist) {
        minDist = dist;
        closest = name;
      }
    });
    return closest;
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final imageWidth = screenW * 0.8;
    final imageHeight = imageWidth * 4 / 3;

    // Ratio to adjust positions based on image size
    final double ratioX = imageWidth / 300;
    final double ratioY = imageHeight / 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTapUp: _handleTap,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  width: screenW * 0.85,
                  child: H2TITLE('What is your preferred position ?'),
                ),
                SizedBox(height: 30),
                Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/image 96.png',
                        key: _imageKey,
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.contain,
                      ),
                      ...tappedPositions.map((entry) {
                        return Positioned(
                          left: entry['position'].dx * ratioX - 12,
                          top: entry['position'].dy * ratioY - 12,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
