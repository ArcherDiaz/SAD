import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

enum  DataType{string, date}

class FormatClass{

  DateTime now = DateTime.now();


  String formatDate(dynamic date, {DataType dataType = DataType.date}){
    DateTime inputtedDate;
    if(dataType == DataType.date){
      inputtedDate = date;
    }else{
      inputtedDate = DateTime.parse(date);
    }
    if(now.isAfter(date)){
      return _timeAgo(inputtedDate);
    }else{
      return _futureTime(inputtedDate);
    }
  }

  String _timeAgo(DateTime postDate, {bool numDates = true}){
    final timeDiff = now.difference(postDate);

    if((timeDiff.inDays / 30).floor() >= 2){
      return '${(timeDiff.inDays / 30).floor()} months ago';
    } else if((timeDiff.inDays / 30).floor() >= 1) {
      return (numDates) ? '1 month ago' : 'Last Month';
    } else if((timeDiff.inDays / 7).floor() >= 2) {
      return '${(timeDiff.inDays / 7).floor()} weeks ago';
    } else if ((timeDiff.inDays / 7).floor() >= 1) {
      return (numDates) ? '1 week ago' : 'Last week';
    } else if (timeDiff.inDays >= 2) {
      return '${timeDiff.inDays} days ago';
    } else if (timeDiff.inDays >= 1) {
      return (numDates) ? '1 day ago' : 'Yesterday';
    } else if (timeDiff.inHours >= 2) {
      return '${timeDiff.inHours} hours ago';
    } else if (timeDiff.inHours >= 1) {
      return (numDates) ? '1 hour ago' : 'An hour ago';
    } else if (timeDiff.inMinutes >= 2) {
      return '${timeDiff.inMinutes} minutes ago';
    } else if (timeDiff.inMinutes >= 1) {
      return (numDates) ? '1 minute ago' : 'A minute ago';
    } else if (timeDiff.inSeconds >= 3) {
      return '${timeDiff.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
  String _futureTime(DateTime deadline){
    final timeDiff = deadline.difference(now);

    if((timeDiff.inDays / 30).floor() >= 1){
      return 'in ${(timeDiff.inDays / 30).floor()} months';
    } else if((timeDiff.inDays / 7).floor() >= 1) {
      return 'in ${(timeDiff.inDays / 7).floor()} weeks';
    } else if (timeDiff.inDays >= 1) {
      return 'in ${timeDiff.inDays} days';
    } else if (timeDiff.inHours >= 1) {
      return 'in ${timeDiff.inHours} hours';
    } else if (timeDiff.inMinutes >= 1) {
      return 'in ${timeDiff.inMinutes} minute(s)';
    } else if (timeDiff.inSeconds >= 1) {
      return 'in ${timeDiff.inSeconds} seconds';
    } else {
      return 'Times Up!';
    }
  }



  String formatPhoneNumber(String phone){
    phone = phone.replaceAll("(", "");
    phone = phone.replaceAll(")", "");
    phone = phone.replaceAll("-", "");
    return phone;
  }

  String formatMoney(double num){
    String a = "$num";
    String upper = "";
    String b = a.substring(0, a.indexOf("."));
    for(int i = (b.length-1); i >=0; i--){
      if((i%3) == 0 && (b.length - i) > 3){
        upper = b[i] + "," + upper;
      }else{
        upper = b[i] + upper;
      }
    }
    String lower = a.substring(a.indexOf("."));
    lower = lower.padRight(3, "0");
    if(lower.length > 3){lower = lower.substring(0, 3);}
    return "\$$upper$lower";
  }



  double getPriceFromLocation(double latitude, double longitude){
    //17.133342590287807, -61.83389212936163 epicurean coordinates
    double theta = longitude - -61.83389212936163;
    double distance = sin(_deg2rad(latitude)) * sin(_deg2rad(17.133342590287807)) +
        cos(_deg2rad(latitude)) * cos(_deg2rad(17.133342590287807)) * cos(_deg2rad(theta));
    distance = acos(distance);
    distance = _rad2deg(distance);
    distance = distance * 60 * 1.1515;
    distance = distance * 1.609344;
    double price = 3.85 * distance.round();
    if(price < 10.0){price = 10.0;}
    return (price + 10);
  }
  double _deg2rad(double deg){
    return (deg * pi / 180.0);
  }
  double _rad2deg(double rad){
    return (rad * 180.0 / pi);
  }



  List<dynamic> _inventory = List();

  List<String> formatImageToMap(Uint8List rawPath, String key, int limit, {bool useMerchant = false, String merchant = ""}){
    String data = String.fromCharCodes(rawPath);
    Map<String, dynamic> contents = json.decode(data);
    _inventory = contents["items"];

    // key needs to be uppercase to compare it to product names, which are all in uppercase
    return filter(key.toUpperCase(), limit, [],);
  }

  List<String> filter(String key, int limit, List<String> results, {bool useMerchant = false, String merchant = "", int loops = 2}){
    // key is the search phrase
    // limit is how many results is wanted
    // loops is how many times we want to go around this recursive function(the more loops, the more results; due to key shortening)

    for(int i = 0; i < _inventory.length; i++){
      if(_inventory[i]["name"].contains(key) || _inventory[i]["upc"].contains(key)){
        if(!results.contains(_inventory[i]["ID"])){
          if(useMerchant == true && _inventory[i]["merchant"] == merchant) {
            results.add(_inventory[i]["ID"]);
          }else{
            results.add(_inventory[i]["ID"]);
          }
        }
        if(results.length >= limit){
          break;
        }
      }
    }
    if(results.length < limit && loops > 1 && key.length > 2){
      return filter(key.substring(0, key.length-2), limit-results.length, results,
        useMerchant: useMerchant,
        merchant: merchant,
        loops: loops--,);
    }else {
      return results;
    }
  }

  bool inventoryIsEmpty(){
    return _inventory.isEmpty;
  }

  String formattedDate(String dateStr) {
    DateTime postDate = DateTime.parse(dateStr);
    String day;
    String month;
    String year;
    if(postDate.weekday == 0) {
      day = "Sun";
    } else if (postDate.weekday == 1) {
      day = "Mon";
    } else if (postDate.weekday == 2) {
      day = "Tues";
    } else if (postDate.weekday == 3) {
      day = "Wed";
    } else if (postDate.weekday == 4) {
      day = "Thurs";
    } else if (postDate.weekday == 5) {
      day = "Fri";
    } else if (postDate.weekday == 6) {
      day = "Sat";
    }

    if(postDate.month == 1) {
      month = "Jan";
    } else if (postDate.month == 2) {
      month = "Feb";
    } else if (postDate.month == 3) {
      month = "Mar";
    } else if (postDate.month == 4) {
      month = "Apr";
    } else if (postDate.month == 5) {
      month = "May";
    } else if (postDate.month == 6) {
      month = "Jun";
    } else if (postDate.month == 7) {
      month = "Jul";
    } else if (postDate.month == 8) {
      month = "Aug";
    } else if (postDate.month == 9) {
      month = "Sept";
    } else if (postDate.month == 10) {
      month = "Oct";
    } else if (postDate.month == 11) {
      month = "Nov";
    } else if (postDate.month == 12) {
      month = "Dec";
    }

    year = postDate.year.toString();

    return "${month} ${postDate.day}, ${year}";
  }
  
}



