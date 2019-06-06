function [temp]=LSH_type( dataset, type, h_table_size, h_table_number,w,flag,v,b,number )
%LSH p稳定局部敏感哈希函数
%   dataset, 查询数据集
%   testset, 测试数据
%   type, 分布，1为柯西，2为高斯
%   h_table_size,   哈希表的大小
%   h_table_number, 哈希表的个数
%   vector_D, 向量维度
%   W,  桶宽


[m,n]=size(dataset);
temp=zeros(m,2);
% load('dataset/prime1-20000.mat');
% col_prime=size(prime,2);

% v=rand(1,n);
% b=rand(1)*w;
% lsh_table=[];
% number = randperm(col_prime,h_table_size);
if flag==1
    for hash=1:h_table_size
        for i=1:1:m
%             data_zero = find(dataset(i,:)==0);
%             dataset(i,data_zero) = mean(dataset(i,:));
            h=floor((sum(dataset(i,:).*v(1,:))+b)/w);
            temp(i,1)=i;
            temp(i,2)=temp(i,2)+number(1,hash)*h;
        end
    end
end
if flag==2
    for hash=1:h_table_size
        for i=1:1:m
%             data_zero = find(dataset(i,:)==0);
%             dataset(i,data_zero) = mean(dataset(i,:));
            h=floor(sum((dataset(i,:).*v(1,:))+b)/w);
            temp(i,1)=i;
            temp(i,2)=h;
        end
    end
end
if flag==3
    for i=1:1:m
%         data_zero = find(dataset(i,:)==0);
%         dataset(i,data_zero) = mean(dataset(i,:));
        dataset(i,:) = dataset(i,:)./max(dataset(i,:));
        h=floor(sum((dataset(i,:).*v(1,:))+b)/w);
        temp(i,1)=i;
        temp(i,2)=h;
     end
end

temp=sortrows(temp,2);
% fid = fopen(FileURL,'w+');
% 
% for j=1:1:m
%     tt=temp(j,1);
%     if temp(j,2)~=0
%         for i=j+1:1:m
%             if temp(j,2)==temp(i,2) && temp(i,2)~=0
%                 tt=[tt,temp(i,1)];
%                 temp(i,2)=0;
%             end
%         end
%         [a b]=size(tt);    
%         %将每个桶中元素写入到文件中
%         for i=1:1:a
% %     fprintf(fid,'%d ',i);
%             for j=1:1:b
%                 if j ~=b
%                     fprintf(fid,'%d ',tt(i,j));
%                 else
%                     fprintf(fid,'%d\n',tt(i,j));
%                 end
%             end
%         end       
%     end
% end
% fclose(fid);
end

