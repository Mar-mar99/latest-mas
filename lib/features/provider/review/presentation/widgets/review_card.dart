// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:masbar/features/provider/review/domain/entities/review_entity.dart';

import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/profile/mini_avatar.dart';

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              MiniAvatar(
                url: review.user?.picture ??'',
                name: review.user?.firstName ??'',
                disableProfileView: true,
              ),
              const SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '${review.user?.firstName ??''} ${review.user?.lastName ??''}',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    children: [
                      ...List.generate(5, (index) => Icon(
                        index < (review.userRating ??0) ? Icons.star : Icons.star_border,
                        color: index<(review.userRating ??0) ? Colors.amber : Colors.grey,
                        size: 15,
                      ))
                    ],
                  ),
                  const SizedBox(height: 5,),
                ],
              ),
            ],
          ),
      if(review.userComment!=null && review.userComment!.isNotEmpty)
      ...[    const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:  AppText(
              review.userComment??'',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          )
      ]
        ],
      ),
    );
  }
}
