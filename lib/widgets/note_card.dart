import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/styles/app_style.dart';

List<Color> cardColors = [
  const Color.fromARGB(255, 255, 255, 255),
  const Color.fromARGB(255, 246, 215, 153),
  const Color.fromARGB(255, 171, 246, 148),
  const Color.fromARGB(255, 247, 153, 179),
  const Color.fromARGB(255, 241, 247, 143),
  const Color.fromARGB(255, 245, 132, 132),
  const Color.fromARGB(255, 144, 246, 226),
];
Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardColors[doc["color_id"]],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc["note_title"],
            style: mainTitle,
          ),
          const SizedBox(height: 8),
          Text(
            doc["creation_date"],
            style: dateTitle,
          ),
          const SizedBox(height: 10),
          Text(
            doc["note_content"],
            style: mainContent,
            overflow: TextOverflow.fade,
            maxLines: 4,
          ),
        ],
      ),
    ),
  );
}
