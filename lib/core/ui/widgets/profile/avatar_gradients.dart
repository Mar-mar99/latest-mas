import 'package:flutter/material.dart';

class AvatarGradients {
  static List<Color> getGradients(String name) {
    int code = name.isNotEmpty ? name.toUpperCase()[0].codeUnits[0] : 1;
    code += (name.length) > 1 ? name.toUpperCase()[1].codeUnits[0] : 0;

    List<List<Color>> colors = [
      [
        const Color.fromRGBO(150, 222, 218, 1.0),
        const Color.fromRGBO(80, 201, 195, 1.0),
      ],
      [
        const Color.fromRGBO(102, 126, 254, 1.0),
        const Color.fromRGBO(148, 75, 192, 1.0),
      ],
      [
        const Color.fromRGBO(255, 177, 153, 1.0),
        const Color.fromRGBO(255, 8, 68, 1.0),
      ],
      [
        const Color.fromRGBO(100, 210, 255, 1.0),
        const Color.fromRGBO(10, 60, 255, 1.0),
      ],
      [
        const Color.fromRGBO(83, 120, 149, 1.0),
        const Color.fromRGBO(9, 32, 63, 1.0),
      ],
      [
        const Color.fromRGBO(48, 210, 190, 1.0),
        const Color.fromRGBO(53, 132, 167, 1.0),
      ],
      [
        const Color.fromRGBO(255, 179, 169, 1.0),
        const Color.fromRGBO(245, 103, 144, 1.0),
      ]
    ];

    return colors[code % colors.length];
  }

}
