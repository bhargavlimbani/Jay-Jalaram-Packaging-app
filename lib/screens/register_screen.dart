import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool otpSent = false;
  bool isPasswordHidden = true;
  String message = "";
  String error = "";
  bool loading = false;

  // 🔥 SEND OTP
  void sendOtp() async {
    setState(() {
      error = "";
      message = "";
      loading = true;
    });

    var res = await ApiService.register(
      name.text,
      email.text,
      phone.text,
      address.text,
      password.text,
    );

    setState(() {
      otpSent = true;
      message = res["message"] ?? "OTP sent to email";
      loading = false;
    });
  }

  void verifyOtp() async {
  if (otp.text.isEmpty) {
    setState(() {
      error = "Enter OTP";
    });
    return;
  }

  setState(() {
    loading = true;
    error = "";
    message = "";
  });

  var res = await ApiService.verifyOtp(
    email.text.trim(),
    otp.text.trim(),
  );

  print("VERIFY RESPONSE: $res"); // 🔥 VERY IMPORTANT

  if (res["status"] == "success") {
    setState(() {
      message = "Registration successful";
    });

    // ✅ Navigate after success
    Navigator.pushNamed(context, "/login");
  } else {
    setState(() {
      error = res["message"] ?? "Invalid OTP";
    });
  }

  setState(() {
    loading = false;
  });
}

  // 🎨 CUSTOM INPUT
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

                SizedBox(height: 15),

                // NAME
                customInput(
                  hint: "Full Name",
                  icon: Icons.person,
                  controller: name,
                ),

                // EMAIL
                customInput(
                  hint: "Email",
                  icon: Icons.email,
                  controller: email,
                ),

                // PHONE
                customInput(
                  hint: "Phone",
                  icon: Icons.phone,
                  controller: phone,
                ),

                // PASSWORD
                customInput(
                  hint: "Password",
                  icon: Icons.lock,
                  controller: password,
                  isPassword: true,
                ),

                // ADDRESS
                customInput(
                  hint: "Address",
                  icon: Icons.location_on,
                  controller: address,
                ),

                // OTP FIELD
                if (otpSent)
                  customInput(
                    hint: "Enter OTP",
                    icon: Icons.lock_clock,
                    controller: otp,
                  ),

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
                      loading ? null : (otpSent ? verifyOtp : sendOtp),
                  child: Text(
                    otpSent ? "Verify OTP" : "Send OTP",
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

                // LOGIN LINK
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}