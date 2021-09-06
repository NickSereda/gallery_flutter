import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_gallery_flutter/provider/gallery_data.dart';
import 'package:provider/provider.dart';

class PhotoGalleryProviderScreen extends StatefulWidget {
  @override
  _PhotoGalleryProviderScreenState createState() =>
      _PhotoGalleryProviderScreenState();
}

class _PhotoGalleryProviderScreenState
    extends State<PhotoGalleryProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          // context.watch makes the widget listen to changes
          itemCount: context.watch<GalleryData>().photosCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 6.0, mainAxisSpacing: 6.0),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Image.network(
                context.watch<GalleryData>().photos[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        context.read<GalleryData>().loadAnotherPage();
      },
      child: Icon(Icons.add)),
    );
  }
}
