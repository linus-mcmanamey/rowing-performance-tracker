# Security

## Authentication & Authorization

### iOS App Security
```swift
// Keychain storage for sensitive data
class SecureStorage {
    static func saveAPIKey(_ key: String) {
        let data = key.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "APIKey",
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
}
// CloudKit automatic authentication via Apple ID
```

### Backend Security
```typescript
// JWT authentication with refresh tokens
const authMiddleware = async (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};
```

## Data Protection
- **At Rest**: CloudKit automatic encryption, PostgreSQL TDE
- **In Transit**: TLS 1.3 for all connections
- **BLE**: PM5 uses open protocol (no encryption needed)
- **Privacy**: GDPR compliance, data export/deletion endpoints
