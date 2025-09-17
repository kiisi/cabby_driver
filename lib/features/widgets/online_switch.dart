import 'package:cabby_driver/app/app_config.dart';
import 'package:flutter/material.dart';

class OnlineSwitch extends StatelessWidget {
  final bool isOnline;
  final Function(bool) onToggle;

  const OnlineSwitch({
    Key? key,
    required this.isOnline,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOnline ? AppConfig.onlineColor : AppConfig.offlineColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  isOnline ? 'You\'re visible to riders' : 'Go online to start receiving requests',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Switch(
              value: isOnline,
              onChanged: onToggle,
              activeColor: AppConfig.primaryColor,
              activeTrackColor: AppConfig.primaryColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
