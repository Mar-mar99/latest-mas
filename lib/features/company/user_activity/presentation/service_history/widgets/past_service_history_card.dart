// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../domain/entities/service_history_entity.dart';
import '../screen/request_company_details_screen.dart';

class PastServiceHistoryCard extends StatelessWidget {
  final ServiceHistoryEntity data;
  const PastServiceHistoryCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(width: 0.2,color: Colors.grey)
        ),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data.name??'',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4,),
                      AppText(
                       data.finishedAt ??'',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            color: (data.status! ) == 'CANCELLED' ? Colors.red :Colors.green,
                            borderRadius: BorderRadius.circular(12)
                        ),
                      ),
                      const SizedBox(width: 8,),
                      AppText(
                       data.status! ,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children:  [
                  MiniAvatar(
                    url:data.providerAvatar ??'' ,
                    name: data.providerName ??'' ,
                    disableProfileView: true,
                  ),
                  const SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        data.providerName ??'' ,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 4,),
                      Row(
                        children: [
                          AppText(
                            data.providerRating ??'',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          const Icon( Icons.star ,
                            color:  Colors.amber ,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if( (data.status!  ) == 'COMPLETED')
                      Column(
                        children: [
                          AppText(
                            '${AppLocalizations.of(context)?.uadLabel??""} ${data.paymentValue??''}',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    const Spacer(),
                    AppButton(
                      onTap: (){
                        Navigator.pushNamed(context, RequestCompanyDetailsScreen.routeName,arguments: {'id':data.requestId});
                      },
                      isSmall: true,
                      buttonColor: ButtonColor.green,
                      title: AppLocalizations.of(context)?.viewDetails??"",
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

