class NotifItem {
  final String title;
  final String subtitle;

  const NotifItem(this.title, this.subtitle);

  String get body => subtitle;
}
