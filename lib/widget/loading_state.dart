import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final bool useListView;

  const LoadingStateWidget({
    super.key,
    this.useListView = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingContent = const Center(
      child: CircularProgressIndicator(),
    );

    if (useListView) {
      return ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300, // Adjust this value as needed
            child: loadingContent,
          ),
        ],
      );
    }

    return loadingContent;
  }
}