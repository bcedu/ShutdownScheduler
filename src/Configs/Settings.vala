namespace App.Configs {

    public class AppSettings : Granite.Services.Settings {

        public int window_width { get; set; }
        public int window_height { get; set; }
        public int window_posx { get; set; }
        public int window_posy { get; set; }
        public int window_state { get; set; }

        private static AppSettings _settings;

        public static unowned AppSettings get_default () {
            if (_settings == null) _settings = new AppSettings ();
            return _settings;
        }

        private AppSettings () {
            base ("com.github.bcedu.shutdownscheduler.settings");
        }
    }

}
