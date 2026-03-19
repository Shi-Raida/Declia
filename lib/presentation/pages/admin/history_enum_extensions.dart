import '../../../core/enums/communication_channel.dart';
import '../../../core/enums/communication_status.dart';
import '../../../core/enums/gallery_status.dart';
import '../../../core/enums/order_status.dart';
import '../../../core/enums/payment_status.dart';
import '../../../core/enums/session_status.dart';
import '../../../core/enums/session_type.dart';
import '../../translations/translation_keys.dart';

extension SessionTypeTr on SessionType {
  String get trKey => switch (this) {
    SessionType.family => Tr.sessionTypeFamily,
    SessionType.equestrian => Tr.sessionTypeEquestrian,
    SessionType.event => Tr.sessionTypeEvent,
    SessionType.maternity => Tr.sessionTypeMaternity,
    SessionType.school => Tr.sessionTypeSchool,
    SessionType.portrait => Tr.sessionTypePortrait,
    SessionType.miniSession => Tr.sessionTypeMiniSession,
    SessionType.other => Tr.sessionTypeOther,
  };
}

extension SessionStatusTr on SessionStatus {
  String get trKey => switch (this) {
    SessionStatus.scheduled => Tr.sessionStatusScheduled,
    SessionStatus.confirmed => Tr.sessionStatusConfirmed,
    SessionStatus.completed => Tr.sessionStatusCompleted,
    SessionStatus.cancelled => Tr.sessionStatusCancelled,
    SessionStatus.noShow => Tr.sessionStatusNoShow,
  };
}

extension PaymentStatusTr on PaymentStatus {
  String get trKey => switch (this) {
    PaymentStatus.pending => Tr.paymentStatusPending,
    PaymentStatus.partial => Tr.paymentStatusPartial,
    PaymentStatus.paid => Tr.paymentStatusPaid,
    PaymentStatus.refunded => Tr.paymentStatusRefunded,
  };
}

extension GalleryStatusTr on GalleryStatus {
  String get trKey => switch (this) {
    GalleryStatus.draft => Tr.galleryStatusDraft,
    GalleryStatus.published => Tr.galleryStatusPublished,
    GalleryStatus.archived => Tr.galleryStatusArchived,
    GalleryStatus.expired => Tr.galleryStatusExpired,
  };
}

extension OrderStatusTr on OrderStatus {
  String get trKey => switch (this) {
    OrderStatus.pending => Tr.orderStatusPending,
    OrderStatus.processing => Tr.orderStatusProcessing,
    OrderStatus.shipped => Tr.orderStatusShipped,
    OrderStatus.delivered => Tr.orderStatusDelivered,
    OrderStatus.cancelled => Tr.orderStatusCancelled,
    OrderStatus.refunded => Tr.orderStatusRefunded,
  };
}

extension CommunicationChannelTr on CommunicationChannel {
  String get trKey => switch (this) {
    CommunicationChannel.email => Tr.commChannelEmail,
    CommunicationChannel.sms => Tr.commChannelSms,
  };
}

extension CommunicationStatusTr on CommunicationStatus {
  String get trKey => switch (this) {
    CommunicationStatus.queued => Tr.commStatusQueued,
    CommunicationStatus.sent => Tr.commStatusSent,
    CommunicationStatus.delivered => Tr.commStatusDelivered,
    CommunicationStatus.failed => Tr.commStatusFailed,
    CommunicationStatus.bounced => Tr.commStatusBounced,
  };
}
