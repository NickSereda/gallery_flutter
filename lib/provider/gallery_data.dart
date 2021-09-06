import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:photo_gallery_flutter/services/network_helper.dart';

import '../keys.dart';

class GalleryData extends ChangeNotifier {
  int _pageNumber = 1;

  List<String> _photos = [];

  int get photosCount {
    return _photos.length;
  }

  UnmodifiableListView<String> get photos {
    return UnmodifiableListView(_photos);
  }

  Future<void> getPhotos() async {
    List<String> pixabyImages = [];

    String url =
        "https://pixabay.com/api/?key=$pixabyAPIKey&image_type=photo&per_page=20&page=$_pageNumber";

    NetworkHelper networkHelper = NetworkHelper(url: url);

    dynamic data = await networkHelper.getData();

    for (var i = 0; i < 20; i++) {
      pixabyImages.add(data["hits"][i]["largeImageURL"]);
    }

    _photos = pixabyImages;
    notifyListeners();
  }

  Future<void> loadAnotherPage() async {
    String url =
        "https://pixabay.com/api/?key=$pixabyAPIKey&image_type=photo&per_page=20&page=${_pageNumber + 1}";

    NetworkHelper networkHelper = NetworkHelper(url: url);

    dynamic data = await networkHelper.getData();

    for (var i = 0; i < 20; i++) {
      _photos.add(data["hits"][i]["largeImageURL"]);
    }

    notifyListeners();
  }
}
