import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:lemolite_drawing/pages/drawing_page/cubit/color_cubit.dart';
import 'package:lemolite_drawing/service/device_info_service.dart';
import 'package:lemolite_drawing/service/firebase_cloud_service.dart';
import 'package:lemolite_drawing/utils/custom_snackbar.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  DrawingController drawingController = DrawingController();

  @override
  void initState() {
    super.initState();
    FirebaseService.instance.getDrawingStream();
  }

  Future<void> getDeviceID() async {
    final id = await DeviceIDService().getDeviceID();
    log(id);
  }

  void addTestLine() async {
    final list = drawingController.getJsonList();
    if (list.isNotEmpty) {
      await FirebaseService.instance.addDrawing(list: list);
    } else {
      CustomSnackBar.show(
          message: "Please draw something...", color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing App"),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await showColorPicker();
            },
            icon: Icon(Icons.color_lens_outlined),
          ),
        ],
      ),
      body: buildInternalBodyWidget(size),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addTestLine();
        },
        child: Icon(Icons.save_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  Widget buildInternalBodyWidget(Size size) {
    return SafeArea(
      child: BlocConsumer<ColorCubit, Color>(
        listener: (_, state) {},
        builder: (_, colorState) {
          return DrawingBoard(
            controller: drawingController..setStyle(color: colorState),
            showDefaultActions: true,
            showDefaultTools: true,
            background: Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Future<void> showColorPicker() async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: context.read<ColorCubit>().state,
              onColorChanged: (internalColor) {
                context.read<ColorCubit>().changeColor(color: internalColor);
              },
              pickerAreaBorderRadius: BorderRadius.all(Radius.circular(2)),
              portraitOnly: true,
              displayThumbColor: true,
            ),
          ),
          actions: [
            TextButton(
              child: Text("Done"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    drawingController.dispose();
    super.dispose();
  }
}
