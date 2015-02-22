function [ATIMES, BITS] = generate_packets(Num_Pkts, mean_rate, mean_bits) 
 
ATIMES = zeros(1,Num_Pkts); 
BITS = zeros(1,Num_Pkts); 
 
current_time = 0; 
 
    for j=1:Num_Pkts 

     mean_time = 1/mean_rate; 


     ATIMES(1,j) = current_time; 
%      BITS(1,j) = rand() * 2 * mean_bits; 
% 
%      current_time = current_time + rand() * 2 * mean_time; 
   BITS(1,j) = rand() * 2 * mean_bits; 

     current_time = current_time + rand() * 2 * mean_time; 

    end; 
 
end 