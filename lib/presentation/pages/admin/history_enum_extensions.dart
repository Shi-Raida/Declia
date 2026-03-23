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
    SessionType.family => Tr.common.sessionType.family,
    SessionType.equestrian => Tr.common.sessionType.equestrian,
    SessionType.event => Tr.common.sessionType.event,
    SessionType.maternity => Tr.common.sessionType.maternity,
    SessionType.school => Tr.common.sessionType.school,
    SessionType.portrait => Tr.common.sessionType.portrait,
    SessionType.miniSession => Tr.common.sessionType.miniSession,
    SessionType.other => Tr.common.sessionType.other,
  };
}

extension SessionStatusTr on SessionStatus {
  String get trKey => switch (this) {
    SessionStatus.scheduled => Tr.common.sessionStatus.scheduled,
    SessionStatus.confirmed => Tr.common.sessionStatus.confirmed,
    SessionStatus.completed => Tr.common.sessionStatus.completed,
    SessionStatus.cancelled => Tr.common.sessionStatus.cancelled,
    SessionStatus.noShow => Tr.common.sessionStatus.noShow,
  };
}

extension PaymentStatusTr on PaymentStatus {
  String get trKey => switch (this) {
    PaymentStatus.pending => Tr.common.paymentStatus.pending,
    PaymentStatus.partial => Tr.common.paymentStatus.partial,
    PaymentStatus.paid => Tr.common.paymentStatus.paid,
    PaymentStatus.refunded => Tr.common.paymentStatus.refunded,
  };
}

extension GalleryStatusTr on GalleryStatus {
  String get trKey => switch (this) {
    GalleryStatus.draft => Tr.common.galleryStatus.draft,
    GalleryStatus.published => Tr.common.galleryStatus.published,
    GalleryStatus.archived => Tr.common.galleryStatus.archived,
    GalleryStatus.expired => Tr.common.galleryStatus.expired,
  };
}

extension OrderStatusTr on OrderStatus {
  String get trKey => switch (this) {
    OrderStatus.pending => Tr.common.orderStatus.pending,
    OrderStatus.processing => Tr.common.orderStatus.processing,
    OrderStatus.shipped => Tr.common.orderStatus.shipped,
    OrderStatus.delivered => Tr.common.orderStatus.delivered,
    OrderStatus.cancelled => Tr.common.orderStatus.cancelled,
    OrderStatus.refunded => Tr.common.orderStatus.refunded,
  };
}

extension CommunicationChannelTr on CommunicationChannel {
  String get trKey => switch (this) {
    CommunicationChannel.email => Tr.common.commChannel.email,
    CommunicationChannel.sms => Tr.common.commChannel.sms,
  };
}

extension CommunicationStatusTr on CommunicationStatus {
  String get trKey => switch (this) {
    CommunicationStatus.queued => Tr.common.commStatus.queued,
    CommunicationStatus.sent => Tr.common.commStatus.sent,
    CommunicationStatus.delivered => Tr.common.commStatus.delivered,
    CommunicationStatus.failed => Tr.common.commStatus.failed,
    CommunicationStatus.bounced => Tr.common.commStatus.bounced,
  };
}
