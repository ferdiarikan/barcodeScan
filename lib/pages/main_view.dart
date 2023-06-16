import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/clip_path.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  late bool barcodLoad;
  late AnimationController controller;
  late Animation<double> animation;
  String _scanBarcode = 'Unknown';
  late final Uri _url = Uri.parse(_scanBarcode);
  final String barkorPictureAsset = "assets/ic_splash_barcode.png";

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'iptal', true, ScanMode.QR);
      if (kDebugMode) {
        print(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Platform sürümü alınamadı.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Link açılamıyor: $_url');
    }
  }

  @override
  void initState() {
    barcodLoad = true;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFfdb623),
        body: Center(
            child: Column(children: [
          const UstDalga(),
          Expanded(
            flex: 2,
            child: Image.asset(
              barkorPictureAsset,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Kod Tarama",
                  style: GoogleFonts.itim(
                      textStyle: Theme.of(context).textTheme.headlineLarge),
                ),
                Text(
                  "Pratikliğin keyfini ücretsiz çıkararak hayatınızı kolaylaştırın.",
                  style: GoogleFonts.itim(
                      textStyle: Theme.of(context).textTheme.bodyLarge),
                  textAlign: TextAlign.center,
                ),
                Container(
                  child: (_scanBarcode == 'Unknown')
                      ? InkWell(
                          onTap: () {
                            scanQR();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Start",
                                  style: GoogleFonts.iceberg(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayMedium),
                                ),
                                AnimatedIcon(
                                  icon: AnimatedIcons.ellipsis_search,
                                  progress: animation,
                                  size: 72,
                                ),
                              ]))
                      : Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                _launchUrl();
                              },
                              child: Text('Git : $_scanBarcode\n',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 2),
                            ),
                            IconButton(
                              onPressed: () {
                                scanQR();
                              },
                              icon: (const Icon(Icons.refresh_outlined)),
                              iconSize: 40,
                            ),
                          ],
                        ),
                )
              ],
            ),
          ),
        ])));
  }
}
