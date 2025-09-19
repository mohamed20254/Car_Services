import 'package:ecommerce_app/core/constant/link_services.dart';
import 'package:ecommerce_app/helper/api.dart';

import 'package:ecommerce_app/model/get_all_prudict.dart';

class Servises {
  List<PrudctModel> prudictList = [];
  List<PrudctModel> prudictpartslist = [];
  List<PrudctModel> prudictscreenlist = [];
  List<PrudctModel> prudictcarcarelist = [];

  Future<List<PrudctModel>> getAllPrudict() async {
    List<dynamic> prucdict = await ApiMethod().get(url: LinkServices.view);
    for (var i in prucdict) {
      prudictList.add(PrudctModel.fromjson(i));
    }
    return prudictList;
  }

  //////////////////////////////////////////////////////////////
  Future<List<PrudctModel>> getAllPrudictparts() async {
    List<dynamic> prucdict = await ApiMethod().get(url: LinkServices.parts);
    for (var i in prucdict) {
      prudictpartslist.add(PrudctModel.fromjson(i));
    }
    return prudictpartslist;
  }

  ///////////////////////////////////////////////////////////////
  Future<List<PrudctModel>> getAllPrudictscreen() async {
    List<dynamic> prucdict = await ApiMethod().get(url: LinkServices.screen);
    for (var i in prucdict) {
      prudictscreenlist.add(PrudctModel.fromjson(i));
    }
    return prudictscreenlist;
  }

  Future<List<PrudctModel>> getAllPrudictcarcare() async {
    List<dynamic> prucdict = await ApiMethod().get(url: LinkServices.carcare);
    for (var i in prucdict) {
      prudictcarcarelist.add(PrudctModel.fromjson(i));
    }
    return prudictcarcarelist;
  }
}
