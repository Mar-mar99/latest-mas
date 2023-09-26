import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../../../core/utils/helpers/helpers.dart';
import '../../../domain/entities/company_emirates_entity.dart';
import '../bloc/update_company_emirates_bloc.dart';

class CompanyEmiratesWidgets extends StatefulWidget {
  final List<CompanyEmiratesEntity> data;
  const CompanyEmiratesWidgets({super.key, required this.data});

  @override
  State<CompanyEmiratesWidgets> createState() => _CompanyEmiratesWidgetsState();
}

class _CompanyEmiratesWidgetsState extends State<CompanyEmiratesWidgets> {
  List<bool> changedData = [];
  var selectedHead;

  @override
  void initState() {
    super.initState();
    Helpers.modelBuilder(widget.data, (index, model) {
      if (model.isMainBranch) {
        selectedHead = index;
      }
      changedData.add(model.isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ..._getItem(widget.data),
        const SizedBox(
          height: 16,
        ),
        _buildSaveBtn(context)
      ],
    );
  }

  Widget _buildSaveBtn(BuildContext context) {
    return BlocBuilder<UpdateCompanyEmiratesBloc, UpdateCompanyEmiratesState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state is LoadingUpdateCompanyEmirates,
          title: AppLocalizations.of(context)!.save,
          onTap: () {
            BlocProvider.of<UpdateCompanyEmiratesBloc>(context).add(
              UpdateEmiratesEvent(
                states: changedData,
                headState: selectedHead,
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _getItem(List<CompanyEmiratesEntity> data) {
    return Helpers.modelBuilder(
        data,
        (index, emirate) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.grey,
                      ),
                      child: Checkbox(
                          value: changedData[index],
                          onChanged: (value) {
                            setState(() {
                              changedData[index] = value!;
                            });
                          }),
                    ),
                    Text(emirate.name),
                  ],
                ),
                if (changedData[index] == true)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedHead = index;
                      });
                    },
                    icon: Icon(
                      Icons.stars,
                      color: selectedHead == index ? Colors.amber : Colors.grey,
                    ),
                  )
              ],
            ));
  }
}
