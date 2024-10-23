QGIS_PROJECT_PATH=./demo_crop.qgz
PYTHON_SCRIPT_PATH=./crop.py

qgis --nologo --project $QGIS_PROJECT_PATH -f $PYTHON_SCRIPT_PATH

# Keep QGIS open, let people enjoy things
