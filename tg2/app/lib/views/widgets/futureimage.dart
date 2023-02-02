import 'package:flutter/material.dart';

// This is a wrapper widget for loading images from any image provider (Asset, network...)
// It supports placeholder and fallback images, scaling, aspect ratios, borders...
class FutureImage extends StatefulWidget {
  const FutureImage(
      {super.key, required this.image, this.height, this.width, this.aspectRatio, this.borderRadius, this.color});

  final Image image;
  final double? height;
  final double? width;
  final double? aspectRatio;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  State<FutureImage> createState() => _FutureImageState();
}

class _FutureImageState extends State<FutureImage> {
  @override
  Widget build(BuildContext context) {
    Widget imageWidget = FadeInImage(
      image: widget.image.image,
      placeholder: const AssetImage('assets/images/loading.gif'),
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/placeholder.png', fit: BoxFit.contain);
      },
      fit: BoxFit.contain,
      placeholderFit: BoxFit.fill,
    );

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.color,
          ),
          child: (widget.aspectRatio != null)
              ? AspectRatio(aspectRatio: widget.aspectRatio!, child: imageWidget)
              : imageWidget),
    );
  }
}
