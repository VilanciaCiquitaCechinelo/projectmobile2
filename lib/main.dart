import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:pkpl/RegisterPage.dart';
import 'package:pkpl/admin_loginpage.dart';
import 'package:pkpl/loginpage.dart';
import 'package:pkpl/views/homescreen.dart';
import 'package:pkpl/views/musicscreen.dart';
import 'package:pkpl/views/profilescreen.dart';
import 'package:pkpl/views/schedulescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'notification.dart';
import 'package:appwrite/appwrite.dart';
import 'welcome_page.dart';

void main() async {
  Client client = Client();
  client
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('6569c7ecc40e71246d2f')
      .setSelfSigned(); // For self-signed certificates, only use for development

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  await FirebaseMessagingHandler().initPushNotification();
  // await FirebaseMessagingHandler().initLocalNotification();

  runApp(
    MaterialApp(
      home: DefaultTabController(
        length: 6, // Menambahkan satu tab untuk Admin
        child: Scaffold(
          extendBody: true, // Membuat latar belakang memperpanjang di bawah navbar
          backgroundColor: Colors.transparent, // Mengatur latar belakang Scaffold menjadi transparan
          body: TabBarView(
            children: [
              WelcomePage(),
              LoginPage(),
              RegisterPage(),
              HomeScreen(),
              MusicScreen(),
              ScheduleScreen(),
              ProfileScreen(),
              // AdminLoginPage(), // Halaman Login Admin
            ],
          ),
          bottomNavigationBar: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Colors.purple,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.queue_music_rounded,
                  color: Colors.purple,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.schedule,
                  color: Colors.purple,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:pkpl/loginpage.dart';
// import 'package:pkpl/views/homescreen.dart';
// import 'package:pkpl/views/musicscreen.dart';
// import 'package:pkpl/views/profilescreen.dart';
// import 'package:pkpl/views/schedulescreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'firebase_options.dart';
// import 'notification.dart';
// import 'package:appwrite/appwrite.dart';
//
// void main() async {
//
//   Client client = Client();
//   client
//       .setEndpoint('https://cloud.appwrite.io/v1')
//       .setProject('6569c7ecc40e71246d2f')
//       .setSelfSigned(); // For self-signed certificates, only use for development
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await Get.putAsync(() async => await SharedPreferences.getInstance());
//   await FirebaseMessagingHandler().initPushNotification();
//   // await FirebaseMessagingHandler().initLocalNotification();
//
//   runApp(
//     MaterialApp(
//       home: DefaultTabController(
//         length: 5,
//         child: Scaffold(
//           extendBody: true, // Membuat latar belakang memperpanjang di bawah navbar
//           backgroundColor: Colors.transparent, // Mengatur latar belakang Scaffold menjadi transparan
//           body: TabBarView(
//             children: [
//               LoginPage(),
//               HomeScreen(),
//               MusicScreen(),
//               ScheduleScreen(),
//               ProfileScreen(),
//
//             ],
//           ),
//           bottomNavigationBar: const TabBar(
//             tabs: [
//               Tab(
//                 icon: Icon(
//                   Icons.home,
//                   color: Colors.purple,
//                 ),
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.queue_music_rounded,
//                   color: Colors.purple,
//                 ),
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.schedule,
//                   color: Colors.purple,
//                 ),
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.person,
//                   color: Colors.purple,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
