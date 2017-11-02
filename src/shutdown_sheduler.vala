/*
    * Copyright (c) 2011-2017 Your Organization (https://yourwebsite.com)
    *
    * This program is free software; you can redistribute it and/or
    * modify it under the terms of the GNU General Public
    * License as published by the Free Software Foundation; either
    * version 2 of the License, or (at your option) any later version.
    *
    * This program is distributed in the hope that it will be useful,
    * but WITHOUT ANY WARRANTY; without even the implied warranty of
    * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    * General Public License for more details.
    *
    * You should have received a copy of the GNU General Public
    * License along with this program; if not, write to the
    * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
    * Boston, MA 02110-1301 USA
    *
    * Authored by: Eduard Berloso Clarà <eduard.bc.95@gmail.com>
    */


    public class ShutdownSheduler : Gtk.Application {

        public bool shutdown_programed = false;
        Gtk.ApplicationWindow app_window;
        Granite.Widgets.DatePicker date;
        Granite.Widgets.TimePicker time;

        public ShutdownSheduler () {
            Object (application_id: "com.github.bcedu.shutdown_sheduler",
            flags: ApplicationFlags.FLAGS_NONE);
        }

        protected override void activate () {
            app_window = new Gtk.ApplicationWindow (this);
            app_window.title = "Shutdown Sheduler";
        		app_window.window_position = Gtk.WindowPosition.CENTER;

            Gtk.Box main_box;
            if (is_shutdown_programed()) {
                main_box = get_shutdown_info();
            }else {
                main_box = get_shutdown_programer();
            }
            app_window.add(main_box);
            app_window.show_all ();
            app_window.show ();
        }

        public static int main (string[] args) {
            var app = new ShutdownSheduler ();
            return app.run (args);
        }

        private bool is_shutdown_programed() {
            // Returns True if there is any shutdown programed in the system
            return this.shutdown_programed;
        }

        private Gtk.Box get_shutdown_info() {
            // Returns a Gtk.Box with info about programed shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            box.pack_start (new Gtk.Label (get_shedule_description()), false, false, 10);
            box.pack_start (new Gtk.Label (get_shedule_remaining_time()), false, false, 10);
            box.pack_start (get_shedule_cancel_button(), false, false, 10);
            return box;
        }

        private string get_shedule_description() {
            // Returns a string with the discription of the sheduled shutdown. Example:
            // "Shutdown sheduled for HH:MM:SS DD/MM/YYYY"
            DateTime obj = get_widgets_time();
            return "Shutdown sheduled for " + obj.format("%H:%M:%S %d/%m/%y");
        }

        private string get_shedule_remaining_time() {
            // Returns a string with the remaining time of the sheduled shutdown. Example:
            // "HH:MM:SS"
            return "HH:MM:SS";
        }

        private Gtk.Button get_shedule_cancel_button() {
            // Returns a Gtk.Button to cancel the sheduled shutdown.
            return new Gtk.Button.with_label ("Cancel");
        }

        private Gtk.Box get_shutdown_programer() {
            // Returns a Gtk.Box with controls to shedule a shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            box.pack_start (get_time_box(), false, false, 10);
            box.pack_start (get_time_buttons_box(), false, false, 10);
            box.pack_start (get_shedule_program_button(), false, false, 10);
            return box;
        }

        private Gtk.Box get_time_box() {
            // Returns a Gtk.Box with interface to enter time to program shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.date = new Granite.Widgets.DatePicker();
            this.time = new Granite.Widgets.TimePicker();
            box.pack_start (this.date, false, false, 10);
            box.pack_start (this.time, false, false, 10);
            return box;
        }

        private Gtk.Box get_time_buttons_box() {
            // Returns a Gtk.Box with buttons to summ/substract time to programed
            // shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            Gtk.Button bt;

            bt = new Gtk.Button.with_label ("+15 min.");
            bt.clicked.connect (() => {add_time(15);});
            box.pack_start (bt, false, false, 10);

            bt = new Gtk.Button.with_label ("+30 min.");
            bt.clicked.connect (() => {add_time(30);});
            box.pack_start (bt, false, false, 10);

            bt = new Gtk.Button.with_label ("+1 h.");
            bt.clicked.connect (() => {add_time(60);});
            box.pack_start (bt, false, false, 10);

            bt = new Gtk.Button.with_label ("+2 h.");
            bt.clicked.connect (() => {add_time(120);});
            box.pack_start (bt, false, false, 10);

            return box;
        }

        private void add_time(int min) {
          // Adds 'min' minutes to thtime that will be sheduled
          DateTime obj = get_widgets_time();
          // Sum 'min' minutes
          obj = obj.add_minutes(min);
          // Store new time to widgets
          this.date.date = obj;
          this.time.time = obj;
        }

        private Gtk.Button get_shedule_program_button() {
            // Returns a Gtk.Button to program shutdown
            Gtk.Button bt = new Gtk.Button.with_label ("Shedule");
            bt.clicked.connect (() => {
                string command = "shutdown +" + get_minutes_to_shutdown();
                Posix.system(command);
                this.shutdown_programed = true;
                update_interface();
            });
            return bt;
        }

        private string get_minutes_to_shutdown() {
            // Returns a string with the number of minutes left for when we
            // want to program the shutdown
            DateTime obj = get_widgets_time();
            // Get current local time
            DateTime now = new DateTime.now_local ();
            // Calc. diff. in minutes
            TimeSpan diff = obj.difference(now);
            return (diff/60000000).to_string();
        }

        private DateTime get_widgets_time() {
          int year, month, day, hour, minute;
          this.date.date.get_ymd(out year, out month, out day);
          hour = this.time.time.get_hour();
          minute = this.time.time.get_minute();
          // Build new DateTime with the data
          return new DateTime.local (year, month, day, hour, minute, 0);
        }

        private void update_interface() {
            // Updates interface depending on programed shutdown
            Gtk.Box main_box;
            if (is_shutdown_programed()) {
                main_box = get_shutdown_info();
            }else {
                main_box = get_shutdown_programer();
            }
            app_window.forall ((element) => app_window.remove (element));
            app_window.add(main_box);
            app_window.show_all ();
            app_window.show ();
        }

    }
