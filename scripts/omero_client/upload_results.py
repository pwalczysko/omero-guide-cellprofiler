from omero.grid import DoubleColumn, ImageColumn, LongColumn, WellColumn
from omero.constants.namespaces import NSBULKANNOTATIONS
from omero.gateway import FileAnnotationWrapper
from omero.model import OriginalFileI
from pandas.api.types import (
    is_integer_dtype,
    is_float_dtype,
    is_bool_dtype,
)


def upload_as_table(conn, plate_id, dataframe):

    cols = []


    for col in dataframe.columns:

        if col == "ImageID":
            cols.append(ImageColumn("Image", "", dataframe[col].astype("int64")))

        elif col == "Well":
            cols.append(WellColumn("Well", "", dataframe[col].astype("int64")))

        elif is_integer_dtype(dataframe[col]):
            cols.append(LongColumn(col, "", dataframe[col].astype("int64")))

        elif is_float_dtype(dataframe[col]):
            cols.append(DoubleColumn(col, "", dataframe[col].astype(float)))

        elif is_bool_dtype(dataframe[col]):
            cols.append(LongColumn(col, "", dataframe[col].astype("int64")))

        else:
            print(f"Skipping string column: {col}")

    # ---- OMERO TABLES ----
    resources = conn.c.sf.sharedResources()

    repo_id = resources.repositories().descriptions[0].getId().getValue()

    table_name = f"cp_image_plate_{plate_id}"

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