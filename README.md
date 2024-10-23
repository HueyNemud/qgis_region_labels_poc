# PoC PyQGIS script to crop and export regions with labels OOBs

A demo PyQGIS script to extracts the georeferenced image of a region from the main QGIS map canvas, calculates oriented bounding boxes of all the labels displayed in the region and save them as polygons in Geopackage format.

**Tested on QGIS 3.38.3-Grenoble 'Grenoble' (37f9e6efeec)** 


## Try it yourself

1. Clone this repo
```bash
git clone git@github.com:HueyNemud/qgis_region_labels_poc.git
cd qgis_region_labels_poc
```
2. Download the demo data
```bash
wget https://github.com/HueyNemud/qgis_region_labels_poc/releases/download/0.1/demo_crop.gpkg
```

3. Run the demo script

> [!NOTE]
> Outputs will be stored in /tmp

```bash
./demo_crop.sh
```

## ⚠️ Important notes

### 1. OOB per word
In the `Parallel` and `Horizontal` placement modes, only one bounding box will be created per label, even if it is made up of several words.
For example :
```raw
+----------------------+
| PASSAGE␣DES␣CHARDONS |
+----------------------+
```

Only the `Curved` mode allows to create a bounding box for each word.
The previous example becomes :
```raw
+------- -+ +-----+ +----------+
| PASSAGE | | DES | | CHARDONS |
+---------+ +-----+ +----------+
```

### 2. Upside Down labels

Due - probably - to a bug in the construction of QgsLabelPosition objects, the bounding boxes calculated for Upside Down labels are incorrect.

There are two possible solutions to this problem:
- either force the display of upside down labels to `Always` in the `Rendering` label settings.
  However, this will potentially cause some labels to be displayed upside down.
- or, in the case of a linear layer, reorder the points of the LineString so that they are
  oriented in the reading direction.
  This can be done in pre-processing with the SQL query :
  ```sql
    SELECT ...,
    CASE WHEN ST_X(ST_StartPoint(geometry)) > ST_X(ST_EndPoint(geometry)) THEN ST_Reverse(geometry)
    ELSE geometry
    END AS geometry
    FROM some_linear_layer;
  ```
