import 'package:flutter/material.dart';
import 'package:pkpl/RegisterPage.dart';
import 'package:pkpl/admin_loginpage.dart';  // Import AdminLoginPage

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Selection'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Please select your login type:'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman Login dan Register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()), // Halaman LoginPage
                );
              },
              child: const Text('Login as User'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke AdminLoginPage saat klik Login as Admin
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()), // Navigasi ke halaman Admin Login
                );
              },
              child: const Text('Login as Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
