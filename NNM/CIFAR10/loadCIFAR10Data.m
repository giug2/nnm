function [XTrain, YTrain, XTest, YTest] = loadCIFAR10Data(cifar10Data)
    % Helper function to load CIFAR-10 data
    % Load training data
    numTrainFiles = 5;
    XTrain = [];
    YTrain = [];
    for i = 1:numTrainFiles
        load(fullfile(cifar10Data, ['data_batch_' num2str(i) '.mat']), 'data', 'labels');
        XTrain = cat(4, XTrain, reshape(data', 32, 32, 3, []));
        YTrain = [YTrain; labels];
    end

    % Load test data
    load(fullfile(cifar10Data, 'test_batch.mat'), 'data', 'labels');
    XTest = reshape(data', 32, 32, 3, []);
    YTest = labels;

    % Convert labels to categorical
    YTrain = categorical(YTrain);
    YTest = categorical(YTest);
end
