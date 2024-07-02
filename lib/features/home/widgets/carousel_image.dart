import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:amazon_clone/constants/global_variables.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages
          .map((e) => Builder(
              builder: (context) => Image.network(
                    e,
                    fit: BoxFit.cover,
                    height: 200,
                  )))
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: 200,
      ),
    );
  }
}
