extension StringExtension on String {
  String replaceFarsiNumber() {
    final sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      switch (this[i]) {
        //Persian digits
        case '\u06f0':
          sb.write('0');
          break;
        case '\u06f1':
          sb.write('1');
          break;
        case '\u06f2':
          sb.write('2');
          break;
        case '\u06f3':
          sb.write('3');
          break;
        case '\u06f4':
          sb.write('4');
          break;
        case '\u06f5':
          sb.write('5');
          break;
        case '\u06f6':
          sb.write('6');
          break;
        case '\u06f7':
          sb.write('7');
          break;
        case '\u06f8':
          sb.write('8');
          break;
        case '\u06f9':
          sb.write('9');
          break;

        //Arabic digits
        case '\u0660':
          sb.write('0');
          break;
        case '\u0661':
          sb.write('1');
          break;
        case '\u0662':
          sb.write('2');
          break;
        case '\u0663':
          sb.write('3');
          break;
        case '\u0664':
          sb.write('4');
          break;
        case '\u0665':
          sb.write('5');
          break;
        case '\u0666':
          sb.write('6');
          break;
        case '\u0667':
          sb.write('7');
          break;
        case '\u0668':
          sb.write('8');
          break;
        case '\u0669':
          sb.write('9');
          break;
        default:
          sb.write(this[i]);
          break;
      }
    }
    return sb.toString();
  }

  String convertUidStringToDaoKey() {
    return replaceAll(":", "-");
  }

  String ifEmpty(String replace) => isEmpty ? replace : this;


}


extension NumberExtention on int {

  String   formatNumber (){
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(0)}k';
    } else {
      return toString();
    }
  }
}
