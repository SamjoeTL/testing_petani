import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_to_list_flutter/models/petani.dart';
import 'package:json_to_list_flutter/models/kelompoktani.dart';
import 'package:json_to_list_flutter/models/errorMSG.dart';
import 'package:json_to_list_flutter/utils/const.dart';


class ApiStatic {
  //static final host='http://192.168.43.189/webtani/public';
  static var _token = "8|x6bKsHp9STb0uLJsM11GkWhZEYRWPbv0IqlXvFi7";
  static Future<List<Petani>> getPetani(String s) async {
    try {
      final response =
          await http.get(Uri.parse("$host/api/petani?s="), headers: {
        'Authorization': 'Bearer ' + _token,
      });
      // print('ss1');
      if (response.statusCode == 200) {
        //print('ss2');
        var json = jsonDecode(response.body);
        //print(json);
        final parsed = json['data'].cast<Map<String, dynamic>>();
        return parsed.map<Petani>((json) => Petani.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
   static Future<ErrorMSG> postPetani(petani) async {
    try {
      print(petani);
      var url = Uri.parse('https://dev.wefgis.com/api/petani');

      var request = http.MultipartRequest('POST', url);
      request.fields['nama'] = petani.nama;
      request.fields['nik'] = petani.nik;
      request.fields['alamat'] = petani.alamat;
      request.fields['telp'] = petani.telp;
      request.fields['status'] = petani.status;
      request.fields['id_kelompok_tani'] = petani.idKelompokTani;

      request.headers.addAll({
        'Authorization': 'Bearer ' + _token,
      });
      var response = await request.send();

      if (response.statusCode == 200) {
        // return Petani.fromJson(jsonDecode(response.body));
        final respStr = await response.stream.bytesToString();
        print(jsonDecode(respStr));
        // print(respStr);

        // return Petani.fromJson(jsonDecode(response.body));
        return ErrorMSG.fromJson(jsonDecode(respStr));
        // return ErrorMSG.fromJson(jsonDecode(respStr));
      } else {
        //return ErrorMSG.fromJson(jsonDecode(response.body));
        // return ErrorMSG(success: false, message: 'err Request');

        throw Exception('Failed to update petani');
      }
    } catch (e) {
      // ErrorMSG responseRequest =
      //     ErrorMSG(success: false, message: 'error caught: $e');
      // return responseRequest;
      print(e);
      throw Exception('Error $e');
    }
  }
  Future<List<Kelompok>> getKelompokTani() async {
    try {
      final response =
          await http.get(Uri.parse("$host/api/kelompoktani"), headers: {
        'Authorization': 'Bearer ' + _token,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final parsed = json.cast<Map<String, dynamic>>();
        return parsed.map<Kelompok>((json) => Kelompok.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}