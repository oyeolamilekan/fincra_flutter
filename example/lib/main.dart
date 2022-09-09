import 'package:fincra_flutter/fincra_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const TestFincra(),
    );
  }
}

class TestFincra extends StatelessWidget {
  const TestFincra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: const Text('Launch fincra'),
              onTap: () {
                FincraFlutter.launchFincra(
                  context,
                  publicKey: "<public_api_key>",
                  amount: "4000",
                  name: "oyee",
                  phoneNumber: "+2348087307896",
                  currency: "NGN",
                  email: "oye@qww.com",
                  feeBearer: "business",
                  onSuccess: (data) {},
                  onError: (data) {},
                  onClose: () {},
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
