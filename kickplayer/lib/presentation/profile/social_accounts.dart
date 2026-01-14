import 'package:flutter/material.dart';

class LinkedAccountsPage extends StatelessWidget {
  final List<SocialAccount> accounts = [
    SocialAccount(
      name: "Google",
      logo: "assets/images/image 17.png",
      isConnected: true,
    ),
    SocialAccount(
      name: "Facebook",
      logo: "assets/images/Facebook_Logo_Primary 1.png",
      isConnected: false,
    ),
    SocialAccount(
      name: "Instagram",
      logo: "assets/images/Frame 818.png",
      isConnected: true,
    ),
    SocialAccount(
      name: "X",
      logo: "assets/images/Frame 818 (1).png",
      isConnected: false,
    ),
    SocialAccount(
      name: "Apple ID",
      logo: "assets/images/Frame 818 (2).png",
      isConnected: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Linked Accounts',
          style: TextStyle(
            color: Colors.blue[900],
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "Manage and connect your social media accounts for easy login and sharing.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  leading: Image.asset(
                    account.logo,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(
                    account.name,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: account.isConnected
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Connected',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.edit, color: Colors.green, size: 18),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Connect',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.add, color: Colors.grey, size: 18),
                          ],
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Handle save changes
              },
              child: Text(
                "Save Changes",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialAccount {
  final String name;
  final String logo;
  final bool isConnected;

  SocialAccount({
    required this.name,
    required this.logo,
    required this.isConnected,
  });
}
