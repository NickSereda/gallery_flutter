import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery_flutter/bloc/gallery_cubit.dart';

class PhotoGalleryCubitScreen extends StatefulWidget {
  @override
  _PhotoGalleryCubitScreenState createState() =>
      _PhotoGalleryCubitScreenState();
}

class _PhotoGalleryCubitScreenState extends State<PhotoGalleryCubitScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GalleryCubit>(
      create: (BuildContext context) => GalleryCubit()..getPhotos(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<GalleryCubit, GalleryState>(
            buildWhen: (prevState, currState) =>
                prevState.galleryStatus != currState.galleryStatus,
            builder: (context, state) {
              if (state.images!.isNotEmpty) {
                return NotificationListener<ScrollNotification>(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return CachedNetworkImage(
                              imageUrl: state.images![index],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: Container(
                                  margin: EdgeInsets.all(25),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black26),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.broken_image),
                            );
                          },
                          childCount: state.images?.length ?? 0,
                        ),
                      ),
                      if (state.galleryStatus == GalleryStatus.allImagesLoaded)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "end of story:(",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (state.galleryStatus == GalleryStatus.imagesLoading)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Center(
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black26),
                                  )),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      if (state.galleryStatus !=
                          GalleryStatus.allImagesLoaded) {
                        context.read<GalleryCubit>().loadMore();
                      }
                    }
                    return false;
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
