import 'package:tron_stake/domain/mixin/log_mixin.dart';
import 'package:flutter/material.dart';

class LoadingController extends ChangeNotifier with LoggingMixin {
  LoadingController() {
    logCreation();
  }
  bool _visibleLoading = false;
  bool _visibleInfo = false;
  bool _visibleError = false;

  String _titleInfo = '';
  String _titleError = 'Error';
  String _descriptionError = '';

  bool get visibleLoading => _visibleLoading;
  bool get visibleError => _visibleError;
  bool get visibleInfo => _visibleInfo;

  String get titleInfo => _titleInfo;
  String get titleError => _titleError;
  String get descriptionError => _descriptionError;

  set setVisibleLoading(bool v) {
    if (_visibleLoading == v) return;
    _visibleLoading = v;
    notifyListeners();
  }

  void showError(title, text) {
    _titleError = title;
    _descriptionError = text;
    _visibleError = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void showInfo(text) {
    _titleInfo = text;
    _visibleInfo = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  close() {
    _titleError = '';
    _descriptionError = '';
    _titleInfo = '';
    _visibleError = false;
    _visibleLoading = false;
    _visibleInfo = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
