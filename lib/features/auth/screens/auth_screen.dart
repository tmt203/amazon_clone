import 'package:flutter/material.dart';
import 'package:amazon_clone/commons/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void toggleHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void signUpUser() {
    authService.signUp(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
    );
  }

  void signInUser() {
    authService.signin(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget suffixIcon() {
      if (_obscureText) {
        return GestureDetector(
          onTap: toggleHidePassword,
          child: const Icon(Icons.visibility_off),
        );
      } else {
        return GestureDetector(
          onTap: toggleHidePassword,
          child: const Icon(Icons.visibility),
        );
      }
    }

    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Xin chào!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: _auth == Auth.signup ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundColor,
                  shape: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  title: const Text(
                    'Tạo tài khoản',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signup,
                    groupValue: _auth,
                    onChanged: (Auth? auth) => setState(() {
                      _auth = auth!;
                    }),
                  ),
                ),
                if (_auth == Auth.signup)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: GlobalVariables.backgroundColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              hintText: 'Tên',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                              if (!emailValid) {
                                return 'Vui lòng nhập đúng định dạng email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              suffixIcon: suffixIcon(),
                              hintText: 'Mật khẩu',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }

                              if (value.length < 8) {
                                return 'Mật khẩu phải từ 8 ký tự trở lên';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _passwordConfirmController,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              suffixIcon: suffixIcon(),
                              hintText: 'Nhập lại mật khẩu',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập lại mật khẩu';
                              }

                              if (value != _passwordController.text) {
                                return 'Mật khẩu không khớp';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Đăng ký',
                            onTap: () {
                              if (_signUpFormKey.currentState!.validate()) signUpUser();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: _auth == Auth.signin ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundColor,
                  shape: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  title: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signin,
                    groupValue: _auth,
                    onChanged: (Auth? auth) => setState(() {
                      _auth = auth!;
                    }),
                  ),
                ),
                if (_auth == Auth.signin)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: GlobalVariables.backgroundColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }

                              final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                              if (!emailValid) {
                                return 'Vui lòng nhập đúng định dạng email';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              suffixIcon: suffixIcon(),
                              hintText: 'Mật khẩu',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Đăng nhập',
                            onTap: () {
                              if (_signInFormKey.currentState!.validate()) signInUser();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
