import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'color.dart';

Widget AuthorCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Style.cardsColor[doc['color_id']],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc['author_name'],
            style: Style.mainTitle,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            doc['author_book'],
            style: Style.mainContext,
          ),
          SizedBox(
            height: 5,
          ),
          // Image.network(doc['image']),
          Image.network(doc['image']),
        ],
      ),
    ),
  );
}
