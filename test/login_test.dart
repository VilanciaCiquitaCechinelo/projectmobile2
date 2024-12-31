import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pkpl/LoginPage.dart';

// Mock Classes
import 'package:pkpl/controllers/logincontroller.dart';

void main() {
  group('LoginController', () {
    testWidgets('Login berhasil dengan email dan password yang benar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    LoginController.login(context, 'test@gmail.com', 'password123');
                  },
                  child: const Text('Login'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Login berhasil!'), findsOneWidget);
    });

    testWidgets('Login gagal dengan email atau password yang salah', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    LoginController.login(context, 'salah@example.com', '1234');
                  },
                  child: const Text('Login'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Email atau password salah!'), findsOneWidget);
    });
  });
}
