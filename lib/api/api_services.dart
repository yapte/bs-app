import 'api_client.dart';
import 'services/app_api_service.dart';
import 'services/appointments_api_service.dart';
import 'services/auth_api_service.dart';
import 'services/clients_api_service.dart';
import 'services/employee_schedules_api_service.dart';
import 'services/employees_api_service.dart';
import 'services/favorite_groups_api_service.dart';
import 'services/favorites_api_service.dart';
import 'services/payments_api_service.dart';
import 'services/reservations_api_service.dart';
import 'services/rooms_api_service.dart';
import 'services/spa_procedure_groups_api_service.dart';
import 'services/spa_procedures_api_service.dart';
import 'services/users_api_service.dart';

class ApiServices {
  ApiServices(ApiClient client)
    : app = AppApiService(client),
      auth = AuthApiService(client),
      clients = ClientsApiService(client),
      users = UsersApiService(client),
      rooms = RoomsApiService(client),
      reservations = ReservationsApiService(client),
      payments = PaymentsApiService(client),
      employees = EmployeesApiService(client),
      employeeSchedules = EmployeeSchedulesApiService(client),
      favorites = FavoritesApiService(client),
      spaProcedures = SpaProceduresApiService(client),
      spaProcedureGroups = SpaProcedureGroupsApiService(client),
      favoriteGroups = FavoriteGroupsApiService(client),
      appointments = AppointmentsApiService(client);

  final AppApiService app;
  final AuthApiService auth;
  final ClientsApiService clients;
  final UsersApiService users;
  final RoomsApiService rooms;
  final ReservationsApiService reservations;
  final PaymentsApiService payments;
  final EmployeesApiService employees;
  final EmployeeSchedulesApiService employeeSchedules;
  final FavoritesApiService favorites;
  final SpaProceduresApiService spaProcedures;
  final SpaProcedureGroupsApiService spaProcedureGroups;
  final FavoriteGroupsApiService favoriteGroups;
  final AppointmentsApiService appointments;
}
