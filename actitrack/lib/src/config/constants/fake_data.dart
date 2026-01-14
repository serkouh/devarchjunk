import 'package:actitrack/src/models/task.dart';

List<Task> dummyTasksData = [
  {
    'id': 1,
    'name': 'Flyer Distribution in Zone 1',
    'zone_id': 101,
    'start_location': "dfdfd",
    'end_location': "dasdas",
    'animator_id': 201,
    'locations': [
      {
        'id': 1,
        'name': '45 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.773108,
        'longitude': -5.775933,
        'delivery_completed': false
      },
      {
        'id': 2,
        'name': '46 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.769069,
        'longitude': -5.775762,
        'delivery_completed': false
      },
      {
        'id': 3,
        'name': '47 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.767815,
        'longitude': -5.767694,
        'delivery_completed': true
      },
    ],
    'flyers_count': 3,
    'flyers_left': 2,
    'flyers_distributed': 1,
    'start_date': DateTime.now().toString(),
    'end_date': DateTime.now().add(const Duration(hours: 3)).toString(),
    'status': 'ongoing',
  },
  {
    'id': 2,
    'name': 'Event Promotion in Zone 2',
    'zone_id': 102,
    'start_location': "dfdfd",
    'end_location': "dasdas",
    'animator_id': 202,
    'locations': [
      {
        'id': 1,
        'name': '49 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.773108,
        'longitude': -5.77593,
        'delivery_completed': false
      },
      {
        'id': 2,
        'name': '50 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.769069,
        'longitude': -5.77576,
        'delivery_completed': false
      },
      {
        'id': 3,
        'name': '51 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.767815,
        'longitude': -5.76769,
        'delivery_completed': false
      },
      {
        'id': 4,
        'name': '52 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.778816,
        'longitude': -5.76969,
        'delivery_completed': false
      },
    ],
    'flyers_count': 4,
    'flyers_left': 4,
    'flyers_distributed': 0,
    'start_date': DateTime.now().toString(),
    'end_date': DateTime.now().add(const Duration(hours: 3)).toString(),
    'status': 'ongoing',
  },
  {
    'id': 3,
    'name': 'Event Promotion in Zone 2',
    'zone_id': 102,
    'start_location': "dfdfd",
    'end_location': "dasdas",
    'animator_id': 202,
    'locations': [
      {
        'id': 1,
        'name': '49 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.773108,
        'longitude': -5.77593,
        'delivery_completed': false,
      },
      {
        'id': 2,
        'name': '50 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.769069,
        'longitude': -5.77576,
        'delivery_completed': false,
      },
      {
        'id': 3,
        'name': '51 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.767815,
        'longitude': -5.76769,
        'delivery_completed': false,
      },
      {
        'id': 4,
        'name': '52 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.778816,
        'longitude': -5.76969,
        'delivery_completed': false,
      },
    ],
    'flyers_count': 4,
    'flyers_left': 4,
    'flyers_distributed': 0,
    'start_date': '2024-05-02T09:00:00.000',
    'end_date': '2024-05-02T17:00:00.000',
    'status': 'cancelled',
  },
  {
    'id': 4,
    'name': 'Event Promotion in Zone 3',
    'zone_id': 102,
    'start_location': "dfdfd",
    'end_location': "dasdas",
    'animator_id': 202,
    'locations': [
      {
        'id': 1,
        'name': '490 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.773108,
        'longitude': -5.77593,
        'delivery_completed': false
      },
      {
        'id': 2,
        'name': '500 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.769069,
        'longitude': -5.77576,
        'delivery_completed': false
      },
      {
        'id': 3,
        'name': '510 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.767815,
        'longitude': -5.76769,
        'delivery_completed': false
      },
      {
        'id': 4,
        'name': '520 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.778816,
        'longitude': -5.76969,
        'delivery_completed': false
      },
    ],
    'flyers_count': 4,
    'flyers_left': 0,
    'flyers_distributed': 4,
    'start_date': '2024-05-02T09:00:00.000',
    'end_date': '2024-05-02T17:00:00.000',
    'status': 'completed',
  },
  {
    'id': 5,
    'name': 'Event Promotion in Zone 3',
    'zone_id': 102,
    'start_location': "dfdfd",
    'end_location': "dasdas",
    'animator_id': 202,
    'locations': [
      {
        'id': 1,
        'name': '490 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.773108,
        'longitude': -5.77593,
        'delivery_completed': false
      },
      {
        'id': 2,
        'name': '500 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.769069,
        'longitude': -5.77576,
        'delivery_completed': false
      },
      {
        'id': 3,
        'name': '520 Ave Mohammed VI, Rue de Imam Moslim Tangier 90000',
        'latitude': 35.778816,
        'longitude': -5.76969,
        'delivery_completed': false
      },
    ],
    'flyers_count': 3,
    'flyers_left': 0,
    'flyers_distributed': 3,
    'start_date': '2024-05-02T09:00:00.000',
    'end_date': '2024-05-02T17:00:00.000',
    'status': 'completed',
  },
].map((data) => Task.fromJson(data)).toList();
