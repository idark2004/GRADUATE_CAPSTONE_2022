import 'package:apms_mobile/themes/colors.dart';
import 'package:flutter/material.dart';

class AppBarBuilder {
  PreferredSize appBarDefaultBuilder(String title) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(56), child: _buildAppBar(title));
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: deepBlue),
      centerTitle: true,
      title: Text(title, style: const TextStyle(color: deepBlue)),
      backgroundColor: lightBlue,
    );
  }
}
