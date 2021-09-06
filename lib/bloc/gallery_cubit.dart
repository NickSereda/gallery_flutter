import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photo_gallery_flutter/services/network_helper.dart';

import '../keys.dart';

part 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit()
      : super(GalleryState(images: [], galleryStatus: GalleryStatus.initial));

  int _pageNumber = 1;

  Future<void> getPhotos() async {
    try {
      emit(state.copyWith(galleryStatus: GalleryStatus.imagesLoading));

      List<String> pixabyImages = [];

      String url =
          "https://pixabay.com/api/?key=$pixabyAPIKey&image_type=photo&per_page=20&page=$_pageNumber";

      NetworkHelper networkHelper = NetworkHelper(url: url);

      dynamic data = await networkHelper.getData();

      List images = data["hits"];

      for (var i = 0; i < images.length; i++) {
        pixabyImages.add(data["hits"][i]["largeImageURL"]);
      }

      if (pixabyImages.isEmpty) {
        emit(state.copyWith(galleryStatus: GalleryStatus.imagesEmpty));
      } else {
        emit(state.copyWith(
            galleryStatus: GalleryStatus.imagesLoaded, images: pixabyImages));
      }
    } catch (e) {
      emit(state.copyWith(galleryStatus: GalleryStatus.error));
    }
  }

  Future<void> loadMore() async {
    try {
      emit(state.copyWith(galleryStatus: GalleryStatus.imagesLoading));

      List<String> pixabyImages = [];

      String url;

      // Maximum 5 pages
      if (state.images!.length <= 60) {
        url =
            "https://pixabay.com/api/?key=$pixabyAPIKey&image_type=photo&per_page=20&page=${_pageNumber + 1}";
      } else {
        url =
            "https://pixabay.com/api/?key=$pixabyAPIKey&image_type=photo&per_page=20&page=$_pageNumber";
      }

      NetworkHelper networkHelper = NetworkHelper(url: url);

      dynamic data = await networkHelper.getData();

      List images = data["hits"];

      for (var i = 0; i < images.length; i++) {
        pixabyImages.add(data["hits"][i]["largeImageURL"]);
      }

      if (pixabyImages.isEmpty) {
        emit(state.copyWith(galleryStatus: GalleryStatus.imagesEmpty));
      } else {
        final List<String>? images = state.images ?? [];

        images?.addAll(pixabyImages);

        emit(state.copyWith(
            galleryStatus: GalleryStatus.imagesLoaded, images: images));

        if (state.images!.length >= 60) {
          emit(state.copyWith(galleryStatus: GalleryStatus.allImagesLoaded));
        }
      }
    } catch (e) {
      emit(state.copyWith(galleryStatus: GalleryStatus.error));
    }
  }
}
