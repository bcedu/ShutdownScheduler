using App.Controllers;
using Gtk;
using Gee;
using App.Widgets;

namespace App.Views {

    public struct ButtonConf {
        public int bvalue;
        public string btype;
    }

    public class ViewConf : AppView, VBox {
        private Gtk.Entry entry1;
        private Gtk.Entry entry2;
        private Gtk.Entry entry3;
        private Gtk.Entry entry4;
        private Gtk.ComboBoxText types1;
        private Gtk.ComboBoxText types2;
        private Gtk.ComboBoxText types3;
        private Gtk.ComboBoxText types4;
        private Gtk.Button conf_button;

        public ViewConf (AppController controler) {
            conf_button = new Gtk.Button.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);
            controler.window.headerbar.pack_end(conf_button);
            this.pack_start (get_time_buttons_confbox(controler), true, true, 10);
            this.show_all();
        }

        public string get_id() {
            return "view3";
        }

        public void connect_signals(AppController controler) {
            conf_button.clicked.connect(() => {
                controler.add_registered_view ("view3");
            });
        }

        public void update_view(AppController controler) {
            controler.window.headerbar.back_button.set_label (_("Save"));
        }

        public void update_view_on_hide(AppController controler) {
                ArrayList<AddTimeButton> add_time_buttons = new ArrayList<AddTimeButton>();

                int sv;
                string st;
                sv = int.parse(entry1.get_text());
                st = types1.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                add_time_buttons.add (
                    new AddTimeButton(sv, st)
                );

                sv = int.parse(entry2.get_text());
                st = types2.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                add_time_buttons.add (
                    new AddTimeButton(sv, st)
                );

                sv = int.parse(entry3.get_text());
                st = types3.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                add_time_buttons.add (
                    new AddTimeButton(sv, st)
                );

                sv = int.parse(entry4.get_text());
                st = types4.get_active_text();
                if (st == "minutes") st = "m";
                else st = "h";
                add_time_buttons.add (
                    new AddTimeButton(sv, st)
                );

                controler.set_conf_file (add_time_buttons);
        }


        public Gtk.Box get_time_buttons_confbox(AppController controler) {
            Gtk.Box vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 1);
            vbox.margin = 10;

            // Section text
            Gtk.Label lb = new Gtk.Label(_("Fast access buttons"));
            lb.get_style_context().add_class ("conf_btn_label");
            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            hbox.pack_start(lb, true, true, 0);
            // Reset buttons button
            Gtk.Button btn = new Gtk.Button.from_icon_name ("gtk-refresh", Gtk.IconSize.BUTTON);
            btn.get_style_context().add_class ("conf_btn_reset");
            btn.set_border_width(0);
            btn.clicked.connect(() => {
                entry1.set_text ("5");
                entry2.set_text ("15");
                entry3.set_text ("30");
                entry4.set_text ("1");
                types1.set_active (0);
                types2.set_active (0);
                types3.set_active (0);
                types4.set_active (1);

            });
            hbox.pack_end(btn, false, false, 0);
            vbox.pack_start(hbox, true, true, 5);

            // Button 1
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            ButtonConf bconf = get_btn_conf(0, controler);
            Gtk.Label text = new Gtk.Label(_("Button 1"));
            text.get_style_context().add_class ("conf_btn_text");
            entry1 = new Gtk.Entry();
            entry1.get_style_context().add_class ("conf_btn_entry");
            entry1.set_text(bconf.bvalue.to_string());
            types1 = new Gtk.ComboBoxText ();
            types1.get_style_context().add_class ("conf_btn_types");
            types1.append_text (_("minutes"));
            types1.append_text (_("hours"));
            if (bconf.btype == "m") types1.set_active(0);
            else types1.set_active(1);
            hbox.pack_end(types1, false, false, 0);
            hbox.pack_end(entry1, true, true, 0);
            hbox.pack_end(text, false, false, 10);
            vbox.pack_start (hbox, true, true, 0);

            // Button 2
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            bconf = get_btn_conf(1, controler);
            text = new Gtk.Label(_("Button 2"));
            text.get_style_context().add_class ("conf_btn_text");
            entry2 = new Gtk.Entry();
            entry2.get_style_context().add_class ("conf_btn_entry");
            entry2.set_text(bconf.bvalue.to_string());
            types2 = new Gtk.ComboBoxText ();
            types2.get_style_context().add_class ("conf_btn_types");
            types2.append_text (_("minutes"));
            types2.append_text (_("hours"));
            if (bconf.btype == "m") types2.set_active(0);
            else types2.set_active(1);
            hbox.pack_end(types2, false, false, 0);
            hbox.pack_end(entry2, true, true, 0);
            hbox.pack_end(text, false, false, 10);
            vbox.pack_start (hbox, true, true, 0);

            // Button 3
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            bconf = get_btn_conf(2, controler);
            text = new Gtk.Label(_("Button 3"));
            text.get_style_context().add_class ("conf_btn_text");
            entry3 = new Gtk.Entry();
            entry3.get_style_context().add_class ("conf_btn_entry");
            entry3.set_text(bconf.bvalue.to_string());
            types3 = new Gtk.ComboBoxText ();
            types3.get_style_context().add_class ("conf_btn_types");
            types3.append_text (_("minutes"));
            types3.append_text (_("hours"));
            if (bconf.btype == "m") types3.set_active(0);
            else types3.set_active(1);
            hbox.pack_end(types3, false, false, 0);
            hbox.pack_end(entry3, true, true, 0);
            hbox.pack_end(text, false, false, 10);
            vbox.pack_start (hbox, true, true, 0);

            // Button 4
            hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            bconf = get_btn_conf(3, controler);
            text = new Gtk.Label(_("Button 4"));
            text.get_style_context().add_class ("conf_btn_text");
            entry4 = new Gtk.Entry();
            entry4.get_style_context().add_class ("conf_btn_entry");
            entry4.set_text(bconf.bvalue.to_string());
            types4 = new Gtk.ComboBoxText ();
            types4.get_style_context().add_class ("conf_btn_types");
            types4.append_text (_("minutes"));
            types4.append_text (_("hours"));
            if (bconf.btype == "m") types4.set_active(0);
            else types4.set_active(1);
            hbox.pack_end(types4, false, false, 0);
            hbox.pack_end(entry4, true, true, 0);
            hbox.pack_end(text, false, false, 10);
            vbox.pack_start (hbox, true, true, 0);
            return vbox;
        }

        public ButtonConf get_btn_conf(int nbutton, AppController controler) {
            // Hi ha 4 butons per tant nbutton pot ser 0, 1, 2 o 3
            int time = 0;
            string type = "m";
            try {
                File file = File.new_for_path(controler.get_conf_file ());
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

    }

}
