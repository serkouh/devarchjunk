import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';

class PasswordAndSecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_SecurityOption> options = [
      _SecurityOption(title: 'Change Password', onTap: () {}),
      _SecurityOption(title: 'Two-Factor Authentication (2FA)', onTap: () {}),
      _SecurityOption(title: 'Manage Trusted Devices', onTap: () {}),
      _SecurityOption(title: 'Login Activity', onTap: () {}),
      _SecurityOption(
          title: 'Security Alerts and  Recovery Options', onTap: () {}),
      _SecurityOption(
        title: 'Deactivate or Delete Account',
        onTap: () {},
        isDestructive: true,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Password and Security',
          style: TextStyle(
            color: deepBlueColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: options.length,
        separatorBuilder: (context, index) => Container(height: 0),
        itemBuilder: (context, index) {
          final option = options[index];
          return _buildTile(option.title, option.onTap,
              isDestructive: option.isDestructive);
        },
      ),
    );
  }

  Widget _buildTile(String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _SecurityOption {
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  _SecurityOption({
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}
