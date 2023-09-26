import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';
import 'package:masbar/features/user/payment_methods/domain/use_cases/add_card_use_case.dart';
import 'package:masbar/features/user/payment_methods/presentation/screens/payment_methods_screen.dart';
import 'package:stripe_api_2/stripe_api.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../../../../../core/api_service/network_service_http.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../../core/utils/helpers/credit_card_utils.dart';
import '../../../../../core/utils/helpers/toast_utils.dart';
import '../../data/data_source/payment_data_source.dart';
import '../../data/repositories/payment-method_repo_impl.dart';
import '../bloc/add_card_bloc.dart';
import '../bloc/get_payments_bloc.dart';

class AddCardScreen extends StatefulWidget {
  static const routeName = 'add_card_screen';
  AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> numberKey =
      GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> cvvKey =
      GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> dateKey =
      GlobalKey<FormFieldState<String>>();

  final GlobalKey<FormFieldState<String>> holderKey =
      GlobalKey<FormFieldState<String>>();

  String cardNumber = '';

  String expiryDate = '';

  String cardHolderName = '';

  String cvvCode = '';
  bool isCvvFocused = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(builder: (context) {
        return BlocListener<AddCardBloc,AddCardState>(
          listener: (context, state) {
              if (state.formSubmissionState is FormSubmittingState) {
      showLoadingDialog(context);
    } else if (state.formSubmissionState is FormNoInternetState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internnet Connection');
    } else if (state.formSubmissionState is FormNetworkErrorState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage((state.formSubmissionState as FormNetworkErrorState).message);
    } else if (state.formSubmissionState is FormSuccesfulState) {
      Navigator.pop(context);
      ToastUtils.showSusToastMessage('The card has been added successfully');
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, PaymentMethodsScreen.routeName);

     }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.addCardTitle,
              ),
            ),
            body: BlocBuilder<AddCardBloc, AddCardState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        75,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              CreditCardForm(
                                formKey: formKey,
                                cardNumberKey: numberKey,
                                cvvCodeKey: cvvKey,
                                expiryDateKey: dateKey,
                                cardHolderKey: holderKey,

                                onCreditCardModelChange: onCreditCardModelChange,
                                themeColor: Colors.red,
                                cardNumberValidator: (p0) =>
                                    CardUtils.validateNumber(context, p0),
                                expiryDateValidator: (p0) =>
                                    CardUtils.validateDate(p0, context),
                                cardHolderValidator: (p0) =>
                                    CardUtils.validateCardHolder(p0, context),
                                cvvValidator: (p0) =>
                                    CardUtils.validateCVV(p0, context),
                                cardNumberDecoration: InputDecoration(
                                  border: OutlineInputBorder(),

                                  labelText:
                                      AppLocalizations.of(context)!.cardNumber,
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)!
                                      .cardholderName,
                                ),
                                obscureCvv: false,
                                obscureNumber: false,
                                cardNumber: cardNumber,
                                cvvCode: cvvCode,
                                cardHolderName: cardHolderName,
                                expiryDate: expiryDate,
                                isHolderNameVisible: true,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                              ),
                              _buildInfo(context),
                            ],
                          ),
                        ),
                        _buildSubmitBtn(
                          context,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  AddCardBloc _getBloc() {
    return AddCardBloc(
        addCardUseCase: AddCardUseCase(
            paymentMethodsRepo: PaymentMethodsRepoImpl(
                paymentDataSource: PaymentDataSourWithHttp(
      client: NetworkServiceHttp(),
    ))));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Widget _buildSubmitBtn(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
        title: AppLocalizations.of(context)?.securelySaveCardLabel ?? "",
        // isLoading: isLoading,
        // isDisabled: !(controller.details.complete),
        onTap: () async {
          bool isValid1 = cvvKey.currentState!.validate();
          bool isValid2 = numberKey.currentState!.validate();
          bool isValid3 = holderKey.currentState!.validate();
          bool isValid4 = dateKey.currentState!.validate();
          if (isValid1 && isValid2 && isValid3 && isValid4) {
            StripeCard stripeCard = StripeCard(
                number: cardNumber.replaceAll(' ', ''),
                cvc: cvvCode.trim(),
                expMonth: CardUtils.getMonth(expiryDate),
                expYear: CardUtils.getYear(expiryDate));
            BlocProvider.of<AddCardBloc>(context)
                .add(AddEvent(stripeCard: stripeCard));
          }

          // setState(() {
          //   error = "";
          // });
          // final form = addCardKey.currentState;
          // if (form?.validate() ?? false) {
          //   if (card.validateCard()) {
          //     setState(() {
          //       isLoading = true;
          //     });

          //     try {
          //       await payments.saveCard();
          //       Navigator.pop(context);
          //     } catch (e) {
          //       if (e is PlatformException) {
          //         setState(() {
          //           error = e.message.toString();
          //           isLoading = false;
          //         });
          //       }
          //       //  DialogPayment.dialogSuccess(context,'حدث خطأ ما',true);
          //     }
          //   } else {
          //     setState(() {
          //       /// we need to fix the issues
          //       /// so we need to get the app done
          //       error = "Card details are not valid.";
          //     });
          //   }
          //    }
        },
        icon: const Icon(
          EvaIcons.lockOutline,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        text: TextSpan(
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),
            children: [
              TextSpan(
                  text: AppLocalizations.of(context)?.paymentProviderMessage ??
                      "",
                  style: TextStyle(color: Colors.grey[500])),
              TextSpan(
                  text:
                      AppLocalizations.of(context)?.learnMoreAboutStripe ?? "",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      try {
                        if (Platform.isAndroid) {
                          launchUrlString(ApiConstants.stripeInfo);
                        } else {
                          launchUrlString(ApiConstants.stripeInfo);
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    })
            ]),
      ),
    );
  }
}
