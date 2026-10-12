package dao

// Shared with pwm-dotnet/UserDataResetService. Native sign-up reopens the
// identity before HTTP onboarding; only the latter may clear this marker,
// inside the same transaction that purges the previous account history.
const pendingRestoreReason = "pwm_restore_pending"
