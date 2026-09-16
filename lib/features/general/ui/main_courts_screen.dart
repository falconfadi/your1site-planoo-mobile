import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import 'package:centro_partner/features/general/data/model/main_court/all_main_courts_model.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/all_main_courts_usecase.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/delete_main_court_usecase.dart';
import 'package:centro_partner/features/general/ui/main_court_details_screen.dart';
import 'package:centro_partner/features/general/widget/add_main_court_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainCourtsScreen extends StatelessWidget {

  MainCourtsScreen({super.key});

  GetModelCubit<AllMainCourtsModel>? allMainCourtsCubit;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("courts"),isNavBar: false),
      body: GetModel<AllMainCourtsModel>(
          onCubitCreated: (cubit) {
            allMainCourtsCubit = cubit as GetModelCubit<AllMainCourtsModel>;
          },
          useCaseCallBack: () {
            return AllMainCourtsUseCase(GeneralRepository()).call(params: AllMainCourtsParams());
          },
          onSuccess: (model) {},
          modelBuilder: (model) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 25.h),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      CustomSheet.show(
                          isDismissible: true,
                          header: Center(),
                          padding: 30.w,
                          context: context,
                          child: AddMainCourtWidget(onRefresh: () {
                            allMainCourtsCubit!.getModel();
                          })
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.add_circle_outline_outlined,color: AppColors.turquoiseColor,
                          size: isTablet ? 25.sp : null,
                        ),
                        SizedBox(width: 5.w),
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(AppLocalization.of(context).translate("add"),
                            style: AppTheme.bodyLarge.copyWith(fontSize: 20.sp,color: AppColors.turquoiseColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: model.courtsList!.length,
                    itemBuilder: (context,index) {
                      return InkWell(
                        onTap: () => Navigation.push(
                            MainCourtDetailsScreen(mainCourtDetailsModel: model.courtsList![index])
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          child: Card(
                            color: AppColors.whiteColor,
                            elevation: 3,
                            shadowColor: AppColors.gray2Color,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: Text(model.courtsList![index].name!, style: AppTheme.titleLarge.copyWith(color: AppColors.primaryColor))),
                                      SizedBox(width: 10.w),
                                      SizedBox(
                                        width: 15.w,
                                        height: 30.h,
                                        child: PopupMenuButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: isTablet ? 20.sp : null,
                                          color: AppColors.whiteColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8.r)),
                                          ),
                                          elevation: 10,
                                          shadowColor: AppColors.blackColor,
                                          itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(
                                              value: "",
                                              height: 50.h,
                                              child: Center(
                                                child: Text(
                                                  AppLocalization.of(context).translate("edit"),
                                                  style: AppTheme.bodyLarge,
                                                ),
                                              ),
                                              onTap: () {
                                                CustomSheet.show(
                                                    isDismissible: true,
                                                    header: Center(),
                                                    padding: 30.w,
                                                    context: context,
                                                    child: AddMainCourtWidget(isEdit: true,mainCourt: model.courtsList![index],onRefresh: () {
                                                      allMainCourtsCubit!.getModel();
                                                    })
                                                );
                                              },
                                            ),
                                            // todo enable delete later if required
                                            /*PopupMenuItem(
                                                value: "",
                                                height: 50.h,
                                                child: Center(
                                                  child: Text(
                                                    AppLocalization.of(context).translate("delete"),
                                                    style: AppTheme.bodyLarge.copyWith(color: AppColors.redColor),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Dialogs.showQuestion(context,
                                                    title: "",content: Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text(AppLocalization.of(context).translate("are_you_sure") +
                                                              AppLocalization.of(context).translate("?"),
                                                            textAlign: TextAlign.center,
                                                            style: AppTheme.headlineSmall.copyWith(color: AppColors.mediumGrayColor),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    btnOk: CreateModel(
                                                      withValidation: false,
                                                      onTap: () {},
                                                      onSuccess: (model) async {
                                                        Navigation.pop();
                                                        allMainCourtsCubit!.getModel();
                                                      },
                                                      useCaseCallBack: (deleteModel) {
                                                        return DeleteMainCourtUseCase(GeneralRepository()).call(
                                                            params: DeleteMainCourtParams(
                                                                mainCourtId: model.courtsList![index].id!
                                                            )
                                                        );
                                                      },
                                                      child: CustomButton(
                                                        height: 40.h,
                                                        width: 1.sw,
                                                        backgroundColor: AppColors.redColor,
                                                        borderRadius: 8.r,
                                                        buttonName: AppLocalization.of(context).translate("ok"),
                                                        textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),*/
                                          ],
                                          offset: Offset(AppStorage.languageCode == "ar" ? -15 : 15,isTablet ? 50 : 30),
                                          onSelected: (value) {},
                                        ),
                                      )
                                    ],
                                  ),
                                  if(model.courtsList![index].description != null) ...[
                                    SizedBox(height: 10.h),
                                    Text(model.courtsList![index].description!, style: AppTheme.bodyLarge),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              )
          ),
      )
    );
  }
}
