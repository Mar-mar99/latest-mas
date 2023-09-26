// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/utils/helpers/custome_page_route.dart';
import '../../../domain/entities/service_entity.dart';
import '../../request_service/masbar_choosen/screens/masbar_request_service_screen.dart';
import '../../request_service/user_choosen/screens/user_request_service_screen.dart';

class RequestDialog extends StatefulWidget {
  final ServiceEntity serviceEntity;
  const RequestDialog({
    Key? key,
    required this.serviceEntity,
  }) : super(key: key);

  @override
  State<RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<RequestDialog> {
  int selectedValue=1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
               '${AppLocalizations.of(context)!.how_would_you_like_to_choose_your_service}',
                textAlign: TextAlign.center,
              ),
                const SizedBox(
                    height: 8,
                  ),
              Row(
                children: [
                  Expanded(
                      child: _buildItem(
                          image: 'assets/images/logo.jpg',
                          title: AppLocalizations.of(context)!.let_masbar_choose_for_me,
                          value: 1)),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: _buildItem(
                          image: 'assets/images/choosing.png',
                          title: AppLocalizations.of(context)!.let_me_pick_the_service_provider,
                          value: 2)),
                ],
              ),
                const SizedBox(
                    height: 8,
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCancelBtn(context),
                  const SizedBox(
                    width: 20,
                  ),
                  _buildNextButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildCancelBtn(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(.5),
        ),
        child: Text(
         AppLocalizations.of(context)!.cancel,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Expanded _buildNextButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          switch (selectedValue) {
            case 1:
              Navigator.pop(context);
              Navigator.push(
                context,
                CustomePageRoute(
                    child: MasbarRequestServiceScreen(
                        serviceEntity: widget.serviceEntity),
                    direction: AxisDirection.up),
              );
              break;
            case 2:
             Navigator.pop(context);
              Navigator.push(
                context,
                CustomePageRoute(
                    child: UserRequestServiceScreen(
                        serviceEntity: widget.serviceEntity),
                    direction: AxisDirection.up),
              );
              break;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: Text(
          AppLocalizations.of(context)!.choose,
        ),
      ),
    );
  }

  Container _buildItem(
      {required String image, required String title, required int value}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xF0FFFFFF),
          border: Border.all(color: Colors.grey, width: 0.4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 100,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.grey),
            child: Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: value,
              groupValue: selectedValue,
              onChanged: (v) {
                setState(() {
                  selectedValue = v!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
