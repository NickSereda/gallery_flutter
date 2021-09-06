part of 'gallery_cubit.dart';

enum GalleryStatus {
  initial,
  error,
  imagesLoading,
  imagesEmpty,
  imagesLoaded,
  allImagesLoaded,
}

class GalleryState extends Equatable {

  final GalleryStatus? galleryStatus;

  final List<String>? images;

  const GalleryState({this.images, this.galleryStatus});

  @override
  List<Object?> get props => [images, galleryStatus];

  GalleryState copyWith({
    List<String>? images,
    GalleryStatus? galleryStatus,
  }) {
    return GalleryState(
      images: images ?? this.images,
      galleryStatus: galleryStatus ?? this.galleryStatus,
    );
  }
}
