import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  List<String> outputData = [];
  void addToOutputData(String item) => outputData.add(item);
  void removeFromOutputData(String item) => outputData.remove(item);
  void removeAtIndexFromOutputData(int index) => outputData.removeAt(index);
  void insertAtIndexInOutputData(int index, String item) =>
      outputData.insert(index, item);
  void updateOutputDataAtIndex(int index, Function(String) updateFn) =>
      outputData[index] = updateFn(outputData[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
