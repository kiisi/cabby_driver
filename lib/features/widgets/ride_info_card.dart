import 'package:cabby_driver/data/models/driver_model.dart';
import 'package:flutter/material.dart';

class RiderInfoCard extends StatelessWidget {
  final RiderUser rider;
  final bool isExpanded;
  final VoidCallback onExpand;

  const RiderInfoCard({
    Key? key,
    required this.rider,
    required this.isExpanded,
    required this.onExpand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? 180 : 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Header (always visible)
            InkWell(
              onTap: onExpand,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Rider avatar
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: rider.profilePicture != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(rider.profilePicture!),
                            )
                          : Icon(
                              Icons.person,
                              size: 24,
                              color: Colors.grey[500],
                            ),
                    ),
                    const SizedBox(width: 12),

                    // Rider name and rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                rider.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${rider.avgRating}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            isExpanded ? 'Tap to collapse' : 'Tap for rider details',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Expand/collapse icon
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            // Extended info (visible when expanded)
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),

                    // Contact and trip stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.phone,
                            'Phone',
                            rider.phoneNumber,
                            onTap: () {
                              // In a real app, would launch phone call
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling rider...'),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.history,
                            'Completed Trips',
                            rider.tripCount.toString(),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.verified_user,
                            'Account',
                            'Verified',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rider notes
                    if (rider.notes != null && rider.notes!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.note,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                rider.notes!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value, {
    Color? color,
    VoidCallback? onTap,
  }) {
    final content = Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: color ?? Colors.grey[700],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
