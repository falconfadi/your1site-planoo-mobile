import 'dart:async';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_multi_items_widget.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import 'package:centro_partner/features/home/data/usecase/facilities_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/facility/create_facility_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/facility/delete_facility_usecase.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FacilitiesWidget extends StatefulWidget {

  final String? ownerType;
  final int? ownerId;
  Set<int> selectedFacilitiesId;
  final bool? isEdit;

  FacilitiesWidget({super.key,this.ownerType,this.ownerId,required this.selectedFacilitiesId,this.isEdit});

  @override
  State<FacilitiesWidget> createState() => _FacilitiesWidgetState();
}

class _FacilitiesWidgetState extends State<FacilitiesWidget> {

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return GetModel<FacilityModel>(
      useCaseCallBack: () {
        return FacilitiesUseCase(HomeRepository())
            .call(params: FacilitiesParams());
      },
      modelBuilder: (model) => SelectMultiItemsWidget(
        title: AppLocalization.of(context).translate("facilities"),
        list: model.facilitiesList!,
        selectedIds: widget.selectedFacilitiesId,
        labelBuilder: (item) => item.name!,
        idBuilder: (item) => item.ID!,
        onSelect: (ids) {
          setState(() {
            widget.selectedFacilitiesId = ids;
          });
          if(widget.isEdit == true) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 400), () async {
              await CreateFacilityUseCase(HomeRepository()).call(
                params: CreateFacilityParams(
                  ownerType: widget.ownerType!,
                  ownerId: widget.ownerId!,
                  facilities: widget.selectedFacilitiesId.toList(),
                ),
              );
            });
          }
        },
        isDelete: widget.isEdit == true ? true : false,
        onDelete: (id) async {
          setState(() {
            widget.selectedFacilitiesId.remove(id);
          });
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 400), () async {
            await DeleteFacilityUseCase(HomeRepository()).call(
              params: DeleteFacilityParams(
                ownerType: widget.ownerType!,
                ownerId: widget.ownerId!,
                facilities: [id],
              ),
            );
          });
        },
      ),
    );
  }
}
