import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaunchCard extends StatelessWidget {
  final Map<String, dynamic> launch;

  const LaunchCard({
    Key? key,
    required this.launch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final launchDate = DateTime.parse(launch['launch_date_utc']);
    final formattedDate = DateFormat('MMM dd, yyyy').format(launchDate);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          launch['rocket']['rocket_name'] ?? 'Unknown Rocket',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Launch Date: $formattedDate'),
            Text('Launch Site: ${launch['launch_site']?['site_name'] ?? 'Unknown Site'}'),
            if (launch['launch_success'] != null)
              Text(
                'Status: ${launch['launch_success'] ? 'Successful' : 'Failed'}',
                style: TextStyle(
                  color: launch['launch_success'] ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
        },
      ),
    );
  }
} 