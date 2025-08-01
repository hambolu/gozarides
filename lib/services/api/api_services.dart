import 'api_client.dart';
import 'auth_service.dart';
import 'orders_service.dart';
import 'rides_service.dart';
import 'payment_service.dart';
import 'messages_service.dart';
import 'search_service.dart';

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();
  factory ApiServices() => _instance;

  late final ApiClient _apiClient;
  late final AuthService auth;
  late final OrdersService orders;
  late final RidesService rides;
  late final PaymentsService payments;
  late final WalletService wallet;
  late final MessagesService messages;
  late final SearchService search;

  ApiServices._internal() {
    _apiClient = ApiClient();
    auth = AuthService(_apiClient);
    orders = OrdersService(_apiClient);
    rides = RidesService(_apiClient);
    payments = PaymentsService(_apiClient);
    wallet = WalletService(_apiClient);
    messages = MessagesService(_apiClient);
    search = SearchService(_apiClient);
  }
}
