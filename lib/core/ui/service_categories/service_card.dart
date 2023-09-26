// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../utils/helpers/helpers.dart';
import '../widgets/app_text.dart';

class ServiceCard extends StatelessWidget {
    final String title;
  final String image;
  final VoidCallback handlerOnTap;
  const ServiceCard({
    Key? key,
    required this.title,
    required this.image,
    required this.handlerOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return InkWell(
      onTap: () {
       handlerOnTap();

      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xF0FFFFFF),
            border: Border.all(color: Colors.grey, width: 0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Image.network(
                    Helpers.getImage(image),
                    fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppText(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
