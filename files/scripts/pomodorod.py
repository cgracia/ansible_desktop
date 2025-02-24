#!/usr/bin/env python3
import logging
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
        self.lock = threading.RLock()
        self.server = None
        logging.basicConfig(
            level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
        )
        logging.info("Pomodoro Daemon initialized with duration %s seconds", duration)

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
                logging.info("Session started: start=%s, end=%s", start_time, end_time)
                self.notify("Pomodoro started")
                self.update_polybar()
                return "Session started"
            logging.warning("Attempt to start session when one is already running")
            return "A session is already running."

    def stop_session(self, interrupted=True):
        """Stop the current session and log its details."""
        logging.info("Stopping session: interrupted=%s", interrupted)
        with self.lock:
            logging.debug("Session: %s", self.session)
            if self.session:
                now = int(time.time())
                # Log the session: start_time, scheduled_end, actual_end, interrupted_flag
                log_line = f"{self.session['start_time']},{self.session['end_time']},{now},{int(interrupted)}\n"
                logging.info("Writing history: %s", log_line.strip())
                try:
                    with open(HISTORY_FILE, "a") as f:
                        f.write(log_line)
                    logging.info("Session stopped: %s", log_line.strip())
                except Exception as e:
                    logging.error("Error writing history: %s", e)
                self.session = None
                logging.info("Pomodoro stopped" if interrupted else "Pomodoro complete")
                self.notify("Pomodoro stopped" if interrupted else "Pomodoro complete")
                self.update_polybar()
                return "Session stopped"
            logging.warning("Attempt to stop session when no session is active")
            return "No active session to stop."

    def notify(self, message):
        """Send a desktop notification."""
        try:
            subprocess.run(["notify-send", message], check=True, timeout=5)
            logging.info("Notification sent: %s", message)
        except Exception as e:
            logging.error("Failed to send notification: %s", e)

    def update_polybar(self):
        """Trigger a polybar update via its hook system."""
        try:
            # Adding a timeout of 5 seconds
            subprocess.run(
                ["polybar-msg", "action", "hook", "pomodoro", "1"],
                check=True,
                timeout=5,
            )
            logging.debug("Polybar updated via hook")
        except subprocess.TimeoutExpired:
            logging.error("Polybar update timed out")
        except Exception as e:
            logging.error("Polybar update failed: %s", e)

    def session_status(self):
        """Return the current session status."""
        with self.lock:
            if self.session:
                remaining = self.session["end_time"] - int(time.time())
                remaining_minutes = remaining // 60
                if remaining_minutes < 1:
                    return "🍅 Less than a minute remaining."
                return f"🍅 {remaining_minutes} minutes remaining."
            return "No active session."

    def check_session(self):
        """Continuously check if the current session has expired."""
        while self.running:
            with self.lock:
                if self.session:
                    now = int(time.time())
                    if now >= self.session["end_time"]:
                        logging.info("Session expired naturally")
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
        logging.info("Socket server listening on %s", SOCKET_PATH)
        while self.running:
            try:
                client, _ = self.server.accept()
                data = client.recv(1024).decode("utf-8").strip()
                logging.debug("Received command: %s", data)
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
        if cmd == "stop":
            return self.stop_session(interrupted=True)
        if cmd == 'toggle':
            if self.session:
                return self.stop_session(interrupted=True)
            return self.start_session()
        if cmd == "status":
            return self.session_status()
        return "Unknown command. Valid commands are: start, stop, toggle, status."

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
        logging.info("Daemon shutdown")

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
