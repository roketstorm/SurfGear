import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';

import '../base/mock_app.dart';
import '../base/test_extensions.dart';

main() {
    var app = MockAppComponent();
    _testSummary(app);
}

void _testSummary(MockAppComponent app) {
    test("Тест запроса данных о пользователе", () {
        expectTrue(Observable.just(true));
    });
}
