import 'package:flutter/material.dart';

// TODO BORDER SUPPORT
// This is a wrapper widget for loading images by providing a placeholder and fallback image
// when trying to load any image provider (Asset, network...)
// Also supports scaling and aspect ratios
class FutureImage extends StatefulWidget {
  const FutureImage({
    super.key,
    required this.image,
    this.errorImageUri,
    this.height,
    this.width,
    this.aspectRatio,
  });

  final ImageProvider image;
  final String? errorImageUri;
  final double? height;
  final double? width;
  final double? aspectRatio;

  @override
  State<FutureImage> createState() => _FutureImageState();
}

class _FutureImageState extends State<FutureImage> {
  @override
  Widget build(BuildContext context) {
    Widget imageWidget = FadeInImage(
      image: widget.image,
      placeholder: const AssetImage('assets/images/loading.gif'),
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(
            widget.errorImageUri ?? 'assets/images/placeholder.png',
            fit: BoxFit.contain);
      },
      fit: BoxFit.contain,
      placeholderFit: BoxFit.fill,
    );

    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: (widget.aspectRatio != null)
            ? AspectRatio(aspectRatio: widget.aspectRatio!, child: imageWidget)
            : imageWidget);
  }
}
