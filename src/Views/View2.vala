using App.Controllers;
using Gtk;
namespace App.Views {

    public class View2 : AppView, VBox {

        private Gtk.Label remaining_time_lbl;
        private Button cancel_button;

        public View2 (AppController controler) {
            this.remaining_time_lbl = new Label(_("No shutdown programed"));
            this.remaining_time_lbl.get_style_context().add_class ("timelabel");
            this.cancel_button = new Button.with_label(_("Cancel"));
            this.pack_start (this.remaining_time_lbl, true, true, 0);
            this.pack_start (get_cancel_button (), false, false, 10);
            this.get_style_context().add_class ("app_view");
            this.show_all();
        }

        public string get_id() {
            return "view2";
        }

        public void connect_signals(AppController controler) {
            this.cancel_button.clicked.connect(() => {
                controler.stop_shutdown_programed();
                controler.view_controller.get_previous_view ();
                controler.update_window_view ();
            });
        }

        public void update_view(AppController controler) {
            controler.window.headerbar.back_button.set_label (_("Cancel"));
            controler.shutdown_programed = true;
            controler.launcher.progress_visible = true;
            this.remaining_time_lbl.set_text(controler.get_schedule_remaining_time ());
            if (controler.alerted) this.remaining_time_lbl.get_style_context().add_class ("redtimelabel");
        }

        public void update_view_on_hide(AppController controler) {
            this.update_view(controler);
        }

        private Gtk.Box get_cancel_button() {
            Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.cancel_button = new Button.with_label(_("Cancel"));
            box.pack_start (this.cancel_button, true, true, 10);
            return box;
        }

    }

}
