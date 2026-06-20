import 'employee_models.dart';

class TimeInterval {
  const TimeInterval({required this.from, required this.to});

  final String from;
  final String to;
}

class EmployeeSchedule {
  const EmployeeSchedule({
    required this.id,
    required this.employeeId,
    required this.employee,
    required this.date,
    required this.intervals,
  });

  final int id;
  final int employeeId;
  final EmployeeSummary employee;
  final DateTime date;
  final List<TimeInterval> intervals;
}

class EmployeeScheduleItem {
  const EmployeeScheduleItem({required this.employee, required this.intervals});

  final EmployeeSummary employee;
  final List<TimeInterval> intervals;
}

class EmployeeScheduleDay {
  const EmployeeScheduleDay({required this.date, required this.employees});

  final DateTime date;
  final List<EmployeeScheduleItem> employees;
}

class CreateEmployeeSchedule {
  const CreateEmployeeSchedule({
    required this.employeeId,
    required this.date,
    required this.intervals,
  });

  final int employeeId;
  final DateTime date;
  final List<TimeInterval> intervals;
}

class UpdateEmployeeSchedule {
  const UpdateEmployeeSchedule({this.employeeId, this.date, this.intervals});

  final int? employeeId;
  final DateTime? date;
  final List<TimeInterval>? intervals;
}

class EmployeeScheduleSearch {
  const EmployeeScheduleSearch({
    required this.employeeIds,
    required this.dates,
  });

  final List<int> employeeIds;
  final List<DateTime> dates;
}
