# MNIST Classification - kmeans-KNN

This is the realization of a kmeans-KNN Calssification for MNIST dataset (Code + Description), which is a small project in the Digital Image Processing class during my 6th semester in Wuhan University in Autumn 2017. Here is the file structure:

```
kmeans-KNN
    |-- src
        |-- data
            |-- cluster_C.mat
            |-- cluster_C_dedimen.mat
            |-- cluster_idx.mat
            |-- cluster_idx_dedimen.mat
            |-- DIGITS.mat
            |-- DIGITS_dedimen.mat
        |-- digits
            |-- test0.mat
            |-- test1.mat
            |-- test2.mat
            |-- test3.mat
            |-- test4.mat
            |-- test5.mat
            |-- test6.mat
            |-- test7.mat
            |-- test8.mat
            |-- test9.mat
            |-- train0.mat
            |-- train1.mat
            |-- train2.mat
            |-- train3.mat
            |-- train4.mat
            |-- train5.mat
            |-- train6.mat
            |-- train7.mat
            |-- train8.mat
            |-- train9.mat
        |-- functions
            |-- mycluster_plus.m
            |-- mydist.m
            |-- mydist_corre.m
            |-- mydist_cosine.m
            |-- mydist_hamm.m
            |-- mydrawkmeans.m
            |-- myerrcal.m
            |-- mykmeans.m
            |-- mynumstatistic.m
        |-- digit_recog_train.m
        |-- digit_recog_validate.m
    |-- LICENSE
    |-- MNIST _ 基于k-means和KNN的0-9数字手写体识别.md
    |-- Readme.md
```
Among the files above:
- in folder 'src':
  - in folder 'data':
    - file 'cluster_C.m' is cluster centers of 60.000 pics(28*28=784 dimensions) of 10 digits in the training set;
    - file 'cluster_C_dedimen.m' is cluster centers of 60.000 pics(64 dimensions) of 10 digits in the training set;
    - file 'cluster_idx.m' is the cluster id (there are 10 cluster centers for each digit from 0 to 9, that is to say, there are 100 cluster centers in total) of each digit in the training set;
    - file 'cluster_idx_dedimen.m' si the cluster id of each digit in the training set where each digit is represented as a 64 vector, instead of s 64-vector;
    - file 'DIGITS.mat' is a 20*1 cell containing data of the training set, that is to say, from 20 files 'test0.mat' to 'train9.mat';
    - file 'DIGITS_dedimen.mat' is a 20*1 cell containing data of the training set where each digit is represented as a 64-vector, instead of s 64-vector;
  - in folder 'digits':
    - 20 .MAT files containing all data of the training set and testing set, same as what is introduced in file 'Readme' in project ['MNIST Classification - NaiveBayes']();
  - in folder 'functions':
    - functions to realize the kmeans algorithm, for detailed information, see project [KmeansCluster](https://github.com/chentianyangWHU/KmeansCluster);
  - file 'digit_recog_train.m' is a function to **train** a kmeans-KNN classification;
  - file 'digit_recog_validate.m' is function to **validate** the trained kmeans-KNN classification;
- file 'LICENSE' is the license file produced by github;
- file 'MNIST _ 基于k-means和KNN的0-9数字手写体识别.md' is a detailed introduction document for this project. 

For more detailed information, refer to article [MNIST _ 基于k-means和KNN的0-9数字手写体识别.md]().