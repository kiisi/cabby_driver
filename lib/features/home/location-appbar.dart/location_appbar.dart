import 'package:cabby_driver/core/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final bool enableLocationAppbar;
  LocationAppBar({super.key, this.enableLocationAppbar = false, required this.context});
  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: enableLocationAppbar ? const Color(0xFFfe9900) : Colors.blue,
      child: enableLocationAppbar
          ? GestureDetector(
              onTap: () async {
                await _locationService.determinePosition();
              },
              child: Container(
                height: 50,
                color: const Color(0xFFfe9900),
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 12,
                  right: 12,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Location sharing disabled. Tap here to enable",
                        style: TextStyle(
                          color: Color(0xff2d0200),
                        ),
                        softWrap: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Enable",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, enableLocationAppbar ? 50 : 0);
}
