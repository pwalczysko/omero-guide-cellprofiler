from omero.grid import DoubleColumn, ImageColumn, LongColumn, WellColumn
from omero.constants.namespaces import NSBULKANNOTATIONS
from omero.gateway import FileAnnotationWrapper
from omero.model import OriginalFileI



def upload_as_table(conn, plate_id, dataframe):

    cols = []

    for col in dataframe.columns:
        if col == 'Image':
            cols.append(ImageColumn(col, '', dataframe[col]))
        elif col == 'Well':
            cols.append(WellColumn(col, '', dataframe[col]))
        elif dataframe[col].dtype == 'int64':
            cols.append(LongColumn(col, '', dataframe[col]))
        elif dataframe[col].dtype == 'float64':
            cols.append(DoubleColumn(col, '', dataframe[col]))
        else:
            # fallback for CellProfiler string outputs
            cols.append(DoubleColumn(col, '', dataframe[col].astype(float)))

    # ---- OMERO TABLES ----
    resources = conn.c.sf.sharedResources()

    repo_id = resources.repositories().descriptions[0].getId().getValue()

    table_name = f"nuclei_plate_{plate_id}"

    table = resources.newTable(repo_id, table_name)

    table.initialize(cols)
    table.addData(cols)

    # ---- LINK TO PLATE ----
    orig_file = table.getOriginalFile()

    file_ann = FileAnnotationWrapper(conn)
    file_ann.setNs(NSBULKANNOTATIONS)

    file_ann._obj.file = OriginalFileI(orig_file.id.val, False)
    file_ann.save()

    plate = conn.getObject("Plate", plate_id)

    plate.linkAnnotation(file_ann)

    table.close()

    print("OMERO.tables upload successful")