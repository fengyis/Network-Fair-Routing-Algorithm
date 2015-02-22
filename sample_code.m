%---------------------SAMPLE CODE TO GET STARTED -------------------------------------------- %---------------------------------------------------------------- 
% MAIN_WRR_2014.m 
% 4DN4 class demo, Wed,Thurs. Feb 12,13, 2014 
% this programs implements a basic Weighted Round Robin scheduler 
%---------------------------------------------------------------- 
 
clear all; % clear all variables 
close all; % close all figures 
clc; % clear command window 
 

 
% define some global data-structures, visible in functions 
global NUM_PKTS; 
global ATIMES; 
global BITS; 
global LINK_RATE; 

NUM_FLOWS = 4;  
NUM_PKTS = 100; 
 
LINK_RATE = 1000; % 1 kbits per second 
 
% define 2 matrices, to store data on packets 
% store packet arrival times,a nd bits per packet 
ATIMES = zeros(NUM_FLOWS, NUM_PKTS); 
BITS = zeros(NUM_FLOWS, NUM_PKTS); 
 
% define 3 vectors, to store data on flows 
MEAN_RATES = zeros(1, NUM_FLOWS); 
MEAN_BITS = zeros(1, NUM_FLOWS); 
FLOW_WEIGHTS = zeros(1, NUM_FLOWS); 
 
MEAN_RATES = [10 20 5 3]; 
MEAN_BITS = [20 15 40 100]; 
FLOW_WEIGHTS = [ 1 1 1 1]; 
 
figure(1); 
 
% initialize the packet arrivals on ecah flow 
for flow=1:4
 
 flow_rate = MEAN_RATES(1, flow) ;
 flow_bits = MEAN_BITS(1, flow)  ;
 
 
 [atimes, bits] = generate_packets(NUM_PKTS, flow_rate, flow_bits); 
 
 ATIMES(flow,:) = atimes ;
 BITS(flow,:) = bits ;
 
 plot_arrivals(flow, atimes, bits); 
 
 %figure(1); % bring window to front of screen 
end; 
 
%----------------------------------------- 
% weighted round robin server 
%----------------------------------------- 
figure(6); 
current_time = 0; 
for round = 1 : 100 
 
 for flow = 1:NUM_FLOWS 
 
     flow_weight = FLOW_WEIGHTS(1,flow); 

     % for each round and for each flow, service a 
     % number of packets equal to the flow's weight 
     for pass = 1:flow_weight 

         pkt_num = check_for_arrivals(flow, current_time); 

         if (pkt_num > 0) 

             % we have an arrival to transmit 
             bits = BITS(flow, pkt_num); 
             tx_time = bits/LINK_RATE; 

             plot_transmission_2014(flow, pkt_num, current_time, tx_time); 
             figure(6); 

             ATIMES(flow, pkt_num) = inf; 

             current_time = current_time + tx_time; 

             fprintf('TXed pkt: flow %g, pkt %g\n',flow, pkt_num); 
         end; 

     end; % for pass .. 
 
 end; 
 
end 
 
