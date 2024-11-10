import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pkpl/controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final box = GetStorage();

  ProfileScreen() {
    nameController.text = box.read('name') ?? 'Fadhil Rahman';
    phoneController.text = box.read('phone') ?? '0812-8877-3590';
    locationController.text = box.read('location') ?? 'Malang, Indonesia';
    birthdayController.text = box.read('birthday') ?? '17 Nov 2003';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // Membungkus dengan SingleChildScrollView agar bisa discroll
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: controller.imagePath.value.isNotEmpty
                              ? FileImage(File(controller.imagePath.value))
                              : null,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Text(
                    'Your information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  buildEditableInfoColumn('Name', nameController),
                  buildEditableBirthdayColumn(context),
                  SizedBox(height: 20),
                  buildEditableInfoColumn('Phone', phoneController),
                  buildEditableInfoColumn('Location', locationController),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (validateFields(context)) {
                        saveData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data berhasil disimpan.')),
                        );
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableInfoColumn(String title, TextEditingController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your $title',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditableBirthdayColumn(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Birthday',
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
                birthdayController.text = formattedDate;
                box.write('birthday', formattedDate);
              }
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white, size: 16),
                SizedBox(width: 5),
                Text(
                  birthdayController.text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validateFields(BuildContext context) {
    if (nameController.text.length > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama tidak boleh lebih dari 30 karakter.')),
      );
      return false;
    }

    if (phoneController.text.isEmpty || !RegExp(r'^\d+$').hasMatch(phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nomor telepon hanya boleh mengandung angka dan tidak boleh kosong.')),
      );
      return false;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(locationController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi hanya boleh mengandung huruf dan spasi.')),
      );
      return false;
    }

    return true;
  }

  void saveData() {
    box.write('name', nameController.text);
    box.write('phone', phoneController.text);
    box.write('location', locationController.text);
    box.write('birthday', birthdayController.text);
  }
}
