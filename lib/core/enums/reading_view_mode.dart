enum ReadingViewMode { detailsView, regularView }

extension ReadingViewModeX on ReadingViewMode {
  String get code => switch (this) {
    ReadingViewMode.detailsView => 'details',
    ReadingViewMode.regularView => 'regular',
  };

  static ReadingViewMode fromCode(String? code) {
    switch (code) {
      case 'regular':
        return ReadingViewMode.regularView;
      case 'details':
      default:
        return ReadingViewMode.detailsView;
    }
  }
}
