class Data {
  final int bg;
  final int cgm;

  Data(this.bg, this.cgm);

  Data.fromJson(Map<String, dynamic> json)
      : bg = json['BG'],
        cgm = json['CGM'];

  Map<String, dynamic> ToJson() => {'BG': bg, 'CGM': cgm};
}
