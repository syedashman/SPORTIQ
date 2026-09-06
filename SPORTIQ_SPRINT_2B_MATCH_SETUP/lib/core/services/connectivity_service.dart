// TEMPORARY STUB — NOT REAL NETWORK DETECTION.
//
// [ConnectivityChecker] is the interface future code should depend on.
// [StubConnectivityChecker] always reports "online" and never actually
// checks the network. It exists only so the shared OfflineWidget/reusable
// offline state has something to bind to during foundation development.
//
// Do not treat this as a real connectivity signal. Replace
// [StubConnectivityChecker] with a `connectivity_plus`-backed
// implementation in a later sprint — no other file should
// need to change, since callers depend on [ConnectivityChecker], not the
// stub class.
import 'dart:async';

abstract class ConnectivityChecker {
  Stream<bool> get onStatusChange;
  void dispose();
}

class StubConnectivityChecker implements ConnectivityChecker {
  StubConnectivityChecker() : _controller = StreamController<bool>.broadcast() {
    // Stub: always reports online. Real implementation pending.
    _controller.add(true);
  }

  final StreamController<bool> _controller;

  @override
  Stream<bool> get onStatusChange => _controller.stream;

  @override
  void dispose() => _controller.close();
}
