import 'dart:io';
import 'package:bloc_v2/pdf/helper/pdf_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';

class PdfInvoicePdfHelper {
  static Future<File> generate(List<dynamic> salesData, DateTime startDate, DateTime endDate) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(salesData, startDate, endDate),
        buildSalesTable(salesData),
      ],
    ));

    return PdfHelper.saveDocument(name: 'sales_report.pdf', pdf: pdf);
  }

  static String capitalizeFirstLetter(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).join(' ');
  }

  static Widget buildTitle(List<dynamic> salesData, DateTime startDate, DateTime endDate) {
    final branchName = salesData.isNotEmpty ? capitalizeFirstLetter(salesData[0]['fn_branch_name']) : '';
    final branchManagerName = "Mahmoud Hossam"; // Add the branch manager's name here
    final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Sales Report',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Increased font size
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Center(
          child: Text(
            'Branch Name: $branchName',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Increased font size
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Center(
          child: Text(
            'Report Period: $formattedStartDate - $formattedEndDate', // Show start and end dates
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal), // Adjust font size
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Center(
          child: Text(
            'Branch Manager: $branchManagerName', // Branch manager's name
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Make it bold
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
      ],
    );
  }

  static Widget buildSalesTable(List<dynamic> salesData) {
    final headers = [
      'ID',
      'Item Name',
      'Quantity',
      'Total Sales'
    ];

    final data = salesData.map((item) {
      return [
        item['fn_item_id'].toString(),
        capitalizeFirstLetter(item['fn_item_name']),
        item['fn_sales_count'].toString(),
        item['fn_total_sales'].toString(),
      ];
    }).toList();

    final totalSales = salesData.fold(0.0, (sum, item) {
      final totalSalesValue = double.tryParse(item['fn_total_sales'].toString()) ?? 0.0;
      return sum + totalSalesValue;
    });

    data.add([
      '', // Empty cell for ID column
      'Total All Item Sales',
      '', // Empty cell for Quantity column
      totalSales.toStringAsFixed(2),
    ]);

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), // Increased header font size
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellStyle: TextStyle(fontSize: 16), // Increased cell font size
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.center,
      },
    );
  }
}
