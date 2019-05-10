using App.Controllers;
using Gtk;
using Gee;
using App.Widgets;

namespace App.Views {

    public class InitialView : AppView, VBox {

        private Granite.Widgets.DatePicker date;
        private Granite.Widgets.TimePicker time;
        private ArrayList<AddTimeButton> add_time_buttons;
        private Button continue_button;

        public InitialView (AppController controler) {
            this.pack_start (get_time_box(), false, false, 10);
            this.pack_start (get_addtime_buttons_box(controler), true, true, 10);
            this.pack_start (get_continue_button(), false, false, 10);
            this.show_all();
        }

        private Gtk.Box get_time_box() {
            // Returns a Gtk.Box with interface to enter time to program shutdown
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            box.get_style_context().add_class ("boxprogramer");
            this.date = new Granite.Widgets.DatePicker();
            this.time = new Granite.Widgets.TimePicker();
            this.date.get_style_context().add_class ("timewidget1");
            this.time.get_style_context().add_class ("timewidget2");
            box.pack_start (this.date, true, true, 10);
            box.pack_start (this.time, true, true, 10);
            return box;
        }

        private Gtk.Box get_addtime_buttons_box(AppController controler) {
            this.add_time_buttons = AddTimeButton.load_buttons_from_file(controler.get_conf_file());
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            foreach (AddTimeButton i in this.add_time_buttons) {
                box.pack_start (i, true, true, 10);
                i.get_style_context().add_class ("timebutton");
            }
            return box;
        }

        private Gtk.Box get_continue_button() {
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.continue_button = new Button.with_label(_("Continue"));
            box.pack_start (this.continue_button, true, true, 10);
            return box;
        }

        public string get_id() {
            return "init";
        }

        public void connect_signals (AppController controler) {
            foreach (AddTimeButton i in this.add_time_buttons) {
                i.clicked.connect(() => {
                    this.add_time(i.get_minutes());
                });
            }
            this.continue_button.clicked.connect(() => {
                controler.view_controller.add_registered_view ("view2");
                controler.start_shutdown_programed(this.get_widgets_time ());
                controler.update_window_view ();
            });
        }

        public void add_time(int min) {
            // Adds 'min' minutes to thtime that will be scheduled
            DateTime obj = this.get_widgets_time();
            // Sum 'min' minutes
            obj = obj.add_minutes(min);
            // Store new time to widgets
            this.date.date = obj;
            this.time.time = obj;
        }

        public DateTime get_widgets_time() {
            int year, month, day, hour, minute;
            this.date.date.get_ymd(out year, out month, out day);
            hour = this.time.time.get_hour();
            minute = this.time.time.get_minute();
            // Build new DateTime with the data
            return new DateTime.local (year, month, day, hour, minute, 0);
        }

        public void update_view(AppController controler) {
            controler.shutdown_programed = false;
            controler.launcher.progress_visible = false;
            AddTimeButton.update_buttons_from_file(add_time_buttons, controler.get_conf_file());
        }

        public void update_view_on_hide(AppController controler) {
            this.update_view(controler);
        }

    }

}
