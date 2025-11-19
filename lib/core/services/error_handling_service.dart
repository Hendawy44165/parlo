import 'package:parlo/core/enums/codes_enum.dart';

class ErrorHandlingService {
  static Codes getErrorCode(String errorCode) {
    switch (errorCode) {
      case 'anonymous_provider_disabled':
        return Codes.anonymousProviderDisabled;
      case 'bad_code_verifier':
        return Codes.badCodeVerifier;
      case 'bad_json':
        return Codes.badJson;
      case 'bad_jwt':
        return Codes.badJwt;
      case 'bad_oauth_callback':
        return Codes.badOauthCallback;
      case 'bad_oauth_state':
        return Codes.badOauthState;
      case 'captcha_failed':
        return Codes.captchaFailed;
      case 'conflict':
        return Codes.conflict;
      case 'email_address_invalid':
        return Codes.emailAddressInvalid;
      case 'email_address_not_authorized':
        return Codes.emailAddressNotAuthorized;
      case 'email_conflict_identity_not_deletable':
        return Codes.emailConflictIdentityNotDeletable;
      case 'email_exists':
        return Codes.emailExists;
      case 'email_not_confirmed':
        return Codes.emailNotConfirmed;
      case 'email_provider_disabled':
        return Codes.emailProviderDisabled;
      case 'flow_state_expired':
        return Codes.flowStateExpired;
      case 'flow_state_not_found':
        return Codes.flowStateNotFound;
      case 'google_id_token_missing':
        return Codes.googleIdTokenMissing;
      case 'google_sign_in_failed':
        return Codes.googleSignInFailed;
      case 'hook_payload_invalid_content_type':
        return Codes.hookPayloadInvalidContentType;
      case 'hook_payload_over_size_limit':
        return Codes.hookPayloadOverSizeLimit;
      case 'hook_timeout':
        return Codes.hookTimeout;
      case 'hook_timeout_after_retry':
        return Codes.hookTimeoutAfterRetry;
      case 'identity_already_exists':
        return Codes.identityAlreadyExists;
      case 'identity_not_found':
        return Codes.identityNotFound;
      case 'insufficient_aal':
        return Codes.insufficientAal;
      case 'invalid_credentials':
        return Codes.invalidCredentials;
      case 'invite_not_found':
        return Codes.inviteNotFound;
      case 'manual_linking_disabled':
        return Codes.manualLinkingDisabled;
      case 'mfa_challenge_expired':
        return Codes.mfaChallengeExpired;
      case 'mfa_factor_name_conflict':
        return Codes.mfaFactorNameConflict;
      case 'mfa_factor_not_found':
        return Codes.mfaFactorNotFound;
      case 'mfa_ip_address_mismatch':
        return Codes.mfaIpAddressMismatch;
      case 'mfa_phone_enroll_not_enabled':
        return Codes.mfaPhoneEnrollNotEnabled;
      case 'mfa_phone_verify_not_enabled':
        return Codes.mfaPhoneVerifyNotEnabled;
      case 'mfa_totp_enroll_not_enabled':
        return Codes.mfaTotpEnrollNotEnabled;
      case 'mfa_totp_verify_not_enabled':
        return Codes.mfaTotpVerifyNotEnabled;
      case 'mfa_verification_failed':
        return Codes.mfaVerificationFailed;
      case 'mfa_verification_rejected':
        return Codes.mfaVerificationRejected;
      case 'mfa_verified_factor_exists':
        return Codes.mfaVerifiedFactorExists;
      case 'mfa_web_authn_enroll_not_enabled':
        return Codes.mfaWebAuthnEnrollNotEnabled;
      case 'mfa_web_authn_verify_not_enabled':
        return Codes.mfaWebAuthnVerifyNotEnabled;
      case 'no_authorization':
        return Codes.noAuthorization;
      case 'not_admin':
        return Codes.notAdmin;
      case 'oauth_provider_not_supported':
        return Codes.oauthProviderNotSupported;
      case 'otp_disabled':
        return Codes.otpDisabled;
      case 'otp_expired':
        return Codes.otpExpired;
      case 'over_email_send_rate_limit':
        return Codes.overEmailSendRateLimit;
      case 'over_request_rate_limit':
        return Codes.overRequestRateLimit;
      case 'over_sms_send_rate_limit':
        return Codes.overSmsSendRateLimit;
      case 'phone_exists':
        return Codes.phoneExists;
      case 'phone_not_confirmed':
        return Codes.phoneNotConfirmed;
      case 'phone_provider_disabled':
        return Codes.phoneProviderDisabled;
      case 'provider_disabled':
        return Codes.providerDisabled;
      case 'provider_email_needs_verification':
        return Codes.providerEmailNeedsVerification;
      case 'reauthentication_needed':
        return Codes.reauthenticationNeeded;
      case 'reauthentication_not_valid':
        return Codes.reauthenticationNotValid;
      case 'refresh_token_already_used':
        return Codes.refreshTokenAlreadyUsed;
      case 'refresh_token_not_found':
        return Codes.refreshTokenNotFound;
      case 'request_timeout':
        return Codes.requestTimeout;
      case 'same_password':
        return Codes.samePassword;
      case 'saml_assertion_no_email':
        return Codes.samlAssertionNoEmail;
      case 'saml_assertion_no_user_id':
        return Codes.samlAssertionNoUserId;
      case 'saml_entity_id_mismatch':
        return Codes.samlEntityIdMismatch;
      case 'saml_idp_already_exists':
        return Codes.samlIdpAlreadyExists;
      case 'saml_idp_not_found':
        return Codes.samlIdpNotFound;
      case 'saml_metadata_fetch_failed':
        return Codes.samlMetadataFetchFailed;
      case 'saml_provider_disabled':
        return Codes.samlProviderDisabled;
      case 'saml_relay_state_expired':
        return Codes.samlRelayStateExpired;
      case 'saml_relay_state_not_found':
        return Codes.samlRelayStateNotFound;
      case 'session_expired':
        return Codes.sessionExpired;
      case 'session_not_found':
        return Codes.sessionNotFound;
      case 'signup_disabled':
        return Codes.signupDisabled;
      case 'single_identity_not_deletable':
        return Codes.singleIdentityNotDeletable;
      case 'sms_send_failed':
        return Codes.smsSendFailed;
      case 'sso_domain_already_exists':
        return Codes.ssoDomainAlreadyExists;
      case 'sso_provider_not_found':
        return Codes.ssoProviderNotFound;
      case 'too_many_enrolled_mfa_factors':
        return Codes.tooManyEnrolledMfaFactors;
      case 'unexpected_audience':
        return Codes.unexpectedAudience;
      case 'unexpected_failure':
        return Codes.unexpectedFailure;
      case 'user_already_exists':
        return Codes.userAlreadyExists;
      case 'user_banned':
        return Codes.userBanned;
      case 'user_not_found':
        return Codes.userNotFound;
      case 'user_sso_managed':
        return Codes.userSsoManaged;
      case 'validation_failed':
        return Codes.validationFailed;
      case 'weak_password':
        return Codes.weakPassword;
      default:
        return Codes.unknown;
    }
  }

  static String getMessage(Codes errorCode) {
    switch (errorCode) {
      case Codes.anonymousProviderDisabled:
        return 'Anonymous sign-ins are disabled.';
      case Codes.badCodeVerifier:
        return 'Invalid code verifier. Please try again.';
      case Codes.badJson:
        return 'Invalid request format.';
      case Codes.badJwt:
        return 'Invalid authentication token.';
      case Codes.badOauthCallback:
        return 'OAuth authentication failed. Please try again.';
      case Codes.badOauthState:
        return 'OAuth state is invalid. Please try again.';
      case Codes.captchaFailed:
        return 'CAPTCHA verification failed. Please try again.';
      case Codes.conflict:
        return 'A conflict occurred. Please try again.';
      case Codes.couldNotAddElevenLabsApiKey:
        return 'Could not add ElevenLabs API key. Please try again.';
      case Codes.couldNotCreateNewConversation:
        return 'Could not create a new conversation. Please try again.';
      case Codes.couldNotDeleteElevenLabsApiKey:
        return 'Could not delete ElevenLabs API key. Please try again.';
      case Codes.couldNotGetChatEntries:
        return 'Could not retrieve chats.';
      case Codes.couldNotGetElevenLabsApiKeys:
        return 'Could not retrieve ElevenLabs API keys. Please try again.';
      case Codes.emailAddressInvalid:
        return 'Email address is invalid. Please use a valid email.';
      case Codes.emailAddressNotAuthorized:
        return 'This email address is not authorized.';
      case Codes.emailConflictIdentityNotDeletable:
        return 'Cannot unlink this identity due to email conflict.';
      case Codes.emailExists:
        return 'Email address already exists in the system.';
      case Codes.emailNotConfirmed:
        return 'Please confirm your email address before signing in.';
      case Codes.emailProviderDisabled:
        return 'Email sign-ups are currently disabled.';
      case Codes.flowStateExpired:
        return 'Authentication session expired. Please sign in again.';
      case Codes.flowStateNotFound:
        return 'Authentication session not found. Please sign in again.';
      case Codes.googleIdTokenMissing:
        return 'Google ID token is missing. Please try signing in again.';
      case Codes.googleSignInFailed:
        return 'Google sign-in failed. Please try again.';
      case Codes.hookPayloadInvalidContentType:
        return 'Invalid webhook payload format.';
      case Codes.hookPayloadOverSizeLimit:
        return 'Webhook payload exceeds size limit.';
      case Codes.hookTimeout:
        return 'Webhook request timed out.';
      case Codes.hookTimeoutAfterRetry:
        return 'Webhook request failed after retries.';
      case Codes.identityAlreadyExists:
        return 'This identity is already linked to another user.';
      case Codes.identityNotFound:
        return 'Identity not found.';
      case Codes.insufficientAal:
        return 'Additional authentication required. Please complete MFA.';
      case Codes.invalidCredentials:
        return 'Invalid email or password.';
      case Codes.invalidEmail:
        return 'Invalid email format.';
      case Codes.invalidPassword:
        return 'Password must be at least 8 characters and include uppercase, lowercase, and a number.';
      case Codes.inviteNotFound:
        return 'Invitation expired or already used.';
      case Codes.manualLinkingDisabled:
        return 'Manual account linking is disabled.';
      case Codes.mfaChallengeExpired:
        return 'MFA challenge expired. Please request a new code.';
      case Codes.mfaFactorNameConflict:
        return 'MFA factor name already exists. Choose a different name.';
      case Codes.mfaFactorNotFound:
        return 'MFA factor not found.';
      case Codes.mfaIpAddressMismatch:
        return 'IP address mismatch during MFA enrollment.';
      case Codes.mfaPhoneEnrollNotEnabled:
        return 'Phone MFA enrollment is disabled.';
      case Codes.mfaPhoneVerifyNotEnabled:
        return 'Phone MFA verification is disabled.';
      case Codes.mfaTotpEnrollNotEnabled:
        return 'TOTP MFA enrollment is disabled.';
      case Codes.mfaTotpVerifyNotEnabled:
        return 'TOTP MFA verification is disabled.';
      case Codes.mfaVerificationFailed:
        return 'Incorrect MFA code. Please try again.';
      case Codes.mfaVerificationRejected:
        return 'MFA verification rejected.';
      case Codes.mfaVerifiedFactorExists:
        return 'A verified phone factor already exists.';
      case Codes.mfaWebAuthnEnrollNotEnabled:
        return 'WebAuthn MFA enrollment is disabled.';
      case Codes.mfaWebAuthnVerifyNotEnabled:
        return 'WebAuthn MFA verification is disabled.';
      case Codes.noAuthorization:
        return 'Authorization required.';
      case Codes.notAdmin:
        return 'Admin access required.';
      case Codes.oauthProviderNotSupported:
        return 'OAuth provider is not supported.';
      case Codes.otpDisabled:
        return 'OTP sign-in is disabled.';
      case Codes.otpExpired:
        return 'OTP code expired. Please request a new one.';
      case Codes.overEmailSendRateLimit:
        return 'Too many emails sent. Please try again later.';
      case Codes.overRequestRateLimit:
        return 'Too many requests. Please try again later.';
      case Codes.overSmsSendRateLimit:
        return 'Too many SMS sent. Please try again later.';
      case Codes.phoneExists:
        return 'Phone number already exists in the system.';
      case Codes.phoneNotConfirmed:
        return 'Please confirm your phone number before signing in.';
      case Codes.phoneProviderDisabled:
        return 'Phone sign-ups are currently disabled.';
      case Codes.providerDisabled:
        return 'This authentication provider is disabled.';
      case Codes.providerEmailNeedsVerification:
        return 'Email verification required from OAuth provider.';
      case Codes.reauthenticationNeeded:
        return 'Please reauthenticate to continue.';
      case Codes.reauthenticationNotValid:
        return 'Reauthentication failed. Please try again.';
      case Codes.refreshTokenAlreadyUsed:
        return 'Session expired. Please sign in again.';
      case Codes.refreshTokenNotFound:
        return 'Session not found. Please sign in again.';
      case Codes.requestTimeout:
        return 'Request timed out. Please try again.';
      case Codes.samePassword:
        return 'New password must be different from current password.';
      case Codes.samlAssertionNoEmail:
        return 'No email found in SAML response.';
      case Codes.samlAssertionNoUserId:
        return 'No user ID found in SAML response.';
      case Codes.samlEntityIdMismatch:
        return 'SAML entity ID mismatch.';
      case Codes.samlIdpAlreadyExists:
        return 'SAML identity provider already exists.';
      case Codes.samlIdpNotFound:
        return 'SAML identity provider not found.';
      case Codes.samlMetadataFetchFailed:
        return 'Failed to fetch SAML metadata.';
      case Codes.samlProviderDisabled:
        return 'SAML authentication is disabled.';
      case Codes.samlRelayStateExpired:
        return 'SAML authentication expired. Please sign in again.';
      case Codes.samlRelayStateNotFound:
        return 'SAML authentication session not found. Please sign in again.';
      case Codes.sessionExpired:
        return 'Session expired. Please sign in again.';
      case Codes.sessionNotFound:
        return 'Session not found. Please sign in again.';
      case Codes.signupDisabled:
        return 'Sign-ups are currently disabled.';
      case Codes.singleIdentityNotDeletable:
        return 'Cannot delete your only authentication method.';
      case Codes.smsSendFailed:
        return 'Failed to send SMS. Please try again.';
      case Codes.ssoDomainAlreadyExists:
        return 'SSO domain already exists.';
      case Codes.ssoProviderNotFound:
        return 'SSO provider not found.';
      case Codes.tooManyEnrolledMfaFactors:
        return 'Too many MFA factors enrolled.';
      case Codes.unauthenticatedUser:
        return 'User is not authenticated. Please sign in.';
      case Codes.unexpectedAudience:
        return 'Unexpected token audience.';
      case Codes.unexpectedFailure:
        return 'An unexpected error occurred. Please try again.';
      case Codes.userAlreadyExists:
        return 'User already exists.';
      case Codes.userBanned:
        return 'User account is temporarily banned.';
      case Codes.userNotFound:
        return 'User not found.';
      case Codes.userSsoManaged:
        return 'User is managed by SSO.';
      case Codes.validationFailed:
        return 'Validation failed. Please check your input.';
      case Codes.weakPassword:
        return 'Password is too weak. Please use a stronger password.';
      case Codes.unknown:
        return 'An error has occurred.';
      case Codes.userNotAuthenticated:
        return 'User is not authenticated. Please sign in.';
      case Codes.couldNotGoLive:
        return 'Could not go live. Please try again.';
      case Codes.couldNotUpdatePresence:
        return 'Could not update presence. Please try again.';
      case Codes.couldNotUnsubscribe:
        return 'Could not unsubscribe from presence channel. Please try again.';
      case Codes.notSubscribedToPresence:
        return 'Not subscribed to presence channel.';
      case Codes.couldNotGetMessages:
        return 'Could not get messages. Please try again.';
      case Codes.couldNotSendTextMessage:
        return 'Could not send text message. Please try again.';
      case Codes.couldNotSendAudioMessage:
        return 'Could not send audio message. Please try again.';
      case Codes.couldNotGetOtherUsername:
        return 'Could not get other username. Please try again.';
      case Codes.couldNotGetOtherAvatarUrl:
        return 'Could not get other avatar URL. Please try again.';
      case Codes.couldNotSubscribeToNewConversations:
        return 'Could not subscribe to new conversations. Please try again.';
      case Codes.couldNotGetConversationInfo:
        return 'Could not get conversation info. Please try again.';
      case Codes.couldNotSubscribeToConversationChanges:
        return 'Could not subscribe to conversation changes. Please try again.';
      default:
        return 'Success or Unhandled code.';
    }
  }
}
