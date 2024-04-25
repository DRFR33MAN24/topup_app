import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:giftme/data/datasource/remote/dio/dio_client.dart';
import 'package:giftme/util/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

import '../data/model/response/order_model.dart';
import '../helper/date.dart';

class PrintingProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  PrintingProvider({required this.sharedPreferences}) {
    _loadSettings();
  }

  String? _pageSize = '58mm';
  String? get pageSize => _pageSize;
  String? _printerIP = '';
  String? get printerIP => _printerIP;
  int? _printerPort = 9100;
  int? get printerPort => _printerPort;
  bool? _isWifi = true;
  bool? get isWifi => _isWifi;

  bool isScanning = false;
  bool isConnected = false;
  bool isWifiPrinterReady = false;
  NetworkPrinter? printer;

  List<BluetoothInfo> printers = [];

  void updateSettings(String? pageSize, String? ip, int? port, bool? iswifi) {
    _isWifi = iswifi;
    _printerPort = port;
    _printerIP = ip;
    _pageSize = pageSize;

    _saveSettings(pageSize, ip, port, iswifi);
    notifyListeners();
  }

  _loadSettings() async {
    _pageSize = sharedPreferences!.getString('pageSize')!;
    _printerIP = (sharedPreferences!.getString('ip')!) ?? '';
    _printerPort = (sharedPreferences!.getInt('port')!) ?? 9100;
    _isWifi = sharedPreferences!.getBool('isWifi') ?? true;

    notifyListeners();
  }

  _saveSettings(String? pageSize, String? ip, int? port, bool? iswifi) async {
    sharedPreferences!.setString('pageSize', pageSize!);
    sharedPreferences!.setString('ip', ip!);
    sharedPreferences!.setInt('port', port!);
    sharedPreferences!.setBool('isWifi', iswifi!);
  }

  void scanBlutooth() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
    await Permission.location.request();
    await Permission.nearbyWifiDevices.request();
    await Permission.bluetoothAdvertise.request();

    isScanning = true;

    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    setPrinters(listResult);

    notifyListeners();
  }

  void setPrinters(List<BluetoothInfo> p) {
    print("dbg ${p}");
    printers = p;
    isScanning = false;
    notifyListeners();
  }

  void connect(int? deviceIndex) async {
    if (_isWifi!) {
      PaperSize paper = _pageSize == "58mm" ? PaperSize.mm58 : PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      printer = NetworkPrinter(paper, profile);

      final PosPrintResult res =
          await printer!.connect(_printerIP!, port: _printerPort!);

      if (res.msg == "Success") {
        isWifiPrinterReady = true;
        isConnected = true;
        notifyListeners();
      }
      print('Print result: ${res.msg}');
    } else {
      print('connecting to ${printers[deviceIndex!].name}');
      final bool result = await PrintBluetoothThermal.connect(
          macPrinterAddress: printers[deviceIndex!].macAdress);
      isConnected = true;
      notifyListeners();
      // printMessage("test");
    }
  }

  void disconnect() async {
    if (_isWifi!) {
      printer!.disconnect();
      isWifiPrinterReady = false;
      isConnected = false;
      notifyListeners();
    } else {
      final bool result = await PrintBluetoothThermal.disconnect;
      isConnected = false;
      notifyListeners();
    }
  }

  void printOrder(BuildContext context, Order? order) async {
    PaperSize paper = _pageSize == "58mm" ? PaperSize.mm58 : PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];

    bytes += ticket.hr();
    bytes += ticket!.row([
      PosColumn(
        text: "ID",
        width: 2,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: order!.id.toString(),
        width: 10,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket!.row([
      PosColumn(
        text: "NAME",
        width: 2,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: order.service!.title!,
        width: 10,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket!.row([
      PosColumn(
        text: "DATE",
        width: 2,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: getDateFormatted(order.createdAt!),
        width: 10,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket!.row([
      PosColumn(
        text: "QNT",
        width: 2,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: order.qty.toString(),
        width: 10,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket.hr();

    bytes += ticket!.row([
      PosColumn(
        text: 'Total',
        width: 2,
        styles: PosStyles(
            align: PosAlign.center,
            underline: true,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: order!.price! + order.currency!,
        width: 10,
        styles: PosStyles(
            align: PosAlign.center,
            underline: true,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket.hr();
    bytes += ticket.text("RESULT:");
    bytes += ticket.text(order.reason!);
    bytes += ticket.hr();
    bytes += ticket.text('Thank you!',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += ticket.feed(2);
    bytes += ticket.cut();
    if (_isWifi!) {
      // await printer!.connect(_printerIP!, port: _printerPort!);
      if (isWifiPrinterReady) {
        printer!.rawBytes(bytes);

        // printer!.disconnect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text("Connect to printer first!"),
            backgroundColor: Colors.green));
      }
    } else {
      if (printers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text("Connect to printer first!"),
            backgroundColor: Colors.green));
        return;
      }

      final result = await PrintBluetoothThermal.writeBytes(bytes);
    }
  }

  void printCardTokens(BuildContext context, Order? order) async {
    PaperSize paper = _pageSize == "58mm" ? PaperSize.mm58 : PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    List<String> test2 = order!.reason!.split(',');

    // const esc = '\x1B';
    // const cSizeESCn = '$esc!'; // Select character size [N]
    // bytes += Uint8List.fromList(
    //   List.from(cSizeESCn.codeUnits)..add(48),
    // );

    // bytes += ticket.hr();
    bytes += ticket.text('giftme',
        linesAfter: 1,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += ticket.text(order.service!.title!,
        linesAfter: 1,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += ticket!.row([
      PosColumn(
        text: "ORDER ID",
        width: 3,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: order.id.toString(),
        width: 9,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket!.row([
      PosColumn(
        text: "DATE",
        width: 2,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: getDateFormatted(order.createdAt),
        width: 10,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    bytes += ticket!.row([
      PosColumn(
        text: "------------------------------",
        width: 12,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);

    //bytes += ticket.hr();

    test2.forEach((element) {
      if (element.isEmpty) {
        return;
      }
      var card = element.split('%');
      card.forEach((detail) {
        if (detail.isEmpty) {
          return;
        }
        bytes += ticket!.row([
          PosColumn(
            text: detail,
            width: 12,
            styles: PosStyles(
                align: PosAlign.center,
                underline: false,
                fontType: PosFontType.fontB),
          ),
        ]);
      });

      bytes += ticket!.row([
        PosColumn(
          text: "******************************",
          width: 12,
          styles: PosStyles(
              align: PosAlign.center,
              underline: false,
              fontType: PosFontType.fontB),
        ),
      ]);
    });
    bytes += ticket!.row([
      PosColumn(
        text: "------------------------------",
        width: 12,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    // bytes += ticket.hr();
    // bytes += ticket.hr();
    // bytes += ticket!.row([
    //   PosColumn(
    //     text: 'Total',
    //     width: 2,
    //     styles: PosStyles(
    //         align: PosAlign.center,
    //         underline: false,
    //         fontType: PosFontType.fontB),
    //   ),
    //   PosColumn(
    //     text: order!.price! + "LBP",
    //     width: 10,
    //     styles: PosStyles(
    //         align: PosAlign.center,
    //         underline: false,
    //         fontType: PosFontType.fontB),
    //   ),
    // ]);
    bytes += ticket!.row([
      PosColumn(
        text: "------------------------------",
        width: 12,
        styles: PosStyles(
            align: PosAlign.center,
            underline: false,
            fontType: PosFontType.fontB),
      ),
    ]);
    if (order.service!.title!.toLowerCase().contains('alfa')) {
      bytes += ticket!.row([
        PosColumn(
          text: "Dial*14*xxxxxxxxxxxxxx#",
          width: 12,
          styles: PosStyles(
              align: PosAlign.center,
              underline: false,
              fontType: PosFontType.fontB),
        ),
      ]);
    } else {
      bytes += ticket!.row([
        PosColumn(
          text: "Dial*200*xxxxxxxxxxxxxx#",
          width: 12,
          styles: PosStyles(
              align: PosAlign.center,
              underline: false,
              fontType: PosFontType.fontB),
        ),
      ]);
    }
    // bytes += ticket.hr();
    bytes += ticket.text('Thank you!',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += ticket.feed(2);
    bytes += ticket.cut();
    if (_isWifi!) {
      // await printer!.connect(_printerIP!, port: _printerPort!);
      if (isWifiPrinterReady) {
        printer!.rawBytes(bytes);

        // printer!.disconnect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text("Connect to printer first!"),
            backgroundColor: Colors.green));
      }
    } else {
      if (printers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text("Connect to printer first!"),
            backgroundColor: Colors.green));
        return;
      }

      final result = await PrintBluetoothThermal.writeBytes(bytes);
    }
  }
}
