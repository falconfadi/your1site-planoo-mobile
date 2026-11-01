import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';
import 'package:centro_partner/features/home/data/usecase/workday/all_workdays_usecase.dart';
import 'package:centro_partner/features/home/ui/workdays_screen.dart';
import 'package:centro_partner/features/home/widget/workdays_preview_widget.dart';
import 'package:flutter/material.dart';

/// Workdays section of the edit screens: previews the owner's days and opens
/// [WorkdaysScreen] to manage them, reloading the preview on return.
class EditWorkdaysWidget extends StatefulWidget {

  final String ownerType;
  final String ownerId;
  final List<WorkdayDetailsModel> workdaysList;
  final VoidCallback? onRefresh;

  const EditWorkdaysWidget({super.key,
    required this.ownerType,
    required this.ownerId,
    required this.workdaysList,
    this.onRefresh,
  });

  @override
  State<EditWorkdaysWidget> createState() => _EditWorkdaysWidgetState();
}

class _EditWorkdaysWidgetState extends State<EditWorkdaysWidget> {

  late List<WorkdayDetailsModel> workdaysList = widget.workdaysList;

  Future<void> reloadWorkdays() async {
    final result = await AllWorkdaysUseCase(HomeRepository()).call(
      params: AllWorkdaysParams(ownerType: widget.ownerType, ownerId: widget.ownerId),
    );
    if (!mounted) return;
    // The API answers "days not found" with an error once the last day is deleted.
    setState(() => workdaysList = result.data?.workdaysList ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigation.push(WorkdaysScreen(
          ownerType: widget.ownerType,
          ownerId: widget.ownerId,
          onRefresh: widget.onRefresh,
        ));
        await reloadWorkdays();
      },
      child: WorkdaysPreviewWidget(workdaysList: workdaysList),
    );
  }
}
