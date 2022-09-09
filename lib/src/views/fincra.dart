import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../files/fincra_html.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading.dart';

class FincraWebview extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String amount;
  final String email;
  final String publicKey;
  final String currency;
  final String feeBearer;
  final Function onClose;
  final Function(dynamic payload) onSuccess;
  final Function(dynamic payload) onError;

  const FincraWebview({
    Key? key,
    required this.publicKey,
    required this.amount,
    required this.email,
    required this.currency,
    required this.onClose,
    required this.onSuccess,
    required this.onError,
    required this.name,
    required this.phoneNumber,
    required this.feeBearer,
  }) : super(key: key);

  @override
  _FincraWebviewState createState() => _FincraWebviewState();
}

class _FincraWebviewState extends State<FincraWebview> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoading = true;
  bool _isError = false;

  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers =
      {Factory(() => EagerGestureRecognizer())}.toSet();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: WebView(
            initialUrl: Uri.dataFromString(
              buildFincraHtml(
                widget.name,
                widget.amount,
                widget.email,
                widget.publicKey,
                widget.feeBearer,
                widget.phoneNumber,
                widget.currency,
              ),
              mimeType: "text/html",
            ).toString(),
            javascriptChannels: _fincraJavascriptChannel,
            gestureRecognizers: gestureRecognizers,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (String url) {
              _isLoading = false;
              setState(() {});
            },
            onWebResourceError: (onWebResourceError) {
              _isLoading = false;
              _isError = true;
              setState(() {});
            },
            gestureNavigationEnabled: true,
            navigationDelegate: _handleNavigationInterceptor,
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: const Positioned(
            child: FincraLoader(),
          ),
        ),
        Visibility(
          visible: _isError,
          child: Positioned(
            child: FincraErrorWidget(
              title: "Couldn't load up checkout.",
              reload: () async {
                _isLoading = true;
                _isError = false;
                setState(() {});
                await _controller.future.then((value) => value.reload());
              },
            ),
          ),
        ),
      ],
    );
  }

  Set<JavascriptChannel> get _fincraJavascriptChannel => {
        JavascriptChannel(
          name: 'FincraClientInterface',
          onMessageReceived: (data) {
            handleResponse(data.message);
          },
        )
      };

  void handleResponse(String body) async {
    try {
      final Map<String, dynamic> bodyMap = json.decode(body);
      final String event = bodyMap['event'];
      switch (event) {
        case "checkout.closed":
          widget.onClose();
          break;
        case "checkout.success":
          widget.onSuccess(
            bodyMap['data'],
          );
          break;
        default:
      }
    } catch (e) {
      widget.onError({"data": "something really bad happened."});
    }
  }

  NavigationDecision _handleNavigationInterceptor(NavigationRequest request) {
    if (request.url.toLowerCase().contains('fincra')) {
      // Navigate to all urls contianing fincra
      return NavigationDecision.navigate;
    } else {
      // Block all navigations outside fincra
      return NavigationDecision.prevent;
    }
  }
}
