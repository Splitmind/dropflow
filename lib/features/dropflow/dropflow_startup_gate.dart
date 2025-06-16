import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dropflow_welcome_screen.dart';

class DropFlowStartupGate extends StatefulWidget {
  const DropFlowStartupGate({super.key});

  @override
  State<DropFlowStartupGate> createState() => _DropFlowStartupGateState();
}

class _DropFlowStartupGateState extends State<DropFlowStartupGate> {
  bool isLoading = true;
  bool installStarted = false;

  final String shopDomain = 'dropflow-dev.myshopify.com';

  final Uri shopifyInstallUrl = Uri.parse(
    'https://admin.shopify.com/oauth/install_custom_app'
    '?client_id=17666a62ec6f6b831c533c069bc37f13'
    '&no_redirect=true'
    '&signature=eyJleHBpcmVzX2F0IjoxNzUwNjM1NzU3LCJwZXJtYW5lbnRfZG9tYWluIjoiZHJvcGZsb3ctZGV2Lm15c2hvcGlmeS5jb20iLCJjbGllbnRfaWQiOiIxNzY2NmE2MmVjNmY2YjgzMWM1MzNjMDY5YmMzN2YxMyIsInB1cnBvc2UiOiJjdXN0b21fYXBwIiwibWVyY2hhbnRfb3JnYW5pemF0aW9uX2lkIjoxNzExOTE5NTh9--2e725cba9a17f9565a2c3983f95b89ac4944b2b9',
  );

  @override
  void initState() {
    super.initState();
    checkIfAlreadyInstalled();
  }

  Future<void> checkIfAlreadyInstalled() async {
    try {
      print('🔍 Checking Supabase install...');
      final installed = await isShopInstalled().timeout(
        const Duration(seconds: 8),
      );
      final spocket = await isSpocketConnected().timeout(
        const Duration(seconds: 8),
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (installed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DropFlowWelcomeScreen(
              shopOwner: shopDomain,
              spocketDetected: spocket,
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Supabase init check failed: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> startInstallFlow() async {
    setState(() {
      installStarted = true;
      isLoading = true;
    });

    if (!await launchUrl(
      shopifyInstallUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch Shopify install';
    }

    await Future.delayed(const Duration(seconds: 5));

    for (int i = 0; i < 15; i++) {
      final installed = await isShopInstalled();
      final spocket = await isSpocketConnected();

      if (!mounted) return;

      if (installed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DropFlowWelcomeScreen(
              shopOwner: shopDomain,
              spocketDetected: spocket,
            ),
          ),
        );
        return;
      }

      await Future.delayed(const Duration(seconds: 3));
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<bool> isShopInstalled() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('shops')
        .select('id')
        .eq('shop_domain', shopDomain)
        .maybeSingle();
    return response != null;
  }

  Future<bool> isSpocketConnected() async {
    final supabase = Supabase.instance.client;
    final result = await supabase
        .from('integrations')
        .select('id')
        .eq('shop_domain', shopDomain)
        .eq('vendor', 'spocket')
        .maybeSingle();
    return result != null;
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to DropFlow 👋",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: startInstallFlow,
                    child: const Text("Connect Shopify Store"),
                  ),
                  if (installStarted)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text("Waiting for install confirmation..."),
                    ),
                ],
              ),
      ),
    );
  }
}
