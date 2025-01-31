import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/schedule/hability_model.dart';

class HabilityService {
  final String apiUrl = 'http://192.168.1.9:8080/schedule/hability';

  Future<List<HabilityModel>> fetchHabilities() async {
    final res = await http.get(Uri.parse(apiUrl));
    if(res.statusCode == 200){
      List<dynamic> jsonData = jsonDecode(res.body);
      return jsonData.map((habil) => HabilityModel.fromJson(habil)).toList();
    } else {
      throw Exception('Error al cargar las habilidades');
    }
  }
}