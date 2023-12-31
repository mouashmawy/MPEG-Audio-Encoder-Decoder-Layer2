function [Encoded_signal,subband_bits,min_array,max_array]= Encoder(filterOutput,Lk)

% Applying fft on the filter output
filter_fft =zeros(32,1024);

for i=1:32
    filter_fft(i,:)=fft(filterOutput(i,:),1024);
end

% Calculating SPLs
filter_SPLs=zeros(32,512);
N=1024;
for i = 1:32
filter_SPLs(i,:)=96+(10*log10((4/N^2)*abs(filter_fft(i,513:1024).^2)*8/3));
end
%multipying the Lks vector by the filter SPLs
Lk_t=transpose(Lk);
important_frequencies=zeros(32,512);
for i = 1:32
important_frequencies=Lk_t.*filter_SPLs(i,:);
end

%Summing resultant SPLs 
sum_spl = zeros(1,32);

for i = 1:32
    sum_spl(1,i)=sum(important_frequencies(i));
end

% bit allocation
BPS_signal=16;
subband_bits = zeros(1,32);
count = 0;
if BPS_signal<=16
    BPS = BPS_signal;
else
    BPS = 16;
end

b = BPS;

for i=1:1:32
    [smax,index] = max(sum_spl);
    index;
    
    if count < 4
        b = BPS;
    elseif count<8
        if BPS - 10 >= 2 
            b = BPS - 10;
        else
            b = 2;
        end
    elseif count<12
        if BPS - 14 >= 2
            b = BPS - 14;
        else
            b = 2;
        end
    elseif count<16
        if BPS - 14 >= 2
            b = BPS - 14;
        else
            b = 2;
        end
    elseif count<20
       if BPS - 14 >= 2
            b = BPS - 14;
        else
            b = 2;
       end
    elseif count<24
        if BPS - 15 >= 1
            b = BPS - 15;
        else
            b = 2;
        end
    elseif count<28
        if BPS - 15 >= 1
            b = BPS - 15;
        else
            b = 1;
        end
    else
        if BPS - 15 >= 1
            b = BPS - 15;
        else
            b = 1;
        end
    end
    subband_bits(index) = b;
    count = count + 1;
    sum_spl(index) = -inf;
end

%quantization 

numFrames = size(filterOutput, 2) / 12; % Calculate the number of frames
frames = zeros(numFrames, 384); % Initialize storage for frames, with each frame as a row
% Initialize an empty vector to store sampled_quan values
Encoded_signal = [];
max_array=[];
min_array=[];
for j = 1:12:size(filterOutput, 2) % Loop over columns in steps of 12
    if j+11 <= size(filterOutput, 2)
       
        for i = 1:size(filterOutput, 1) % Loop over each row
            % Extract 12 elements from the current row
            currentElements = filterOutput(i, j:j+11);

            [maxi, mini, sampled_quan] = Quan(currentElements, subband_bits(i));

            Encoded_signal = [Encoded_signal , sampled_quan];

            max_array=[max_array , maxi];
            min_array=[min_array, mini];
        end

        
    end
end

