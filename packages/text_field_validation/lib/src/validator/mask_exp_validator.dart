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

import 'package:flutter/cupertino.dart';
import 'package:text_field_validation/src/validator/data/validator_data.dart';
import 'package:text_field_validation/src/validator/text_field_validator.dart';

/// Валидатор на основе маски
class MaskTextFieldValidator extends TextFieldValidator {
  MaskTextFieldValidator({
    @required this.mask,
    @required this.conformitySymbols,
    String errorText,
  })  : assert(mask != null && conformitySymbols != null),
        super.fromText(errorText);

  /// Маска для валидации
  /// Например 8 (###) ### ##-##
  final String mask;

  /// Соответствие символом маски
  /// Пример
  /// {
  /// #: RegExp(r'\D')
  /// }
  final Map<String, RegExp> conformitySymbols;

  @override
  ValidatorData validate(String text) {
    /// При несовпадении количества симовлов - однозначно false
    if (text.length != mask.length) return getValidatorData(false);

    for (int i = 0; i < mask.length; i++) {
      if (!conformitySymbols.containsKey(mask[i]) && mask[i] != text[i]) {
        /// Проверяет является символ маски - символом для текста
        /// Например для маски 8 (###) ### ##-##
        /// Символ # из Map {#: RegExp(r'\D')} сверяется с символом mask[i]
        /// Для # == '#' - да, являтся символом для текста
        /// # == ')' - нет, не является
        /// Если совпало - то это символ текста и его пропускаем,
        /// на его месте может быть любой символ
        /// содержание отдается на откуп разработчику / форматтеру
        ///
        /// Если это не символ текста #, значит это явно указанный разделитель
        /// Проверяем равны ли символы на позиции i
        /// Если нет - вернуть false
        return getValidatorData(false);
      }
    }

    return getValidatorData(true);
  }
}
