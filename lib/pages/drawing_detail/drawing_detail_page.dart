import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:lemolite_drawing/service/firebase_cloud_service.dart';

class DrawingDetailPage extends StatefulWidget {
  final String remoteId;

  const DrawingDetailPage({
    super.key,
    required this.remoteId,
  });

  @override
  State<DrawingDetailPage> createState() => _DrawingDetailPageState();
}

class _DrawingDetailPageState extends State<DrawingDetailPage> {
  final DrawingController drawingController = DrawingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawing Detail"),
        forceMaterialTransparency: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: FirebaseService.instance
              .getDrawingStreamById(id: widget.remoteId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading
            }
            if (snapshot.hasError) {
              return Center(child: Text("❌ Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                "No drawings available",
                style: TextStyle(fontSize: 20),
              ));
            }

            final drawingData = snapshot.data ?? []; // Get the list of maps
            drawingController.setStyle(color: Colors.transparent);
            drawingData.map(
              (e) {
                log(e["type"], name: "Drawing-Shape");
                if (e["type"] == "SimpleLine") {
                  drawingController.addContent(SimpleLine.fromJson(e));
                } else if (e["type"] == "Circle") {
                  drawingController.addContent(Circle.fromJson(e));
                } else if (e["type"] == "Rectangle") {
                  drawingController.addContent(Rectangle.fromJson(e));
                } else if (e["type"] == "StraightLine") {
                  drawingController.addContent(StraightLine.fromJson(e));
                } else if (e["type"] == "Eraser") {
                  drawingController.addContent(Eraser.fromJson(e));
                } else {
                  drawingController.addContent(SmoothLine.fromJson(e));
                }
              },
            ).toList();
            return DrawingBoard(
              controller: drawingController,
              showDefaultActions: false,
              showDefaultTools: false,
              background: Container(
                width: size.width,
                height: size.height,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    drawingController.dispose();
    super.dispose();
  }
}
