import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final TextEditingController _controller = TextEditingController();
  String _currentUrl = '';
  final WebViewController _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(hintText: 'Enter URL here...'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _currentUrl = _controller.text;
                _webViewController.loadRequest(Uri.parse(_currentUrl));
              });
            },
          ),
          _currentUrl.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.cancel_sharp),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      _currentUrl = '';
                    });
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }
}
