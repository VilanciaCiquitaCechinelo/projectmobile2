import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:pkpl/controllers/intl.dart';
import 'package:pkpl/views/profilescreen.dart';
import 'package:pkpl/views/schedulescreen.dart';
import 'dart:async';

import '../loginpage.dart';
import '../models/websitebox_models.dart';
import 'musicscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginPage _auth = Get.put(LoginPage());
  int remainingHours = 0;
  int remainingMinutes = 0;
  int remainingSeconds = 0;
  bool isCountingDown = false;
  Timer? countdownTimer;

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Time's Up"),
          content: Text('The countdown has finished.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void startCountdown(int hours, int minutes) {
    setState(() {
      isCountingDown = true;
      remainingHours = hours;
      remainingMinutes = minutes;
      remainingSeconds = 0;
    });

    const oneSecond = Duration(seconds: 1);
    countdownTimer = Timer.periodic(oneSecond, (Timer timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else if (remainingMinutes > 0) {
        setState(() {
          remainingMinutes--;
          remainingSeconds = 59;
        });
      } else if (remainingHours > 0) {
        setState(() {
          remainingHours--;
          remainingMinutes = 59;
          remainingSeconds = 59;
        });
      } else {
        setState(() {
          isCountingDown = false;
        });
        timer.cancel();
        _showTimeUpDialog();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _auth.logout(context); // Ensure your logout logic works correctly
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1 - Home Screen Content
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hello There,\n',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'You had a good Sleep last night',
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Ideal hours of sleep',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '7h 30m',
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 90.0),
                          ElevatedButton(
                            onPressed: isCountingDown ? null : () => startCountdown(7, 30),
                            child: Text('Mulai'),
                          ),
                          ElevatedButton(
                            onPressed: isCountingDown
                                ? () {
                              countdownTimer?.cancel();
                              setState(() {
                                isCountingDown = false;
                                remainingHours = 0;
                                remainingMinutes = 0;
                                remainingSeconds = 0;
                              });
                            }
                                : null,
                            child: Text('Stop'),
                          ),
                        ],
                      ),
                      Text(
                        'Remaining Time: ${remainingHours.toString().padLeft(2, '0')}h ${remainingMinutes.toString().padLeft(2, '0')}m ${remainingSeconds.toString().padLeft(2, '0')}s',
                        style: TextStyle(fontSize: 10.0, color: Colors.white),
                      ),
                      SizedBox(height: 30),
                      WebsiteLinkBox(url: 'https://www.example1.com'),
                      SizedBox(height: 20),
                      WebsiteLinkBox(url: 'https://www.example2.com'),
                      SizedBox(height: 20),
                      WebsiteLinkBox(url: 'https://www.example3.com'),
                    ],
                  ),
                ),
              ],
            ),
            // Tab 2 - MusicScreen
            MusicScreen(),
            // Tab 3 - ScheduleScreen
            ScheduleScreen(),
            // Tab 4 - ProfileScreen
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home, color: Colors.black)),
            Tab(icon: Icon(Icons.queue_music_rounded, color: Colors.black)),
            Tab(icon: Icon(Icons.schedule, color: Colors.black)),
            Tab(icon: Icon(Icons.person, color: Colors.black)),
          ],
          indicatorColor: Colors.white,
        ),
      ),
    );
  }
}





