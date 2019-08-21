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

namespace App.Widgets {

    public class AddTimeButton : Gtk.Button {

        public int time;
        public string units;

        public AddTimeButton(int time, string units) {
            this.time = time;
            this.units = units;
            this.set_label("%d %s".printf(time, units));
        }

        public static Gee.ArrayList<AddTimeButton> load_buttons_from_file(string path) {
            var aux = new Gee.ArrayList<AddTimeButton>();
            int time = 0;
            string units = "m";
            try {
                File file = File.new_for_path(path);
                DataInputStream reader = new DataInputStream(file.read());
                string info = "";
                for (int i = 0; i< 4; i++) {
                    info = reader.read_line(null);
                    time = int.parse(info.split(";")[0]);
                    units = info.split(";")[1];
                    aux.add(new AddTimeButton(time, units));
                }
            } catch (Error e) {
                stderr.printf(e.message);
            }
            return aux;
        }

        public static void update_buttons_from_file(Gee.ArrayList<AddTimeButton> buttons, string path) {
            int time = 0;
            string units = "m";
            try {
                File file = File.new_for_path(path);
                DataInputStream reader = new DataInputStream(file.read());
                string info = "";
                for (int i = 0; i< 4; i++) {
                    info = reader.read_line(null);
                    time = int.parse(info.split(";")[0]);
                    units = info.split(";")[1];
                    buttons[i].update_button(time, units);
                }
            } catch (Error e) {
                stderr.printf(e.message);
            }
        }

        public int get_minutes() {
            if (this.units.get_char(0) == 's') return this.time/60;
            else if (this.units.get_char(0) == 'm') return this.time;
            else if (this.units.get_char(0) == 'h') return this.time*60;
            else return this.time;
        }

        public void update_button(int time, string units) {
            this.time = time;
            this.units = units;
            string printable_units = units;
            if (time < 10) {
                printable_units = "%s  ".printf(printable_units);
            }
            this.set_label("%d %s".printf(time, printable_units));
        }

    }

}
