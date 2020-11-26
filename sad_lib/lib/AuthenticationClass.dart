import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationClass{

  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthenticationClass({bool checkUser = false}){
    if(checkUser == true){
      if(_auth.currentUser == null){
        _auth.signInAnonymously().then((credential){
          print("Authentication Class | SUCCESSFUL anonymous sign in");
        }).catchError((onError){
          print("Authentication Class | Anonymous Sign In: ${onError.toString()}");
        });
      }else{
        _auth.currentUser.reload().then((useless){
          print("Authentication Class | SUCCESSFUL active user reload");
        }).catchError((onError){
          print("Authentication Class | Reloading Current User: ${onError.toString()}");
        });
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
      print("Authentication Class | SUCCESSFUL user sign up");
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
        "message": "Authentication Class | Logging In Error: ${onError.toString()}",
      };
    });
  }

  Future<dynamic> registerUser(String email, String password, {bool emailVerification = false}){
    return _auth.createUserWithEmailAndPassword(email: email, password: password).then((credential){
      if(emailVerification == true){
        return credential.user.sendEmailVerification().then((useless){
          print("Authentication Class | SUCCESSFUL user sign up with verification email sent");
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
            "message": "Authentication Class | Email Verification Request Error: ${onError.toString()}",
          };
        });
      }else{
        print("Authentication Class | SUCCESSFUL user sign up");
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
        "message": "Authentication Class | Registering Error: ${onError.toString()}",
      };
    });
  }

}
