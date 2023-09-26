// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/ui/widgets/small_button.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../domain/entities/request_past_provider_entity.dart';
import '../bloc/rate_provider_bloc.dart';

class ProviderRatingWidget extends StatefulWidget {
  final RatingEntity? rating;
  final int id;
  const ProviderRatingWidget({
    Key? key,
    required this.rating,
    required this.id,
  }) : super(key: key);

  @override
  State<ProviderRatingWidget> createState() => _ProviderRatingWidgetState();
}

class _ProviderRatingWidgetState extends State<ProviderRatingWidget> {
  final formKey = GlobalKey<FormState>();
  late double? ratingValue;
  double enteredRate = 3;
  @override
  void initState() {
    super.initState();

    ratingValue =
        widget.rating == null ? null : widget.rating!.providerRating!.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RateProviderBloc, RateProviderState>(
        listener: (context, state) {
          _buildRateListener(state, context);
        },
        child: ratingValue == null
            ? SmallButton(
                onTap: () {
                  _onTapHandler(context);
                },
                title: AppLocalizations.of(context)?.rateLabel ?? "",
                color: Theme.of(context).primaryColor.withOpacity(0.25),
              )
            : Row(
                children: [
                  AppText(
                    '$ratingValue',
                    bold: true,
                  ),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  )
                ],
              ));
  }

  void _buildRateListener(RateProviderState state, BuildContext context) {
    if (state is LoadedRateProvider) {
      ToastUtils.showSusToastMessage('Thank you');
      Navigator.pop(context);
    } else if (state is RateProviderOfflineState) {
      ToastUtils.showErrorToastMessage('NO internet Connection');
    } else if (state is RateProviderErrorState) {
      ToastUtils.showErrorToastMessage('An error occurred, try again');
    }
  }

  void _onTapHandler(BuildContext context) {
    TextEditingController enterTextEditingController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<RateProviderBloc>(context),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                5,
              ),
            ),
            buttonPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            title: Text(
              AppLocalizations.of(context)!.leaveAReview,
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: formKey,
                          child: AppTextField(
                            controller: enterTextEditingController,
                            minLines: 3,
                            maxLines: 5,
                            hintText: AppLocalizations.of(context)!
                                .pleaseEnterComment,
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return AppLocalizations.of(context)!
                                    .pleaseEnterComment;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              enteredRate = rating;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        BlocBuilder<RateProviderBloc, RateProviderState>(
                          builder: (context, state) {
                            return state is LoadingRateProvider
                                ? const CircularProgressIndicator()
                                : Row(
                                    children: [
                                      _buildCancelBtn(context),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      _buildReviewBtn(
                                          context, enterTextEditingController),
                                    ],
                                  );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewBtn(
    BuildContext context,
    TextEditingController enterTextEditingController,
  ) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            if (enteredRate > 0) {
              BlocProvider.of<RateProviderBloc>(context).add(
                RateEvent(
                  rating: enteredRate.toInt(),
                  requestId: widget.id,
                  comment: enterTextEditingController.text,
                ),
              );
              setState(() {
                ratingValue = enteredRate;
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: Text(
          AppLocalizations.of(context)!.reviewLabel,
        ),
      ),
    );
  }

  Widget _buildCancelBtn(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop(false);
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
}
