import 'package:cabby_driver/app/app_config.dart';
import 'package:cabby_driver/data/models/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatInterface extends StatelessWidget {
  final List<RideMessage> messages;
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onClose;

  const ChatInterface({
    Key? key,
    required this.messages,
    required this.controller,
    required this.onSend,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54,
      child: GestureDetector(
        onTap: () {
          // Dismiss when tapping outside the chat container
          onClose();
        },
        child: Center(
          child: GestureDetector(
            // Prevent taps inside the chat container from dismissing
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConfig.cardBorderRadius),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Text(
                          'Chat with Rider',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: onClose,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Messages list
                  Expanded(
                    child: messages.isEmpty
                        ? _buildEmptyChat()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              final reversedIndex = messages.length - 1 - index;
                              final message = messages[reversedIndex];
                              final isDriver = message.senderRole == 'driver';

                              return _buildMessageBubble(
                                message: message.message,
                                timestamp: message.timestamp,
                                isDriver: isDriver,
                              );
                            },
                          ),
                  ),

                  // Input area
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => onSend(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppConfig.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: onSend,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start the conversation with your rider',
            style: TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required DateTime timestamp,
    required bool isDriver,
  }) {
    final time = DateFormat.Hm().format(timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: isDriver ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isDriver)
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          if (!isDriver) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: isDriver ? AppConfig.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                // Different border radius for sender and receiver
                // borderTopRight: Radius.circular(isDriver ? 0 : 16),
                // borderTopLeft: Radius.circular(isDriver ? 16 : 0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isDriver ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(
                      color: isDriver ? Colors.white70 : Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isDriver) const SizedBox(width: 8),
          if (isDriver)
            const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.directions_car,
                size: 16,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
