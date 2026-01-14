import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool circular;
  final double? radius;
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.circular = false,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) {
        final Widget retImage = Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
        );
        if (circular) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(99999),
            child: retImage,
          );
        }
        if (radius != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: retImage,
          );
        }
        return Image(image: imageProvider);
      },
      errorWidget: (context, url, err) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            child: Icon(Icons.image),
            decoration: BoxDecoration(
              shape: circular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: circular ? null : BorderRadius.circular(radius ?? 0.0),
              color: Colors.white,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).scaffoldBackgroundColor,
          highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: circular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: circular ? null : BorderRadius.circular(radius ?? 0.0),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
