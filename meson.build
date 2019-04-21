project('com.github.bcedu.shutdownscheduler', ['c', 'vala'],        version: '0.1.0',
  meson_version: '>= 0.40.0',
)

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')
i18n = import('i18n')

subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
