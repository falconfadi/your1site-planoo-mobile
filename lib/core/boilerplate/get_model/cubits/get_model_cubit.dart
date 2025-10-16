import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../results/result.dart';
part 'get_model_state.dart';

typedef UseCaseCallBack = Future<Result> Function();

class GetModelCubit<Model> extends Cubit<GetModelState> {
  final UseCaseCallBack getData;

  GetModelCubit(this.getData) : super(GetModelInitial());

  Future<void> getModel() async {
    emit(Loading());
    try {
      Result response = await getData();
      if (response.hasDataOnly) {
        emit(GetModelSuccessfully(model: response.data));
      } else if (response.hasErrorOnly) {
        emit(Error(message: response.error!.message!));
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}