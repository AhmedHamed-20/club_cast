import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_cast/data_layer/bloc/intial_cubit/general_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class GenerateColor {
  static PaletteGenerator? extractcolor;
  static List<PaletteColor> colors = [];

  static Future<List<PaletteColor>> extractColor(
      String image, BuildContext context) async {
    PaletteGenerator extractcolor = await PaletteGenerator.fromImageProvider(
      ResizeImage(
        CachedNetworkImageProvider(image),
        height: 20,
        width: 20,
      ),
    );
    colors = extractcolor.paletteColors;
    GeneralAppCubit.get(context).changeState();

    return colors;
  }
}
