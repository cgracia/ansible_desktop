#!/usr/bin/env python3
import os
import socket
import subprocess
import threading
import time

# Configuration parameters
SOCKET_PATH = "/tmp/pomodoro.sock"
DEFAULT_DURATION = 1500  # 25 minutes in seconds
HISTORY_FILE = "/var/tmp/pomodoro-history"


class PomodoroDaemon:
    def __init__(self, duration=DEFAULT_DURATION):
        self.duration = duration
        self.session = None  # Holds current session info
        self.running = True
        self.lock = threading.Lock()
        self.server = None

    def start_session(self):
        """Start a new Pomodoro session if one is not active."""
        with self.lock:
            if self.session is None:
                start_time = int(time.time())
                end_time = start_time + self.duration
                self.session = {
                    "start_time": start_time,
                    "end_time": end_time,
                    "paused": False,
                }
                self.notify("Pomodoro started")
                self.update_polybar()
                return "Session started"
            else:
                return "A session is already running."

    def stop_session(self, interrupted=True):
        """Stop the current session and log its details."""
        with self.lock:
            if self.session:
                now = int(time.time())
                # Log the session: start_time, scheduled_end, actual_end, interrupted_flag
                log_line = f"{self.session['start_time']},{self.session['end_time']},{now},{int(interrupted)}\n"
                with open(HISTORY_FILE, "a") as f:
                    f.write(log_line)
                self.session = None
                self.notify("Pomodoro stopped" if interrupted else "Pomodoro complete")
                self.update_polybar()
                return "Session stopped"
            else:
                return "No active session to stop."

    def notify(self, message):
        """Send a desktop notification."""
        subprocess.run(["notify-send", message])

    def update_polybar(self):
        """Trigger a polybar update via its hook system."""
        subprocess.run(["polybar-msg", "cmd", "hook", "pomodoro", "1"])

    def session_status(self):
        """Return the current session status."""
        with self.lock:
            if self.session:
                remaining = self.session["end_time"] - int(time.time())
                return f"🍅 {remaining} seconds remaining."
            else:
                return "No active session."

    def check_session(self):
        """Continuously check if the current session has expired."""
        while self.running:
            with self.lock:
                if self.session:
                    now = int(time.time())
                    if now >= self.session["end_time"]:
                        # Session finished naturally
                        self.stop_session(interrupted=False)
            time.sleep(1)

    def run_socket_server(self):
        """Create and run the Unix domain socket server for command handling."""
        # Ensure any previous socket is removed
        if os.path.exists(SOCKET_PATH):
            os.remove(SOCKET_PATH)
        self.server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.server.bind(SOCKET_PATH)
        self.server.listen(5)
        while self.running:
            try:
                client, _ = self.server.accept()
                data = client.recv(1024).decode("utf-8").strip()
                response = self.handle_command(data)
                client.send(response.encode("utf-8"))
                client.close()
            except Exception as e:
                print("Socket error:", e)

    def handle_command(self, command):
        """Process commands received via the socket."""
        cmd = command.lower()
        if cmd == "start":
            return self.start_session()
        elif cmd == "stop":
            return self.stop_session(interrupted=True)
        elif cmd == "status":
            return self.session_status()
        else:
            return "Unknown command. Valid commands are: start, stop, status."

    def run(self):
        """Run the daemon: start the session-check thread and the socket server."""
        # Start a background thread to monitor session expiration
        check_thread = threading.Thread(target=self.check_session, daemon=True)
        check_thread.start()
        # Run the socket server (blocking)
        try:
            self.run_socket_server()
        finally:
            self.shutdown()

    def shutdown(self):
        """Shut down the daemon cleanly."""
        self.running = False
        if self.server:
            self.server.close()
        if os.path.exists(SOCKET_PATH):
            os.remove(SOCKET_PATH)


if __name__ == "__main__":
    daemon = PomodoroDaemon()
    try:
        daemon.run()
    except KeyboardInterrupt:
        daemon.shutdown()
