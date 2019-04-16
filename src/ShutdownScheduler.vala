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

    public struct ButtonConf {
        public int bvalue;
        public string btype;
    }

    public class ShutdownScheduler : Gtk.Application {

        public string appdata_dir;
        public string conf_path;

        public bool shutdown_programed;
        public bool alerted;
        public int alert_seconds;
        public bool closed;

        public Gtk.Box main_box;
        public Unity.LauncherEntry launcher;
        public Gtk.ApplicationWindow app_window;

        public Gtk.Label remaining_time_lbl;
        public DateTime start_time;
        public Granite.Widgets.DatePicker date;
        public Granite.Widgets.TimePicker time;

        public ShutdownScheduler (string? base_dir) {
            Object (application_id: "com.github.bcedu.shutdownscheduler",
            flags: ApplicationFlags.FLAGS_NONE);
            this.init_conf_vals();
            this.init_conf_file(base_dir);
        }

        public void init_conf_vals() {
            closed = false;
            shutdown_programed = false;
            alerted = false;
            alert_seconds = 10;
        }

        public void init_conf_file(string? base_dir) {
            string app_dir = base_dir;
            if (app_dir == null) app_dir = "%s/".printf(Environment.get_home_dir());
            this.appdata_dir =  app_dir+".shutdownscheduler";
            this.conf_path = this.appdata_dir + "/shutdownscheduler_conf";
            try {
                File file = File.new_for_path (this.appdata_dir);
                if (!file.query_exists()) file.make_directory ();
            } catch (Error e) {
                stderr.printf(e.message);
            }
        }

        public File create_conf_file() {
            File file;
            try {
                file = File.new_for_path(this.conf_path);
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

        protected override void activate () {
            closed = false;
            this.app_window = new Gtk.ApplicationWindow (this);
            this.app_window.title = _("Shutdown Scheduler");
            this.app_window.window_position = Gtk.WindowPosition.CENTER;
            // Css
            this.init_css();

            // Create interface
            Gtk.Box aux_box;
            if (is_shutdown_programed()) {
                aux_box = get_shutdown_info();
            }else {
                aux_box = get_shutdown_programer();
            }
            this.main_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.main_box.pack_start (aux_box, false, false, 10);
            this.launcher = Unity.LauncherEntry.get_for_desktop_id ("com.github.bcedu.shutdownscheduler.desktop");

            this.app_window.delete_event.connect (() => {
                if (this.is_shutdown_programed()) {
                    return app_window.hide_on_delete ();
                }else return false;
            });

            this.app_window.add(main_box);
            this.app_window.set_resizable(false);

            var header_bar = new Gtk.HeaderBar ();
            header_bar.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            header_bar.show_close_button = true;
            header_bar.pack_end(this.get_conf_button());
            app_window.set_titlebar (header_bar);

            this.app_window.show_all ();
            this.app_window.show ();
        }

        public void init_css() {
            // Load CSS
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/bcedu/shutdownscheduler/Application.css");
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        public static int main (string[] args) {
            var app = new ShutdownScheduler (null);
            return app.run (args);
        }

        public ButtonConf get_btn_conf(int nbutton) {
            // Hi ha 4 butons per tant nbutton pot ser 0, 1, 2 o 3
            int time = 0;
            string type = "m";
            try {
                File file = File.new_for_path(this.conf_path);
                DataInputStream reader = new DataInputStream(file.read());
                string info = "";
                for (int i = 0; i<= nbutton; i++) info = reader.read_line(null);
                time = int.parse(info.split(";")[0]);
                type = info.split(";")[1];
            } catch (Error e) {
                stderr.printf(e.message);
            }
            return {time, type};
        }

        public void set_btn_conf(int nbutton, ButtonConf bconf) {
            try {
                File file = File.new_for_path(this.conf_path);
                DataInputStream reader = new DataInputStream(file.read());
                DataOutputStream writer = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
                string line;
                int i = 0;
                while ((line=reader.read_line(null)) != null) {
                    if (i == nbutton) line = bconf.bvalue.to_string()+";"+bconf.btype;
                    writer.put_string(line+"\n");
                    i+=1;
                }
            }catch (Error e){
                error("%s", e.message);
            }
        }

        public void show_conf_panel(Gtk.Button button) {
            var confpw = new Gtk.Popover(button);
            confpw.set_position(Gtk.PositionType.BOTTOM);
            confpw.get_style_context().add_class ("confpanel");
            Gtk.Box vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 1);
            vbox.margin = 10;

            // Section text
            Gtk.Label lb = new Gtk.Label(_("Fast acces buttons"));
            lb.get_style_context().add_class ("conf_btn_label");
            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            hbox.pack_start(lb, true, true, 0);
            // Reset buttons button
            Gtk.Button btn = new Gtk.Button.from_icon_name ("gtk-refresh", Gtk.IconSize.BUTTON);
            btn.get_style_context().add_class ("conf_btn_reset");
            btn.set_border_width(0);
            btn.clicked.connect(() => {
                confpw.popdown();
                create_conf_file();
                update_interface();
            });
            hbox.pack_end(btn, false, false, 0);
            vbox.pack_start(hbox, true, true, 5);

            // Button 1
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            ButtonConf bconf = get_btn_conf(0);
            Gtk.Label text = new Gtk.Label(_("Button 1"));
            text.get_style_context().add_class ("conf_btn_text");
            Gtk.Entry entry1 = new Gtk.Entry();
            entry1.get_style_context().add_class ("conf_btn_entry");
            entry1.set_text(bconf.bvalue.to_string());
            Gtk.ComboBoxText types1 = new Gtk.ComboBoxText ();
            types1.get_style_context().add_class ("conf_btn_types");
            types1.append_text (_("minutes"));
            types1.append_text (_("hours"));
            if (bconf.btype == "m") types1.set_active(0);
            else types1.set_active(1);
            hbox.pack_end(types1, false, false, 0);
            hbox.pack_end(entry1, false, false, 0);
            hbox.pack_end(text, true, true, 10);
            vbox.pack_start (hbox, true, true, 0);

            // Button 2
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            bconf = get_btn_conf(1);
            text = new Gtk.Label(_("Button 2"));
            text.get_style_context().add_class ("conf_btn_text");
            Gtk.Entry entry2 = new Gtk.Entry();
            entry2.get_style_context().add_class ("conf_btn_entry");
            entry2.set_text(bconf.bvalue.to_string());
            Gtk.ComboBoxText types2 = new Gtk.ComboBoxText ();
            types2.get_style_context().add_class ("conf_btn_types");
            types2.append_text (_("minutes"));
            types2.append_text (_("hours"));
            if (bconf.btype == "m") types2.set_active(0);
            else types2.set_active(1);
            hbox.pack_end(types2, false, false, 0);
            hbox.pack_end(entry2, false, false, 0);
            hbox.pack_end(text, true, true, 10);
            vbox.pack_start (hbox, true, true, 0);

            // Button 3
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            bconf = get_btn_conf(2);
            text = new Gtk.Label(_("Button 3"));
            text.get_style_context().add_class ("conf_btn_text");
            Gtk.Entry entry3 = new Gtk.Entry();
            entry3.get_style_context().add_class ("conf_btn_entry");
            entry3.set_text(bconf.bvalue.to_string());
            Gtk.ComboBoxText types3 = new Gtk.ComboBoxText ();
            types3.get_style_context().add_class ("conf_btn_types");
            types3.append_text (_("minutes"));
            types3.append_text (_("hours"));
            if (bconf.btype == "m") types3.set_active(0);
            else types3.set_active(1);
            hbox.pack_end(types3, false, false, 0);
            hbox.pack_end(entry3, false, false, 0);
            hbox.pack_end(text, true, true, 10);
            vbox.pack_start (hbox, true, true, 0);

            // Button 4
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            bconf = get_btn_conf(3);
            text = new Gtk.Label(_("Button 4"));
            text.get_style_context().add_class ("conf_btn_text");
            Gtk.Entry entry4 = new Gtk.Entry();
            entry4.get_style_context().add_class ("conf_btn_entry");
            entry4.set_text(bconf.bvalue.to_string());
            Gtk.ComboBoxText types4 = new Gtk.ComboBoxText ();
            types4.get_style_context().add_class ("conf_btn_types");
            types4.append_text (_("minutes"));
            types4.append_text (_("hours"));
            if (bconf.btype == "m") types4.set_active(0);
            else types4.set_active(1);
            hbox.pack_end(types4, false, false, 0);
            hbox.pack_end(entry4, false, false, 0);
            hbox.pack_end(text, true, true, 10);
            vbox.pack_start (hbox, true, true, 0);

            confpw.add(vbox);
            vbox.show_all();
            confpw.popup();
            confpw.closed.connect(() => {
                int sv;
                string st;

                sv = int.parse(entry1.get_text());
                st = types1.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                set_btn_conf(0, {sv,st});

                sv = int.parse(entry2.get_text());
                st = types2.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                set_btn_conf(1, {sv,st});

                sv = int.parse(entry3.get_text());
                st = types3.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                set_btn_conf(2, {sv,st});

                sv = int.parse(entry4.get_text());
                st = types4.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                set_btn_conf(3, {sv,st});

                update_interface();
            });
        }

        public Gtk.Button get_conf_button() {
            Gtk.Button btn = new Gtk.Button.from_icon_name ("document-properties", Gtk.IconSize.BUTTON);
            btn.clicked.connect(show_conf_panel);
            return btn;
        }

        public bool is_shutdown_programed() {
            // Returns True if there is any shutdown programed in the system
            return this.shutdown_programed;
        }

        public Gtk.Box get_shutdown_info() {
            // Returns a Gtk.Box with info about programed shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            box.get_style_context().add_class ("boxinfo");
            box.pack_start (new Gtk.Label (get_schedule_description()), false, false, 10);
            this.remaining_time_lbl = new Gtk.Label (get_schedule_remaining_time());
            this.remaining_time_lbl.get_style_context().add_class ("timelabel");
            box.pack_start (this.remaining_time_lbl, false, false, 10);
            box.pack_start (get_schedule_cancel_button(), false, false, 10);
            // Start time function to update counter each second
            GLib.Timeout.add_seconds (1, update_counter);
            return box;
        }

        public string get_schedule_description() {
            // Returns a string with the discription of the scheduled shutdown. Example:
            // "Shutdown scheduled for HH:MM:SS DD/MM/YYYY"
            DateTime obj = get_widgets_time();
            return _("Shutdown scheduled for ") + obj.format("%H:%M:%S %d/%m/%y");
        }

        public string get_schedule_remaining_time() {
            // Returns a string with the remaining time of the scheduled shutdown. Example:
            // "HH:MM:SS"
            DateTime obj = get_widgets_time();
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
            DateTime obj = get_widgets_time();
            DateTime now = new DateTime.now_local ();
            TimeSpan passed = now.difference(this.start_time);
            TimeSpan total = obj.difference(this.start_time);
            return (double)passed/(double)total;
        }

        public Gtk.Button get_schedule_cancel_button() {
            // Returns a Gtk.Button to cancel the scheduled shutdown.
            Gtk.Button bt;

            bt = new Gtk.Button.with_label (_("Cancel"));
            bt.clicked.connect (() => {
                string command = "shutdown -c";
                Posix.system(command);
                this.shutdown_programed = false;
                this.alerted = false;
                this.launcher.progress_visible = false;
                update_interface();
            });
            return bt;
        }

        public Gtk.Box get_shutdown_programer() {
            // Returns a Gtk.Box with controls to schedule a shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            box.get_style_context().add_class ("boxprogramer");
            box.pack_start (get_time_box(), true, true, 10);
            box.pack_start (get_time_buttons_box(), true, true, 10);
            box.pack_start (get_schedule_program_button(), true, true, 10);
            return box;
        }

        public Gtk.Box get_time_box() {
            // Returns a Gtk.Box with interface to enter time to program shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.date = new Granite.Widgets.DatePicker();
            this.time = new Granite.Widgets.TimePicker();
            this.date.get_style_context().add_class ("timewidget1");
            this.time.get_style_context().add_class ("timewidget2");
            box.pack_start (this.date, false, false, 10);
            box.pack_start (this.time, false, false, 10);
            return box;
        }

        public Gtk.Box get_time_buttons_box() {
            // Returns a Gtk.Box with buttons to summ/substract time to programed
            // shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            Gtk.Button bt;

            // Create conf file if necessary
            File file = File.new_for_path(this.conf_path);
            if (!file.query_exists()) file = create_conf_file();

            // Read buttons values from conf file
            DataInputStream reader;
            string info;
            string btext;
            int btime1,btime2,btime3,btime4;

            try {
                reader = new DataInputStream(file.read());
            } catch (Error e) {
                reader = null;
                stderr.printf(e.message);
            }

            try {
                info = reader.read_line(null);
                if (info.split(";")[1] == "m") {
                    btext = info.split(";")[0] + " " + _("min.");
                    btime1 = int.parse(info.split(";")[0]);
                }else {
                    btext = info.split(";")[0] + " " + _("h.");
                    btime1 = int.parse(info.split(";")[0]) * 60;
                }
            } catch (Error e) {
                btext = "5 min";
                btime1 = 5;
            }
            bt = new Gtk.Button.with_label (btext);
            bt.get_style_context().add_class ("timebutton");
            bt.clicked.connect (() => {add_time(btime1);});
            box.pack_start (bt, true, true, 10);

            try {
                info = reader.read_line(null);
                if (info.split(";")[1] == "m") {
                    btext = info.split(";")[0] + " " + _("min.");
                    btime2 = int.parse(info.split(";")[0]);
                }else {
                    btext = info.split(";")[0] + " " + _("h.");
                    btime2 = int.parse(info.split(";")[0]) * 60;
                }
            } catch (Error e) {
                btext = "15 min";
                btime2 = 15;
            }
            bt = new Gtk.Button.with_label (btext);
            bt.get_style_context().add_class ("timebutton");
            bt.clicked.connect (() => {add_time(btime2);});
            box.pack_start (bt, true, true, 10);

            try {
                info = reader.read_line(null);
                if (info.split(";")[1] == "m") {
                    btext = info.split(";")[0] + " " + _("min.");
                    btime3 = int.parse(info.split(";")[0]);
                }else {
                    btext = info.split(";")[0] + " " + _("h.");
                    btime3 = int.parse(info.split(";")[0]) * 60;
                }
            } catch (Error e) {
                btext = "30 min";
                btime3 = 30;
            }
            bt = new Gtk.Button.with_label (btext);
            bt.get_style_context().add_class ("timebutton");
            bt.clicked.connect (() => {add_time(btime3);});
            box.pack_start (bt, true, true, 10);

            try {
                info = reader.read_line(null);
                if (info.split(";")[1] == "m") {
                    btext = info.split(";")[0] + " " + _("min.");
                    btime4 = int.parse(info.split(";")[0]);
                }else {
                    btext = info.split(";")[0] + " " + _("h.");
                    btime4 = int.parse(info.split(";")[0]) * 60;
                }
            } catch (Error e) {
                btext = "60 h";
                btime4 = 60;
            }
            bt = new Gtk.Button.with_label (btext);
            bt.get_style_context().add_class ("timebutton");
            bt.clicked.connect (() => {add_time(btime4);});
            box.pack_start (bt, true, true, 10);

            return box;
        }

        public void add_time(int min) {
            // Adds 'min' minutes to thtime that will be scheduled
            DateTime obj = get_widgets_time();
            // Sum 'min' minutes
            obj = obj.add_minutes(min);
            // Store new time to widgets
            this.date.date = obj;
            this.time.time = obj;
        }

        public Gtk.Button get_schedule_program_button() {
            // Returns a Gtk.Button to program shutdown
            Gtk.Button bt = new Gtk.Button.with_label (_("Schedule"));
            bt.clicked.connect (() => {
                this.start_time = new DateTime.now_local ();
                this.shutdown_programed = true;
                this.launcher.progress_visible = true;
                update_interface();
            });
            return bt;
        }

        public DateTime get_widgets_time() {
          int year, month, day, hour, minute;
          this.date.date.get_ymd(out year, out month, out day);
          hour = this.time.time.get_hour();
          minute = this.time.time.get_minute();
          // Build new DateTime with the data
          return new DateTime.local (year, month, day, hour, minute, 0);
        }

        public void update_interface() {
            // Updates interface depending on programed shutdown
            Gtk.Box aux_box;
            if (is_shutdown_programed()) {
                aux_box = get_shutdown_info();
            }else {
                aux_box = get_shutdown_programer();
            }
            this.main_box.forall ((element) => this.main_box.remove (element));
            this.main_box.pack_start (aux_box, false, false, 10);
            this.main_box.show_all();
        }

        public bool update_counter() {
            string alert_str_time = get_str_time_rep_hh_mm_ss(this.alert_seconds);
            string rmaining_time_str = get_schedule_remaining_time();
            this.remaining_time_lbl.set_text(rmaining_time_str);
            if (rmaining_time_str.collate(alert_str_time) <= 0) {
                if (!alerted & closed) {
                    this.activate ();
                    this.app_window.present();
                    alerted = true;
                }
                this.remaining_time_lbl.get_style_context().add_class ("redtimelabel");
            }

            if (rmaining_time_str.contains("-") && this.is_shutdown_programed()) {
                // shutdown command only handels minutes when sheduling , not seconds.
                // So we may have passed the time. We check if we are in negative numbers and we shutdown the computer
                Posix.system("shutdown +0");
            }

            this.launcher.progress = get_percentage_progres();
            if (this.shutdown_programed) return true;
            else return false;
        }

    }
