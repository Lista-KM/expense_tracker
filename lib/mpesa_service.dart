import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart'; // Import the logging package

class MpesaService {
  static const String consumerKey =
      'EKlVfVGUInv2FArtvGSLmBBxL9XFNpiXcxPkgWE4ZAG5xiFQ';
  static const String consumerSecret =
      'Us9iG7eVlAGZ8wGNY06T7v9yZtr6onTVAqTesSEowk3D9TGS5ABdaVucOsfimfaz';

  final Logger _logger = Logger('MpesaService'); // Create a logger

  Future<void> initiateMpesaPayment(
      String amount, String till, String phone) async {
    String token = await _getAccessToken();
    const String url =
        'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest'; // Use const here

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "BusinessShortCode": till,
      "Password": _generatePassword(),
      "Timestamp": _getTimestamp(),
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amount,
      "PartyA": phone,
      "PartyB": till,
      "PhoneNumber": phone,
      "CallBackURL": "https://fruity-tips-agree.loca.lt",
      "AccountReference": "Expense",
      "TransactionDesc": "Payment for $amount"
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      _logger.info('Payment initiated successfully'); // Use logger
    } else {
      _logger
          .severe('Failed to initiate payment: ${response.body}'); // Use logger
    }
  }

  Future<String> _getAccessToken() async {
    const String url =
        'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
    String auth = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Basic $auth',
    });
    var data = jsonDecode(response.body);
    return data['access_token'];
  }

  String _generatePassword() {
    // Generate password using your credentials and timestamp
    return '<YOUR_GENERATED_PASSWORD>'; // You need to implement this
  }

  String _getTimestamp() {
    // Return current timestamp in YYYYMMDDHHMMSS format
    return DateTime.now()
        .toIso8601String()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .split('.')[0];
  }
}
