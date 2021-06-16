import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/auth/auth_error.dart';
import 'package:agonistica/core/auth/auth_result.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/firebase_auth_user.dart';
import 'package:agonistica/core/repositories/firebase_auth_user_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/utils/db_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class FirebaseAuthUserService extends CrudService<FirebaseAuthUser> {

  static Logger _logger = getLogger('FirebaseAuthUserService');

  final FirebaseAuth _firebaseAuth;

  UserCredential? _firebaseUser;

  FirebaseAuthUserService(this._firebaseAuth, DatabaseReference databaseReference)
    : super(databaseReference, FirebaseAuthUserRepository(databaseReference));

  Future<String> getAppUserIdFromFirebaseUser(String firebaseUserId) async {
    FirebaseAuthUser firebaseUser = await getItemById(firebaseUserId);
    return firebaseUser.appUserId;
  }

  Future<AuthResult> loginUser(String email, String password) async {
    AuthError authError = await _startLoginOperation(email, password);

    User? user = await _getFirebaseAuthStateChanges().first;

    if(user == null) {
      _logger.d('User is currently signed out');
      String errorMessage = AuthError.firebaseErrorCodeToLoginDisplayError(authError.errorCode!);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }
    if(authError.isError) {
      String errorMessage = AuthError.firebaseErrorCodeToLoginDisplayError(authError.errorCode!);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }

    bool isEmailVerified;
    if(DatabaseService.REQUIRE_EMAIL_VERIFICATION) {
      await user.reload();
      isEmailVerified = user.emailVerified;
    } else {
      isEmailVerified = true;
    }

    if(!isEmailVerified) {
      _logger.d("Email not verified yet");
      String errorMessage = AuthError.firebaseErrorCodeToLoginDisplayError(AuthError.MY_FIREBASE_ERROR_EMAIL_NOT_VERIFIED);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }

    // get firebaseAuthUser
    FirebaseAuthUser firebaseAuthUser = await getItemById(user.uid);

    return AuthResult(isOk: true, firebaseAuthUser: firebaseAuthUser);
  }

  Future<AuthResult> signUpUser(String email, String password) async {

    AuthError authError = await _startSignUpOperation(email, password);

    // Use a future instead of a Stream. Get the first User returned
    User? user = await _getFirebaseAuthStateChanges().first;

    if(user == null) {
      _logger.d('User is currently signed out');
      String errorMessage = AuthError.firebaseErrorCodeToRegisterDisplayError(authError.errorCode!);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }
    if(authError.isError) {
      String errorMessage = AuthError.firebaseErrorCodeToRegisterDisplayError(authError.errorCode!);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }

    // create firebaseAuthUser
    FirebaseAuthUser firebaseAuthUser = FirebaseAuthUser(user.uid, email, password);

    return AuthResult(isOk: true, firebaseAuthUser: firebaseAuthUser); // Everything is ok
  }

  Future<AuthResult> resetUserPassword(String email) async {
    AuthError authError = await _sendPasswordResetEmail(email);

    User? user = await _getFirebaseAuthStateChanges().first;

    if(user == null) {
      _logger.d('User is currently signed out');
      String errorMessage = AuthError.firebaseErrorCodeToRegisterDisplayError(authError.errorCode!);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }
    if(authError.isError) {
      String errorMessage = AuthError.firebaseErrorCodeToRegisterDisplayError(authError.errorCode!);
      return AuthResult(isOk: false, errorMessage: errorMessage);
    }

    // get firebaseAuthUser
    FirebaseAuthUser firebaseAuthUser = await getItemById(user.uid);

    return AuthResult(isOk: true, firebaseAuthUser: firebaseAuthUser);
  }

  Future<AuthError> _startLoginOperation(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      _firebaseUser = userCredential;

      return AuthError(isError: false);
    } on FirebaseAuthException catch (e) {
      if(e.code == AuthError.FIREBASE_ERROR_USER_NOT_FOUND) {
        _logger.d('No user found for that email');

      } else if(e.code == AuthError.FIREBASE_ERROR_WRONG_PASSWORD) {
        _logger.d('wrong password provided for that user');
      }
      return AuthError(isError: true, errorCode: e.code);
    } catch (e) {
      _logger.d(e.toString());
      return AuthError(isError: true, errorCode: AuthError.MY_FIREBASE_ERROR_GENERAL_ERROR);
    }
  }

  Future<AuthError> _startSignUpOperation(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(DbUtils.getDisplayNameFromEmail(email));
      await userCredential.user!.reload();
      _firebaseUser = userCredential;
      // verify email
      if(DatabaseService.REQUIRE_EMAIL_VERIFICATION && !_firebaseUser!.user!.emailVerified) {
        _logger.d("Sending email verification");
        await sendEmailVerification();
      }

      return AuthError(isError: false);

    } on FirebaseAuthException catch (e) {
      if(e.code == AuthError.FIREBASE_ERROR_WEAK_PASSWORD)
        _logger.d('The password provided is too weak');
      else if(e.code == AuthError.FIREBASE_ERROR_EMAIL_ALREADY_IN_USE)
        _logger.d('The account already exists for that email');
      return AuthError(isError: true, errorCode: e.code);
    } catch (e) {
      _logger.d(e.toString());
      return AuthError(isError: true, errorCode: AuthError.MY_FIREBASE_ERROR_GENERAL_ERROR);
    }
  }

  Future<AuthError> _sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return AuthError(isError: false);
    } on FirebaseAuthException catch (e) {
      if(e.code == AuthError.FIREBASE_ERROR_USER_NOT_FOUND) {
        _logger.d('No user found for that email');
      }
      return AuthError(isError: true, errorCode: e.code);
    } catch (e) {
      _logger.d(e.toString());
      return AuthError(isError: true, errorCode: AuthError.MY_FIREBASE_ERROR_GENERAL_ERROR);
    }
  }

  Future<bool> sendEmailVerification() async {
    if(_firebaseUser == null || _firebaseUser!.user == null)
      return false;
    await _firebaseUser!.user!.sendEmailVerification();
    return true;
  }

  Stream<User?> _getFirebaseAuthStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

}