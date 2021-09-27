import 'package:get/get.dart';

class Data extends GetxController {
  double bg;
  double cgm;

  Data(this.bg, this.cgm);

  Data.fromJson(Map<String, dynamic> json)
      : bg = json['BG'],
        cgm = json['CGM'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['BG'] = this.bg;
    data['CGM'] = this.cgm;

    return data;
  }

  renew() {
    bg = this.bg;
    cgm = this.cgm;
    update();
  }
}
