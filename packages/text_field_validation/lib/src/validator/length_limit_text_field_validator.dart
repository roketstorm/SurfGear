import 'package:text_field_validation/src/validator/data/validator_data.dart';
import 'package:text_field_validation/src/validator/text_field_validator.dart';

/// Валидатор кол-ва символов
class LengthLimitTextFieldValidator extends TextFieldValidator {
  LengthLimitTextFieldValidator(this.count, [String errorText])
      : super.fromText(errorText);

  /// Количество символов
  final int count;

  @override
  ValidatorData validate(String text) {
    return getValidatorData(text.length == count);
  }
}
