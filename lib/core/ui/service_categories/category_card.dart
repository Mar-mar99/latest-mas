// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../utils/helpers/helpers.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback handlerOnTap;
  const CategoryCard({
    Key? key,
    required this.title,
    required this.image,
    required this.handlerOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
             handlerOnTap();
            },
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                      Helpers.getImage(
                        image,
                      ),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                ),
              ),
            ),
          ),
        ),
        Text(title,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }
}
