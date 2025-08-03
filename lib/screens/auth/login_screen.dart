import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/app_router.dart';
import '../../core/constants/size.dart';
import '../../core/extensions/size.dart';
import '../../core/extensions/theme.dart';
import '../../core/extensions/validators.dart';
import '../../core/extensions/value_notifier.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/primary_button.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final obscureNotifier = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: Padding(
        padding: horizontalPadding,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              Center(
                child: Image.asset(
                  Assets.images.logo,
                  width: context.width * 0.6,
                ),
              ),
              Text(
                'Welcome !',
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppTextField(
                labelText: 'Email',
                hintText: 'you@example.com',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.isValidEmail) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              obscureNotifier.build(
                (obscure) => AppTextField(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  controller: passwordController,
                  obscureText: obscure,
                  suffix: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      obscureNotifier.value = !obscureNotifier.value;
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password action
                  },
                  child: Text(
                    'Forgot Password?',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                isLoading: false,
                label: 'Login',
                onPressed: () {
                  context.push(AppRouter.otpVerification);
                  if (formKey.currentState?.validate() != true) {
                    return;
                  }
                  // Handle login action
                  final email = emailController.text;
                  final password = passwordController.text;
                  // Perform login logic here
                },
              ),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRouter.registration,
                  ); // Assuming you add this route
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Are you a practitioner? ',
                    style: context.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Register here',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // FilledButton(
              //   onPressed: () {
              //     // Handle login action
              //   },
              //   style: FilledButton.styleFrom(
              //     minimumSize: Size(double.infinity, 48),
              //     shape: RoundedRectangleBorder(borderRadius: radiusFull),
              //   ),
              //   child: Text('Login'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
