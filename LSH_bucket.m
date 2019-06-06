%% 设置参数
type=2;h_table_size=40;h_table_number=1;w=0.0005;
ratio=0.6;
splitNumber_nubmer=40;

%设置随机梯度下降参数
k=6;steps=100;alpha=0.0045;beta=0.02;stop=1e-7;

load('dataset/prime1-20000.mat');
col_prime=size(prime,2);
number = randperm(col_prime,h_table_size);

% train_path = 'dataset/pings_4hr/train/5min/pings_4h5min_train';
% str_train_path = sprintf('%s%.1f.mat',train_path,ratio);
train_path = 'dataset/gant/train/GeantOD_train';
str_train_path = sprintf('%s%.1f.mat',train_path,ratio);
load(str_train_path);
% sampleMatrix = sampleMatrixNorm;
% testMatrix = testMatrixNorm;

% sampleMatrix=[1,1,1;2,2,2;3,3,3;1,2,3;2,4,6;3,6,9];
sampleMatrix_ori = sampleMatrix;

[m,n]=size(sampleMatrix_ori);
for i=1:1:m
    data_zero = find(sampleMatrix_ori(i,:)==0);
    sampleMatrix_ori(i,data_zero) = mean(sampleMatrix_ori(i,:));
    sampleMatrix_ori(i,:) = sampleMatrix_ori(i,:)./max(sampleMatrix_ori(i,:));
end

% testMatrix=sampleMatrix;
% originMatrix=sampleMatrix;
% sampleMatrix = sampleMatrix;

% testMatrix = testMatrix;
originMatrix = sampleMatrix + testMatrix;
sampleMatrix = sampleMatrix/max(max(originMatrix));
testMatrix = testMatrix/max(max(originMatrix));
originMatrix = sampleMatrix + testMatrix;
% [ sampleMatrix,testMatrix,sampleOmiga ] = sample_new( originMatrix,sampleLocation,ratio );
Compactness_lsh_table=zeros(h_table_size,1);
Separation_lsh_table=zeros(h_table_size,1);
Compactness_mod_lsh_table=zeros(h_table_size,1);
Separation_mod_lsh_table=zeros(h_table_size,1);
Compactness_kmeans_table=zeros(h_table_size,1);
Separation_kmeans_table=zeros(h_table_size,1);
time_table=zeros(h_table_size,1);
time_mod_table=zeros(h_table_size,1);
t_lsh_table=zeros(h_table_size,1);
t_kmeans_table=zeros(h_table_size,1);

v=rand(h_table_size,size(sampleMatrix,2));
b=rand(1)*w;
table_size=1;
splitNumber=10;
test_node = [];

t0 = clock;
[temp_mod]=LSH_type( sampleMatrix_ori, type, table_size, h_table_number,w,1,v,b,number );
time_mod_lsh = etime(clock,t0);
[ rebuildDataset_mod ] = rebuileMatrix( sampleMatrix, temp_mod);
[ rebuildOrigin_mod ] = rebuileMatrix( originMatrix, temp_mod);
%         [ rebuildSample_mod] = rebuileMatrix( sampleOmiga, temp_mod);

[ meaLocation_mod,splitNumber_mod,tempLocation_mod ] = noMergeLsh( temp_mod,0.005,splitNumber);

% for i=1:cluster_number
%     mean_cluster_1 = mean(sampleMatrix(cluster(i,1):cluster(i,2),:));
% end
mean_cluster_1 = mean(sampleMatrix(meaLocation_mod(1,1):meaLocation_mod(1,2),:));
mean_cluster_2 = mean(sampleMatrix(meaLocation_mod(2,1):meaLocation_mod(2,2),:));
mean_cluster_3 = mean(sampleMatrix(meaLocation_mod(3,1):meaLocation_mod(3,2),:));
mean_cluster_4 = mean(sampleMatrix(meaLocation_mod(4,1):meaLocation_mod(4,2),:));
mean_cluster_5 = mean(sampleMatrix(meaLocation_mod(5,1):meaLocation_mod(5,2),:));
% cos_1_2 = dot(mean_cluster_1,mean_cluster_2)/(norm(mean_cluster_1)*norm(mean_cluster_2));
% cos_1_3 = dot(mean_cluster_1,mean_cluster_3)/(norm(mean_cluster_1)*norm(mean_cluster_3));
% cos_1_4 = dot(mean_cluster_1,mean_cluster_4)/(norm(mean_cluster_1)*norm(mean_cluster_4));
% cos_1_5 = dot(mean_cluster_1,mean_cluster_5)/(norm(mean_cluster_1)*norm(mean_cluster_5));

cos_1_2 = norm(mean_cluster_1-mean_cluster_2,2);
cos_1_3 = norm(mean_cluster_1-mean_cluster_3,2);
cos_1_4 = norm(mean_cluster_1-mean_cluster_4,2);
cos_1_5 = norm(mean_cluster_1-mean_cluster_5,2);

% cosin=[cos_1_2 cos_1_3 cos_1_4 cos_1_5];
cosin=[cos_1_5 cos_1_4 cos_1_2];
bar_Demo(cosin);
% bar(cosin);

% [ Compactness_mod_lsh,Separation_mod_lsh ] = ClusterTest( rebuildDataset_mod,meaLocation_mod);
% Compactness_mod_lsh_table(table_size,1)=Compactness_mod_lsh;
% Separation_mod_lsh_table(table_size,1)=Separation_mod_lsh;
% time_mod_table(table_size,1)=time_mod_lsh;
% Compactness_kmeans_table(table_size,1)=Compactness_kmeans;
% Separation_kmeans_table(table_size,1)=Separation_kmeans;
% t_kmeans_table(table_size,1)=time_kmeans;

% train_path_t = 'Data\result\20190427\LSH_Cluster';
%     train_path_t = 'Data\result\20190426\LSH_Cluster_gant';
% base_name = sprintf('%s%.1f.mat',train_path_t,splitNumber);
%     base_name = 'Data\result\20190422\LSH_Cluster.mat';
% save(base_name,'Compactness_mod_lsh_table','Separation_mod_lsh_table','time_mod_table');

