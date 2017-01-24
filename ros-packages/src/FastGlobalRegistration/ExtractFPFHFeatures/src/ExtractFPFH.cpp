#include <pcl/point_types.h>
#include <pcl/features/normal_3d.h>
#include <pcl/features/fpfh_omp.h>
#include <pcl/io/ply_io.h>
#include <pcl/io/pcd_io.h>
#include <string>

int main(int argc, char *argv[])
{
	if(argc < 2){
		printf("give inpute point clouds !");
		exit(-1);
	}

	std::string pcdfile = argv[1];

	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);

	pcl::io::loadPLYFile((pcdfile + ".ply").c_str(),*cloud);
	// pcl::io::loadPCDFile<pcl::PointXYZ> ((pcdfile + ".pcd").c_str(), *cloud);
  	// Create the normal estimation class, and pass the input dataset to it
	pcl::NormalEstimation<pcl::PointXYZ, pcl::Normal> ne;
	ne.setInputCloud (cloud);

	pcl::search::KdTree<pcl::PointXYZ>::Ptr tree (new pcl::search::KdTree<pcl::PointXYZ> ());
	ne.setSearchMethod (tree);

	// Output datasets
	pcl::PointCloud<pcl::Normal>::Ptr cloud_normals (new pcl::PointCloud<pcl::Normal>);

	// Use all neighbors in a sphere of radius 3cm
	ne.setRadiusSearch (0.01);

	// Compute the features
	ne.compute (*cloud_normals);

	pcl::FPFHEstimationOMP<pcl::PointXYZ, pcl::Normal, pcl::FPFHSignature33> fest;
	pcl::PointCloud<pcl::FPFHSignature33>::Ptr object_features(new pcl::PointCloud<pcl::FPFHSignature33>());
	fest.setRadiusSearch(0.01);  
	fest.setInputCloud(cloud);
	fest.setInputNormals(cloud_normals);
	fest.compute(*object_features);

	FILE* fid = fopen((pcdfile + ".bin").c_str(), "wb");
	int nV = cloud->size(), nDim = 33;
	fwrite(&nV, sizeof(int), 1, fid);
	fwrite(&nDim, sizeof(int), 1, fid);
	for (int v = 0; v < nV; v++) {
	    const pcl::PointXYZ &pt = cloud->points[v];
	    // printf("%f %f %f \n", pt.x,pt.y,pt.z);
	    float xyz[3] = {pt.x, pt.y, pt.z};
	    fwrite(xyz, sizeof(float), 3, fid);
	    const pcl::FPFHSignature33 &feature = object_features->points[v];
	    fwrite(feature.histogram, sizeof(float), 33, fid);
	}
	fclose(fid);
}