# MNIST Classification - NaiveBayes

This is the realization of a Naive Bayes Calssification for MNIST dataset (Code + Description), which is a small project in the Digital Image Processing class during my 6th semester in Wuhan University in Autumn 2017. Here is the file structure:

```
NaiveBayes
    |-- src
        |-- data
            |-- matdata
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
            |-- rawdatra
                |-- FILE FORMATS FOR THE MNIST DATABASE.txt
                |-- t10k-images-idx3-ubyte
                |-- t10k-labels-idx1-ubyte
                |-- train-images-idx3-ubyte
                |-- train-labels-idx1-ubyte
            |-- dataresolve.m
        |-- models
            |-- XXX.mat
        |-- othertestpic
            |-- XXX.jpg
        |-- test-images
            |-- testX_XX.png (10,000 figs in total)
        |-- test-images-smaller
            |-- testX_XX.png
        |-- train-images
            |-- trainX_XX.png (60,000 figs in total)
        |-- train-images-smaller
            |-- trainX_XX.png
        |-- CBayesTesting.m
        |-- CBayesTraining.m
        |-- CBayesValidation.m
        |-- DBayesTesting.m
        |-- DBayesTraining.m
        |-- DBayesValidation.m
        |-- im_pre_here.m
        |-- mat2pic.m
        |-- mynormpdf.m
        |-- myNumStatistic.m
    |-- LICENSE
    |-- MNIST _ 基于朴素贝叶斯分类器的0-9数字手写体识别.md
    |-- Readme.md
    |-- 用Bayes分类器做0-9数字手写体识别-实验记录单.docx
```
Among the files above:
- in folder 'src':
  - in folder 'data':
    - folder 'rawdatra' contains 4 rawdata files of [MNIST](http://yann.lecun.com/exdb/mnist/) and a .TXT description document;
    - folder 'matdata' contains 20 .MAT files converted from that 4 rawdata files;
    - file 'dataresolve.m' converts data from the 4 rawdata files to 20 .MAT files;
  - in folder 'models':
    - several trained model for classification by file 'CBayesTraining.m' or 'DBayesTraining.m';
  - in folder 'othertestpic':
    - several pictures not contained in MNIST for further test of the performance of trained Naive Bayes classifications;
  - in folder 'test-images':
    - 10,000 pictures of digits from 0 to 9 converted from 10 .MAT files in folder 'matdata', through file 'mat2pic.m';
  - in folder 'test-images-smaller':
    - smaller pictures of digits from 0 to 9, equivalent to a sub-set of folder 'test-images';
  - in folder 'train-images':
    - 60,000 pictures of digits from 0 to 9 converted from 10 .MAT files in folder 'matdata', through file 'mat2pic.m';
  - in folder 'train-images-smaller':
    - smaller pictures of digits from 0 to 9, equivalent to a sub-set of folder 'train-images';
  - file 'CBayesTraining.m' is a function to **train** a Naive Bayes classification, when converting pictures to matrix as **continuous** data;
  - file 'CBayesValidation.m' is function to **validate** the trained Naive Bayes classification, when converting pictures to matrix as **continuous** data;
  - file 'CBayesTesting.m' is is function to **test** the trained Naive Bayes classification, when converting pictures to matrix as **continuous** data;
  - file 'DBayesTraining.m' is a function to **train** a Naive Bayes classification, when converting pictures to matrix as **discrete** data;
  - file 'DBayesValidation.m' is function to **validate** the trained Naive Bayes classification, when converting pictures to matrix as **discrete** data;
  - file 'DBayesTesting.m' is is function to **test** the trained Naive Bayes classification, when converting pictures to matrix as **discrete** data;
  - file 'im_pre_here.m' is a file to do some pre-process for each input images;
  - file 'mat2pic.m' is a file to convert the contents of 20 packets in folder 'matdata' into images and store them separately in folder 'test-images' and 'train-images';
  - file 'mynormpdf.m' is a function to calculate the probability density of x under the Gaussian distribution.
  - file 'myNumStatistic.m' is a function to do data statistics for the input vector;
- file 'LICENSE' is the license file produced by github;
- file 'MNIST _ 基于朴素贝叶斯分类器的0-9数字手写体识别.md' is a detailed introduction document for this project. 
- file '用Bayes分类器做0-9数字手写体识别-实验记录单.docx' is a record document of experinments carried out in this project.

For more detailed information, refer to article [MNIST _ 基于朴素贝叶斯分类器的0-9数字手写体识别.md]().