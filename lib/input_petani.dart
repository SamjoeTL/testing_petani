import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_to_list_flutter/Service/apistatic.dart';
import 'package:json_to_list_flutter/models/kelompoktani.dart';
import 'package:json_to_list_flutter/utils/const.dart';
import 'package:json_to_list_flutter/models/petani.dart';
import 'dart:async';

class InputPetani extends StatefulWidget {
  @override
  _InputPetaniState createState() => _InputPetaniState();
}

class _InputPetaniState extends State<InputPetani> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  Kelompok? _selectedKelompok;
  String _selectedStatus = 'N';
  List<Kelompok> _kelompokList = [];

  final ApiStatic apiService = ApiStatic();

  void postData(Petani petani) async {
  final url = '$host/api/petani?s=';
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'nama': petani.nama,
    'nik': petani.nik,
    'alamat': petani.alamat,
    'telp': petani.telp,
    'idKelompok': _selectedKelompok!.idKelompokTani,
    'status': _selectedStatus
  });

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Data berhasil dikirim');
      showSnackBar('Data berhasil dikirim');
    } else {
      final error = json.decode(response.body)['error'];
      print('Gagal mengirim data. Error: $error');
      showSnackBar('Gagal mengirim data. Error: $error');
    }
  } catch (error) {
    print('Terjadi kesalahan saat mengirim data. Error: $error');
    showSnackBar('Terjadi kesalahan saat mengirim data. Error: $error');
  }
}

Future<void> getKelompokTani() async {
  final url = '$host/api/kelompoktani';
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _kelompokList = List<Kelompok>.from(data.map((x) => Kelompok.fromJson(x)));
      });
    } else {
      print('Gagal mendapatkan data kelompok tani');
    }
  } catch (error) {
    print('Terjadi kesalahan saat mendapatkan data kelompok tani');
  }
}


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    getKelompokTani();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // ...
      appBar: AppBar(
        title: Text('Input Petani'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: nikController,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: telpController,
              decoration: InputDecoration(labelText: 'Telepon'),
            ),
            SizedBox(height: 16.0),
           DropdownButtonFormField<Kelompok>(
  value: _selectedKelompok,
  onChanged: (newValue) {
    setState(() {
      _selectedKelompok = newValue;
    });
  },
  items: _kelompokList.isNotEmpty
      ? _kelompokList.map<DropdownMenuItem<Kelompok>>((Kelompok kelompok) {
          return DropdownMenuItem<Kelompok>(
            value: kelompok,
            child: Text(kelompok.namaKelompok),
          );
        }).toList()
      : [],
  decoration: const InputDecoration(
    labelText: 'Kelompok Tani',
  ),
  validator: (value) {
    if (value == null) {
      return 'Pilih kelompok tani';
    }
    return null;
  },
),
           SizedBox(height: 16.0),
            const Text("Status:"),
            ListTile(
              title: const Text("N"),
              leading: Radio<String>(
                value: "N",
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Y"),
              leading: Radio<String>(
  value: "Y",
  onChanged: (value) {
    setState(() {
      _selectedStatus = value!;
    });
  },
  groupValue: _selectedStatus,
),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Membuat objek Petani dari input pengguna
                Petani petani = Petani(
                  nama: namaController.text,
                  nik: nikController.text,
                  alamat: alamatController.text,
                  telp: telpController.text,
                );

                if (_selectedKelompok != null) {
      
                postData(petani);
                 } else {
               showSnackBar('Pilih kelompok tani');
              }
              },
              child: Text('Kirim Data'),
            ),
          ],
        ),
      ),
    );
  }
}