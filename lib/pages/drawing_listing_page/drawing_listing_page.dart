import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lemolite_drawing/pages/drawing_detail/drawing_detail_page.dart';
import 'package:lemolite_drawing/pages/drawing_page/drawing_page.dart';
import 'package:lemolite_drawing/service/firebase_cloud_service.dart';

class DrawingListingPage extends StatelessWidget {
  const DrawingListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Drawing Remote Users"),
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: _buildStreamBuilder(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DrawingPage(),
          ));
        },
        child: Icon(Icons.draw),
      ),
    );
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder(
      stream: FirebaseService.instance.getDrawingStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          final docsData = snapshot.data?.docs ?? [];
          return docsData.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  itemBuilder: (_, index) {
                    final model = docsData.elementAt(index);
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => DrawingDetailPage(
                              remoteId: model.id,
                            ),
                          ));
                        },
                        title: Text(model.id),
                        contentPadding: EdgeInsets.only(
                            right: 5, left: 10, top: 5, bottom: 5),
                        trailing: Icon(CupertinoIcons.right_chevron),
                      ),
                    );
                  },
                  itemCount: docsData.length,
                )
              : Center(
                  child: SizedBox(
                    child: Text(
                      "Drawing not found",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
