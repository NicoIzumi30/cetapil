import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../../../controller/video_controller/video_controller.dart';

class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomVideoPlayer(),
      ],
    );
  }
}
