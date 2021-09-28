import 'package:get/get.dart';

class Data extends GetxController {
  double bg;
  double cgm;
  String timeData;

  Data(this.bg, this.cgm, this.timeData);

  Data.fromJson(Map<String, dynamic> json)
      : bg = json['BG'],
        cgm = json['CGM'],
        timeData = json['timeData'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['BG'] = this.bg;
    data['CGM'] = this.cgm;
    data['timeData'] = this.timeData;

    return data;
  }

  renew() {
    bg = this.bg;
    cgm = this.cgm;
    timeData = this.timeData;

    update();
  }
}
