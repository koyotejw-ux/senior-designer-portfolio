# Build Issue Resolution

## Issue Summary
Flutter web build is failing with shader compilation error for `ink_sparkle.frag`:

```
ShaderCompilerException: Shader compilation of "ink_sparkle.frag" failed with exit code -1073741819
```

## Root Cause
This is a known Windows-specific issue with Flutter's shader compiler (`impellerc.exe`). The error code `-1073741819` (0xC0000005) indicates an Access Violation, which is a crash in the shader compiler itself.

## Immediate Workarounds

### Option 1: Run in Debug Mode (Recommended for Development)
Debug mode doesn't compile shaders, so you can test your changes:
```bash
flutter run -d chrome
```

### Option 2: Disable Wasm Dry Run
This won't fix the shader issue but will remove warnings:
```bash
flutter build web --no-wasm-dry-run
```

### Option 3: Use Flutter Beta/Master Channel
The shader compiler issue may be fixed in newer Flutter versions:
```bash
flutter channel beta
flutter upgrade
flutter build web
```

## Long-term Solutions

### Solution 1: Update Flutter SDK
Update to the latest stable Flutter version:
```bash
flutter upgrade
```

### Solution 2: Disable Ink Sparkle Effect
If the issue persists, you can disable the ink_sparkle shader by avoiding Material 3 components that use it, or by setting:

```dart
// In your MaterialApp
theme: ThemeData(
  useMaterial3: false, // Disables Material 3 features including ink_sparkle
)
```

### Solution 3: Windows Antivirus Exclusion
Sometimes antivirus software interferes with the shader compiler. Add Flutter SDK directory to Windows Defender exclusions:
1. Open Windows Security
2. Virus & threat protection
3. Manage settings
4. Exclusions
5. Add `C:\flutter` (or your Flutter SDK path)

## Current Status

**PDF Generation Fix**: ✅ Completed
- Fixed btoa() encoding issue with Korean text
- Changed to UTF-8 Blob-based approach
- File: `lib/features/admin/presentation/widgets/resume_print_dialog.dart`

**Build Issue**: ⚠️ Flutter SDK shader compiler crash (not our code)
- Development can continue using `flutter run -d chrome`
- Production builds will need one of the solutions above

## Next Steps

1. **For Development**: Use `flutter run -d chrome` to test PDF generation fix
2. **For Production**:
   - Try upgrading Flutter SDK
   - Or disable Material 3 (useMaterial3: false)
   - Or add antivirus exclusion

## Verification Commands

```bash
# Check Flutter version
flutter --version

# Check for Flutter issues
flutter doctor -v

# Analyze code (should pass)
flutter analyze

# Run in debug mode
flutter run -d chrome
```
