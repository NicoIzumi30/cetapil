import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/outlet/outlet_controller.dart';
import '../model/list_channel_response.dart';
import './dropdown_textfield.dart';

class ChannelDropdown extends StatelessWidget {
  final String title;
  final OutletController controller;

  const ChannelDropdown({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final channels = controller.supportController.getChannels();
      final selectedValue = controller.selectedChannel.value?.name;
      
      // Create items list
      final items = channels.map((channel) => DropdownMenuItem<String>(
        value: channel.name ?? '',
        child: Text(channel.name ?? ''),
      )).toList();

      // Only set value if it exists in items
      final validValue = items.any((item) => item.value == selectedValue) 
          ? selectedValue 
          : null;
      
      return CustomDropdown(
        title: title,
        items: items,
        value: validValue,
        hint: "-- Pilih Channel Outlet --",
        onChanged: (String? value) {
          if (value != null) {
            final selectedChannel = channels.firstWhere(
              (channel) => channel.name == value,
              orElse: () => Data(id: "", name: ""),
            );
            controller.setChannel(selectedChannel);
          }
        },
      );
    });
  }
}