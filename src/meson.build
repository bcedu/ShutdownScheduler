
srcs = files([
    'configs/constants.vala',
    'configs/settings.vala',
    'widgets/header_bar.vala',
    'widgets/add_time_button.vala',
    'views/app_view.vala',
    'views/view1.vala',
    'views/view2.vala',
    'views/view_conf.vala',
    'controllers/view_controller.vala',
    'controllers/app_controller.vala',
    'application.vala',
    'window.vala',
    'main.vala'
])

srcs += gresources

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
    dependencies: deps,
    install: true
)
