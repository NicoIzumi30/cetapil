import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final bool useListView;

  const EmptyStateWidget({
    super.key,
    this.message = 'No data available',
    this.useListView = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget emptyContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.inbox_outlined,
          color: Colors.grey,
          size: 60,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (useListView) {
      return ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300, // Adjust this value as needed
            child: Center(child: emptyContent),
          ),
        ],
      );
    }

    return Center(child: emptyContent);
  }
}