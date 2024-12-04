class Appointment {
  final String id; 
  final String clientId;
  final String agentId; 
  final String propertyId;
  final DateTime appointmentDate;
  final String location;
  final String status;


  Appointment({
    required this.id,
    required this.clientId,
    required this.agentId,
    required this.propertyId,
    required this.appointmentDate,
    this.location = '',
    this.status = 'scheduled',
  }); // Set default createdAt

  // Factory method to create an Appointment object from a JSON map
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      clientId: json['clientId'],
      agentId: json['agentId'],
      propertyId: json['propertyId'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      location: json['location'] ?? '',
      status: json['status'] ?? 'scheduled',
    );
  }

  // Convert an Appointment object to a JSON map (for storage in Firestore or APIs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'agentId': agentId,
      'propertyId': propertyId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'location': location,
      'status': status,
    };
  }

  Appointment copyWith({
    String? status,
    String? notes,
    DateTime? appointmentDate,
  }) {
    return Appointment(
      id: id,
      clientId: clientId,
      agentId: agentId,
      propertyId: propertyId,
      appointmentDate: appointmentDate!,
      location: location,
      status: status ?? this.status,
    );
  }
}
