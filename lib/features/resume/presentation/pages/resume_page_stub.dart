// Stub for mobile platforms where dart:html is not available
class Window {
  void print() {
    // No-op on mobile
  }
}

final window = Window();
