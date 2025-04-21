import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const String baseUrl = "baseurl";

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    String? token = await _getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await _sendRequest(http.post(url, headers: headers, body: jsonEncode(body)), url);
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    String? token = await _getToken();

    final headers = {
      'Authorization': 'Bearer $token',
    };
    return await _sendRequest(http.get(url, headers: headers), url);
  }

  static Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    String? token = await _getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return await _sendRequest(http.patch(url, headers: headers, body: jsonEncode(body)), url);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    String? token = await _getToken();

    final headers = {
      'Authorization': 'Bearer $token',
    };
    return await _sendRequest(http.delete(url, headers: headers), url);
  }

  // PUT Request
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    String? token = await _getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return await _sendRequest(http.put(url, headers: headers, body: jsonEncode(body)), url);
  }

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
    
  }

  static Future<Map<String, dynamic>> _sendRequest(Future<http.Response> request, Uri url) async {
    try {
      final response = await request;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'error': errorData['error'] ?? 'Something went wrong'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }
}
