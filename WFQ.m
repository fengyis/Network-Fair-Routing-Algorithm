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
global ATIMES_a;
global BITS_a;

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
WEIGHT = [ 1 1 1 1]; 
 
queue1 =[];
queue2 =[];
queue3 =[];
queue4 =[];
%vector to store finish time of each packet in the flow 1, 2, 3
VFT_1 = [];
VFT_2 = [];
VFT_3 = [];
VFT_4 = [];

reference_time=0;
round=0;
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
 
current_time = 0; 
finish_time=0;
 time_increment=1/LINK_RATE;

ATIMES_a=ATIMES;
BITS_a=BITS;


current_time_a = 0; 
for round_a =1:30

     for flow_a = 1:4 

         flow_weight_a = WEIGHT(1,flow_a); 

         % for each round and for each flow, service a 
         % number of packets equal to the flow's weight 
         for pass = 1:flow_weight_a 

             pkt_num_a = check_for_arrivals_a(flow_a, current_time_a); 

             if (pkt_num_a > 0) 

                 % we have an arrival to transmit 
                 bits_a = BITS_a(flow_a, pkt_num_a); 
                 tx_time_a = bits_a/LINK_RATE; 
                    figure(5); 
                title('Transmission Buffer of Round-robin servie');
                xlabel('time/ms');
                 plot_transmission_2014_a(flow_a, pkt_num_a, current_time_a, tx_time_a); 
                 

                 ATIMES_a(flow_a, pkt_num_a) = inf; 

                 current_time_a = current_time_a + tx_time_a; 

                 fprintf('TXed pkt: flow %g, pkt %g\n',flow_a, pkt_num_a); 
             end

         end
     end
end
 
 pause;
for current_time = 0:time_increment:2
    
    
     
    total_weight=WEIGHT(1)*~isempty(queue1)+WEIGHT(2)*~isempty(queue2)+WEIGHT(3)*~isempty(queue3);
    
    
   
    flow=1;
    % flow1
    pkt_num = check_for_arrivals(flow, current_time);
    % find the packet
    if (pkt_num > 0)
     bits1 = BITS(flow,pkt_num);
          % update finish time VFT
        if(isempty(VFT_1))
            VFT_1 = [VFT_1,round + bits1/WEIGHT(1)];
        else
            VFT_1 = [VFT_1,max(round,VFT_1(end)) + bits1/WEIGHT(1)];
        end
     
         queue1 = [queue1,bits1];
    
         ATIMES(flow,pkt_num) = inf;
    end;

flow=2;
    % flow1
    pkt_num = check_for_arrivals(flow, current_time);
    % find the packet
    if (pkt_num > 0)
     bits2 = BITS(flow,pkt_num);
          
        if(isempty(VFT_2))
            VFT_2 = [VFT_2,round + bits2/WEIGHT(2)];
        else
            VFT_2 = [VFT_2,max(round,VFT_2(end)) + bits2/WEIGHT(2)];
        end
         queue2 = [queue2,bits2];
    % remove the packet so it is not selected again
         ATIMES(flow,pkt_num) = inf;
        
    end;
flow=3;
    % flow1
    pkt_num = check_for_arrivals(flow, current_time);
    % find the packet
    if (pkt_num > 0)
     bits3 = BITS(flow,pkt_num);
          
        if(isempty(VFT_3))
            VFT_3 = [VFT_3,round + bits3/WEIGHT(3)];
        else
            VFT_3 = [VFT_3,max(round,VFT_3(end)) + bits3/WEIGHT(3)];
        end
         queue3 = [queue3,bits3];
    % remove the packet so it is not selected again
         ATIMES(flow,pkt_num) = inf;
        
    end;
flow=4;
    % flow1
    pkt_num = check_for_arrivals(flow, current_time);
    % find the packet
    if (pkt_num > 0)
     bits4 = BITS(flow,pkt_num);

        if(isempty(VFT_4))
            VFT_4 = [VFT_4,round + bits4/WEIGHT(4)];
        else
            VFT_4 = [VFT_4,max(round,VFT_4(end)) + bits4/WEIGHT(4)];
        end
         queue4 = [queue4,bits4];
    % remove the packet so it is not selected again
         ATIMES(flow,pkt_num) = inf;

    end;
    if(~isempty(VFT_1)) 
        a=min(VFT_1);
    else
        a=inf;
    end
    
    if(~isempty(VFT_2))
        b=min(VFT_2);
    else
        b=inf;
    end
    
    if(~isempty(VFT_3))
        c=min(VFT_3);
    else
        c=inf;
    end
    
    if(~isempty(VFT_4))
        d=min(VFT_4);
    else
        d=inf;
    end
    
 if(~(isempty(VFT_1)||isempty(VFT_2)||isempty(VFT_3)||isempty(VFT_4)))
         m=min([a,b,c,d]);
         if(m==a)
             f=1;
             
             pkt=find(VFT_1==m);
             bits=queue1(pkt);
             fprintf('flow is %g,VFT is %g size is %g\n',f,m, bits);
             VFT_1(pkt)=[];
             
             queue1(pkt)=[];
         end  
        if(m==b)
             f=2;
             pkt=find(VFT_2==m);
             bits=queue2(pkt);
             fprintf('flow is %g ,VFT is %g size is %g\n',f,m, bits );
             VFT_2(pkt)=[];
             
             queue2(pkt)=[];
        end
         if (m==c)
             f=3;
             pkt=find(VFT_3==m);
             bits=queue3(pkt);
             fprintf('flow is %g ,VFT is %g size is %g\n',f,m, bits );
             VFT_3(pkt)=[];
             
             queue3(pkt)=[];
            
         end
         if (m==d)
             f=4;
             pkt=find(VFT_4==m);
             bits=queue4(pkt);
             fprintf('flow is %g ,VFT is %g size is %g\n',f,m, bits );
             VFT_4(pkt)=[];
             
             queue4(pkt)=[];
            
         end
    
    tx_time=bits/LINK_RATE;
   
    
    
     
    if(current_time>=finish_time)
      figure(6);
      title('Transmission Buffer of Weighted Fail Queue Service')
      xlabel('time/ms')
      plot_WFQ_2014(f,bits,finish_time,tx_time);
      finish_time=finish_time+tx_time;
    
    end
 end
    
    one_round_time=((WEIGHT(1)*~isempty(VFT_1)+WEIGHT(2)*~isempty(VFT_2)+WEIGHT(3)*~isempty(queue3))/LINK_RATE);
    
     
     if((current_time-reference_time)>=one_round_time)
         fprintf('This is round %g, tim %g \n',round, current_time);
         round=round+1;
         reference_time=current_time;
     end
     
    
end
% 
%      
%      
%      
%      
%      
