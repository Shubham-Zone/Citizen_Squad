import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'otp.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

   static String verify="";

  @override
  State<Phone> createState() => _PhoneState();

}

class _PhoneState extends State<Phone> {


  TextEditingController countrycode=TextEditingController();
  TextEditingController mobno=TextEditingController();
  var phone="";

  bool _canShowButton = true;
  bool _canShowCircular = false;

  void hideWidget() {
    setState(() {
      _canShowButton = !_canShowButton;
      _canShowCircular=!_canShowCircular;
    });
  }

  void showWidget() {
    setState(() {
      _canShowButton = true;
      _canShowCircular=false;
    });
  }

  @override
  void initState() {
    countrycode.text="+91";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var mediaquery=MediaQuery.of(context);

    return Scaffold(

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(

          margin: const EdgeInsets.only(left: 20,right: 20,top: 150),

          alignment: Alignment.center,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                  "assets/lottie/auth2.json",
                  height: 200,
                  fit: BoxFit.cover
              ),
              const SizedBox(
                height: 40,
              ),
              const Text("Phone Verification",
                style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 10,
              ),
              const Text("we will send you an otp on this given mobile number",textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                margin: const EdgeInsets.only(left: 8,right: 8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      width: mediaquery.size.width*0.07,
                      child: TextField(
                        controller: countrycode,
                        decoration: const InputDecoration(border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text("|",
                      style: TextStyle(fontSize: 20,color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: mobno,
                      onChanged: (value){
                        phone=value;
                      },
                      decoration: const InputDecoration(border: InputBorder.none,hintText: "Phone",hintStyle: TextStyle(
                        fontSize: 18
                      )),
                    )),

                  ],
                ),
              ),
              const SizedBox (
                height: 20,
              ),
              Visibility(
                visible: _canShowButton,
                child: Container(
                  height: 50,
                  width:double.infinity,
                  margin: const EdgeInsets.only(left: 8,right: 8),
                  child: ElevatedButton(
                    onPressed: () async {

                      if(mobno.text.isNotEmpty){
                        hideWidget();
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: countrycode.text+phone,
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            // print(e.toString());
                            showWidget();
                          },
                          codeSent: (String verificationId, int? resendToken) async {
                            Phone.verify= verificationId;
                            //saving mobile no to local storage
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('phoneNo', int.parse(mobno.text));
                            if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Otp()));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your no")));
                      }

                      }
                    ,
                    style: ElevatedButton.styleFrom(

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    child: const Text("Send the code"),
                  ),
                ),
              ),
              Visibility(
                visible: _canShowCircular,
                child: const CircularProgressIndicator(),),
            ],
          ),
        ),
      ),
    );
  }
}
