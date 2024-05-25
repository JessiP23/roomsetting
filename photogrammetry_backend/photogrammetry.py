import os
import subprocess

def run_photogrammetry(image_dir, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    subprocess.run(['openMVG_main_SfMInit_ImageListing',
                    '-i', image_dir,
                    '-o', output_dir,
                    '-d', 'sensor_width_camera_database.txt'])

    subprocess.run(['openMVG_main_ComputeFeatures',
                    '-i', os.path.join(output_dir, 'sfm_data.json'),
                    '-o', output_dir])

    subprocess.run(['openMVG_main_ComputeMatches',
                    '-i', os.path.join(output_dir, 'sfm_data.json'),
                    '-o', output_dir])

    subprocess.run(['openMVG_main_IncrementalSfM',
                    '-i', os.path.join(output_dir, 'sfm_data.json'),
                    '-m', output_dir,
                    '-o', output_dir])

    subprocess.run(['openMVG_main_ComputeStructureFromKnownPoses',
                    '-i', os.path.join(output_dir, 'sfm_data.bin'),
                    '-m', output_dir,
                    '-o', output_dir])

    subprocess.run(['openMVG_main_openMVG2openMVS',
                    '-i', os.path.join(output_dir, 'sfm_data.bin'),
                    '-o', os.path.join(output_dir, 'scene.mvs')])

    subprocess.run(['DensifyPointCloud', os.path.join(output_dir, 'scene.mvs')])
    subprocess.run(['ReconstructMesh', os.path.join(output_dir, 'scene_dense.mvs')])
    subprocess.run(['TextureMesh', os.path.join(output_dir, 'scene_dense_mesh.mvs')])

if __name__ == "__main__":
    run_photogrammetry('uploads', 'output')
