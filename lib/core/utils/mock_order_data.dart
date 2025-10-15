// import 'package:picpee_mobile/models/order_model.dart';

// class MockOrderData {
//   static List<Order> getAllOrders() {
//     return [
//       // Completed Orders (2-3 orders)
//       Order(
//         id: 'OD2943BGYD',
//         serviceName: 'Blended Brackets (HDR)',
//         amount: 2,
//         total: 0.7,
//         designerName: 'Sarah Johnson',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 22, 4, 37),
//         dueDate: DateTime(2025, 9, 22, 16, 37),
//         status: OrderStatus.completed,
//         checklist: [],
//       ),
//       Order(
//         id: 'OD2943BWPN',
//         serviceName: 'Single Exposure',
//         amount: 3,
//         total: 1.2,
//         designerName: 'Mike Chen',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 21, 8, 15),
//         dueDate: DateTime(2025, 9, 21, 18, 30),
//         status: OrderStatus.completed,
//         checklist: ['Background removal', 'Color enhancement'],
//       ),
//       Order(
//         id: 'OD2943COMP',
//         serviceName: 'Single Exposure',
//         amount: 2,
//         total: 2.5,
//         designerName: 'Emily Davis',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 20, 10, 20),
//         dueDate: DateTime(2025, 9, 20, 20, 00),
//         status: OrderStatus.completed,
//         checklist: [],
//       ),

//       // In Progress Orders (2-3 orders)
//       Order(
//         id: 'OD2943PROG1',
//         serviceName: 'Single Exposure',
//         amount: 3,
//         total: 3.0,
//         designerName: 'Alex Rodriguez',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 23, 9, 00),
//         dueDate: DateTime(2025, 9, 24, 17, 00),
//         status: OrderStatus.inProgress,
//         checklist: [],
//       ),
//       Order(
//         id: 'OD2943PROG2',
//         serviceName: 'Blended Brackets (HDR)',
//         amount: 1,
//         total: 1.8,
//         designerName: 'Lisa Wang',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 23, 11, 30),
//         dueDate: DateTime(2025, 9, 25, 15, 00),
//         status: OrderStatus.inProgress,
//         checklist: ['Model enhancement', 'Background blur', 'Color correction'],
//       ),
//       Order(
//         id: 'OD2943PROG2',
//         serviceName: 'Blended Brackets (HDR)',
//         amount: 1,
//         total: 1.8,
//         designerName: 'Lisa Wang',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 23, 11, 30),
//         dueDate: DateTime(2025, 9, 25, 15, 00),
//         status: OrderStatus.inProgress,
//         checklist: ['Model enhancement', 'Background blur', 'Color correction'],
//       ),

//       // Delivered Orders (2 orders)
//       Order(
//         id: 'OD2943DELV1',
//         serviceName: 'Corporate Headshots',
//         amount: 8,
//         total: 0.8,
//         designerName: 'James Thompson',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 22, 14, 20),
//         dueDate: DateTime(2025, 9, 23, 12, 00),
//         status: OrderStatus.delivered,
//         checklist: ['Professional lighting', 'Background cleanup'],
//       ),
//       Order(
//         id: 'OD2943DELV2',
//         serviceName: 'E-commerce Product Photos',
//         amount: 5,
//         total: 1.5,
//         designerName: 'Rachel Green',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 22, 16, 45),
//         dueDate: DateTime(2025, 9, 23, 14, 30),
//         status: OrderStatus.delivered,
//         checklist: ['White background', 'Shadow creation', 'Size optimization'],
//       ),

//       // Pending Vendor Confirm Orders (2 orders)
//       Order(
//         id: 'OD2943PEND1',
//         serviceName: 'Architectural Photography',
//         amount: 2,
//         total: 4.2,
//         designerName: 'David Kim',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 23, 8, 00),
//         dueDate: DateTime(2025, 9, 25, 18, 00),
//         status: OrderStatus.pendingVendorConfirm,
//         checklist: [
//           'Perspective correction',
//           'HDR processing',
//           'Color enhancement',
//         ],
//       ),
//       Order(
//         id: 'OD2943PEND2',
//         serviceName: 'Event Photography Editing',
//         amount: 2,
//         total: 2.8,
//         designerName: 'Maria Garcia',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 23, 13, 15),
//         dueDate: DateTime(2025, 9, 26, 16, 00),
//         status: OrderStatus.pendingVendorConfirm,
//         checklist: ['Batch processing', 'Color consistency', 'Noise reduction'],
//       ),

//       // Awaiting Revision Orders (2 orders)
//       Order(
//         id: 'OD2943WAIT1',
//         serviceName: 'Portrait Retouching',
//         amount: 1,
//         total: 1.0,
//         designerName: 'Tom Wilson',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 21, 10, 30),
//         dueDate: DateTime(2025, 9, 23, 10, 30),
//         status: OrderStatus.awaitingRevision,
//         checklist: ['Skin smoothing', 'Eye enhancement', 'Hair adjustment'],
//       ),
//       Order(
//         id: 'OD2943WAIT2',
//         serviceName: 'Product Catalog Photos',
//         amount: 2,
//         total: 2.2,
//         designerName: 'Anna Lee',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 20, 15, 45),
//         dueDate: DateTime(2025, 9, 22, 15, 45),
//         status: OrderStatus.awaitingRevision,
//         checklist: [
//           'Color matching',
//           'Background replacement',
//           'Size standardization',
//         ],
//       ),

//       // Dispute Orders (1 order)
//       Order(
//         id: 'OD2943DISP1',
//         serviceName: 'Social Media Content',
//         amount: 6,
//         total: 0.6,
//         designerName: 'Chris Brown',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 19, 12, 00),
//         dueDate: DateTime(2025, 9, 21, 12, 00),
//         status: OrderStatus.dispute,
//         checklist: ['Creative enhancement', 'Brand consistency'],
//       ),

//       // Resolve Orders (1 order)
//       Order(
//         id: 'OD2943RESV1',
//         serviceName: 'Marketing Materials',
//         amount: 4,
//         total: 1.4,
//         designerName: 'Jennifer Taylor',
//         designerAvatar: '',
//         submitted: DateTime(2025, 9, 18, 9, 30),
//         dueDate: DateTime(2025, 9, 20, 17, 00),
//         status: OrderStatus.resolve,
//         checklist: ['Template application', 'Text overlay', 'Final review'],
//       ),
//     ];
//   }

//   // Get orders by specific status
//   static List<Order> getOrdersByStatus(OrderStatus status) {
//     return getAllOrders().where((order) => order.status == status).toList();
//   }

//   // Get count by status
//   static Map<OrderStatus, int> getOrderCountByStatus() {
//     final orders = getAllOrders();
//     Map<OrderStatus, int> counts = {};

//     for (OrderStatus status in OrderStatus.values) {
//       counts[status] = orders.where((order) => order.status == status).length;
//     }

//     return counts;
//   }

//   // Get total orders count
//   static int getTotalOrdersCount() {
//     return getAllOrders().length;
//   }
// }
