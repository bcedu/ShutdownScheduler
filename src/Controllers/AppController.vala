/*
* Copyright (C) 2018  Eduard Berloso Clarà <eduard.bc.95@gmail.com>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*/
using App.Configs;
using App.Widgets;


namespace App.Controllers {

    public class AppController {
        /**
         * Constructs a new {@code AppController} object.
         * The AppControler manages all the elements of the applications.
         */
        public App.Application application;
        public AppWindow window;
        public ViewController view_controller;
        public Unity.LauncherEntry launcher;
        public DateTime shutdown_time;
        public DateTime start_time;
        public bool shutdown_programed;
        public bool alerted;
        public bool closed;

        public AppController (App.Application application) {
            this.application = application;
            // Create the main window
            this.window = new AppWindow (this.application);
            this.application.add_window (this.window);
            // Create the view_controller;
            this.view_controller = new ViewController (this);
            // Connect the signals
            this.connect_signals();
            this.launcher = Unity.LauncherEntry.get_for_desktop_id (Constants.LAUNCHER_ID);
        }

        public void activate () {
            this.alerted = false;
            this.closed = false;
            // Show all elements from window
            window.init ();
            // Set current view
            this.update_window_view ();
        }

        public void quit () {
            // Close the window
            window.destroy ();
        }

        public void update_window_view() {
            this.window.clean ();
            this.view_controller.update_views ();
            var aux = this.view_controller.get_current_view ();
            this.window.add (aux);
        }

        public void add_registered_view(string view_id) {
            this.view_controller.add_registered_view (view_id);
            this.update_window_view ();
        }

        private void connect_signals() {
            // Signals of views
            this.view_controller.connect_signals ();
            // Signal for back button
            this.window.headerbar.back_button.clicked.connect (() => {
                this.view_controller.get_current_view ();
                this.view_controller.get_previous_view ();
                this.update_window_view ();
		    });
		    this.window.delete_event.connect (() => {
                if (this.shutdown_programed) {
                    this.closed = true;
                    return this.window.hide_on_delete ();
                }else return false;
            });
        }

        public void set_conf_file(Gee.ArrayList<AddTimeButton> add_time_buttons) {
            File f = File.new_for_path (this.get_conf_file());
            try {
	            f.delete ();
                f.create(FileCreateFlags.NONE);
                DataOutputStream writer = new DataOutputStream (f.replace (null, false, FileCreateFlags.NONE));
                foreach (AddTimeButton btn in add_time_buttons) {
                    writer.put_string("%d;%s\n".printf (btn.time, btn.units));
                }
            } catch (Error e) {
	            print ("Error: %s\n", e.message);
            }
        }

        public string get_conf_file() {
            string app_dir = "%s/.shutdownscheduler".printf(Environment.get_home_dir());
            string conf_path = app_dir + "/shutdownscheduler_conf";
            try {
                File file = File.new_for_path (app_dir);
                if (!file.query_exists()) file.make_directory ();
                file = File.new_for_path (conf_path);
                if (!file.query_exists()) this.create_conf_file(conf_path);
            } catch (Error e) {
                stderr.printf(e.message);
            }
            return conf_path;
        }

        public File create_conf_file(string conf_path) {
            File file;
            try {
                file = File.new_for_path(conf_path);
                if (file.query_exists()) file.delete ();
                file.create(FileCreateFlags.NONE);
                FileIOStream io = file.open_readwrite();
                io.seek (0, SeekType.END);
                var writer = new DataOutputStream(io.output_stream);
                writer.put_string("5;m\n");
                writer.put_string("15;m\n");
                writer.put_string("30;m\n");
                writer.put_string("1;h\n");
            } catch (Error e) {stderr.printf(e.message);}
            return file;
        }

        public void reset_conf_file() {
            create_conf_file (get_conf_file ());
        }

        public void start_shutdown_programed(DateTime dt) {
            this.shutdown_time = dt;
            this.shutdown_programed = true;
            this.alerted = false;
            this.closed = false;
            this.start_time = new DateTime.now_local ();
            GLib.Timeout.add_seconds (1, update_counter);
        }

        private bool update_counter() {
            string alert_str_time = get_str_time_rep_hh_mm_ss(10);
            string rmaining_time_str = get_schedule_remaining_time();
            if (rmaining_time_str.collate(alert_str_time) <= 0) {
                if (!alerted & closed) {
                    this.application.activate ();
                    this.window.present();
                    this.alerted = true;
                    this.closed = false;
                }
            }

            if (rmaining_time_str.contains("-") && this.shutdown_programed) {
                // shutdown command only handels minutes when sheduling , not seconds.
                // So we may have passed the time. We check if we are in negative numbers and we shutdown the computer
                Posix.system("shutdown +0");
                //print("APAGAAAAAAAAAAAAAAAAAAATTTT\n");
            }
            this.update_window_view ();
            this.launcher.progress = get_percentage_progres();
            if (this.shutdown_programed) return true;
            else return false;
        }

        public void stop_shutdown_programed() {
            this.shutdown_programed = false;
        }

        public string get_schedule_remaining_time() {
            // Returns a string with the remaining time of the scheduled shutdown. Example:
            // "HH:MM:SS"
            DateTime obj = this.shutdown_time;
            DateTime now = new DateTime.now_local ();
            TimeSpan diff = obj.difference(now);
            return get_str_time_rep_hh_mm_ss((int)(diff/1000000));
        }

        public string get_str_time_rep_hh_mm_ss(int seconds) {
            int rem_sec = seconds % 60;
            int minutes = seconds / 60;
            int rem_min = minutes % 60;
            int hours = minutes / 60;
            string aux1 = rem_min.to_string();
            if (rem_min < 10) aux1 = "0"+aux1;
            string aux2 = rem_sec.to_string();
            if (rem_sec < 10) aux2 = "0"+aux2;
            return hours.to_string()+":"+aux1+":"+aux2;
        }

        public double get_percentage_progres() {
            // Returns an int between 0 and 1 representing the percentage of time
            // that has passed since the shutdown was programed to the shutdown time
            DateTime obj = this.shutdown_time;
            DateTime now = new DateTime.now_local ();
            TimeSpan passed = now.difference(this.start_time);
            TimeSpan total = obj.difference(this.start_time);
            return (double)passed/(double)total;
        }

    }
}
