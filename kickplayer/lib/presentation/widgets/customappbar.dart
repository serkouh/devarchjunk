import 'package:Kaledal/core/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          SizedBox(
            height: 30,
            child: Image.asset("assets/images/vector.png"),
          ),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: deepBlueColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Single Support Icon
          InkWell(
            onTap: () {
              // Handle support icon tap
            },
            child: Icon(
              Icons.support_agent,
              color: deepBlueColor,
              size: 28,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey[300],
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class SpecialCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SpecialCustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // KickPlayer title using Google Font
          Text(
            "KickPlayer",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Challenges Icon
          IconButton(
            onPressed: () {
              // TODO: Handle Challenges tap
            },
            icon: Icon(
              Icons.flag, // You can replace this with another icon
              size: 28,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
