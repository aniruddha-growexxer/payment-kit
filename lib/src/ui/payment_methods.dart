import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paytm/paytm.dart';
import 'package:http/http.dart' as http;

import '../constants/color.dart';
import '../utils/size_config.dart';

class PaymentMethods extends StatefulWidget {
  final String merchantId;
  final String merchantKey;
  final bool testing;
  final double amount;
  const PaymentMethods(
      {Key? key,
      required this.merchantId,
      required this.merchantKey,
      required this.testing,
      required this.amount})
      : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  void generateTxnToken(int mode) async {
    String payment_response = '';

    //Live
    // String mid = "LIVE_MID_HERE";
    // String PAYTM_MERCHANT_KEY = "LIVE_KEY_HERE";
    // String website = "DEFAULT";
    // bool testing = false;

    //Testing
    // String mid = "bEmXvr81027929901181";
    // String PAYTM_MERCHANT_KEY = "XLh3_TvF_X5jeaKm";
    // String website = "WEBSTAGING";
    // bool testing = true;

    String website = widget.testing ? "WEBSTAGING" : "DEFAULT";

    bool loading = false;
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (widget.testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    //Host the Server Side Code on your Server and use your URL here. The following URL may or may not work. Because hosted on free server.
    //Server Side code url: https://github.com/mrdishant/Paytm-Plugin-Server
    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": widget.merchantId,
      "key_secret": widget.merchantKey,
      "website": website,
      "orderId": orderId,
      "amount": widget.amount.toString(),
      "callbackUrl": callBackUrl,
      "custId": "122",
      "mode": mode.toString(),
      "testing": widget.testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      print("Response is");
      print(response.body);
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          mId: widget.merchantId,
          orderId: orderId,
          txnToken: txnToken,
          txnAmount: "20",
          callBackUrl: callBackUrl,
          staging: widget.testing);

      paytmResponse.then((value) {
        print(value);
        setState(() {
          loading = false;
          print("Value is ");
          print(value);
          if (value['error']) {
            payment_response = value['errorMessage'];
          } else {
            if (value['response'] != null) {
              payment_response = value['response']['STATUS'];
            }
          }
          payment_response += "\n" + value.toString();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  late int groupValue;

  @override
  void initState() {
    super.initState();
    groupValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: COLORS.primary,
        title: Text(
          "Payment Methods",
          style: TextStyle(
              fontFamily: "Mulish", fontSize: SizeConfig.blockWidth * 4.7),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.blockHeight * 2,
                ),
                width: SizeConfig.blockWidth * 90,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Payment Options",
                  style: TextStyle(
                      fontFamily: "Mulish",
                      color: COLORS.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockWidth * 4.5),
                ),
              ),
              _paymentMethodTile(
                  header: "Wallet",
                  leading: Image(
                    image: const AssetImage("assets/images/paytm.png",
                        package: 'payment'),
                    width: SizeConfig.blockWidth * 7,
                  ),
                  radioSelected: 0),
              _paymentMethodTile(
                  header: "Net Banking",
                  leading: Image(
                    image: const AssetImage("assets/images/paytm.png",
                        package: 'payment'),
                    width: SizeConfig.blockWidth * 7,
                  ),
                  radioSelected: 1),
              _paymentMethodTile(
                  header: "UPI",
                  leading: Image(
                    image: const AssetImage("assets/images/paytm.png",
                        package: 'payment'),
                    width: SizeConfig.blockWidth * 7,
                  ),
                  radioSelected: 2),
              _paymentMethodTile(
                  header: "Credit Card",
                  leading: Image(
                    image: const AssetImage("assets/images/paytm.png",
                        package: 'payment'),
                    width: SizeConfig.blockWidth * 7,
                  ),
                  radioSelected: 3),
              // Container(
              //   width: SizeConfig.blockWidth * 90,
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "UPI IDs",
              //     style: TextStyle(
              //         fontFamily: "Mulish",
              //         color: COLORS.primary,
              //         fontWeight: FontWeight.w600,
              //         fontSize: SizeConfig.blockWidth * 4.5),
              //   ),
              // ),

              // _paymentMethodTile(
              //     header: "Phone Pe",
              //     leading: Image(
              //       image: AssetImage("assets/images/phonepe.png"),
              //       width: SizeConfig.blockWidth * 7,
              //     ),
              //     radioSelected: 4),
              // _paymentMethodTile(
              //     header: "Google Pay",
              //     leading: Image(
              //       image: AssetImage("assets/images/googlepay.png"),
              //       width: SizeConfig.blockWidth * 7,
              //     ),
              //     radioSelected: 5),
              // _paymentMethodTile(
              //     header: "Mobikwik",
              //     leading: Image(
              //       image: AssetImage("assets/images/mobikwik.jpg"),
              //       width: SizeConfig.blockWidth * 7,
              //     ),
              //     radioSelected: 6),
            ],
          ),
        ),
      ),
    );
  }

  _paymentMethodTile(
      {Widget? leading, String? header, required int radioSelected}) {
    return GestureDetector(
      onTap: () {
        switch (header) {
          case "Wallet":
            generateTxnToken(0);
            break;
          case "Net Banking":
            generateTxnToken(1);
            break;
          case "UPI":
            generateTxnToken(2);
            break;
          case "Credit Card":
            generateTxnToken(3);
            break;
          default:
            break;
        }
        // Navigator.pushNamed(context, '/order_details');
      },
      // child: GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 2),
        width: SizeConfig.blockWidth * 90,
        // height: SizeConfig.blockHeight * 10,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: COLORS.white,
          borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 7,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        // height: SizeConfig.blockHeight * 5,

        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockWidth * 4,
            vertical: SizeConfig.blockHeight * 2.5),
        child: Row(
          children: [
            leading!,
            SizedBox(
              width: SizeConfig.blockWidth * 3,
            ),
            SizedBox(
              // color: Colors.blue,
              // width: SizeConfig.blockWidth * 60,
              child: Text(
                header!,
                style: TextStyle(
                    fontFamily: "Mulish",
                    color: COLORS.greyDark,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockWidth * 4.5),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: COLORS.primary,
            )
            // Radio(
            //   value: radioSelected,
            //   groupValue: groupValue,
            //   activeColor: COLORS.primary,
            //   toggleable: false,
            //   focusColor: COLORS.primary,
            //   onChanged: (value) {
            //     setState(() {
            //       groupValue = int.parse(value.toString());
            //     });
            //   },
            // ),
          ],
        ),
      ),
      //   onTap: () {
      //     setState(() {
      //       groupValue = radioSelected;
      //     });
      //   },
      // ),
    );
  }
}
