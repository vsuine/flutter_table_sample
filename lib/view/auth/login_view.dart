import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample/view_model/auth_route_navigator_provider.dart';

final _loginErrorMessageProvider = StateProvider<String?>((ref) => null);

class LoginView extends HookConsumerWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextController =
        useTextEditingController(text: 'sample@example.com');
    final passwordTextController = useTextEditingController(text: 'P@ssw0rd');
    final formKey = useMemoized(() => GlobalKey<FormState>(), const []);
    final isLogginIn = useState<bool>(false);
    final isVisiblePassword = useState<bool>(false);
    ref.listen(_loginErrorMessageProvider, (previous, next) {
      if (next == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next)));
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email must not be empty';
                            }
                            if (EmailValidator.validate(value) == false) {
                              return 'Invalid Email';
                            }
                            return null;
                          },
                          controller: emailTextController,
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: TextFormField(
                          obscureText: isVisiblePassword.value == false,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    isVisiblePassword.value =
                                        !isVisiblePassword.value;
                                  },
                                  icon: Icon(isVisiblePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              hintText: 'Password'),
                          validator: (value) {
                            return _validatePassword(value);
                          },
                          controller: passwordTextController,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextButton(
                onPressed: () async {
                  if (isLogginIn.value ||
                      formKey.currentState == null ||
                      formKey.currentState!.validate() == false) {
                    return;
                  }
                  isLogginIn.value = true;
                  String? message = await ref
                      .read(authRouteNavigatorProvider.notifier)
                      .loginWithEmailAndPassword(emailTextController.text,
                          passwordTextController.text);
                  if (message == null) {
                    return;
                  }
                  ref
                      .read(_loginErrorMessageProvider.notifier)
                      .update((state) => message);
                  isLogginIn.value = false;
                },
                child: isLogginIn.value
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Theme.of(context).indicatorColor,
                        ),
                      )
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password must not be empty';
    }
    final regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (regex.hasMatch(password)) {
      return null;
    }
    return 'Invalid Password';
  }
}
