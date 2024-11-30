class Appointment {
  final String id; // Unique identifier for the appointment
  final String clientId; // ID of the client linked to the appointment
  final String agentId; // ID of the agent managing the appointment
  final String propertyId; // ID of the property linked to the appointment
  final DateTime appointmentDate; // Date and time of the appointment
  final String location; // Location of the appointment (optional)
  final String status; // Status (e.g., "scheduled", "completed", "canceled")


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
