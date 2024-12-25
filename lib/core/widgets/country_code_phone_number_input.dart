import 'package:cabby_driver/core/resources/color_manager.dart';
import 'package:cabby_driver/core/resources/strings_manager.dart';
import 'package:cabby_driver/core/resources/values_manager.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class CountryCodePhoneNumberInput extends StatefulWidget {
  const CountryCodePhoneNumberInput(
      {this.errorText,
      this.onTap,
      required this.onCountryCodeSelected,
      required this.onPhoneNumberChanged,
      super.key});

  final String? errorText;
  final Function(String) onPhoneNumberChanged;
  final Function(CountryCode) onCountryCodeSelected;
  final void Function()? onTap;

  @override
  State<CountryCodePhoneNumberInput> createState() =>
      _CountryCodePhoneNumberInputState();
}

class _CountryCodePhoneNumberInputState
    extends State<CountryCodePhoneNumberInput> {
  CountryCode? selectedCountry = CountryCode.fromCode('NG');

  final countryPicker = FlCountryCodePicker(
    filteredCountries: ["AE", "SD", "AU", "KE", "NG"],
    showDialCode: true,
    showSearchBar: false,
    dialCodeTextStyle: TextStyle(color: ColorManager.blueDark),
    countryTextStyle: TextStyle(color: ColorManager.blackDark),
    title: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
      child: Center(
        child: Text(
          AppStrings.selectYourCountry,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSize.s24,
            color: ColorManager.blackDark,
          ),
        ),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        widget.onPhoneNumberChanged(value);
      },
      decoration: InputDecoration(
        errorText: widget.errorText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSize.s12),
          child: IntrinsicWidth(
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    final code = await countryPicker.showPicker(
                      pickerMaxHeight: 300,
                      context: context,
                    );
                    // Null check
                    if (code != null) {
                      setState(() {
                        selectedCountry = code;
                      });
                      widget.onCountryCodeSelected(code);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s5),
                    child: Image.asset(
                      selectedCountry!.flagUri,
                      fit: BoxFit.cover,
                      width: AppSize.s28,
                      height: AppSize.s20,
                      alignment: Alignment.center,
                      package: selectedCountry!.flagImagePackage,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSize.s5,
                ),
                Text(
                  selectedCountry!.dialCode,
                  style: TextStyle(
                    color: ColorManager.blueDark,
                    fontSize: AppSize.s15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: AppSize.s5,
                ),
                Container(
                  width: 1, // Thin line
                  height: 20, // Desired height
                  color: ColorManager.blueDark, // Line color
                ),
                const SizedBox(
                  width: AppSize.s5,
                ),
              ],
            ),
          ),
        ),
        fillColor: const Color(0xfff4f5f6),
        filled: true,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.error),
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.error),
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      ),
      style: const TextStyle(
        fontSize: AppSize.s16,
      ),
    );
  }
}
