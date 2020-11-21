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

import 'package:text_field_validation/src/validator/data/validator_data.dart';
import 'package:text_field_validation/src/validator/text_field_validator.dart';

/// Тестовый валидатор не пустого поля
class NoEmptyTextFieldValidator extends TextFieldValidator {
  NoEmptyTextFieldValidator([String text])
      : super(ValidatorData(errorText: text));

  @override
  ValidatorData validate(String text) {
    return getValidatorData(text.isEmpty);
  }
}
