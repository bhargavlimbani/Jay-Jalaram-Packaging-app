import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController password = TextEditingController();

  bool otpSent = false;
  bool isPasswordHidden = true;
  String message = "";
  String error = "";
  bool loading = false;

  void sendOtp() async {
    setState(() {
      loading = true;
      error = "";
      message = "";
    });

    var res = await ApiService.forgotPassword(email.text);

    setState(() {
      otpSent = true;
      message = res["message"];
      loading = false;
    });
  }

  void resetPassword() async {
    setState(() {
      loading = true;
      error = "";
      message = "";
    });

    var res = await ApiService.resetPassword(
      email.text,
      otp.text,
      password.text,
    );

    setState(() {
      message = res["message"];
      loading = false;
    });
  }

  Widget customInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.teal),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isPasswordHidden : false,
        keyboardType:
            hint == "Email" ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.teal),
          hintText: hint,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.teal,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // 🔥 LOGO
                Image.asset("assets/logo.png", height: 100),

                SizedBox(height: 20),

                // EMAIL
                customInput(
                  hint: "Email",
                  icon: Icons.email,
                  controller: email,
                ),

                // OTP + PASSWORD (only after send)
                if (otpSent) ...[
                  customInput(
                    hint: "OTP",
                    icon: Icons.lock_clock,
                    controller: otp,
                  ),
                  customInput(
                    hint: "New Password",
                    icon: Icons.lock,
                    controller: password,
                    isPassword: true,
                  ),
                ],

                SizedBox(height: 20),

                // BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed:
                      loading ? null : (otpSent ? resetPassword : sendOtp),
                  child: Text(
                    otpSent ? "Reset Password" : "Send OTP",
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 10),

                // ERROR
                if (error.isNotEmpty)
                  Text(error, style: TextStyle(color: Colors.red)),

                // SUCCESS
                if (message.isNotEmpty)
                  Text(message, style: TextStyle(color: Colors.green)),

                SizedBox(height: 10),

                // BACK
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Text("Back to Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}