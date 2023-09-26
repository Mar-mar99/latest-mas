import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/managers/font_manager.dart';
import 'package:masbar/core/ui/widgets/app_button.dart';
import 'package:masbar/core/ui/widgets/app_drop_down.dart';

import '../../../../../../../core/utils/helpers/helpers.dart';

class CompanyWorkingAreaScreen extends StatefulWidget {
  static const routeName = 'company_working_area_screen';
  CompanyWorkingAreaScreen({super.key});

  @override
  State<CompanyWorkingAreaScreen> createState() =>
      _CompanyWorkingAreaScreenState();
}

class _CompanyWorkingAreaScreenState extends State<CompanyWorkingAreaScreen> {
  var data = [
    {
      'Abu dahbi': ['Area 1', 'Area 2'],
    },
    {
      'Dubai': ['Area 1', 'Area 2', 'Area 3'],
    },
  ];
  late Map<String, dynamic> selectd;
  @override
  void initState() {
    super.initState();
    selectd = data[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.companyWorkingAreas),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.select_emirate),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                    label: Text(AppLocalizations.of(context)!.add_new_working_area),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              AppDropDown<Map<String, dynamic>>(
                hintText: AppLocalizations.of(context)!.states,
                items: Helpers.modelBuilder(data, (index, model) {
                  return _buildServicesDropMenuItem(context, model);
                }),
                initSelectedValue: selectd,
                onChanged: (value) {
                  setState(() {
                    selectd = value;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Text(AppLocalizations.of(context)!.working_areas_name),
              const SizedBox(
                height: 4,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: (selectd[selectd.keys.first] as List)
                      .map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$e',
                                      style: TextStyle(
                                          fontSize: FontSize.s14,
                                          color: Colors.grey[800]),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                              alignment: Alignment.center,
                                              width: 40,
                                              height: 40,

                                              child: Image.asset(
                                                  'assets/icon/icon_map.png')),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),

                                          onPressed: () {},
                                          // child: Text('Remove'),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ))
                      .toList())
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<Map<String, dynamic>> _buildServicesDropMenuItem(
      BuildContext context, Map<String, dynamic> e) {
    return DropdownMenuItem<Map<String, dynamic>>(
      value: e,
      child: Text(
        e.keys.first,
      ),
    );
  }
}
