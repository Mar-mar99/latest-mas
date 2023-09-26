// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import '../widgets/app_textfield.dart';

class RatingDialog extends StatefulWidget {
  final Function reviewhandler;
  final Function closehandler;
  final bool showFav;
  const RatingDialog({
    Key? key,
    required this.reviewhandler,
    required this.closehandler,
    this.showFav = false,
  }) : super(key: key);

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final formKey = GlobalKey<FormState>();
  TextEditingController commentTextEditingController = TextEditingController();
  double enteredRate = 3;
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      buttonPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.leaveAReview,
            textAlign: TextAlign.center,
          ),
          _buildRating(),
          const SizedBox(
            height: 15,
          ),
        ],
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
                    child: _buildCommentField(context),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (widget.showFav)
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFav = !isFav;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isFav
                                ?
                                 "Remove from Favorites":
                                'Add to Favorites',
                            style: TextStyle(
                              color: isFav ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      _buildCancelBtn(context),
                      const SizedBox(
                        width: 15,
                      ),
                      _buildReviewBtn(context),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RatingBar _buildRating() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 30,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          enteredRate = rating;
        });
      },
    );
  }

  AppTextField _buildCommentField(BuildContext context) {
    return AppTextField(
      controller: commentTextEditingController,
      minLines: 3,
      maxLines: 5,
      hintText: AppLocalizations.of(context)!.pleaseEnterComment,
      validator: (val) {
        if (val.toString().isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterComment;
        }
        return null;
      },
    );
  }

  Widget _buildReviewBtn(
    BuildContext context,
  ) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            if (widget.showFav) {
              widget.reviewhandler(
                commentTextEditingController.text,
                enteredRate,
                isFav,
              );
            } else {
              widget.reviewhandler(
                commentTextEditingController.text,
                  enteredRate,
              );
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
          widget.closehandler();
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
