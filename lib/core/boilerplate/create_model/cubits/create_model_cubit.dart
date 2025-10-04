import 'package:centro_partner/core/errors/base_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../results/result.dart';
part 'create_model_state.dart';

typedef UseCaseCallBack = Future<Result>? Function(dynamic data);

class CreateModelCubit<Model> extends Cubit<CreateModelState> {
  final UseCaseCallBack getData;

  CreateModelCubit(this.getData) : super(CreateModelInitial());

  Future<void> createModel({dynamic requestData}) async {
    emit(Loading());
    try {
      Result? response = await getData(requestData);
      if (response != null) {
        if (response.hasDataOnly) {
          emit(CreateModelSuccessfully(model: response.data));
        } else if (response.hasErrorOnly) {
          emit(Error(message: response.error!.message!, error: response.error));
        }
      } else {
        emit(CreateModelInitial());
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
