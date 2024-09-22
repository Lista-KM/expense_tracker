import 'package:flutter/material.dart';
import 'mpesa_service.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExpenseForm(),
    );
  }
}

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  ExpenseFormState createState() => ExpenseFormState();
}

class ExpenseFormState extends State<ExpenseForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tillController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); 
  final TextEditingController _reasonController = TextEditingController();
  List<Expense> expenses = []; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
              ),
            ),
            TextField(
              controller: _tillController,
              decoration: const InputDecoration(
                labelText: 'Enter Till or Paybill number',
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter your phone number',
              ),
            ),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for expense',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handlePayment,
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    final String amount = _amountController.text;
    final String till = _tillController.text;
    final String phone = _phoneController.text; 
    final String reason = _reasonController.text;

    if (amount.isEmpty || till.isEmpty || phone.isEmpty || reason.isEmpty) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    await MpesaService().initiateMpesaPayment(amount, till, phone);
    _recordExpense(amount, till, phone, reason);
  }

  void _recordExpense(String amount, String till, String phone, String reason) {
    final Expense expense = Expense(amount: amount, till: till, phone: phone, reason: reason);
    setState(() {
      expenses.add(expense);
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Expense { // Remove underscore to make it public
  final String amount;
  final String till;
  final String phone;
  final String reason;

  Expense({
    required this.amount,
    required this.till,
    required this.phone,
    required this.reason,
  });
}
