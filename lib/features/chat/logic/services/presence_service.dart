import 'dart:async';

import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/enums/online_status_enum.dart';
import 'package:parlo/core/enums/typing_status_enum.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:parlo/features/chat/data/models/presence_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PresenceService {
  ResponseModel<Stream<PresenceDataModel>> subscribe(String conversationId) {
    try {
      _channel = Supabase.instance.client.channel(conversationId);

      _channel!
          .onBroadcast(
            event: 'updating_typing_action',
            callback: (payload) {
              final presenceModel = PresenceDataModel.fromMap(payload);
              _presenseStreamController.add(presenceModel);
            },
          )
          .onBroadcast(
            event: 'message_updated',
            callback: (payload) {
              final presenceModel = PresenceDataModel.fromMap(payload);
              _presenseStreamController.add(presenceModel);
            },
          )
          .onBroadcast(
            event: 'message_inserted',
            callback: (payload) {
              final presenceModel = PresenceDataModel.fromMap(payload);
              _presenseStreamController.add(presenceModel);
            },
          )
          .onPresenceJoin((payload) {
            final presenceMap = payload.newPresences.first.payload;
            final presenceModel = PresenceDataModel.fromMap(presenceMap);
            _presenseStreamController.add(presenceModel);
          })
          .onPresenceLeave((payload) {
            final presenceMap = payload.leftPresences.first.payload;
            final presenceModel = PresenceDataModel.fromMap(presenceMap);

            _presenseStreamController.add(
              presenceModel.copyWith(
                onlineStatus: OnlineStatus.offline,
                typingStatus: TypingStatus.none,
              ),
            );
          })
          .subscribe((state, error) {
            if (state == RealtimeSubscribeStatus.subscribed) {
              _channel!.track(
                PresenceDataModel(
                  userId: Supabase.instance.client.auth.currentUser!.id,
                  onlineStatus: OnlineStatus.online,
                  typingStatus: TypingStatus.none,
                  lastSeen: DateTime.now(),
                ).toMap(),
              );
            } else {
              throw Exception('Failed to subscribe to presence');
            }
          });

      return ResponseModel.success(_presenseStreamController.stream);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotUnsubscribe,
        ErrorHandlingService.getMessage(Codes.couldNotUnsubscribe),
      );
    }
  }

  Future<ResponseModel<void>> updatePresence(
    OnlineStatus onlineStatus,
    TypingStatus typingStatus,
  ) async {
    try {
      if (_channel == null) {
        return ResponseModel.failure(
          Codes.notSubscribedToPresence,
          ErrorHandlingService.getMessage(Codes.notSubscribedToPresence),
        );
      }

      final presenceData = PresenceDataModel(
        userId: Supabase.instance.client.auth.currentUser!.id,
        onlineStatus: onlineStatus,
        typingStatus: typingStatus,
        lastSeen: onlineStatus == OnlineStatus.offline ? DateTime.now() : null,
      );

      await _channel!.sendBroadcastMessage(
        event: 'updating_typing_action',
        payload: presenceData.toMap(),
      );

      return ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotUpdatePresence,
        ErrorHandlingService.getMessage(Codes.couldNotUpdatePresence),
      );
    }
  }

  Future<ResponseModel<void>> unsubscribe() async {
    try {
      if (_channel != null) {
        await _channel!.unsubscribe();
        _channel = null;
      }
      return ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(
        Codes.couldNotUnsubscribe,
        ErrorHandlingService.getMessage(Codes.couldNotUnsubscribe),
      );
    }
  }

  void dispose() {
    _presenseStreamController.close();
  }

  //! private variables
  RealtimeChannel? _channel;
  StreamController<PresenceDataModel> _presenseStreamController =
      StreamController<PresenceDataModel>.broadcast();
}
