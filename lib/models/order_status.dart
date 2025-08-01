enum OrderStatus {
  newOrder('New Order'),
  accepted('Accepted'),
  headingToPickup('Heading to Pickup'),
  arrivedAtPickup('Arrived at Pickup'),
  pickedUp('Picked Up'),
  headingToDelivery('Heading to Delivery'),
  arrivedAtDelivery('Arrived at Delivery'),
  delivered('Delivered'),
  cancelled('Cancelled'),
  unassigned('Unassigned'),
  incomplete('Incomplete'),
  returnToSender('Return to Sender'),
  issue('Issue/Problem');

  final String displayName;
  const OrderStatus(this.displayName);

  static OrderStatus? fromString(String status) {
    try {
      return OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == status || e.displayName == status,
      );
    } catch (e) {
      return null;
    }
  }
}
