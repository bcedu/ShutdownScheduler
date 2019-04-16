# Project name and programming language
project('com.github.bcedu.shutdownscheduler','vala', 'c', version: '1.3.0')

gnome = import('gnome')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()),
    language:'c'
)

# Compile the GResources for this project
asresources = gnome.compile_resources (
    'as-resources', join_paths('data', meson.project_name() + '.gresource.xml'),
    source_dir: 'data',
    c_name: 'as'
)

subdir('src')

executable(
    meson.project_name(),
    sources,
    asresources,
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('unity'),
        meson.get_compiler('vala').find_library('posix')
    ],
    install: true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py') 