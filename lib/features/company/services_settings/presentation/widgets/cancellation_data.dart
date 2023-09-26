// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/features/company/services_settings/presentation/bloc/set_cancellation_bloc.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/ui/widgets/app_switch.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';

class CancellationData extends StatefulWidget {
  final bool isEnabled;
  final num fee;
  final int serviceId;
  const CancellationData({
    Key? key,
    required this.isEnabled,
    required this.fee,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<CancellationData> createState() => _CancellationDataState();
}

class _CancellationDataState extends State<CancellationData> {
  late bool isEnabled;
  TextEditingController feeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isEditing = false;
  @override
  void initState() {
    super.initState();
    isEnabled = widget.isEnabled;
    feeController.text = widget.fee.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(children: [
            _buildSwitch(context),
            const SizedBox(
              height: 16,
            ),
            if (isEnabled)
              _buildCancellationFee(
                context,
              ),
            if (isEditing) _buildFeeField()
          ]),
        ),
        _buildUpdateBtn(context)
      ],
    );
  }

  Widget _buildUpdateBtn(BuildContext context) {
    return BlocBuilder<SetCancellationBloc, SetCancellationState>(
      builder: (context, state) {
        return AppButton(
          isLoading: state is LoadingSetCancellation,
          title: AppLocalizations.of(context)!.update,
          onTap: () {
            if (isEditing) {
              bool isValid = formKey.currentState!.validate();
              if (isValid) {
                BlocProvider.of<SetCancellationBloc>(context).add(
                  SetCancellationSettings(
                    fees: double.parse(feeController.text),
                    hasCancellationFees: isEnabled,
                    serviceId: widget.serviceId,
                  ),
                );
              }
            } else {
              BlocProvider.of<SetCancellationBloc>(context).add(
                SetCancellationSettings(
                  fees: double.parse(feeController.text),
                  hasCancellationFees: isEnabled,
                  serviceId: widget.serviceId,
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildCancellationFee(
    BuildContext context,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Row(
        children: [
          Text('${AppLocalizations.of(context)!.cancelation}: '),
          Text(!isEditing ? '${feeController.text} %' : ''),
        ],
      ),
      trailing: isEditing == false
          ? IconButton(
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
              icon: const Icon(
                Icons.edit,
              ),
            )
          : null,
    );
  }

  Widget _buildFeeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${AppLocalizations.of(context)!.enter_a_cancellation_fee}'),
        Container(
          width: MediaQuery.of(context).size.width - 32,
          child: Form(
            key: formKey,
            child: AppTextField(
              controller: feeController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '${AppLocalizations.of(context)!.cannot_be_empty}';
                } else if (double.tryParse(value) == null) {
                  return '${AppLocalizations.of(context)!.make_sure_you_entered_a_valid_number}';
                } else if (double.parse(value) < 1 ||
                    double.parse(value) > 100) {
                  return '${AppLocalizations.of(context)!.fee_range_error}';
                }

                return null;
              },
            ),
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () {
              setState(() {
                isEditing = false;
                feeController.text = widget.fee.toString();
              });
            },
            child: Text('cancel'))
      ],
    );
  }

  Row _buildSwitch(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.enable_disable_cancelation_fees,
          style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
        ),
        CustomSwitch(
          value: isEnabled,
          onChanged: () async {
            setState(() {
              isEnabled = !isEnabled;
            });
          },
          inactiveColor: Colors.grey[300],
          activeColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
