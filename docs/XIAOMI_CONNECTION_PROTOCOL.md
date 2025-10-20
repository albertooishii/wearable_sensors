# Xiaomi Connection Protocol - Architecture

## Overview

The Xiaomi Smart Band 10 and similar devices require a specific connection strategy:
- **BLE** is used ONLY for initial authentication (one-time)
- **Bluetooth Classic (SPP)** is used for ALL data streaming and subsequent connections

## Connection Paths

### Path 1: Known Device (Reconnection)
**Triggered when:** Device is bonded AND encryption keys exist in storage

```
Device State: Bonded ✓ + Keys exist ✓
           ↓
    Load encryption keys
           ↓
    Load authentication credentials
           ↓
    Connect via BT_CLASSIC (Direct, no BLE)
           ↓
    Retry logic: BT_CLASSIC only (no BLE fallback)
           ↓
    Perform NONCE handshake with saved keys
           ↓
    Start data streaming (HR, movement, etc.)
```

**Time:** ~1-2 seconds (fast)
**Complexity:** Simple (no BLE auth overhead)

---

### Path 2: New Device (First Time)
**Triggered when:** Device not bonded OR keys missing

```
Device State: Not bonded OR no keys
           ↓
    BLE Connect
           ↓
    3-Step Authentication Handshake
    - Send phone nonce
    - Receive watch nonce + HMAC
    - Verify and derive session keys
           ↓
    Save encryption keys to storage
    Save authentication credentials
    Mark device as bonded
           ↓
    Disconnect BLE cleanly
           ↓
    Wait 2 seconds for device to be ready
           ↓
    Connect via BT_CLASSIC
           ↓
    Perform NONCE handshake with new keys
           ↓
    Start data streaming
           ↓
    [FUTURE] Next connection uses Path 1 (fast path)
```

**Time:** ~8-10 seconds (slower, but one-time)
**Complexity:** Full BLE authentication required

---

## Key Design Decisions

### 1. No BLE Fallback After Path 1
**Why?**
- BLE auth is expensive and already completed
- Encryption keys are persistent
- If BT_CLASSIC fails, it indicates a real issue (not a protocol mismatch)

**Behavior:**
- Known devices: Try BT_CLASSIC 3x, then fail (don't retry with BLE)
- User action: Reconnect, or re-pair the device

### 2. Keys Are The Source of Truth
**Decision rule:**
```
if (encryptionKeys exist && device.isBonded):
    Use Path 1 (fast BT_CLASSIC)
else:
    Use Path 2 (full BLE auth)
```

No external "known devices" list needed. Keys are the single source of truth.

### 3. Session Keys Are Fresh Each Connection
**Important:** Even for known devices:
- Old session keys are NOT reused
- Each BT_CLASSIC session gets fresh NONCE handshake
- This ensures security and protocol compliance (Gadgetbridge pattern)

---

## Code Structure

### XiaomiConnectionOrchestrator
Main entry point: `connectAndAuthenticate(deviceId)`

**Decision Logic:**
```dart
if (_encryptionKeys != null && isBonded) {
    // PATH 1: Known device
    await _connectBtClassicDirect(deviceId);
} else {
    // PATH 2: New device
    await _authenticateViaBle(deviceId);
    await _transitionToBtClassic(deviceId);
}
```

### Helper Methods

#### `_connectBtClassicDirect(deviceId)`
- Pure BT_CLASSIC connection
- Retry logic: 3x BT_CLASSIC, NO BLE fallback
- Used for known devices only

#### `_authenticateViaBle(deviceId)`
- Full BLE authentication (3-step handshake)
- Generates and saves encryption keys
- Returns SPP service reference
- Used for first-time devices only

#### `_transitionToBtClassic(deviceId)`
- Disconnect BLE cleanly
- Wait for device to be ready
- Connect via BT_CLASSIC
- Start data streaming

---

## Performance Characteristics

| Scenario | Time | Path |
|----------|------|------|
| Reconnect (known device) | 1-2s | Path 1 |
| First connection | 8-10s | Path 2 |
| Connection lost (auto-reconnect) | 1-2s | Path 1 |
| Keys deleted, device bonded | 8-10s | Path 2 (re-auth) |
| Device not bonded | 8-10s | Path 2 |

---

## Error Handling

### Path 1 Failures
- BT_CLASSIC attempt 1 fails → Retry attempt 2 (500ms delay)
- BT_CLASSIC attempt 2 fails → Retry attempt 3 (500ms delay)
- BT_CLASSIC attempt 3 fails → **Stop, fail to user** (no BLE fallback)

**User remediation:**
1. Ensure Bluetooth is on
2. Restart device
3. Check device is in range
4. If all fails: Re-pair device (clears keys, triggers Path 2)

### Path 2 Failures
- BLE auth fails → Exception surfaced
- Device not responding → Exception surfaced
- Keys not saved properly → Exception surfaced

**User remediation:**
1. Restart device and app
2. Re-pair device from system Bluetooth settings
3. Try again

---

## Testing Checklist

- [ ] First connection to new device (Path 2)
  - Device gets bonded
  - Keys saved to storage
  - Data streaming works
  
- [ ] Second connection to same device (Path 1)
  - Connection faster than first time
  - No BLE scan visible
  - Data streaming works
  
- [ ] Device disconnect/reconnect (Path 1)
  - Auto-reconnect uses Path 1
  - Performance consistent
  
- [ ] Simulate BT_CLASSIC failure on known device
  - Retries 3x BT_CLASSIC
  - Does NOT fallback to BLE
  - Fails with clear error

- [ ] Delete keys manually, then connect
  - System detects no keys
  - Falls back to Path 2 (BLE auth)
  - Re-authenticates successfully

- [ ] Device not paired at system level
  - Goes through Path 2
  - Gets paired automatically
  - Future connections use Path 1

---

## References

- **Gadgetbridge:** [XiaomiSupport.java](https://github.com/Freeyourgadget/Gadgetbridge/)
- **Protocol:** Xiaomi SPP V2 with FE95 service
- **Security:** AES-256 encryption, HMAC verification

