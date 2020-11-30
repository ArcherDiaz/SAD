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
        if(_auth.currentUser.isAnonymous == false) {
          _auth.currentUser.reload().then((useless) {
            print("Authentication Class | SUCCESSFUL active user reload");
          }).catchError((onError) {
            print("Authentication Class | Reloading Current User: ${onError.toString()}");
          });
        }
      }
    }
  }

  bool activeUser(){
    if(_auth.currentUser == null || _auth.currentUser.isAnonymous == true){
      return false;
    }else{
      return true;
    }
  }

  UserInfo getUserInfo(){
    if(_auth.currentUser == null){
      print("Authentication Class | getUserInfo() Warning: trying to get user info/details when there is no active user logged in.");
      return null;
    }else {
      if(_auth.currentUser.isAnonymous == true){
        print("Authentication Class | getUserInfo() Warning: trying to get user info/details when user is ANONYMOUS.");
        return null;
      }else{
        return UserInfo(
          uid: _auth.currentUser.uid,
          email: _auth.currentUser.email,
          verificationStatus: _auth.currentUser.emailVerified,
          photoURL: _auth.currentUser.photoURL,
          userName: _auth.currentUser.displayName,
          creationDate: _auth.currentUser.metadata.creationTime,
          lastSignedIn: _auth.currentUser.metadata.lastSignInTime,
        );
      }
    }
  }

  Future<AuthResult> logInUser(String email, String password){
    return _auth.signInWithEmailAndPassword(email: email, password: password).then((credential){
      print("Authentication Class | SUCCESSFUL user log in");
      return AuthResult(
        successState: true,
        message: "",
        info: UserInfo(
          uid: credential.user.uid,
          email: credential.user.email,
          verificationStatus: credential.user.emailVerified,
          photoURL: credential.user.photoURL,
          userName: credential.user.displayName,
          creationDate: credential.user.metadata.creationTime,
          lastSignedIn: credential.user.metadata.lastSignInTime,
        ),
      );
    }).catchError((onError){
      print("Authentication Class | Logging In Error: ${onError.toString()}");
      return AuthResult(
        successState: false,
        message: "Authentication Class | Logging In Error: ${onError.toString()}",
        info: null,
      );
    });
  }

  Future<AuthResult> registerUser(String email, String password, {bool emailVerification = false}){
    return _auth.createUserWithEmailAndPassword(email: email, password: password).then((credential){
      if(emailVerification == true){
        return credential.user.sendEmailVerification().then((useless){
          print("Authentication Class | SUCCESSFUL user sign up with verification email sent");
          return AuthResult(
            successState: true,
            message: "",
            info: UserInfo(
              uid: credential.user.uid,
              email: credential.user.email,
              verificationStatus: credential.user.emailVerified,
              photoURL: credential.user.photoURL,
              userName: credential.user.displayName,
              creationDate: credential.user.metadata.creationTime,
              lastSignedIn: credential.user.metadata.lastSignInTime,
            ),
          );
        }).catchError((onError){
          print("Authentication Class | Email Verification Request Error: ${onError.toString()}");
          return AuthResult(
            successState: false,
            message: "Authentication Class | Email Verification Request Error: ${onError.toString()}",
            info: null,
          );
        });
      }else{
        print("Authentication Class | SUCCESSFUL user sign up");
        return AuthResult(
          successState: true,
          message: "",
          info: UserInfo(
            uid: credential.user.uid,
            email: credential.user.email,
            verificationStatus: credential.user.emailVerified,
            photoURL: credential.user.photoURL,
            userName: credential.user.displayName,
            creationDate: credential.user.metadata.creationTime,
            lastSignedIn: credential.user.metadata.lastSignInTime,
          ),
        );
      }
    }).catchError((onError){
      print("Authentication Class | Registering Error: ${onError.toString()}");
      return AuthResult(
        successState: false,
        message: "Authentication Class | Registering Error: ${onError.toString()}",
        info: null,
      );
    });
  }

}

class AuthResult{

  bool successState;
  String message;
  UserInfo info;

  AuthResult({
    this.successState,
    this.message,
    this.info,
  });

}

class UserInfo{

  String uid;
  String email;
  bool verificationStatus;
  String photoURL;
  String userName;
  DateTime creationDate;
  DateTime lastSignedIn;

  UserInfo({
    this.uid,
    this.email,
    this.verificationStatus,
    this.photoURL,
    this.userName,
    this.creationDate,
    this.lastSignedIn,
  });

}
