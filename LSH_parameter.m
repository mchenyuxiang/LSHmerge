%% 设置参数
type=2;h_table_size=40;h_table_number=1;w=0.0005;
ratio=0.6;
splitNumber_nubmer=40;

%设置随机梯度下降参数
k=6;steps=100;alpha=0.0045;beta=0.02;stop=1e-7;

load('dataset/prime1-20000.mat');
col_prime=size(prime,2);
number = randperm(col_prime,h_table_size);

train_path = 'dataset/pings_4hr/train/5min/pings_4h5min_train';
str_train_path = sprintf('%s%.1f.mat',train_path,ratio);
% train_path = 'dataset/gant/train/GeantOD_train';
% str_train_path = sprintf('%s%.1f.mat',train_path,ratio);
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
Compactness_kmeans_plus_table=zeros(h_table_size,1);
Separation_kmeans_plus_table=zeros(h_table_size,1);
time_table=zeros(h_table_size,1);
time_mod_table=zeros(h_table_size,1);
t_lsh_table=zeros(h_table_size,1);
t_kmeans_table=zeros(h_table_size,1);
t_kmeans_plus_table=zeros(h_table_size,1);

v=rand(h_table_size,size(sampleMatrix,2));
b=rand(1)*w;

test_node = [];
for splitNumber=1:splitNumber_nubmer
    for table_size=1:h_table_size
%         Compactness_lsh=[];
%         Separation_lsh=[];

%         Compactness_mod_lsh=[];
%         Separation_mod_lsh=[];
%     %     table_size_t=1;
%         %% LSH 哈希分桶
%         t0 = clock;
% %         [temp]=LSH_type( sampleMatrix, type, h_table_size, h_table_number,w,1,v,b,number );
%         [temp,t_lsh,t_kmeans]= LSH_multi( sampleMatrix,splitNumber, table_size, h_table_number,w,v,b );
%         time_lsh = etime(clock,t0);
%         test_node(:,table_size)=temp(:,2);
%         %% 重组矩阵
%         [ rebuildDataset ] = rebuileMatrix( sampleMatrix, temp);
%         [ rebuildOrigin ] = rebuileMatrix( originMatrix, temp);
%         [ rebuildSample] = rebuileMatrix( sampleOmiga, temp);
%         temp(temp==0)=1;
% 
%          [ meaLocation,splitNumber,tempLocation ] = noMergeLsh( temp,0.005);
%         [ Compactness_lsh,Separation_lsh ] = ClusterTest( rebuildDataset,tempLocation);
%         Compactness_lsh_table(table_size,1)=Compactness_lsh;
%         Separation_lsh_table(table_size,1)=Separation_lsh;
%         time_table(table_size,1)=time_lsh;
        %% according to the number of lsh bucket rebuild the matrix
        % [ meaLocation ] = meanComputerMatrix( temp,splitNumber );
        t1 = clock;
        [Idx,C]=kmeans(sampleMatrix,splitNumber); 
        kmeans_temp = zeros(size(Idx,1),3);
        for i=1:size(Idx,1)
            kmeans_temp(i,1) = i;
        end
        kmeans_temp(:,2)=Idx;
        kmeans_temp=sortrows(kmeans_temp,2);
        time_kmeans = etime(clock,t1);
        [ rebuildDataset ] = rebuileMatrix( sampleMatrix, kmeans_temp);
        [ meaLocationKmeans,splitNumberKmeans,tempLocationKmeans ] = noMergeLsh(kmeans_temp,0.005,splitNumber);
        [ Compactness_kmeans,Separation_kmeans ] = ClusterTest( rebuildDataset,tempLocationKmeans);
        
        
        %% k-means++
        t1 = clock;
        [Idx,C]=kmeans(sampleMatrix_ori,splitNumber,'start','plus'); 
        kmeans_plus = zeros(size(Idx,1),3);
        for i=1:size(Idx,1)
            kmeans_plus(i,1) = i;
        end
        kmeans_plus(:,2)=Idx;
        kmeans_plus=sortrows(kmeans_plus,2);
        time_kmeans_plus = etime(clock,t1);
        [ rebuildDataset ] = rebuileMatrix( sampleMatrix, kmeans_plus);
        [ meaLocationKmeans,splitNumberKmeans,tempLocationKmeans ] = noMergeLsh(kmeans_plus,0.005,splitNumber);
        [ Compactness_kmeans_plus,Separation_kmeans_plus ] = ClusterTest( rebuildDataset,tempLocationKmeans);
        
       %% LSH
        t0 = clock;
        [temp_mod]=LSH_type( sampleMatrix_ori, type, table_size, h_table_number,w,1,v,b,number );
        time_mod_lsh = etime(clock,t0);
        [ rebuildDataset_mod ] = rebuileMatrix( sampleMatrix, temp_mod);
        [ rebuildOrigin_mod ] = rebuileMatrix( originMatrix, temp_mod);
%         [ rebuildSample_mod] = rebuileMatrix( sampleOmiga, temp_mod);

        [ meaLocation_mod,splitNumber_mod,tempLocation_mod ] = noMergeLsh( temp_mod,0.005,splitNumber);
        [ Compactness_mod_lsh,Separation_mod_lsh ] = ClusterTest( rebuildDataset_mod,meaLocation_mod);
        Compactness_mod_lsh_table(table_size,1)=Compactness_mod_lsh;
        Separation_mod_lsh_table(table_size,1)=Separation_mod_lsh;
        time_mod_table(table_size,1)=time_mod_lsh;
        Compactness_kmeans_table(table_size,1)=Compactness_kmeans;
        Separation_kmeans_table(table_size,1)=Separation_kmeans;
        t_kmeans_table(table_size,1)=time_kmeans;
        Compactness_kmeans_plus_table(table_size,1)=Compactness_kmeans_plus;
        Separation_kmeans_plus_table(table_size,1)=Separation_kmeans_plus;
        t_kmeans_plus_table(table_size,1)=time_kmeans;
    end
    train_path_t = 'Data\result\20190427\LSH_Cluster';
%     train_path_t = 'Data\result\20190426\LSH_Cluster_gant';
    base_name = sprintf('%s%.1f.mat',train_path_t,splitNumber);
%     base_name = 'Data\result\20190422\LSH_Cluster.mat';
    save(base_name,'Compactness_kmeans_plus_table','Separation_kmeans_plus_table','t_kmeans_plus_table','Compactness_mod_lsh_table','Separation_mod_lsh_table','time_mod_table','Compactness_kmeans_table','Separation_kmeans_table','t_kmeans_table');
end

