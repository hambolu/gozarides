import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final bool isLoading;
  final double? width;
  final bool isLightBorder;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.isLoading = false,
    this.width,
    this.isLightBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isLightBorder 
        ? AppColors.buttonSecondaryBorderLight 
        : AppColors.buttonSecondaryBorder;

    return SizedBox(
      width: width ?? double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Ink(
            decoration: BoxDecoration(
              color: isSecondary ? AppColors.buttonSecondaryBackground : AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              border: isSecondary ? Border.all(
                color: borderColor,
                width: 1.5,
              ) : null,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isSecondary ? borderColor : AppColors.buttonText,
                        ),
                      ),
                    ),
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: isSecondary ? borderColor : AppColors.buttonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}