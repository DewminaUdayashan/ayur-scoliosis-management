import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/exceptions.dart';
import 'package:ayur_scoliosis_management/core/extensions/snack.dart';
import 'package:ayur_scoliosis_management/providers/auth/auth.dart';
import 'package:flutter/foundation.dart';
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
    final isLoading = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final auth = ref.watch(authProvider).valueOrNull;

    useEffect(() {
      // If already authenticated, redirect to home
      if (auth == AuthStatus.authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pushReplacement(AppRouter.home);
        });
      }
      return null;
    }, [auth]);

    useEffect(() {
      if (kDebugMode) {
        // emailController.text = 'givej64432@ahvin.com';
        emailController.text = 'logigi3558@aravites.com';
        passwordController.text = 'Test@123';
      }
      return null;
    });

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
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                isLoading: isLoading.value,
                label: 'Login',
                onPressed: () async {
                  if (formKey.currentState?.validate() != true) {
                    return;
                  }
                  try {
                    isLoading.value = true;
                    await ref
                        .read(authProvider.notifier)
                        .signIn(emailController.text, passwordController.text);
                  } on Exception catch (e) {
                    if (e is PasswordMustChanged && context.mounted) {
                      context.push(AppRouter.newPassword);
                      return;
                    }
                    if (context.mounted) {
                      context.showError('Login failed: ${e.toString()}');
                    }
                  } finally {
                    isLoading.value = false;
                  }
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
            ],
          ),
        ),
      ),
    );
  }
}
