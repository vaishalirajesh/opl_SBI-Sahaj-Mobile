import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:intl/intl.dart';

import 'constants/imageconstant.dart';

class Utils
{

  static String convertIndianCurrency(String? amount ) {

    var moneyString;

    var _amount = double.parse(amount ?? "0.0");

    var formatter = NumberFormat.currency(
      symbol: '₹',
      locale: "en_IN",
      decimalDigits: 3,
    );
    formatter.maximumFractionDigits=0;

    if(_amount != null || _amount != 0.0)
    {
      moneyString = formatter.format(_amount);
    }
    else
    {
      moneyString = formatter.format(0.0);
    }

    return  moneyString;
  }

  static String convertDateFormat(String? date,String inFormat, String outFormat)
  {
    if(date?.isNotEmpty == true)
    {
      final format = DateFormat(inFormat);
      DateTime gettingDate = format.parse(date!);
      final DateFormat formatter = DateFormat(outFormat);
      // Output Date Format
      final String formatted = formatter.format(gettingDate);
      return formatted;
    }
    else
    {
      return '-';
    }

  }

  static void startTimer() {

    int _start = 10;
    const oneSec = const Duration(hours :12,minutes : 48);

    /*Timer _timer = new Timer.periodic(oneSec, (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );*/
  }


  static String path(str) {
    return IMAGEBASEPATH + str;
  }



  //function for dynamic null checking
  static isNullEmptyOrFalse(dynamic o) {
    if (o is Map<String, dynamic> || o is List<dynamic>) {
      return o == null || o.length == 0;
    }
    return o == null || false == o || "" == o;
  }


  //convert to capital letters
  static capitalize(String value) {
    if(value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toUpperCase()}";
  }


  static String getStepperStage() {

    return "Registration";
  }
  static String getManageLoanAppStatusParam(String type) {
    if(TGFlavor.applyMock() == true) {
      return URI_GET_LOANAPP_STATUS + '/$type'; }
    else {
      return URI_GET_LOANAPP_STATUS; }
  }
  static capitalizeFirstLetter(String? value) {
    if(value?.isNotEmpty == true)
    {
      return "${value?[0].toUpperCase()}${value?.substring(1).toLowerCase()}";
    }
    else
    {
      return '';
    }

  }
}





class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: Utils.capitalize(newValue.text),
      selection: newValue.selection,
    );
  }


}




