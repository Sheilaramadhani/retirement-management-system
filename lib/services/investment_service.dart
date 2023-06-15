import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:retirement_management_system/data/models.dart';

class InvestmentService {
  final String _baseUrl = "https://www.foreign.go.tz/services/opportunities-for-investment-in-tanzania"; // Replace with your API endpoint URL

  Future<List<Investment>> fetchInvestments() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Investment> investments =
          data.map((json) => Investment.fromJson(json)).toList();

      return investments;
    } else {
      throw Exception('Failed to fetch investments');
    }
  }

  Future<Investment> addInvestment(Investment investment) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(investment.toJson()),
    );

    if (response.statusCode == 201) {
      final dynamic data = jsonDecode(response.body);
      final Investment newInvestment = Investment.fromJson(data);

      return newInvestment;
    } else {
      throw Exception('Failed to add investment');
    }
  }

  Future<Investment> updateInvestment(Investment investment) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${investment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(investment.toJson()),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      final Investment updatedInvestment = Investment.fromJson(data);

      return updatedInvestment;
    } else {
      throw Exception('Failed to update investment');
    }
  }

  Future<void> deleteInvestment(String investmentId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$investmentId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete investment');
    }
  }

  static getInvestments() {}

  static getAccounts() {}
}
