import 'package:parlo/core/enums/error_codes_enum.dart';

class ErrorHandlingService {
  static ErrorCodes getErrorCode(String errorCode) {
    switch (errorCode) {
      case 'anonymous_provider_disabled':
        return ErrorCodes.anonymousProviderDisabled;
      case 'bad_code_verifier':
        return ErrorCodes.badCodeVerifier;
      case 'bad_json':
        return ErrorCodes.badJson;
      case 'bad_jwt':
        return ErrorCodes.badJwt;
      case 'bad_oauth_callback':
        return ErrorCodes.badOauthCallback;
      case 'bad_oauth_state':
        return ErrorCodes.badOauthState;
      case 'captcha_failed':
        return ErrorCodes.captchaFailed;
      case 'conflict':
        return ErrorCodes.conflict;
      case 'email_address_invalid':
        return ErrorCodes.emailAddressInvalid;
      case 'email_address_not_authorized':
        return ErrorCodes.emailAddressNotAuthorized;
      case 'email_conflict_identity_not_deletable':
        return ErrorCodes.emailConflictIdentityNotDeletable;
      case 'email_exists':
        return ErrorCodes.emailExists;
      case 'email_not_confirmed':
        return ErrorCodes.emailNotConfirmed;
      case 'email_provider_disabled':
        return ErrorCodes.emailProviderDisabled;
      case 'flow_state_expired':
        return ErrorCodes.flowStateExpired;
      case 'flow_state_not_found':
        return ErrorCodes.flowStateNotFound;
      case 'google_id_token_missing':
        return ErrorCodes.googleIdTokenMissing;
      case 'google_sign_in_failed':
        return ErrorCodes.googleSignInFailed;
      case 'hook_payload_invalid_content_type':
        return ErrorCodes.hookPayloadInvalidContentType;
      case 'hook_payload_over_size_limit':
        return ErrorCodes.hookPayloadOverSizeLimit;
      case 'hook_timeout':
        return ErrorCodes.hookTimeout;
      case 'hook_timeout_after_retry':
        return ErrorCodes.hookTimeoutAfterRetry;
      case 'identity_already_exists':
        return ErrorCodes.identityAlreadyExists;
      case 'identity_not_found':
        return ErrorCodes.identityNotFound;
      case 'insufficient_aal':
        return ErrorCodes.insufficientAal;
      case 'invalid_credentials':
        return ErrorCodes.invalidCredentials;
      case 'invite_not_found':
        return ErrorCodes.inviteNotFound;
      case 'manual_linking_disabled':
        return ErrorCodes.manualLinkingDisabled;
      case 'mfa_challenge_expired':
        return ErrorCodes.mfaChallengeExpired;
      case 'mfa_factor_name_conflict':
        return ErrorCodes.mfaFactorNameConflict;
      case 'mfa_factor_not_found':
        return ErrorCodes.mfaFactorNotFound;
      case 'mfa_ip_address_mismatch':
        return ErrorCodes.mfaIpAddressMismatch;
      case 'mfa_phone_enroll_not_enabled':
        return ErrorCodes.mfaPhoneEnrollNotEnabled;
      case 'mfa_phone_verify_not_enabled':
        return ErrorCodes.mfaPhoneVerifyNotEnabled;
      case 'mfa_totp_enroll_not_enabled':
        return ErrorCodes.mfaTotpEnrollNotEnabled;
      case 'mfa_totp_verify_not_enabled':
        return ErrorCodes.mfaTotpVerifyNotEnabled;
      case 'mfa_verification_failed':
        return ErrorCodes.mfaVerificationFailed;
      case 'mfa_verification_rejected':
        return ErrorCodes.mfaVerificationRejected;
      case 'mfa_verified_factor_exists':
        return ErrorCodes.mfaVerifiedFactorExists;
      case 'mfa_web_authn_enroll_not_enabled':
        return ErrorCodes.mfaWebAuthnEnrollNotEnabled;
      case 'mfa_web_authn_verify_not_enabled':
        return ErrorCodes.mfaWebAuthnVerifyNotEnabled;
      case 'no_authorization':
        return ErrorCodes.noAuthorization;
      case 'not_admin':
        return ErrorCodes.notAdmin;
      case 'oauth_provider_not_supported':
        return ErrorCodes.oauthProviderNotSupported;
      case 'otp_disabled':
        return ErrorCodes.otpDisabled;
      case 'otp_expired':
        return ErrorCodes.otpExpired;
      case 'over_email_send_rate_limit':
        return ErrorCodes.overEmailSendRateLimit;
      case 'over_request_rate_limit':
        return ErrorCodes.overRequestRateLimit;
      case 'over_sms_send_rate_limit':
        return ErrorCodes.overSmsSendRateLimit;
      case 'phone_exists':
        return ErrorCodes.phoneExists;
      case 'phone_not_confirmed':
        return ErrorCodes.phoneNotConfirmed;
      case 'phone_provider_disabled':
        return ErrorCodes.phoneProviderDisabled;
      case 'provider_disabled':
        return ErrorCodes.providerDisabled;
      case 'provider_email_needs_verification':
        return ErrorCodes.providerEmailNeedsVerification;
      case 'reauthentication_needed':
        return ErrorCodes.reauthenticationNeeded;
      case 'reauthentication_not_valid':
        return ErrorCodes.reauthenticationNotValid;
      case 'refresh_token_already_used':
        return ErrorCodes.refreshTokenAlreadyUsed;
      case 'refresh_token_not_found':
        return ErrorCodes.refreshTokenNotFound;
      case 'request_timeout':
        return ErrorCodes.requestTimeout;
      case 'same_password':
        return ErrorCodes.samePassword;
      case 'saml_assertion_no_email':
        return ErrorCodes.samlAssertionNoEmail;
      case 'saml_assertion_no_user_id':
        return ErrorCodes.samlAssertionNoUserId;
      case 'saml_entity_id_mismatch':
        return ErrorCodes.samlEntityIdMismatch;
      case 'saml_idp_already_exists':
        return ErrorCodes.samlIdpAlreadyExists;
      case 'saml_idp_not_found':
        return ErrorCodes.samlIdpNotFound;
      case 'saml_metadata_fetch_failed':
        return ErrorCodes.samlMetadataFetchFailed;
      case 'saml_provider_disabled':
        return ErrorCodes.samlProviderDisabled;
      case 'saml_relay_state_expired':
        return ErrorCodes.samlRelayStateExpired;
      case 'saml_relay_state_not_found':
        return ErrorCodes.samlRelayStateNotFound;
      case 'session_expired':
        return ErrorCodes.sessionExpired;
      case 'session_not_found':
        return ErrorCodes.sessionNotFound;
      case 'signup_disabled':
        return ErrorCodes.signupDisabled;
      case 'single_identity_not_deletable':
        return ErrorCodes.singleIdentityNotDeletable;
      case 'sms_send_failed':
        return ErrorCodes.smsSendFailed;
      case 'sso_domain_already_exists':
        return ErrorCodes.ssoDomainAlreadyExists;
      case 'sso_provider_not_found':
        return ErrorCodes.ssoProviderNotFound;
      case 'too_many_enrolled_mfa_factors':
        return ErrorCodes.tooManyEnrolledMfaFactors;
      case 'unexpected_audience':
        return ErrorCodes.unexpectedAudience;
      case 'unexpected_failure':
        return ErrorCodes.unexpectedFailure;
      case 'user_already_exists':
        return ErrorCodes.userAlreadyExists;
      case 'user_banned':
        return ErrorCodes.userBanned;
      case 'user_not_found':
        return ErrorCodes.userNotFound;
      case 'user_sso_managed':
        return ErrorCodes.userSsoManaged;
      case 'validation_failed':
        return ErrorCodes.validationFailed;
      case 'weak_password':
        return ErrorCodes.weakPassword;
      default:
        return ErrorCodes.unknown;
    }
  }

  static String getMessage(ErrorCodes errorCode) {
    switch (errorCode) {
      case ErrorCodes.anonymousProviderDisabled:
        return 'Anonymous sign-ins are disabled.';
      case ErrorCodes.badCodeVerifier:
        return 'Invalid code verifier. Please try again.';
      case ErrorCodes.badJson:
        return 'Invalid request format.';
      case ErrorCodes.badJwt:
        return 'Invalid authentication token.';
      case ErrorCodes.badOauthCallback:
        return 'OAuth authentication failed. Please try again.';
      case ErrorCodes.badOauthState:
        return 'OAuth state is invalid. Please try again.';
      case ErrorCodes.captchaFailed:
        return 'CAPTCHA verification failed. Please try again.';
      case ErrorCodes.conflict:
        return 'A conflict occurred. Please try again.';
      case ErrorCodes.couldNotAddElevenLabsApiKey:
        return 'Could not add ElevenLabs API key. Please try again.';
      case ErrorCodes.couldNotDeleteElevenLabsApiKey:
        return 'Could not delete ElevenLabs API key. Please try again.';
      case ErrorCodes.couldNotGetElevenLabsApiKeys:
        return 'Could not retrieve ElevenLabs API keys. Please try again.';
      case ErrorCodes.emailAddressInvalid:
        return 'Email address is invalid. Please use a valid email.';
      case ErrorCodes.emailAddressNotAuthorized:
        return 'This email address is not authorized.';
      case ErrorCodes.emailConflictIdentityNotDeletable:
        return 'Cannot unlink this identity due to email conflict.';
      case ErrorCodes.emailExists:
        return 'Email address already exists in the system.';
      case ErrorCodes.emailNotConfirmed:
        return 'Please confirm your email address before signing in.';
      case ErrorCodes.emailProviderDisabled:
        return 'Email sign-ups are currently disabled.';
      case ErrorCodes.flowStateExpired:
        return 'Authentication session expired. Please sign in again.';
      case ErrorCodes.flowStateNotFound:
        return 'Authentication session not found. Please sign in again.';
      case ErrorCodes.googleIdTokenMissing:
        return 'Google ID token is missing. Please try signing in again.';
      case ErrorCodes.googleSignInFailed:
        return 'Google sign-in failed. Please try again.';
      case ErrorCodes.hookPayloadInvalidContentType:
        return 'Invalid webhook payload format.';
      case ErrorCodes.hookPayloadOverSizeLimit:
        return 'Webhook payload exceeds size limit.';
      case ErrorCodes.hookTimeout:
        return 'Webhook request timed out.';
      case ErrorCodes.hookTimeoutAfterRetry:
        return 'Webhook request failed after retries.';
      case ErrorCodes.identityAlreadyExists:
        return 'This identity is already linked to another user.';
      case ErrorCodes.identityNotFound:
        return 'Identity not found.';
      case ErrorCodes.insufficientAal:
        return 'Additional authentication required. Please complete MFA.';
      case ErrorCodes.invalidCredentials:
        return 'Invalid email or password.';
      case ErrorCodes.inviteNotFound:
        return 'Invitation expired or already used.';
      case ErrorCodes.manualLinkingDisabled:
        return 'Manual account linking is disabled.';
      case ErrorCodes.mfaChallengeExpired:
        return 'MFA challenge expired. Please request a new code.';
      case ErrorCodes.mfaFactorNameConflict:
        return 'MFA factor name already exists. Choose a different name.';
      case ErrorCodes.mfaFactorNotFound:
        return 'MFA factor not found.';
      case ErrorCodes.mfaIpAddressMismatch:
        return 'IP address mismatch during MFA enrollment.';
      case ErrorCodes.mfaPhoneEnrollNotEnabled:
        return 'Phone MFA enrollment is disabled.';
      case ErrorCodes.mfaPhoneVerifyNotEnabled:
        return 'Phone MFA verification is disabled.';
      case ErrorCodes.mfaTotpEnrollNotEnabled:
        return 'TOTP MFA enrollment is disabled.';
      case ErrorCodes.mfaTotpVerifyNotEnabled:
        return 'TOTP MFA verification is disabled.';
      case ErrorCodes.mfaVerificationFailed:
        return 'Incorrect MFA code. Please try again.';
      case ErrorCodes.mfaVerificationRejected:
        return 'MFA verification rejected.';
      case ErrorCodes.mfaVerifiedFactorExists:
        return 'A verified phone factor already exists.';
      case ErrorCodes.mfaWebAuthnEnrollNotEnabled:
        return 'WebAuthn MFA enrollment is disabled.';
      case ErrorCodes.mfaWebAuthnVerifyNotEnabled:
        return 'WebAuthn MFA verification is disabled.';
      case ErrorCodes.noAuthorization:
        return 'Authorization required.';
      case ErrorCodes.notAdmin:
        return 'Admin access required.';
      case ErrorCodes.oauthProviderNotSupported:
        return 'OAuth provider is not supported.';
      case ErrorCodes.otpDisabled:
        return 'OTP sign-in is disabled.';
      case ErrorCodes.otpExpired:
        return 'OTP code expired. Please request a new one.';
      case ErrorCodes.overEmailSendRateLimit:
        return 'Too many emails sent. Please try again later.';
      case ErrorCodes.overRequestRateLimit:
        return 'Too many requests. Please try again later.';
      case ErrorCodes.overSmsSendRateLimit:
        return 'Too many SMS sent. Please try again later.';
      case ErrorCodes.phoneExists:
        return 'Phone number already exists in the system.';
      case ErrorCodes.phoneNotConfirmed:
        return 'Please confirm your phone number before signing in.';
      case ErrorCodes.phoneProviderDisabled:
        return 'Phone sign-ups are currently disabled.';
      case ErrorCodes.providerDisabled:
        return 'This authentication provider is disabled.';
      case ErrorCodes.providerEmailNeedsVerification:
        return 'Email verification required from OAuth provider.';
      case ErrorCodes.reauthenticationNeeded:
        return 'Please reauthenticate to continue.';
      case ErrorCodes.reauthenticationNotValid:
        return 'Reauthentication failed. Please try again.';
      case ErrorCodes.refreshTokenAlreadyUsed:
        return 'Session expired. Please sign in again.';
      case ErrorCodes.refreshTokenNotFound:
        return 'Session not found. Please sign in again.';
      case ErrorCodes.requestTimeout:
        return 'Request timed out. Please try again.';
      case ErrorCodes.samePassword:
        return 'New password must be different from current password.';
      case ErrorCodes.samlAssertionNoEmail:
        return 'No email found in SAML response.';
      case ErrorCodes.samlAssertionNoUserId:
        return 'No user ID found in SAML response.';
      case ErrorCodes.samlEntityIdMismatch:
        return 'SAML entity ID mismatch.';
      case ErrorCodes.samlIdpAlreadyExists:
        return 'SAML identity provider already exists.';
      case ErrorCodes.samlIdpNotFound:
        return 'SAML identity provider not found.';
      case ErrorCodes.samlMetadataFetchFailed:
        return 'Failed to fetch SAML metadata.';
      case ErrorCodes.samlProviderDisabled:
        return 'SAML authentication is disabled.';
      case ErrorCodes.samlRelayStateExpired:
        return 'SAML authentication expired. Please sign in again.';
      case ErrorCodes.samlRelayStateNotFound:
        return 'SAML authentication session not found. Please sign in again.';
      case ErrorCodes.sessionExpired:
        return 'Session expired. Please sign in again.';
      case ErrorCodes.sessionNotFound:
        return 'Session not found. Please sign in again.';
      case ErrorCodes.signupDisabled:
        return 'Sign-ups are currently disabled.';
      case ErrorCodes.singleIdentityNotDeletable:
        return 'Cannot delete your only authentication method.';
      case ErrorCodes.smsSendFailed:
        return 'Failed to send SMS. Please try again.';
      case ErrorCodes.ssoDomainAlreadyExists:
        return 'SSO domain already exists.';
      case ErrorCodes.ssoProviderNotFound:
        return 'SSO provider not found.';
      case ErrorCodes.tooManyEnrolledMfaFactors:
        return 'Too many MFA factors enrolled.';
      case ErrorCodes.unexpectedAudience:
        return 'Unexpected token audience.';
      case ErrorCodes.unexpectedFailure:
        return 'An unexpected error occurred. Please try again.';
      case ErrorCodes.userAlreadyExists:
        return 'User already exists.';
      case ErrorCodes.userBanned:
        return 'User account is temporarily banned.';
      case ErrorCodes.userNotFound:
        return 'User not found.';
      case ErrorCodes.userSsoManaged:
        return 'User is managed by SSO.';
      case ErrorCodes.validationFailed:
        return 'Validation failed. Please check your input.';
      case ErrorCodes.weakPassword:
        return 'Password is too weak. Please use a stronger password.';
      case ErrorCodes.unknown:
        return 'An error has occurred.';
    }
  }
}
