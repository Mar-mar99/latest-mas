import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/profile/full_avatar.dart';
import '../../../domain/entities/expert_activity_entity.dart';

class UserActivityCard extends StatelessWidget {
  final UserActivityEntity userActivity;
  const UserActivityCard({Key? key, required this.userActivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).scaffoldBackgroundColor),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                child: FullAvatar(
                  url: userActivity.avatar ?? '',
                  name: userActivity.name ?? '',
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText(
                    '${AppLocalizations.of(context)?.activityName ?? ""} ${userActivity.name ?? ''}',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AppText(
                    '${AppLocalizations.of(context)?.activityRevenue ?? ""} ${userActivity.revenue ?? ''}',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AppText(
                    '${AppLocalizations.of(context)?.activityCompleted ?? ""} ${userActivity.completed ?? ''}',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AppText(
                    '${AppLocalizations.of(context)?.activityCanceled ?? ""} ${userActivity.canceled ?? ''}',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      AppText(
                        '${AppLocalizations.of(context)?.activityRating ?? ""}  ${userActivity.rating ?? ''}',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
