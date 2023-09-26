
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/features/user_emirate/domain/entities/uae_state_entity.dart';

import '../../../../../core/ui/widgets/app_drop_down.dart';
import '../bloc/social_login_bloc.dart';

showStatesDialog(
  BuildContext context,
  List<UAEStateEntity> states,
  SocialLoginBloc bloc,
) {
  return showDialog(
    context: context,
    builder: (c) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: StatesDropDown(
        states: states,
        bloc: bloc,
      ),
    ),
  );
}

class StatesDropDown extends StatefulWidget {
  final List<UAEStateEntity> states;
  final SocialLoginBloc bloc;

  const StatesDropDown({
    Key? key,
    required this.states,
    required this.bloc,
  }) : super(key: key);

  @override
  State<StatesDropDown> createState() => _StatesDropDownState();
}

class _StatesDropDownState extends State<StatesDropDown> {
  UAEStateEntity? selected;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.choose_your_emirate),
            const SizedBox(
              height: 8,
            ),
            AppDropDown<UAEStateEntity>(
              hintText: AppLocalizations.of(context)!.choose_your_emirate,
              items: widget.states
                  .map((e) => _buildDropMenuItem(context, e))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selected = value;
                });
              },
              initSelectedValue: selected,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCancelBtn(context),
                const SizedBox(
                  width: 4,
                ),
                _buildOkButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextButton _buildOkButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        widget.bloc.add(SocialSubmitEvent(state: selected!.id));

        Navigator.pop(context);
      },
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
      child: Text(AppLocalizations.of(context)!.ok),
    );
  }

  TextButton _buildCancelBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
      child: Text(AppLocalizations.of(context)!.cancel),
    );
  }

  DropdownMenuItem<UAEStateEntity> _buildDropMenuItem(
      BuildContext context, UAEStateEntity e) {
    return DropdownMenuItem<UAEStateEntity>(
      value: e,
      child: Text(
        e.state,
      ),
    );
  }
}
