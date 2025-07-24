classdef CustomMiniBatchDatastore < matlab.io.datastore.MiniBatchable
    properties
        ImageDatastore
        Labels
        CurrentIndex
        MiniBatchSize
        TotalSamples
    end
    
    methods
        function self = CustomMiniBatchDatastore(imds, labels)
            self.ImageDatastore = imds;
            self.Labels = labels;
            self.CurrentIndex = 1;
            self.MiniBatchSize = 128;
            self.TotalSamples = numel(labels);
        end
        
        function [data, info] = read(self)
            % Read a mini-batch of data
            if self.CurrentIndex + self.MiniBatchSize - 1 <= self.TotalSamples
                idx = self.CurrentIndex:(self.CurrentIndex + self.MiniBatchSize - 1);
                self.CurrentIndex = self.CurrentIndex + self.MiniBatchSize;
            else
                idx = self.CurrentIndex:self.TotalSamples;
                self.CurrentIndex = 1; % Reset for next epoch
            end
            
            % Read images and labels for the current batch
            data = read(self.ImageDatastore, idx);
            labels = self.Labels(idx);
            data = {data, labels};
            
            % Provide info about the batch
            info.CurrentFileIndices = idx;
        end
        
        function reset(self)
            % Reset to the start of the datastore
            self.CurrentIndex = 1;
        end
        
        function TF = hasdata(self)
            % Check if there is more data to read
            TF = self.CurrentIndex <= self.TotalSamples;
        end
        
        function self = shuffle(self)
            % Shuffle the datastore
            idx = randperm(self.TotalSamples);
            self.Labels = self.Labels(idx);
            self.ImageDatastore = subset(self.ImageDatastore, idx);
        end
    end
end
