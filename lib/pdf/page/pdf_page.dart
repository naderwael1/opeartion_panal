import 'package:bloc_v2/pdf/helper/pdf_invoice_helper.dart';
import 'package:bloc_v2/pdf/helper/pdf_service.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../helper/pdf_helper.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  DateTime? startDate;
  DateTime? endDate;
  int? selectedBranchId;
  List<dynamic> branches = [];

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    try {
      final data = await ApiService.fetchBranchesList();
      setState(() {
        branches = data;
      });
    } catch (e) {
      _showErrorDialog(context, 'Failed to load branches: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFE0F7FA),
    body: Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            _buildBranchDropdown(),
            const SizedBox(height: 16),
            _buildDatePicker('Select Start Date', startDate, true),
            const SizedBox(height: 16),
            _buildDatePicker('Select End Date', endDate, false),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                if (startDate == null || endDate == null || selectedBranchId == null) {
                  _showErrorDialog(context, 'Please select a branch and both start and end dates');
                  return;
                }
                if (startDate!.isAfter(endDate!)) {
                  _showErrorDialog(context, 'Start date cannot be later than end date');
                  return;
                }
                try {
                  final salesData = await ApiService.fetchSalesData(
                    DateFormat('yyyy-MM-dd').format(startDate!),
                    DateFormat('yyyy-MM-dd').format(endDate!),
                    selectedBranchId!,
                  );
                  final pdfFile = await PdfInvoicePdfHelper.generate(salesData, startDate!, endDate!);
                  PdfHelper.openFile(pdfFile);
                } catch (e) {
                  _showErrorDialog(context, 'Error generating PDF: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Generate PDF',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black, // Button text color
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildBranchDropdown() {
    return DropdownButtonFormField<int>(
      value: selectedBranchId,
      items: branches.map<DropdownMenuItem<int>>((branch) {
        return DropdownMenuItem<int>(
          value: branch['branch_id'],
          child: Text(capitalizeFirstLetter(branch['branch_name'])),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedBranchId = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Branch',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null ? label : DateFormat('yyyy-MM-dd').format(date),
              style: TextStyle(
                fontSize: 18,
                color: date == null ? Colors.grey : Colors.black,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).join(' ');
  }
}
