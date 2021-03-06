import 'dart:convert';
import 'dart:developer';
import 'package:example/config.dart';
import 'package:example/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'constants/color.dart';
import 'package:payment/payment.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Payment Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Payment Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLORS.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PaytmButton(
              merchantId: Config.merchantId,
              merchantKey: Config.merchantKey,
              testing: true,
              amount: 50,
            ),
            RazorpayWiget(
                onError: (response) {
                  log(response.message!);
                },
                onExternalWalletChosen: (response) {
                  Fluttertoast.showToast(
                      msg: "EXTERNAL_WALLET: ${response.walletName!}",
                      toastLength: Toast.LENGTH_SHORT);
                },
                onSuccess: (response) {
                  log(response.paymentId!);
                },
                razorpayKey: 'rzp_live_ILgsfZCZoFIKMb',
                businessName: 'Acme Corp.',
                amount: '100',
                email: 'test@razorpay.com',
                phone: '8888888888',
                externalWallets: const ['paytm', 'googlepay'],
                description: 'Fine T-Shirt')
          ],
        ),
      ),
    );
  }
}
