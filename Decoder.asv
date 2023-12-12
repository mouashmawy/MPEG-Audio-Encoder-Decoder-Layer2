function [Origianl_Signal] = Decoder(min_array,max_array,bits_array,quantized_signal)


% Dequantizing the signal
size_array = size(quantized_signal,2);
L = size_array /32 /12;

Origianl_Signal = [];
arrayX2 = [];


for i = 1:size_array/12
    maxi = max_array(i);
    mini = min_array(i);
    
    j = rem( i , 33 )+1;
    n_bits = bits_array(j);

    quan = quantized_signal(i*12-11:i*12);

    deq = DeQuan(maxi, mini, n_bits, quan);
    arrayX2 = [arrayX2 deq];

end

dequantized_signal=zeros(32,size(quantized_signal/32));
for i = 0:L-1
    for j = 0:31
        dequantized_signal(j+1,i+1) = [ dequantized_signal(j+1,i+1) arrayX2(i+j*12+1 : i+j*12+12+1) ];
    end
    
end

%calculationg the g_k

g = zeros(32, 512);
h = ones(512, 1);

for k = 0:31
    for n = 0:511
        g(k+1, n+1) = 32 * h(n+1) * cos(((k + 0.5) * (n + 16) * pi) / 32);
    end
end



%upsampling the signal

upsampled_signal = zeros(32 , length(audio_signal));
for i = 1:32
   upsampled_signal(i, :) = upsample(dequantized_signal(i, :), 32);

end

% passing the upsampled function to the filter function
original_signal_1 = zeros(32, length(audio_signal));

for i=1:32
original_signal_1(i,:) = filter(g(i,:),1 ,upsampled_signal(i,:));
end

Origianl_Signal=sum(original_signal_1,1);

end