import 'package:flutter/cupertino.dart';
import '../data_source/model.dart';

class ModelsFactory {
  static ModelsFactory? _instance;

  static ModelsFactory? getInstance() {
    if (_instance != null) return _instance;
    _instance = ModelsFactory();
    return _instance;
  }

  final Map<String, dynamic Function(Map<String, dynamic>)> _modelsMap = {};

  void registerModel(
      String modelName,
      dynamic Function(Map<String, dynamic>) modelCreator,
      ) {
    _modelsMap.update(
      modelName,
          (value) => modelCreator,
      ifAbsent: () => modelCreator,
    );
  }

  T createModel<T>(json, String strString, {bool? withOutResponse}) {
    try {
      if (withOutResponse != null) {
        if (withOutResponse) {
          return BaseModel as T;
        } else {
          final modelName = T.toString();
          assert(_modelsMap.containsKey(modelName));
          final model = _modelsMap[modelName]!(json) as T;
          return model;
        }
      } else {
        assert(_modelsMap.containsKey(strString));
        final model = (_modelsMap[strString]!(json) as T);
        return model;
      }
    } catch (e) {
      debugPrint('exceed(models.factory) : $e');
      rethrow;
    }
  }
}
