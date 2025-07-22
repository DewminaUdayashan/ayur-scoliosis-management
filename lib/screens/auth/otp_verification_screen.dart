import 'dart:async';

import 'package:ayur_scoliosis_management/core/constants/size.dart'
    show horizontalPadding;
import 'package:ayur_scoliosis_management/core/extensions/theme.dart';
import 'package:ayur_scoliosis_management/widgets/app_scaffold.dart';
import 'package:ayur_scoliosis_management/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends HookConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State for cooldown timer
    final resendCooldown = useState<int>(0);
    final timer = useRef<Timer?>(null);

    // Start cooldown timer
    void startCooldown() {
      resendCooldown.value = 30;
      timer.value = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (resendCooldown.value > 0) {
          resendCooldown.value--;
        } else {
          t.cancel();
          timer.value = null;
        }
      });
    }

    // Handle resend OTP
    void handleResendOTP() {
      if (resendCooldown.value == 0) {
        // Add your OTP resend logic here
        startCooldown();
      }
    }

    // Cleanup timer on dispose
    useEffect(() {
      return () {
        timer.value?.cancel();
      };
    }, []);

    return AppScaffold(
      appBarTitle: 'OTP Verification',
      body: Padding(
        padding: horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Check your Email',
              style: context.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Please enter the OTP sent to your registered email.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            SizedBox(height: 70),
            Pinput(length: 6, onCompleted: (value) {}),
            SizedBox(height: 50),
            PrimaryButton(
              isLoading: false,
              label: 'Verify',
              onPressed: () {
                // Handle OTP verification logic here
              },
            ),

            /// Resend OTP button with timeout
            TextButton(
              onPressed: resendCooldown.value > 0 ? null : handleResendOTP,
              child: Text(
                resendCooldown.value > 0
                    ? 'Resend OTP in ${resendCooldown.value}s'
                    : 'Resend OTP',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: resendCooldown.value > 0
                      ? context.colorScheme.onSurface.withAlpha(60)
                      : context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
