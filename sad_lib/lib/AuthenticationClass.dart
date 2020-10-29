import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationClass{

  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthenticationClass({bool checkUser = false}){
    if(checkUser == true){
      if(_auth.currentUser == null){
        _auth.signInAnonymously();
      }else{
        _auth.currentUser.reload();
      }
    }
  }

  bool activeUser(){
    if(_auth.currentUser == null){
      return false;
    }else{
      return true;
    }
  }

  Map<String, dynamic> getUserInfo(){
    if(_auth.currentUser == null){
      print("Authentication Class | getUserInfo() Warning: trying to get user info/details when there is no active user logged in.");
      return null;
    }else {
      return {
        "uid": _auth.currentUser.uid,
        "email": _auth.currentUser.email,
        "verification Status": _auth.currentUser.emailVerified,
        "photo URL": _auth.currentUser.photoURL,
        "user Name": _auth.currentUser.displayName,
        "creation Date": _auth.currentUser.metadata.creationTime,
        "last Signed In": _auth.currentUser.metadata.lastSignInTime,
      };
    }
  }

  Future<Map<String, dynamic>> logInUser(String email, String password){
    return _auth.signInWithEmailAndPassword(email: email, password: password).then((credential){
      return {
        "success": true,
        "uid": credential.user.uid,
        "email": credential.user.email,
        "creation Date": credential.user.metadata.creationTime,
        "last Signed In": credential.user.metadata.lastSignInTime,
      };
    }).catchError((onError){
      print("Authentication Class | Logging In Error: ${onError.toString()}");
      return {
        "success": false,
      };
    });
  }

  Future<Map<String, dynamic>> registerUser(String email, String password, {bool emailVerification = false}){
    return _auth.createUserWithEmailAndPassword(email: email, password: password).then((credential){
      if(emailVerification == true){
        return credential.user.sendEmailVerification().then((useless){
          return {
            "success": true,
            "uid": credential.user.uid,
            "email": credential.user.email,
            "creation Date": credential.user.metadata.creationTime,
            "last Signed In": credential.user.metadata.lastSignInTime,
          };
        }).catchError((onError){
          print("Authentication Class | Email Verification Request Error: ${onError.toString()}");
          return {
            "success": false,
          };
        });
      }else{
        return {
          "success": true,
          "uid": credential.user.uid,
          "email": credential.user.email,
          "creation Date": credential.user.metadata.creationTime,
          "last Signed In": credential.user.metadata.lastSignInTime,
        };
      }
    }).catchError((onError){
      print("Authentication Class | Registering Error: ${onError.toString()}");
      return {
        "success": false,
      };
    });
  }

}
