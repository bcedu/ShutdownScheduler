srcs = files([
    'Configs/Constants.vala',
    'Configs/Settings.vala',
    'Widgets/HeaderBar.vala',
    'Widgets/AddTimeButton.vala',
    'Views/AppView.vala',
    'Views/View1.vala',
    'Views/View2.vala',
    'Views/ViewConf.vala',
    'Controllers/ViewController.vala',
    'Controllers/AppController.vala',
    'Application.vala',
    'Window.vala',
    'Main.vala'
])

# Dependences
deps = [
    dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('gtk+-3.0'),
    dependency('granite'),
    dependency('gee-0.8'),
    dependency('unity'),
    meson.get_compiler('vala').find_library('posix')
]


executable(
    meson.project_name(),
    srcs,
    asresources,
    dependencies: deps,
    install: true
)
