// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import 'package:flutter/src/widgets/framework.dart';

// List<Color> cardColors = [
//   const Color.fromARGB(255, 255, 255, 255),
//   const Color.fromARGB(255, 246, 215, 153),
//   const Color.fromARGB(255, 171, 246, 148),
//   const Color.fromARGB(255, 247, 153, 179),
//   const Color.fromARGB(255, 241, 247, 143),
//   const Color.fromARGB(255, 245, 132, 132),
//   Color.fromARGB(255, 58, 101, 92),
// ];

// class ColorPicker extends StatefulWidget {
//   int index;
//   final Function(int) onTap;
//   ColorPicker({super.key, required this.onTap, required this.index});

//   @override
//   State<ColorPicker> createState() => _ColorPickerState();
// }

// class _ColorPickerState extends State<ColorPicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 30,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           Container(
//             margin: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//                 color: cardColors[index],
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: CupertinoColors.black, width: 2)),
//           );
//         },
//         itemCount: cardColors.length,
//       ),
//     );
//   }
// }
