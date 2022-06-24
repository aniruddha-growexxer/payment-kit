import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants/color.dart';
import '../utils/size_config.dart';

class RazorpayWiget extends StatefulWidget {
  final String razorpayKey;
  final String businessName;
  final String description;
  final String amount;
  final String email;
  final String phone;
  final List<String> externalWallets;
  final void Function(PaymentFailureResponse)? onError;
  final void Function(ExternalWalletResponse)? onExternalWalletChosen;
  final void Function(PaymentSuccessResponse)? onSuccess;
  const RazorpayWiget(
      {Key? key,
      required this.onSuccess,
      required this.onError,
      required this.onExternalWalletChosen,
      required this.razorpayKey,
      required this.businessName,
      required this.amount,
      required this.email,
      required this.phone,
      required this.externalWallets,
      required this.description})
      : super(key: key);

  @override
  State<RazorpayWiget> createState() => _RazorpayWigetState();
}

class _RazorpayWigetState extends State<RazorpayWiget> {
  Razorpay _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
   widget.onSuccess!(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    widget.onError!(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    widget.onExternalWalletChosen!(response);
    // Do something when an external wallet was selected
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: ${response.walletName!}",
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void openCheckout() async {
    // var options = {
    //   'key': 'rzp_live_ILgsfZCZoFIKMb',
    //   'amount': 100,
    //   'name': 'Acme Corp.',
    //   'description': 'Fine T-Shirt',
    //   'retry': {'enabled': true, 'max_count': 1},
    //   'send_sms_hash': true,
    //   'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };

    var options = {
      'key': widget.razorpayKey,
      'amount': widget.amount,
      'name': widget.businessName,
      'description': widget.description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': widget.phone, 'email': widget.email},
      'external': {'wallets': widget.externalWallets}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
      ),
      elevation: 5,
      onPressed: () {
        openCheckout();
      },
      color: COLORS.primary,
      child: const Text(
        "Pay using Razorpay",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
