enum BackgroundType { primary, withoutScroll }

enum FilterType {
  all('All'),
  oneStar('One Star'),
  twoStar('Two Star'),
  threeStar('Three Star'),
  fourStar('Four Star'),
  fiveStar('Five Star');

  final String value;
  const FilterType(this.value);
  String get filterName => value.toUpperCase();
}
