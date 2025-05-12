import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_app/data/provider/home_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusIndicator extends StatelessWidget {
  const NetworkStatusIndicator({Key? key}) : super(key: key);

  String _getNetworkQualityMessage(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected to Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Connected via Bluetooth';
      case ConnectivityResult.vpn:
        return 'Connected via VPN';
      case ConnectivityResult.other:
        return 'Connected to Unknown Network';
      case ConnectivityResult.none:
        return 'No Internet Connection';
    }
  }

  IconData _getNetworkQualityIcon(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.cell_tower;
      case ConnectivityResult.ethernet:
        return Icons.router;
      case ConnectivityResult.bluetooth:
        return Icons.bluetooth;
      case ConnectivityResult.vpn:
        return Icons.vpn_lock;
      case ConnectivityResult.other:
        return Icons.network_check;
      case ConnectivityResult.none:
        return Icons.wifi_off;
    }
  }

  Color _getNetworkQualityColor(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Colors.green;
      case ConnectivityResult.mobile:
        return Colors.blue;
      case ConnectivityResult.ethernet:
        return Colors.green;
      case ConnectivityResult.bluetooth:
        return Colors.blue;
      case ConnectivityResult.vpn:
        return Colors.purple;
      case ConnectivityResult.other:
        return Colors.orange;
      case ConnectivityResult.none:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          initialData: const [ConnectivityResult.none],
          builder: (context, snapshot) {
            final results = snapshot.data ?? [ConnectivityResult.none];
            final result = results.first;
            final isOffline = result == ConnectivityResult.none;

            if (isOffline) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.red.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.red.shade900),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You are offline. Showing cached data.',
                        style: TextStyle(color: Colors.red.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        if (context.mounted) {
                          provider.retryLastOperation(context);
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: _getNetworkQualityColor(result).withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getNetworkQualityIcon(result),
                    color: _getNetworkQualityColor(result),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getNetworkQualityMessage(result),
                    style: TextStyle(
                      color: _getNetworkQualityColor(result),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
} 