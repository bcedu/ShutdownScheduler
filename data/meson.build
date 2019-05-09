icon_size = ['16', '24', '32', '48', '64', '128']

foreach i : icon_size
    install_data(
        join_paths('icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
    install_data(
        join_paths('icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i +'@2', 'apps')
    )
endforeach

install_data(
    join_paths('icons', meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)


#Translate and install our .desktop file
desktop_file = i18n.merge_file(
  input: join_paths(meson.project_name() + '.desktop.in'),
  output: join_paths(meson.project_name() + '.desktop'),
  type: 'desktop',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils,
    args: [desktop_file]
  )
endif

#Translate and install our .appdata file
appstream_file = i18n.merge_file(
  input: join_paths(meson.project_name() + '.appdata.xml.in'),
  output: join_paths(meson.project_name() + '.appdata.xml'),
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'metainfo')
)

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test('Validate appstream file', appstream_util,
    args: ['validate', appstream_file]
  )
endif

# Compile and install options stored in gschema
install_data('com.github.bcedu.shutdownscheduler.gschema.xml',
  install_dir: join_paths(get_option('datadir'), 'glib-2.0/schemas')
)

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file', compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()]
  )
endif

# Install files listed in gresources
gnome = import('gnome')
gresources = gnome.compile_resources(
	'shutdownscheduler-resources', 'resources/shutdownscheduler.gresource.xml', 
	c_name: 'shutdownscheduler'
)