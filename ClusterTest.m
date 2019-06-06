function [ Compactness,Separation ] = ClusterTest( sampleMatrix,cluster)
%ClusterTest ¾ÛÀàĞ§¹û²âÊÔ
%   sampleMatrix ²âÊÔ¾ØÕó
%   cluster ¾ÛÀà
cluster_number = size(cluster,1);
Compactness = 0;
Separation = 0;
for i=1:cluster_number
    mean_cluster_1 = mean(sampleMatrix(cluster(i,1):cluster(i,2),:));
    mean_cluster_2 = repmat(mean_cluster_1,cluster(i,2)-cluster(i,1)+1,1);
    Compactness = Compactness + (sum(norm(sampleMatrix(cluster(i,1):cluster(i,2),:)-mean_cluster_2,1))/(cluster(i,2)-cluster(i,1)+1));
    if i~=cluster_number
        next_mean_cluster = mean(sampleMatrix(cluster(i+1,1):cluster(i+1,2),:));
%         mean_cluster_3 = repmat(mean_cluster_1,cluster(i+1,2)-cluster(i+1,1)+1,1);
        Separation = Separation+norm(next_mean_cluster-mean_cluster_1);
    end
end
Compactness = Compactness / cluster_number;
Separation = (2*Separation)/(cluster_number*cluster_number-cluster_number);
end

