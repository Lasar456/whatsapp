import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Android preview container for the unchanged GreenLeaf Clean Campaigns HTML.
/// UI state is local demonstration data; no live WhatsApp/API access is used.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF181727),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFFFFFFFF),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const GreenLeafPreviewApp());
}

class GreenLeafPreviewApp extends StatelessWidget {
  const GreenLeafPreviewApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'GreenLeaf',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F6F8),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF19C66B),
          ),
        ),
        home: const GreenLeafPreviewPage(),
      );
}

class GreenLeafPreviewPage extends StatefulWidget {
  const GreenLeafPreviewPage({super.key});

  @override
  State<GreenLeafPreviewPage> createState() => _GreenLeafPreviewPageState();
}

class _GreenLeafPreviewPageState extends State<GreenLeafPreviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF6F6F8))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() {
                _loadError = error.description;
                _isLoading = false;
              });
            }
          },
        ),
      );
    _loadHtml();
  }

  Future<void> _loadHtml() async {
    try {
      await _controller.loadFlutterAsset('assets/index.html');
    } catch (error) {
      if (mounted) {
        setState(() {
          _loadError = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Handle Android Back as navigation inside the original HTML prototype.
  Future<void> _handleBack() async {
    if (_isLoading || _loadError != null) return;
    try {
      final result = await _controller.runJavaScriptReturningResult(r"""
        (() => {
          const modal = document.getElementById('modalOverlay');
          const chat = document.getElementById('conversation');
          const page = document.querySelector('.page.active');
          if (modal?.classList.contains('show')) {
            modal.classList.remove('show');
            return 'handled';
          }
          if (chat?.classList.contains('open')) {
            chat.classList.remove('open');
            return 'handled';
          }
          if (page?.id === 'screen-billing') {
            window.showPage?.('more');
            return 'handled';
          }
          if (page?.id && page.id !== 'screen-home') {
            window.showPage?.('home');
            return 'handled';
          }
          return 'exit';
        })();
      """);
      if (result.toString().replaceAll('"', '').trim() == 'exit') {
        await SystemNavigator.pop();
      }
    } catch (_) {
      // Do not crash if Android Back arrives while the WebView is initializing.
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF19C66B)),
                ),
              if (_loadError != null)
                ColoredBox(
                  color: const Color(0xFFF6F6F8),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 42),
                          const SizedBox(height: 14),
                          const Text(
                            'Could not open GreenLeaf',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),
                          Text('$_loadError', textAlign: TextAlign.center),
                          const SizedBox(height: 18),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                _loadError = null;
                                _isLoading = true;
                              });
                              _loadHtml();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
