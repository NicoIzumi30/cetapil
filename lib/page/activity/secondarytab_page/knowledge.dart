import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/video_controller/video_controller.dart';

class KnowledgePage extends GetView<KnowledgeController> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomVideoPlayer(),
      ],
    );
  }
}
