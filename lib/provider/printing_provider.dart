import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

class PrintingProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  PrintingProvider({required this.sharedPreferences}) {
    _loadSettings();
  }

  int? _pageSize = 58;
  int? get pageSize => _pageSize;
  String? _printerIP = '';
  String? get printerIP => _printerIP;
  String? _printerPort = '';
  String? get printerPort => _printerPort;
  bool? _isWifi = true;
  bool? get isWifi => _isWifi;

  void updateSettings(int? pageSize, String? ip, String? port, bool? iswifi) {
    _isWifi = iswifi;
    _printerPort = port;
    _printerIP = ip;
    _pageSize = pageSize;

    _saveSettings(pageSize, ip, port, iswifi);
    notifyListeners();
  }

  _loadSettings() async {
    _pageSize = int.parse(sharedPreferences!.getString('pageSize')!);
    _printerIP = (sharedPreferences!.getString('ip')!) ?? '';
    _printerPort = (sharedPreferences!.getString('port')!) ?? '';
    _isWifi = sharedPreferences!.getString('isWifi') == 'true';

    notifyListeners();
  }

  _saveSettings(int? pageSize, String? ip, String? port, bool? iswifi) async {
    sharedPreferences!.setString('pageSize', pageSize.toString());
    sharedPreferences!.setString('ip', ip!);
    sharedPreferences!.setString('port', port!);
    sharedPreferences!.setString('isWifi', iswifi.toString());
  }

  void print(String? text) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect('192.168.0.123', port: 9100);

    if (res == PosPrintResult.success) {
      //testReceipt(printer);
      printer.disconnect();
    }

    print('Print result: ${res.msg}');
  }
}
