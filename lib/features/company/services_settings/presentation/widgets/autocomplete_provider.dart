// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/company_provider_entity.dart';
import '../bloc/assign_provider_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class AutocompleteProvider extends StatefulWidget {
  final List<CompanyProviderEntity> providers;
  final int serviceId;
  const AutocompleteProvider({
    Key? key,
    required this.providers,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<AutocompleteProvider> createState() => _AutocompleteProviderState();
}

class _AutocompleteProviderState extends State<AutocompleteProvider> {
  bool isSelected = false;
  var providerId;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<CompanyProviderEntity>(
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextFormField(
              onChanged: (value) {
                setState(() {
                  isSelected = false;
                });
              },
              cursorColor: const Color.fromARGB(255, 45, 40, 40),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.grey.withOpacity(.3),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.grey.withOpacity(.3),
                  ),
                ),
              ),
              controller: textEditingController,
              focusNode: focusNode,
            );
          },

          displayStringForOption: (option) {
            print('hi');
            return option.name;
          },
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<CompanyProviderEntity>.empty();
            }
            return widget.providers.where(
              (element) => element.name.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
            );
          },
          onSelected: (option) {
            setState(() {
              providerId = option.id;
              isSelected = true;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        if (isSelected)
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<AssignProviderBloc>(context).add(
                  AssignProviderToServiceEvent(
                    serviceId: widget.serviceId,
                    providerId: providerId,
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.assign_provider))
      ],
    );
  }
}
