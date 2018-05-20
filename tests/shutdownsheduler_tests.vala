class TestShutdownScheduler : Gee.TestCase {

    ShutdownScheduler app;

    public TestShutdownScheduler() {
        // assign a name for this class
        base("TestShutdownScheduler");
        // add test methods
        add_test(" * Test create app works", test_init_ok);
        add_test(" * Test activate app works", test_activate_ok);
    }

    public override void set_up () {
        // setup your test
        app = new ShutdownScheduler("");
    }

    public void test_init_ok() {
        // test init atributes
        assert(app.closed == false);
        assert(app.shutdown_programed == false);
        assert(app.alerted == false);
        assert(app.alert_seconds == 10);
        // Test conf dir created
        assert(app.appdata_dir == ".shutdownscheduler");
        File file = File.new_for_path (".shutdownscheduler");
        assert(file.query_exists() == true);
        // Test conf file created
        assert(app.conf_path == ".shutdownscheduler/shutdownscheduler_conf");
        file = File.new_for_path (".shutdownscheduler/shutdownscheduler_conf");
        DataInputStream reader = new DataInputStream(file.read());
        assert(reader.read_line() == "5;m");
        assert(reader.read_line() == "15;m");
        assert(reader.read_line() == "30;m");
        assert(reader.read_line() == "1;h");
    }

    public void test_activate_ok() {
        // Assert we are in initial state
        assert(app.app_window == null);
        assert(app.main_box == null);
        assert(app.launcher == null);
        // activate app
        // app.activate();
    }

    public override void tear_down () {
        // Delete created conf files
        File file = File.new_for_path (".shutdownscheduler");
        if (file.query_exists()) Posix.system("rm -r .shutdownscheduler");
    }
}
