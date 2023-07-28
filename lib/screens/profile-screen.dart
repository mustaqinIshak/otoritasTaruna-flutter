import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/auth-screen.dart';
import '../providers/dashboard.dart';
import '../providers/profile.dart';
import '../model/http_exception.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool enableButton = false;
  bool _isLoading = false;
  bool _isLoadingButton = false;
  Profile userProfile =
      Profile(nama: "", semester: "", kelas: null, jurusan: "");
  String? numberPhone = "";
  bool hasError = false;
  String? newNumberPhone;
  String? errorName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  void _showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Terjadi Kesalahan'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
                Provider.of<Auth>(context, listen: false).logOut();
              },
              child: Text('Log Out'),
            )
          ],
        );
      },
    );
  }

  void _successMessage() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Text("nomor hp anda bearhasil diubah"),
          actions: [
            TextButton(
              onPressed: () {
                // Provider.of<Auth>(context, listen: false).logOut();
                // Navigator.of(context)
                //     .pushReplacementNamed(AuthScreen.routeName);
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            )
          ],
        );
      },
    );
  }

  Future<void> changeNumberPhone() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
      print(newNumberPhone);
      setState(() {
        hasError = false;
        _isLoadingButton = true;
        errorName = "";
      });
      await Provider.of<ProfileUser>(context, listen: false)
          .editPhoneNumberUser(newNumberPhone!);
      setState(() {
        hasError = false;
        errorName = "";
        numberPhone =
            Provider.of<ProfileUser>(context, listen: false).phoneNumber;
        newNumberPhone = "";
        _isLoadingButton = false;
      });
      _successMessage();
    } on HttpException catch (e) {
      var errorMessage = "Authentication failde";
      if (e.toString().contains('JsonWebTokenError')) {
        errorMessage = 'Tidak bisa mengidentifikasi anda, Silahkan login ulang';
      } else if (e.toString().contains('TokenExpiredError')) {
        errorMessage = 'Sesi anda telah habis, Silahkan login ulang';
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      print("ini error d profileScreen ${e}");
      var errorMessage = "Could not authenticate you, please try again later";
      _showErrorMessage(errorMessage);
    }
  }

  Future<void> getProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Dashboard>(context, listen: false).fetchUserProfile();
      await Provider.of<ProfileUser>(context, listen: false)
          .fetchPhoneNumberUser();

      setState(() {
        numberPhone =
            Provider.of<ProfileUser>(context, listen: false).phoneNumber;
        userProfile =
            Provider.of<Dashboard>(context, listen: false).userProfile;
        _isLoading = false;
      });
    } on HttpException catch (e) {
      var errorMessage = "Authentication failed";
      if (e.toString().contains('JsonWebTokenError')) {
        errorMessage = 'Tidak bisa mengidentifikasi anda, Silahkan login ulang';
      } else if (e.toString().contains('TokenExpiredError')) {
        errorMessage = 'Sesi anda telah habis, Silahkan login ulang';
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      print("ini error d profileScreen ${e}");
      var errorMessage = "Could not authenticate you, please try again later";
      _showErrorMessage(errorMessage);
    }
  }

  Widget buildTextField(String labelText, String placeHolder, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeHolder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        enabled: isEnabled,
      ),
    );
  }

  Widget buildPhoneField(String labelText, String placeHolder, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'Anda harus mengisi nomor handphone';
          } else if (value.toString().length < 8) {
            print("melanggar");
            return 'Nomor Handphone maksimal 8 angka';
          } else {
            enableButton = true;
          }
        },
        onSaved: (newValue) {
          newNumberPhone = newValue;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeHolder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        enabled: isEnabled,
        keyboardType: TextInputType.phone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logOut = Provider.of<Auth>(context).logOut;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: _isLoading
            ? Container(
                width: double.maxFinite,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Profil Taruna",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, color: Colors.red),
                                onPressed: () {
                                  logOut();
                                  Navigator.pushReplacementNamed(
                                      context, AuthScreen.routeName);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Stack(children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/images/avatar2.png'),
                                ),
                              ),
                            )
                          ]),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        buildTextField(
                            "Nama", userProfile.nama.toString(), false),
                        buildTextField(
                            "Kelas", userProfile.kelas.toString(), false),
                        buildTextField(
                            "Jurursan", userProfile.jurusan.toString(), false),
                        buildPhoneField("Nomor HP", numberPhone!, true),
                        Text(
                          hasError ? errorName.toString() : "",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: hasError ? 35 : 0,
                        ),
                        Container(
                          width: deviceSize.width * 0.75,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.all(10),
                              ),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                            ),
                            // onPressed: wait ? null : () => getOtp(),
                            onPressed: changeNumberPhone,
                            child: _isLoadingButton
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ))
                                : Text(
                                    'Simpan',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
