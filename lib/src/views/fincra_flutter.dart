import 'package:flutter/material.dart';

import 'fincra.dart';

class FincraFlutter {
  static Future launchFincra(
    BuildContext _, {

    /// Public Key from your https://app.fincra.com/settings/api
    required String publicKey,

    /// amount
    required String amount,

    /// name
    required String name,

    /// feeBearer
    required String feeBearer,

    /// phoneNumber
    required String phoneNumber,

    /// currency
    required String currency,

    /// email
    required String email,

    /// Success callback
    required void Function(dynamic code) onSuccess,

    /// Error callback
    required void Function(dynamic code) onError,

    /// Triggered on Connect Widget close
    required Function onClose,

    /// Triggered on Abandoned Widget close
    Function? onAbandoned,
    bool showLogs = false,
    String? reference,
  }) async =>
      showModalBottomSheet(
        isScrollControlled: true,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .9,
              child: FincraWebview(
                name: name,
                phoneNumber: phoneNumber,
                publicKey: publicKey,
                amount: amount,
                currency: currency,
                email: email,
                feeBearer: feeBearer,
                onSuccess: (data) {
                  onSuccess(data);
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                onError: onError,
                onClose: () {
                  onClose();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        context: _,
      );
}
