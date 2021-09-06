import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_gallery_flutter/services/network_helper.dart';

import '../keys.dart';

class PhotoGallery extends StatefulWidget {
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {

  int _pageNumber = 1;

  Future<List<String>>? images;

  Future<List<String>> getImagesFromPixaby() async {
    List<String> pixabyImages = [];

    String url =
        "https://pixabay.com/api/?key=$pixabyAPIKey&image_type=photo&per_page=20&page=$_pageNumber";

    NetworkHelper networkHelper = NetworkHelper(url: url);

    dynamic data = await networkHelper.getData();

    for (var i = 0; i < 20; i++) {
      pixabyImages.add(data["hits"][i]["largeImageURL"]);
    }

    return pixabyImages;
  }

  @override
  void initState() {
    super.initState();

    images = getImagesFromPixaby();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: images,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: Text("Error"));
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return GridView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0),
                  itemBuilder: (BuildContext context, int index) {
                    return CachedNetworkImage(
                      imageUrl: snapshot.data![index],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  },
                );
              default:
                return Text("Default");
            }
          },
        ),
      )),
    );
  }
}
