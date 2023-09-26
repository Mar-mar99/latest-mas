// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../domain/entities/promotion_entity.dart';
import '../bloc/update_promo_bloc.dart';

class EditPromoWidget extends StatefulWidget {
  final int id;
  final String promo;
  final num discount;
  final DateTime expire;
  final List<ServicePromotionEntity> servicePromotionEntity;
  const EditPromoWidget({
    Key? key,
    required this.id,
    required this.promo,
    required this.discount,
    required this.expire,
    required this.servicePromotionEntity,
  }) : super(key: key);

  @override
  State<EditPromoWidget> createState() => _EditPromoWidgetState();
}

class _EditPromoWidgetState extends State<EditPromoWidget> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController promoController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController expireController = TextEditingController();
  List<ServicePromotionEntity> allServices = [];
  List<ServicePromotionEntity> selectedServices = [];
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    promoController.text = widget.promo;
    discountController.text = widget.discount.toString();
    expireController.text =
        '${widget.expire.year}/${widget.expire.month}/${widget.expire.day}';
    allServices = widget.servicePromotionEntity;
    for (var e in widget.servicePromotionEntity) {
      if (e.isAssigned) {
        selectedServices.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPromo(),
              const SizedBox(
                height: 16,
              ),
              _buildDiscount(),
              const SizedBox(
                height: 16,
              ),
              _buildeExpiration(context),
              const SizedBox(
                height: 16,
              ),
              //_buildCompanyServices()
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          _buildAddBtn(context)
        ],
      ),
    );
  }

  Widget _buildAddBtn(BuildContext context) {
    return BlocBuilder<UpdatePromoBloc, UpdatePromoState>(
      builder: (context, state) {
        return AppButton(
          title: AppLocalizations.of(context)!.update,
          isLoading: state is LoadingUpdatePromo,
          onTap: () {
            final isValid = formKey.currentState!.validate();

            if (isValid) {
              BlocProvider.of<UpdatePromoBloc>(context).add(
                UpdateEvent(
                  id: widget.id,
                  promo: promoController.text,
                  discount: num.parse(discountController.text),
                  expiration: selectedDate,
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildPromo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.promoCode),
        AppTextField(
          controller: promoController,
          hintText: AppLocalizations.of(context)!.promoCode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.cannot_be_empty;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDiscount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.discount),
        AppTextField(
          controller: discountController,
          hintText: AppLocalizations.of(context)!.discount,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.cannot_be_empty;
            } else if (double.tryParse(value) == null) {
              return AppLocalizations.of(context)!
                  .make_sure_you_entered_a_valid_number;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildeExpiration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(AppLocalizations.of(context)!.expiration),
        AppTextField(
            controller: expireController,
            hintText: AppLocalizations.of(context)!.expire_date,
            onTap: () async {
              DateTime? returnedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100));
              if (returnedDate == null) return;
              setState(() {
                selectedDate = returnedDate;
                expireController.text =
                    '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
              });
            },
            readOnly: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            suffixIcon: (Icons.calendar_month),
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.cannot_be_empty;
              }
              return null;
            }),
      ],
    );
  }

 //  }
}
