import 'package:flutter/services.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import 'constants/imageconstant.dart';

class AppUtils {
  static String convertIndianCurrency(String? amount) {
    var moneyString;

    var _amount = double.parse(amount ?? "0.0");

    var formatter = NumberFormat.currency(
      symbol: '₹',
      locale: "en_IN",
      decimalDigits: 3,
    );
    formatter.maximumFractionDigits = 0;

    if (_amount != null || _amount != 0.0) {
      moneyString = formatter.format(_amount);
    } else {
      moneyString = formatter.format(0.0);
    }

    return moneyString;
  }

  static String convertDateFormat(String? date, String inFormat, String outFormat) {
    if (date?.isNotEmpty == true) {
      final format = DateFormat(inFormat);
      DateTime gettingDate = format.parse(date!);
      final DateFormat formatter = DateFormat(outFormat);
      // Output Date Format
      final String formatted = formatter.format(gettingDate);
      return formatted;
    } else {
      return '-';
    }
  }

  static void startTimer() {
    int _start = 10;
    const oneSec = const Duration(hours: 12, minutes: 48);

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
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toUpperCase()}";
  }

  static String getStepperStage() {
    return "Registration";
  }

  static String getManageLoanAppStatusParam(String type) {
    if (TGFlavor.applyMock() == true) {
      return URI_GET_LOANAPP_STATUS + '/$type';
    } else {
      return URI_GET_LOANAPP_STATUS;
    }
  }

  // For capitalize string
  static String getCamelCase(String status) {
    if (status.isNotEmpty) {
      return "${status[0].toUpperCase()}${status.substring(1).toLowerCase()}";
    } else {
      return '';
    }
  }

  static capitalizeFirstLetter(String? value) {
    if (value?.isNotEmpty == true) {
      return "${value?[0].toUpperCase()}${value?.substring(1).toLowerCase()}";
    } else {
      return '';
    }
  }

  // For get color from transaction status
  static Color? getBgColorByTransactionStatus(String status) {
    if (strRepaid == status || strDisbursed == status) {
      return MyColors.pnbGreenColor;
    } else if (str_Outstanding == status) {
      return MyColors.pnbOrganColor;
    } else if (strOverdue == status) {
      return MyColors.pnbRedColor;
    } else {
      return MyColors.pnbGreenColor;
    }
  }

  static String createInvoiceDate(String date) {
    if (date.isNotEmpty) {
      var inputFormat = DateFormat('dd-MM-yyyy');
      DateTime dt = inputFormat.parse(date);
      String formattedDate = DateFormat('MM/dd/yyyy').format(dt);
      return formattedDate;
    } else {
      return '';
    }
  }

  static String getBankFullName({required String bankName}) {
    switch (bankName) {
      case "SBI":
        return "State Bank of India";
      default:
        return "-";
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: AppUtils.capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
