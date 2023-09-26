// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/utils/services/shared_preferences.dart';
import '../../../data/data_source/explore_services_data_source.dart';
import '../../../data/repositories/explore_services_repo_impl.dart';
import '../../../domain/entities/request_details_entity.dart';
import '../../../domain/use_cases/check_for_active_request_use_case.dart';
import '../../../domain/use_cases/get_request_details_use_case.dart';
import '../../service_details.dart/screen/service_details_screen.dart';

class ServiceDetailsBtn extends StatefulWidget {
  ServiceDetailsBtn({
    Key? key,
    //  required this.id,
  }) : super(key: key);

  @override
  State<ServiceDetailsBtn> createState() => _ServiceDetailsBtnState();
}

class _ServiceDetailsBtnState extends State<ServiceDetailsBtn> {

  final CheckForActiveRequestUseCase checkForService =
      CheckForActiveRequestUseCase(
    exploreServicesRepo: ExploreServicesRepoImpl(
      exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
        client: NetworkServiceHttp(),
      ),
    ),
  );


  Stream<int?> getData() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final res = await checkForService();
      yield res.fold(
        (l) {},
        (requestId) {
          if (requestId == null) {
            return null;
          } else {
            return requestId;
          }
        },
      );
    }
  }

  late Stream<int?> dataStream;
  @override
  void initState() {
    super.initState();
    dataStream = getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
        stream: dataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return  Container();
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Container();
            } else {
              return _buildServiceDetailsBtn(context, snapshot.data!);
            }
          }else{
            return Container();
          }
        });
  }

  Container _buildServiceDetailsBtn(BuildContext context, int id) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green.withOpacity(0.15),
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          AppText(
            AppLocalizations.of(context)?.activeService ?? "",
            fontSize: 18,
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, ServiceDetailsScreen.routeName,
                    arguments: {
                      "id": id,
                    });
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green[400]),
                height: 48,
                width: double.maxFinite,
                child: Center(
                  child: AppText(
                    AppLocalizations.of(context)?.details ?? "",
                    color: Colors.white,
                    bold: true,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
