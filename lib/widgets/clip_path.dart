import 'package:flutter/material.dart';

import '../utils/clips_koordinat.dart';

class UstDalga extends StatelessWidget {
  const UstDalga({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipperTop(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: const BoxDecoration(color: Color(0xFF333333)),
      ),
    );
  }
}