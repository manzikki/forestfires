import os
import zipfile
import glob
import shutil

# Define the directory containing the .nc (zip) files
input_dir = "./"  # Change to your directory path

# Process each .nc file
for nc_path in glob.glob(os.path.join(input_dir, "*.nc")):
    filename = os.path.basename(nc_path)
    date_prefix, _ = os.path.splitext(filename)  # '2018-08-31'

    # Create a temporary extraction directory
    extract_dir = os.path.join(input_dir, "tmp_extract")
    os.makedirs(extract_dir, exist_ok=True)

    try:
        # Treat the .nc file as a zip archive
        with zipfile.ZipFile(nc_path, 'r') as zip_ref:
            zip_ref.extractall(extract_dir)

        # Look for the specific file to rename
        for root, dirs, files in os.walk(extract_dir):
            for file in files:
                if file.endswith("stepType-instant.nc"):
                    src_path = os.path.join(root, file)
                    dst_name = f"{date_prefix}-instant.nc"
                    dst_path = os.path.join(input_dir, dst_name)
                    shutil.move(src_path, dst_path)
                    print(f"Extracted and renamed: {dst_name}")
                    break
            else:
                continue
            break  # Exit outer loop if file was found
    except zipfile.BadZipFile:
        print(f"Warning: {filename} is not a valid zip file.")
    finally:
        # Clean up temporary extraction directory
        shutil.rmtree(extract_dir, ignore_errors=True)