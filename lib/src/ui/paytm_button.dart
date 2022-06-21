import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../utils/size_config.dart';
import 'payment_methods.dart';

class PaytmButton extends StatelessWidget {
  final String merchantId;
  final bool testing;
  final String merchantKey;
  const PaytmButton(
      {Key? key,
      required this.merchantId,
      required this.merchantKey,
      required this.testing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
      ),
      elevation: 5,
      onPressed: () {
        //Firstly Generate CheckSum bcoz Paytm Require this
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentMethods(
              merchantId: merchantId,
              merchantKey: merchantKey,
              testing: testing,
            ),
          ),
        );
      },
      color: COLORS.primary,
      child: const Text(
        "Pay using paytm",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
