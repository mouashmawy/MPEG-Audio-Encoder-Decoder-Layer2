function final_filtered_signal = Filter_Bank(audio_signal, filter_file)
 % Read filter coefficients from the specified file
 filters = readtable(filter_file);

 % Mirror the original vector using the flip function
 mirrored_vector = flip(filters);

 %negelceting the first element to make the symmetry 
 mirrored_vector(1,:)=[];

 % Concatenate the original and mirrored vectors using horzcat
 filters_coe = vertcat(filters, mirrored_vector);

 %convert the data type form table to double
 h=table2array(filters_coe);

 % Calculate impulse responses of the filters
 impulseResponses = zeros( 32 ,size(h, 1));
 
 
 for k = 1:32
     for n = 1 : 512
         impulseResponses(k,n) = h(n)*cos((k+0.5)*(n-16)*pi/32);

     end
 end

 % Pass the signal and the impulse response to filter function
 filteredSignals=zeros(32,length(audio_signal));clc
 for i=1:32
 filteredSignals(i,:) = filter(impulseResponses(i,:),1 ,audio_signal);
 end
 % Downsample each filtered signal
 final_filtered_signal = zeros(size(filteredSignals, 1), length(audio_signal)/32);
 for i = 1:32
    final_filtered_signal(i, :) = downsample(filteredSignals(i, :), 32);
 end










