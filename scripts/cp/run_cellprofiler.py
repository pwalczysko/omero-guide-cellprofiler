import subprocess
from pathlib import Path


def run_cellprofiler(input_dir, output_dir, pipeline_path):

    input_dir = str(Path(input_dir).resolve())
    output_dir = str(Path(output_dir).resolve())
    pipeline_path = Path(pipeline_path).resolve()

    if not pipeline_path.exists():
        raise FileNotFoundError(f"Pipeline not found: {pipeline_path}")

    if pipeline_path.is_dir():
        raise ValueError(
            f"Pipeline path is a directory, not a file: {pipeline_path}"
        )

    cp_dir = str(pipeline_path.parent)
    pipeline_file = pipeline_path.name

    Path(output_dir).mkdir(parents=True, exist_ok=True)

    cmd = [
        "docker", "run", "--rm",
        "-v", f"{input_dir}:/input",
        "-v", f"{output_dir}:/output",
        "-v", f"{cp_dir}:/cp",
        "cellprofiler-headless",
        "-c",
        "-r",
        "-p", f"/cp/{pipeline_file}",
        "-i", "/input",
        "-o", "/output",
    ]

    print("Running CellProfiler:")
    print(" ".join(cmd))

    subprocess.run(cmd, check=True)