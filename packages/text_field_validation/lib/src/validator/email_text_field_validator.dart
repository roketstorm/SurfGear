// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:text_field_validation/src/validator/no_empty_text_field_validator.dart';
import 'package:text_field_validation/src/validator/reg_exp_validator.dart';
import 'package:text_field_validation/src/validator/text_field_multi_validator.dart';

/// Тестовый валидатор email
class EmailTextFieldValidator extends TextFieldMultiValidator {
  EmailTextFieldValidator({
    String emptyErrorText,
    String invalidText,
  }) : super([
          NoEmptyTextFieldValidator(emptyErrorText),
          RegExpTextFieldValidator(invalidText, _emailRegExp),
        ]);

  static final RegExp _emailRegExp = RegExp(r"(?:[a-z0-9!#$%&'"
      r"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"
      r'"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');
}
